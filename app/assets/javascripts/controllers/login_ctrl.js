// login controller
function LoginCtrl($scope, $location, $timeout, apiService, UserData) {
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
      if (data.success === true && data.user !== '') {
        // successful login, make another call to get user data
        $scope.data = UserData;
        
        // $scope.data.username = $data.user;
        $scope.data.loggedin = true;
        $location.path('/dashboard');
      } else {
        // invalid login
        $scope.errorMessage = 'invalid username or password';
      }
    }, 'POST', '/api/login', $scope.formData);

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
LoginCtrl.$inject = ['$scope', '$location', '$timeout', 'apiService', 'UserData'];
