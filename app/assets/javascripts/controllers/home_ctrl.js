// homepage controller
function HomeCtrl($scope, apiService) {
  $scope.tab = '';
  $scope.categories = [];

  $scope.getCategories = function() {
    apiService.apiCall(function(data, status){
      if(status == 200){
        $scope.categories = data.categories;
      } else {
      }
    }, 'GET', '/api/get-categories', {});
  };

  $scope.getCategories();
}
HomeCtrl.$inject = ['$scope', 'apiService'];