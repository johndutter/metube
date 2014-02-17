function DashboardUploadsCtrl($scope, $timeout, apiService){
  $scope.$parent.tab = 'uploads';
  $scope.videos = [];

  $scope.init = function() {

      // get multimedia uploaded by user
      apiService.apiCall(function(data, status) {
        if (status === 200) {
          
        } else {
          // error getting user data
        }
      }, 'GET', '/api/get-user-multimedia', {});
    };

    $scope.init();

}

DashboardUploadsCtrl.$inject = ['$scope', '$timeout', 'apiService'];