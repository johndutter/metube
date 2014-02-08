// dashboard profile controller
function DashboardProfileCtrl($scope, $timeout, apiService) {
  $scope.$parent.tab = 'profile';
  $scope.formData = {};
  $scope.pwdFormData = {};
  $scope.showErrorsOne = false;
  $scope.errorMessageOne = '';
  $scope.successMessageOne = '';
  $scope.showErrorsTwo = false;
  $scope.errorMessageTwo = '';
  $scope.successMessageTwo = '';

  $scope.init = function() {

    // get user profile information
    apiService.apiCall(function(data, status) {
      if (status === 200) {
        $scope.formData.email = data.email;
        $scope.formData.firstname = data.firstname;
        $scope.formData.lastname = data.lastname;
        $scope.formData.phone = data.phone;
      } else {
        // error getting user data
      }
    }, 'GET', '/api/get-user-profile', {});
  };

  $scope.init();

  // update a user's info
  $scope.changeInfo = function() {

    // handle form validation
    if ($scope.profileform.$valid === false) {
      $scope.showErrorsOne = true;
      return;
    }

    apiService.apiCall(function(data, status) {
      if (status === 200) {
        $scope.successMessageOne = 'information updated';
      } else {
        $scope.errorMessageOne = 'error updating profile information';
      }
    }, 'POST', '/api/update-user-profile', $scope.formData);

  };


  $scope.changePass = function() {

    // handle form validation
    if ($scope.passform.$valid === false) {
      $scope.showErrorsTwo = true;
      return;
    }

    // ensure matching passwords
    if ($scope.pwdFormData.encrypted_password !== $scope.pwdFormData.password_confirmation) {
      $scope.showErrorsTwo = true;
      return;
    }

    apiService.apiCall(function(data, status) {
      if (status === 200) {
        $scope.successMessageTwo = 'password updated';
      } else {
        $scope.errorMessageTwo = 'password update failed -- check your old password';
      }
    }, 'POST', '/api/update-user-password', $scope.pwdFormData);

  };


  // watch error message
  $scope.$watch('errorMessageOne', function(newValue, oldValue) {
    if (newValue !== '') {
      $timeout(function() {
        $scope.errorMessageOne = '';
      }, 3000);
    }
  }, true);
  // watch error message
  $scope.$watch('successMessageOne', function(newValue, oldValue) {
    if (newValue !== '') {
      $timeout(function() {
        $scope.successMessageOne = '';
      }, 3000);
    }
  }, true);
  // watch error message
  $scope.$watch('errorMessageTwo', function(newValue, oldValue) {
    if (newValue !== '') {
      $timeout(function() {
        $scope.errorMessageTwo = '';
      }, 3000);
    }
  }, true);
  // watch error message
  $scope.$watch('successMessageTwo', function(newValue, oldValue) {
    if (newValue !== '') {
      $timeout(function() {
        $scope.successMessageTwo = '';
      }, 3000);
    }
  }, true);

}
DashboardProfileCtrl.$inject = ['$scope', '$timeout', 'apiService'];