// homepage controller
function LoginCtrl($scope, apiService, UserData) {
  data = {username: 'lorem', password: 'loremipsum'};
  alert = function (data, status) {
    console.log("my obj: %o", data);
  }
  
  /*$scope.post = function () {
    $http.post('/login', data).success(function(){console.log("success")});
  };*/
    apiService.apiCall(alert, 'POST', 'login', data);
  
  $scope.data = UserData;
  $scope.data.username = "test";

}
LoginCtrl.$inject = ['$scope', 'apiService', 'UserData'];