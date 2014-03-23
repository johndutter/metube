// browse channel ctrl controller
function BrowsePlaylistCtrl($scope, apiService, UserData) {
  $scope.playlists = [];
  $scope.userdata = UserData;

  $scope.getPlaylists = function() {
    apiService.apiCall(function(data, status){
      if(status == 200){
        $scope.playlists = data.playlists;
      } else {
      }
    }, 'GET', '/api/get-playlists', {});
  };

  $scope.getPlaylists();
}
BrowsePlaylistCtrl.$inject = ['$scope', 'apiService', 'UserData'];