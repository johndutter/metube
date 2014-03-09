function ChannelsCtrl($scope, apiService, UserData, $stateParams) {
  $scope.allMultimedia = [];
  $scope.allPlaylists = [];
  $scope.channelInfo = {};

  $scope.init = function () {
    apiService.apiCall(function(data, status) {
      if(status == 200) {
        $scope.channelInfo.username = data.username;

        $scope.getMultimedia();
        $scope.getPlaylists();
      } else {
      }
    }, 'GET', '/api/get-uploader-info', {id: $stateParams.id});

    $scope.getMultimedia = function () {
      apiService.apiCall(function(data, status) {
        if(status == 200) {
          $scope.allMultimedia = data.all_multimedia;
        } else {
        }
      }, 'GET', '/api/get-user-multimedia', {user_id: $stateParams.id});
    };

    $scope.getPlaylists = function () {
      apiService.apiCall(function(data, status) {
        if(status == 200) {
          $scope.allPlaylists = data.uploaded_playlists;
        }
      }, 'GET', '/api/get-user-playlists', {user_id: $stateParams.id});
    };
  };

  $scope.init();
}

ChannelsCtrl.$inject = ['$scope', 'apiService', 'UserData', '$stateParams'];