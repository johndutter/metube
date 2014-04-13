// navbar controller
function SearchCtrl($scope, apiService, $stateParams) {
  $scope.resultsList = [];

  // log out
  $scope.getSearchResults = function() {
    apiService.apiCall(function(data, status) {
      if (status === 200) {
        $scope.resultsList = data.results;
      } else {
      }
    }, 'GET', '/api/search', { query: $stateParams.query });
  };

  $scope.getSearchResults();

}
SearchCtrl.$inject = ['$scope', 'apiService', '$stateParams'];