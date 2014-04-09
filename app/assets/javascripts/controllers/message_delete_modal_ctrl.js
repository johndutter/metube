function MessageDeleteModalCtrl ($scope, apiService, $modalInstance, messages, messageId, messageIndex, isSender) {
  $scope.messageId = messageId;
  $scope.messageIndex = messageIndex;
  $scope.isSender = isSender;
  $scope.messages = messages;

  $scope.deleteMessage = function () {
    console.log($scope.messageId);
    console.log($scope.messageIndex);
    console.log($scope.isSender);

    var apiCallString;
    if($scope.isSender) {
      apiCallString = '/api/delete-as-sender';
    }
    else {
      apiCallString = '/api/delete-as-recipient';
    }

    apiService.apiCall(function(data, status) {
      if(status == 200) {
        console.log('success');
        $scope.messages.splice($scope.messageIndex, 1);
        $modalInstance.dismiss('cancel');
      } else {
        console.log('failure');
      }
    }, 'POST', apiCallString, {message_id: $scope.messageId});
    
  };

  $scope.closeModal = function () {
    $modalInstance.dismiss('cancel');
  };
};

MessageDeleteModalCtrl.$inject = ['$scope', 'apiService', '$modalInstance', 'messages', 'messageId', 'messageIndex', 'isSender'];