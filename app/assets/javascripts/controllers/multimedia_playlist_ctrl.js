function MultimediaPlaylistCtrl($scope, $stateParams, apiService) {
  $scope.playlistMedia = [];
  $scope.currentlyPlaying = $stateParams.id;
  $scope.playlistId = $scope.$parent.playlistId = $stateParams.playlist_id;
  $scope.currentMediaIndex;

  $scope.init = function () {
    apiService.apiCall(function(data, status) {
      if(status == 200) {
        $scope.playlistMedia = data.all_multimedia;
      }

    }, 'GET', '/api/get-playlist-multimedia', {playlist_id: $scope.playlistId});
  };

  $scope.init();

  $scope.isPlayingNow = function (mediaId, playlistIndex) {
    if($scope.currentlyPlaying == mediaId) {
      $scope.markNextMedia(playlistIndex);
      return 'now-playing';
    } else {
      return 'not-playing';
    }
  }

  // mark the media that comes after the one currently playing
  $scope.markNextMedia = function (mediaIndex) {
    // if this is the last video go to the beginning
    if(mediaIndex == $scope.playlistMedia.length - 1) {
      $scope.$parent.nextToPlay = $scope.playlistMedia[0].id;
    } else {
      $scope.$parent.nextToPlay = $scope.playlistMedia[mediaIndex + 1].id;
    }
  }
}

MultimediaPlaylistCtrl.$inject = ['$scope', '$stateParams', 'apiService'];