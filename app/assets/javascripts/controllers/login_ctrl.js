// login controller
function LoginCtrl($rootScope, $scope, $http, $location, $timeout, apiService, UserData) {
  $scope.formData = {};
  $scope.errorMessage = '';
  $scope.showErrors = false;

  // send off ajax request
  $scope.login = function() {

    // handle form validation
    if ($scope.loginform.$valid === false) {
      $scope.showErrors = true;
      return;
    }

    apiService.apiCall(function(data, status) {
      if (data.user !== '') {
        // successful login--set some data in a service
        $scope.data = UserData;
        $location.path('/dashboard');
      } else {
        // invalid login
        $scope.errorMessage = 'invalid username or password';
      }
    }, 'POST', 'login', $scope.formData);

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
LoginCtrl.$inject = ['$rootScope', '$scope', '$http', '$location', '$timeout', 'apiService', 'UserData'];
