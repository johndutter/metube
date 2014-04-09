function DashboardMessagesViewCtrl($scope, apiService, UserData, $stateParams, $location) {
  $scope.message;
  $scope.showErrors = false;
  $scope.errorMessage = '';
  $scope.userIsSender = false;

  $scope.form = {};
  $scope.formData = {};
  $scope.originalSenderName;

  $scope.init = function()  {
    apiService.apiCall(function(data, status) {
      if(status == 200) {
        $scope.message = data.message;
        
        //Get sender's username, and determine if current viewer is sender
        $scope.getUserNameFromId($scope.message.user_id);
        $scope.userIsSender = (UserData.userid == $scope.message.user_id);

        //mark message as read
        if(!$scope.userIsSender) {
          $scope.markAsRead(data.message.id);
        }
      } else {

      }
    }, 'GET', '/api/get-message', {message_id: $stateParams.id});
  };

  $scope.init();

  $scope.replyToMessage = function() {
    // check if form is valid
    if ($scope.form.replytomessage.$valid === false) {
      $scope.showErrors = true;
      return;
    };

    //append reply to original message and send as one message
    $scope.formData.contents = $scope.message.contents + "\n\n-------------------------\n\n" + $scope.formData.contents;

    //add key for rails strong parameters + extra necessary parameters
    $scope.formData.user_id = UserData.userid;
    $scope.formData.recipient_name = $scope.originalSenderName;
    $scope.formData.subject = 'Reply: ' + $scope.message.subject;
    $scope.formData = {message: $scope.formData};

    apiService.apiCall(function(data, status) {
      if(status == 200) {
        $location.url('/dashboard/messages/inbox');
      } else {
        $scope.showErrors = true;
        $scope.errorMessage = 'Unable to send message.';
      }
    }, 'POST', '/api/send-message', $scope.formData);
    
  };

  $scope.getUserNameFromId = function(userId) {
    apiService.apiCall(function(data, status) {
      if(status == 200) {
        $scope.originalSenderName = data.username;
      } else {
        $scope.originalSenderName = '';
      }
    }, 'GET', '/api/get-uploader-info', {id: userId});
  };

  $scope.markAsRead = function(messageId) {
    apiService.apiCall(function(data, status) {
      if(status == 200) {

      } else {}
    }, 'POST', '/api/mark-as-read', {message_id: messageId});
  }

  $scope.deleteMessage = function(messageId) {
   if($scope.userIsSender) {
    $scope.deleteAsSender(messageId);
   } else {
    $scope.deleteAsRecipient(messageId);
   }
  };

  $scope.deleteAsSender = function(messageId) {
    apiService.apiCall(function(data, status) {
      if(status == 200) {
        $location.url('/dashboard/messages/sent');
      } else {

      }
    }, 'POST', '/api/delete-as-sender', {message_id: messageId});
  };

  $scope.deleteAsRecipient = function(messageId) {
    apiService.apiCall(function(data, status) {
      if(status == 200) {
        $location.url('/dashboard/messages/inbox');
      } else {

      }
    }, 'POST', '/api/delete-as-recipient', {message_id: messageId});
  };
}

DashboardMessagesViewCtrl.$inject = ['$scope', 'apiService', 'UserData', '$stateParams', '$location'];