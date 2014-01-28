// navbar controller
function NavCtrl($scope, UserData) {
  $scope.userdata = UserData;
}
NavCtrl.$inject = ['$scope', 'UserData'];