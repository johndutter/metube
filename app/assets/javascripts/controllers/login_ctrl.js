// login controller
function LoginCtrl($rootScope, $scope, $http, $location, $timeout) {
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

    $http({ method: 'POST', url: '/login', timeout: 10000, data: $scope.formData }).
    success(function(data, status, headers, config) {
      if (data.user !== '') {
        // successful login--set some data in a service
        $location.path('/dashboard');
      } else {
        // invalid login
        $scope.errorMessage = 'invalid username or password';
      }
    }).
    error(function(data, status, headers, config) {
      // error connecting with server
      $scope.errorMessage = 'invalid username or password';
    });
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
LoginCtrl.$inject = ['$rootScope', '$scope', '$http', '$location', '$timeout'];