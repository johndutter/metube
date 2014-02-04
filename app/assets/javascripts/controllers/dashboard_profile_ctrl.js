// dashboard profile controller
function DashboardProfileCtrl($scope) {
  $scope.$parent.tab = 'profile';
  $scope.formData = {};
  $scope.pwdFormData = {};
}
DashboardProfileCtrl.$inject = ['$scope'];