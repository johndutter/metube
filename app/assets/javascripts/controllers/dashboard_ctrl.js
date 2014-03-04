// dashboard controller
function DashboardCtrl($scope) {
  $scope.tab = '';
  $scope.playlists = [];

  // bring in user playlist information
  $scope.init = function() {
    console.log("bringin in the p.lists");
  }
}
DashboardCtrl.$inject = ['$scope'];