function DashboardMessagesCtrl($rootScope, $scope, apiService, UserData, $modal, $timeout) {
  $scope.$parent.tab = 'messages';
  $scope.messageData = {};
  $scope.form = {};
  $scope.formData = {};

  $scope.showErrors = false;
  $scope.errorMessage='';

  $scope.alerts = [];

  // display modal for new message
  $scope.openNewMessageModal = function(){
      $scope.modalInstance = $modal.open({
      templateUrl: '/secured/new-message-modal.html',
      controller: DashboardMessagesCtrl
      });
  };

  $scope.sendMessage = function() {

    // handle form validation
    if ($scope.form.newmessage.$valid === false) {
      $scope.showErrors = true;
      return;
    }

    // add key for rails strong parameters and user data
    $scope.formData.user_id = UserData.userid;
    $scope.formData = {message: $scope.formData};

    apiService.apiCall(function(data, status) {
      if(status == 200) {
        //display success
        $scope.cancel();

      } else {
        $scope.showErrors = true;
        $scope.errorMessage= data.message;
      }
    }, 'POST', '/api/send-message', $scope.formData);

  }

  // cancel form creation
  $scope.cancel = function () {
    $scope.$dismiss('cancel');
  };

  $scope.openSuccessModal = function () {

  };

  // watch error message
  $scope.$watch('errorMessage', function(newValue, oldValue) {
    if (newValue !== '') {
      $timeout(function() {
        $scope.errorMessage = '';
      }, 3000);
    }
  }, true);

}

DashboardMessagesCtrl.$inject = ['$rootScope', '$scope', 'apiService', 'UserData', '$modal', '$timeout'];