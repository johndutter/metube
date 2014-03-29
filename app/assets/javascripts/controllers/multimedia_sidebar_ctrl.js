function MultimediaSidebarCtrl($scope, apiService, $stateParams) {
  $scope.recommended = [];

  $scope.getRecommended = function() {
    apiService.apiCall(function(data,status){
      if(status == 200) {
        $scope.recommended = data.recommended;
      } else {
      }
    }, 'GET', '/api/get-recommended', { multimedia_id: $stateParams.id });
  };

  $scope.getRecommended();

}

MultimediaSidebarCtrl.$inject = ['$scope', 'apiService', '$stateParams'];