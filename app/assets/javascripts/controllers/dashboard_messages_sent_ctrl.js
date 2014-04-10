function DashboardMessagesSentCtrl($scope, apiService, UserData, $modal) {
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
    // workaround because of problems passing data through modal
    // possibly refactor later
    $scope.currentMessageId = messageId;
    $scope.currentMessageIndex = messageIndex;

    $scope.modalInstance = $modal.open({
      templateUrl: '/secured/delete-message-modal.html',
      controller: MessageDeleteModalCtrl,
      resolve: {
        messageId: function () {
          return $scope.currentMessageId;
        }, 
        messages: function () {
          return $scope.messages;
        },
        messageIndex: function () {
          return $scope.currentMessageIndex;
        },
        isSender: function () {
          return true;
        }
      }
      });
  };
}

DashboardMessagesSentCtrl.$inject = ['$scope', 'apiService', 'UserData', '$modal'];