// homepage controller
function HomeCtrl($scope, apiService, UserData) {
  $scope.tab = '';
  $scope.categories = [];
  $scope.userdata = UserData;

  $scope.init = function() {
    $scope.getCategories();
    if ($scope.userdata.loggedin === true) {
      $scope.getUserPlaylists();
    } else {
      $scope.getRandomPlaylists();
    }
  };

  $scope.getCategories = function() {
    apiService.apiCall(function(data, status){
      if(status == 200){
        $scope.categories = data.categories;
      } else {
      }
    }, 'GET', '/api/get-categories', {});
  };

  $scope.getRandomChannels = function() {

  };

  $scope.getRandomPlaylists = function() {

  };

  $scope.getUserPlaylists = function() {

  };

  $scope.getUserSubscriptions = function() {

  };

  $scope.init();
}
HomeCtrl.$inject = ['$scope', 'apiService', 'UserData'];