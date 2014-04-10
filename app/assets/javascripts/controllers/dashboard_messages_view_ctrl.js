function DashboardMessagesViewCtrl($scope, apiService, UserData, $stateParams, $location, $modal) {
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
        console.log($scope.userIsSender);

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
    $scope.formData.contents = $scope.message.contents + "\n\n-------------------------\n\n" + "Reply:\n" + $scope.formData.contents;

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

  $scope.confirmDeleteMessage = function () {
    $scope.modalInstance = $modal.open({
      templateUrl: '/secured/delete-message-modal.html',
      controller: MessageDeleteModalCtrl,
      resolve: {
        messageId: function () {
          return $scope.message.id;
        },
        messageIndex: function () {
          return 0;
        },
        messages: function () {
          return [$scope.message];
        },
        isSender: function () {
          return $scope.userIsSender;
        }
      }
      });
  };

}

DashboardMessagesViewCtrl.$inject = ['$scope', 'apiService', 'UserData', '$stateParams', '$location', '$modal'];