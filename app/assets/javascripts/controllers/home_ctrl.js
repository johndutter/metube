// homepage controller
function HomeCtrl($scope, apiService, UserData) {
  $scope.tab = '';
  $scope.userdata = UserData;
  $scope.categories = [];
  $scope.channel_title = $scope.userdata.loggedin ? 'Subscriptions' : 'Channels';
  $scope.playlist_title = $scope.userdata.loggedin ? 'My Playlists' : 'Playlists';
  $scope.channels = [];
  $scope.playlists = [];

  $scope.init = function() {
    $scope.getCategories();
    if ($scope.userdata.loggedin === true) {
      $scope.getUserPlaylists();
      $scope.getUserSubscriptions();
    } else {
      $scope.getRandomPlaylists();
      $scope.getRandomChannels();
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
    apiService.apiCall(function(data, status){
      if(status == 200){
        $scope.channels = data.channels;
      } else {
      }
    }, 'GET', '/api/get-few-channels', {});
  };

  $scope.getUserSubscriptions = function() {
    apiService.apiCall(function(data, status){
      if(status == 200){
        $scope.channels = data.subscriptions;
      } else {
      }
    }, 'GET', '/api/get-user-subscriptions-overview', {user_id: $scope.userdata.userid});
  };

  $scope.getRandomPlaylists = function() {
    apiService.apiCall(function(data, status){
      if(status == 200){
        $scope.playlists = data.playlists;
      } else {
      }
    }, 'GET', '/api/get-few-playlists', {});
  };

  $scope.getUserPlaylists = function() {
    apiService.apiCall(function(data, status){
      if(status == 200){
        $scope.playlists = data.playlists;
      } else {
      }
    }, 'GET', '/api/get-user-playlists-overview', {user_id: $scope.userdata.userid});
  };

  $scope.init();
}
HomeCtrl.$inject = ['$scope', 'apiService', 'UserData'];