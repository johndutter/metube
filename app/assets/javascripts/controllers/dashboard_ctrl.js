// dashboard controller
function DashboardCtrl($scope, apiService, UserData) {
  alert = function (data, status){
    console.log("my object: %o", data);
  }
  apiService.apiCall(alert, "GET", "test", 'data');
  $scope.data = UserData;
}
DashboardCtrl.$inject = ['$scope', 'apiService', 'UserData'];