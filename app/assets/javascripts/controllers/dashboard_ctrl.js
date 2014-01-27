// dashboard controller
function DashboardCtrl($scope, apiService) {
  alert = function (data, status){
    console.log("my object: %o", data);
  }
  apiService.apiCall(alert, "GET", "test", 'data');
}
DashboardCtrl.$inject = ['$scope', 'apiService'];