// homepage controller
function LoginCtrl($scope, apiService, UserData) {
  data = {username: 'lorem', password: 'loremipsum'};
  alert = function (data, status) {
    console.log("my obj: %o", data);
  }
  apiService.apiCall(alert, 'POST', 'login', data);
  
  $scope.data = UserData;
  $scope.data.username = "test";

}
LoginCtrl.$inject = ['$scope', 'apiService', 'UserData'];