// login controller
function LoginCtrl($scope, $location, $timeout, apiService, UserData) {
  $scope.formData = {};
  $scope.errorMessage = '';
  $scope.showErrors = false;
  $scope.userdata = UserData;

  // send off ajax request
  $scope.login = function() {

    // handle form validation
    if ($scope.loginform.$valid === false) {
      $scope.showErrors = true;
      return;
    }

    // make a call to log in
    apiService.apiCall(function(data, status) {
      if (status === 200 && data.user !== '') {

        // successful login, make another call to update user data
        apiService.apiCall(function(data, status) {
          if (status === 200) {
            // set global data
            delete data.success;
            $scope.userdata.username = data.username;
            $scope.userdata.userid = data.userid;
            $scope.userdata.loggedin = data.loggedin;
            
            $location.path('/dashboard/home');
          } else {
            // error getting user data
          }
        }, 'GET', '/api/get-user-info', {});
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
