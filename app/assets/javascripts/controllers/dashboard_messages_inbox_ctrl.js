function DashboardMessagesInboxCtrl($scope, apiService, UserData, $modal) {
  $scope.messages=[];

  $scope.init = function() {
    apiService.apiCall(function(data, status) {
      if(status === 200) {
        $scope.messages = data.received_messages;
      } else {

      }
    }, 'GET', '/api/get-received-messages', {recipient_name: UserData.username});
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
          return false;
        }
      }
      });
  };
  
}

DashboardMessagesInboxCtrl.$inject = ['$scope', 'apiService', 'UserData', '$modal'];