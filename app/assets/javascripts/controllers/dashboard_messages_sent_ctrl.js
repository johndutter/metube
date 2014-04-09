function DashboardMessagesSentCtrl($scope, apiService, UserData) {
  $scope.messages;

  $scope.init = function() {
    apiService.apiCall(function(data, status) {
      if(status == 200) {
        $scope.messages = data.sent_messages;
      }
    }, 'GET', '/api/get-sent-messages', {user_id: UserData.userid});
  };

  $scope.init();

  $scope.confirmDeleteMessage = function (messageId, messageIndex) {
    console.log(messageId);
    console.log(messageIndex);

    // workaround because of problems passing data through modal
    // possibly refactor later
    $scope.currentMessageId = messageId;
    $scope.currentMessageIndex = messageIndex;

    $('#confirmModal').modal('show');
  };

  $scope.deleteMessage = function() {

    apiService.apiCall(function(data, status) {
      if(status == 200) {
        //remove message from messages array
        $scope.messages.splice($scope.currentMessageIndex, 1);
        $('#confirmModal').modal('hide');
      } else {

      }
    }, 'POST', '/api/delete-as-sender', {message_id: $scope.currentMessageId});
  }
}

DashboardMessagesSentCtrl.$inject = ['$scope', 'apiService', 'UserData'];