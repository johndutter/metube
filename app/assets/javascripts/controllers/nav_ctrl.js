// navbar controller
function NavCtrl($scope, $location, apiService, UserData, $state) {
  $scope.userdata = UserData;
  $scope.formData = {};

  // log out
  $scope.logout = function() {

    // first call the logout
    apiService.apiCall(function(data, status) {
      if (status === 200) {

        // successful logout, make another call to clear user data
        apiService.apiCall(function(data, status) {
          if (status === 200) {
            // set global data
            delete data.success;
            $scope.userdata.username = data.username;
            $scope.userdata.userid = data.userid;
            $scope.userdata.loggedin = data.loggedin;
            
            $location.path('/');
          } else {
            // error getting user data
          }
        }, 'GET', '/api/get-user-info', {});

      } else {
        // error logging out
      }
    }, 'POST', '/api/logout', {});

  };

  $scope.search = function() {
    $state.go('search', { query: $scope.formData.searchInput });
  };

}
NavCtrl.$inject = ['$scope', '$location', 'apiService', 'UserData', '$state'];