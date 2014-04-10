function MessageDeleteModalCtrl ($scope, $location, apiService, $modalInstance, messages, messageId, messageIndex, isSender) {
  $scope.messageId = messageId;
  $scope.messageIndex = messageIndex;
  $scope.isSender = isSender;
  $scope.messages = messages;

  $scope.deleteMessage = function () {
    var apiCallString;
    if($scope.isSender) {
      apiCallString = '/api/delete-as-sender';
    }
    else {
      apiCallString = '/api/delete-as-recipient';
    }

    apiService.apiCall(function(data, status) {
      if(status == 200) {
        $scope.messages.splice($scope.messageIndex, 1);
        if($scope.messages.length == 0) {
          $location.url('/dashboard/messages/inbox');
        }
        $scope.closeModal();
      } else {}
    }, 'POST', apiCallString, {message_id: $scope.messageId});
    
  };

  $scope.closeModal = function () {
    $modalInstance.dismiss('cancel');
  };
};

MessageDeleteModalCtrl.$inject = ['$scope', '$location', 'apiService', '$modalInstance', 'messages', 'messageId', 'messageIndex', 'isSender'];