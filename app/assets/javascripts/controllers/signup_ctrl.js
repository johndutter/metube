// signup controller
function SignupCtrl($rootScope, $scope, $http, $location, $timeout) {
  $scope.formData = {};
  $scope.errorMessage = '';
  $scope.showErrors = false;

  // ==========================================================
  // Handle form validation and attempt to sign up user
  // ==========================================================
  $scope.signUp = function() {

    // handle form validation
    if ($scope.signupform.$valid === false) {
      $scope.showErrors = true;
      return;
    }

    // ensure matching passwords
    if ($scope.formData.encrypted_password !== $scope.formData.password_confirmation) {
      $scope.showErrors = true;
      return;
    }

    // attempt to sign up user
    $http({ method: 'POST', url: '/signup', timeout: 10000, data: $scope.formData }).
    success(function(data, status, headers, config) {
      if (data.user !== '' && status === 201) {
        $location.path('/dashboard');
      } else {
        $scope.errorMessage = 'try a different email and username';  
      }
    }).
    error(function(data, status, headers, config) {
      // error
      $scope.errorMessage = 'error talking to the server';
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
SignupCtrl.$inject = ['$rootScope', '$scope', '$http', '$location', '$timeout'];
