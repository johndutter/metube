function PlaylistsCtrl($scope, $stateParams, apiService, UserData, $timeout, $location) {
  $scope.multimedia;
  $scope.playlistInfo;
  $scope.isOwner  = false;
  $scope.isViewer = false;
  $scope.isAnonViewer = false;
  $scope.isLiked = false;

  $scope.showAddVideo = false;
  $scope.showErrors = false;
  $scope.errorMessage = '';
  $scope.form = {};
  $scope.formData = {};

  $scope.init = function () {
    // get all playlist info
    apiService.apiCall(function(data, status){
      if( status == 200){
        $scope.playlistInfo = data.playlist_info;
        // is owner viewing this playlist
        if($scope.playlistInfo.creator === UserData.username) {
          $scope.isOwner = true;
        } else {
          $scope.getSentimentInfo();
          if(UserData.username == '') {
            $scope.isAnonViewer = true;
          }
        }

        // get all multimedia that belong to this playlist
        apiService.apiCall(function(data, status){
          if(status == 200) {
            $scope.multimedia = data.all_multimedia;
          } else {

          }
        }, 'GET', '/api/get-playlist-multimedia', {playlist_id: $stateParams.id});
      }

    }, 'GET', '/api/get-playlist-info', {playlist_id: $stateParams.id});

    $scope.getSentimentInfo = function () {
      apiService.apiCall(function(data, status) {
        if( status == 200) {
          $scope.isViewer = true;
          $scope.isLiked = data.like;
        }

      }, 'GET', '/api/get-playlist-sentiment', {playlist_id: $stateParams.id, user_id: UserData.userid})
    }
  };

  $scope.init();

  $scope.updateViewCount = function() {
    apiService.apiCall(function(data, status) {
      if(status == 200) {
      }
    }, 'POST', '/api/update-playlist-view-count', {playlist_id: $stateParams.id})
  };

  $scope.updateViewCount();

  $scope.toggleAddVideo = function() {
    $scope.showAddVideo = !$scope.showAddVideo;
  }

  $scope.addMediaToPlaylist = function() {
    // check if form is valid
    if ($scope.form.addvideo.$valid === false) {
      $scope.showErrors = true;
      return;
    };

    // grab idea from url input
    var fullUrl = $scope.formData.url;
    var slashIndex = fullUrl.lastIndexOf('/');
    // plust one so we ignore the slash
    var multimedia_id = fullUrl.substr(slashIndex + 1, fullUrl.length);

    apiService.apiCall(function(data,status){
      if(status == 200) {
        // reload page
        $scope.init();
        $scope.toggleAddVideo();
      } else {
        $scope.errorMessage = 'Could not add video.  Check url.';
      }
    }, 'POST', '/api/add-media-to-playlist', {multimedia_id: multimedia_id, playlist_id: $stateParams.id})
  };

  $scope.removeMediaFromPlaylist = function(multimediaId) {
    apiService.apiCall(function(data,status){
      if(status == 200) {
        //update playlist view
        $scope.init();
      }
    }, 'POST', '/api/remove-media-from-playlist', {multimedia_id: multimediaId, playlist_id: $stateParams.id })
  };

  $scope.updateSentiment = function(sentiment) {
    apiService.apiCall(function(data, status) {
      if(status == 200) {
        // update sentiment info
        $scope.getSentimentInfo();

      } else {
        $scope.errorMessage = 'Unable to update playlist sentiment.';
      }
    }, 'POST', '/api/update-playlist-sentiment', {sentiment: sentiment, user_id: UserData.userid, playlist_id: $stateParams.id});
  }

  $scope.playAll = function() {
    $location.url('/multimedia/' + $scope.multimedia[0].id + '/playlist/' + $stateParams.id);
  }

    // watch error message
  $scope.$watch('errorMessage', function(newValue, oldValue) {
    if (newValue !== '') {
      $timeout(function() {
        $scope.errorMessage = '';
      }, 3000);
    }
  }, true);
}

PlaylistsCtrl.$inject = ['$scope', '$stateParams', 'apiService', 'UserData', '$timeout', '$location'];