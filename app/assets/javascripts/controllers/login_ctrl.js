// homepage controller
function LoginCtrl($scope, $http) {
  data = {username: 'lorem', password: 'loremipsum'};
  
  $scope.post = function () {
    $http.post('/login', data).success(function(){console.log("success")});
  };
  
  $scope.post();

}
LoginCtrl.$inject = ['$scope', '$http'];