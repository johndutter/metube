// dashboard controller
function MultimediaCtrl($scope, $stateParams, UserData, apiService, $modal, $location, $timeout) {
  $scope.multInfo = {};
  $scope.uploader = {};
  $scope.sentimentInfo = {};
  $scope.movieFormat = {};
  $scope.show = {
    video: false,
    image: false,
    audio: false,
    playlists: false
  };
  $scope.playlists = [];
  $scope.imagePlaylistTimeoutPromise;

  //necessary for looping through playlist
  $scope.nextToPlay;
  $scope.playlistId;

  $scope.init = function() {

    // go get the multimedia type and information
    apiService.apiCall(function(data, status) {
      if (status === 200) {
        $scope.multInfo = data;
        $scope.multInfo.ending = $scope.multInfo.path.substr($scope.multInfo.path.lastIndexOf('/') + 1);

        if ($scope.multInfo.mediaType === 'video') {
          $scope.initFlowplayer();  
        }
        if ($scope.multInfo.mediaType === 'image') {
          $scope.initImage();  
        }
        if ($scope.multInfo.mediaType === 'audio') {
          $scope.initAudio(); 
        }

        $scope.getUploaderInfo();
        $scope.getSentimentInfo();
        $scope.updateViewCount();

        if(UserData.userid != '') {
          $scope.show.playlists = true;
          $scope.getUserPlaylists();
        }
      } else {
        
      }
    }, 'GET', '/api/get-multimedia-info', { id: $stateParams.id });

    $scope.cyclePlaylist = function() {
      if($scope.nextToPlay && $scope.playlistId) {
        $location.url('/multimedia/' + $scope.nextToPlay + '/playlist/'  + $scope.playlistId);
        $scope.$apply();
      }
    }

    $scope.initFlowplayer = function() {
      $scope.show.video = true;
      var ending = $scope.multInfo.path.substr($scope.multInfo.path.lastIndexOf('.'));
      if (ending === '.mov' || ending === '.mp4' || ending === '.m4v') {
        $scope.movieFormat['mp4'] = $scope.multInfo.path;
      }
      if (ending === '.flv') {
        $scope.movieFormat['flv'] = $scope.multInfo.path;
      }

      $.getScript('/assets/flowplayer-5.4.6.min.js', function () {
        $('#player').flowplayer({
          embed: false,
          flashfit: true,
          swf: '/flowplayer/flowplayer.swf',
          playlist: [
            [
              $scope.movieFormat
            ]
          ]
        });

        // continous play if we're viewing a playlist
        var api = flowplayer();
        api.one('ready', function(e, api) {
          api.resume();
        });

        api.bind('finish', function(e, api) {
          $scope.cyclePlaylist();
        });
      });
    };

    $scope.initImage = function() {
      $scope.show.image = true;
      // cycle image every 5 seconds if in playlist
      $scope.imagePlaylistTimeoutPromise = $timeout(function() {
        console.log('/multimedia/' + $stateParams.id + '/playlist/' + $scope.playlistId);
        if($location.$$path == '/multimedia/' + $stateParams.id + '/playlist/' + $scope.playlistId) {
          $scope.cyclePlaylist();
        }
      }, '5000');
    };

    $scope.initAudio = function() {
      $scope.show.audio = true;

      $.getScript('/assets/flowplayer-3.2.13.min.js', function () {
        $f('.audio', '/flowplayer/flowplayer-3.2.18.swf', {
          plugins: {
            audio: {
              url: '/flowplayer/flowplayer.audio-3.2.11.swf'
            },
            controls: {
              url: '/flowplayer/flowplayer.controls-3.2.16.swf',
              fullscreen: false,
              embed: false,
              autoHide: false
            }

          },
          clip: {
            provider: 'audio',
            autoPlay: true,
            url: $scope.multInfo.path,
            coverImage: {
              url: '/assets/wavform_lg_upper.jpg',
              scaling: 'orig'
            },
            onFinish: function() {
              // continous play if we're viewing a playlist
              $scope.cyclePlaylist();
            }
          }
        });
        // auto play audio
        $f().play();
      });
    };

    $scope.getUploaderInfo = function() {
      apiService.apiCall(function(data, status) {
        if (status === 200) {
          $scope.uploader = data;
        } else {
        }
      }, 'GET', '/api/get-uploader-info', { id: $scope.multInfo.user_id });
    };

    $scope.updateViewCount = function() {
      apiService.apiCall(function(data, status) {
        if (status === 200) {
        } else {
        }
      }, 'POST', '/api/update-view-count', { id: $scope.multInfo.id });
    };

    $scope.getSentimentInfo = function() {
      apiService.apiCall(function(data, status) {
        if (status === 200) {
          $scope.sentimentInfo = data;
        } else {
        }
      }, 'GET', '/api/get-sentiment-info', { multimedia_id: $scope.multInfo.id });
    };
    
    $scope.getUserPlaylists = function() {
      apiService.apiCall(function(data,status){
        if(status == 200) {
          $scope.playlists = data.uploaded_playlists;
        }

      }, 'GET', '/api/get-user-playlists', {user_id: UserData.userid});
    };

  }
  $scope.init();

  $scope.sentiment = function(sentiment) {
    apiService.apiCall(function(data, status) {
      if (status === 200) {
        $scope.sentimentInfo = data;
      } else {
      }
    }, 'POST', '/api/sentiment-multimedia', { multimedia_id: $scope.multInfo.id, option: sentiment });
  };

  $scope.clickedDownload = function($event) {
    $event.preventDefault();
    location.href = '/api/download?ending=' + $scope.multInfo.ending;
  };

  $scope.openModal = function() {
    var modalInstance = $modal.open({
      template: '<img src="' + $scope.multInfo.path + '"></img>',
      windowClass: 'leftModal'
    });
    // if this is an image playlist, pause cycling
    $timeout.cancel($scope.imagePlaylistTimeoutPromise);
  };

  $scope.addMediaToPlaylist = function(playlistId) {
    apiService.apiCall(function(data,status){
      if(status == 200) {
        //update playlist count
        $scope.getUserPlaylists();
      }
    }, 'POST', '/api/add-media-to-playlist', {multimedia_id: $scope.multInfo.id, playlist_id: playlistId })
  };

  $scope.removeMediaFromPlaylist = function(playlistId) {
    apiService.apiCall(function(data,status){
      if(status == 200) {
        //update playlist count
        $scope.getUserPlaylists();
      }
    }, 'POST', '/api/remove-media-from-playlist', {multimedia_id: $scope.multInfo.id, playlist_id: playlistId })
  };

  // determine if media is added or removed
  $scope.performPlaylistAction = function(playlistId) {
      apiService.apiCall(function(data,status){
        if(status == 200) {
          if(data.has_multimedia)
          {
            // media is already in playlist so remove it
            $scope.removeMediaFromPlaylist(playlistId);
          } else {
            // media isn't in playlist so add it
            $scope.addMediaToPlaylist(playlistId);
          }
        }

      }, 'GET', '/api/playlist-has-multimedia', {playlist_id: playlistId, multimedia_id: $scope.multInfo.id});
  };

}
MultimediaCtrl.$inject = ['$scope', '$stateParams', 'UserData', 'apiService', '$modal', '$location', '$timeout'];
