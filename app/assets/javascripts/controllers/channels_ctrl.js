function ChannelsCtrl($scope, apiService, UserData, $stateParams, startFromFilter) {
  $scope.videos= [];
  $scope.audios = [];
  $scope.images = [];

  $scope.playlists = [];
  $scope.channelInfo = {};
  $scope.numberOfThumbnailsToDisplay = 3;

  $scope.init = function () {
    apiService.apiCall(function(data, status) {
      if(status == 200) {
        $scope.channelInfo.username = data.username;

        $scope.getMultimedia();
        $scope.getPlaylists();
      } else {
      }
    }, 'GET', '/api/get-uploader-info', {id: $stateParams.id});

    var initializeMediaPagingData = function() {
      // hashes for each multimedia type to keep track of paging information

      // videos hash
      $scope.videosPagingHash = {
        pageNumber: 1,
        totalPages: Math.ceil($scope.videos.length / $scope.numberOfThumbnailsToDisplay),
        startFrom: 0,
        showPrevious: false,
        showNext: ($scope.videos.length > $scope.numberOfThumbnailsToDisplay),
        totalItems: $scope.videos.length
      }

      // images hash
      $scope.imagesPagingHash = {
        pageNumber: 1,
        totalPages: Math.ceil($scope.images.length / $scope.numberOfThumbnailsToDisplay),
        startFrom: 0,
        showPrevious: false,
        showNext: ($scope.images.length > $scope.numberOfThumbnailsToDisplay),
        totalItems: $scope.images.length
      }

      // audio hash
      $scope.audioPagingHash = {
        pageNumber: 1,
        totalPages: Math.ceil($scope.audios.length / $scope.numberOfThumbnailsToDisplay),
        startFrom: 0,
        showPrevious: false,
        showNext: ($scope.audios.length > $scope.numberOfThumbnailsToDisplay),
        totalItems: $scope.audios.length
      } 
    };

    var initializePlaylistPagingData = function() {
      // playlist hash
      $scope.playlistPagingHash = {
        pageNumber: 1,
        totalPages: Math.ceil($scope.playlists.length / $scope.numberOfThumbnailsToDisplay),
        startFrom: 0,
        showPrevious: false,
        showNext: ($scope.playlists.length > $scope.numberOfThumbnailsToDisplay),
        totalItems: $scope.playlists.length
      } 
    }

    $scope.getMultimedia = function () {
      apiService.apiCall(function(data, status) {
        if(status == 200) {
          for(var i = 0; i < data.all_multimedia.length; i++) {
            media = data.all_multimedia[i];
            switch(media.mediaType) {
              case 'video':
                $scope.videos.push(media);
                break;
              case 'audio':
                $scope.audios.push(media);
                break;
              case 'image':
                $scope.images.push(media);
                break;
            }
            console.log($scope.videos);
            initializeMediaPagingData();
          }
        } else {
        }
      }, 'GET', '/api/get-user-multimedia', {user_id: $stateParams.id});
    };

    $scope.getPlaylists = function () {
      apiService.apiCall(function(data, status) {
        if(status == 200) {
          $scope.playlists = data.uploaded_playlists;
          $scope.getPlaylistThumbnails();
        }
      }, 'GET', '/api/get-user-playlists', {user_id: $stateParams.id});
    };

    $scope.getPlaylistThumbnails = function() {
      for(var i = 0; i < $scope.playlists.length; i++) {
        //wrap call in function to save value of counter 
        (function (loopCounter) { apiService.apiCall(function(data,status){
          if(status == 200) {
            // load in default images if playlist is empty
            if(data.thumbnail_media[0] === undefined) {
              data.thumbnail_media[0] = {id: 0};
              data.thumbnail_media[0].thumbnail_path = '/uploads/thumbnails/empty_playlist_thumbnail.png';
            }
            if(data.thumbnail_media[1] === undefined) {
              data.thumbnail_media[1] = {id: 0};
              data.thumbnail_media[1].thumbnail_path = '/uploads/thumbnails/empty_playlist_thumbnail.png';
            }

            $scope.playlists[loopCounter].media = data.thumbnail_media;
          } else {

          }
        }, 'GET', '/api/get-playlist-thumbnails', {playlist_id: $scope.playlists[i].id});
        })(i)
      }
      initializePlaylistPagingData();
    };
  };

  $scope.init();

//display previous 3 items in a multimedia array
$scope.previousPage = function(mediaHash){
  mediaHash.pageNumber--;

  if(mediaHash.pageNumber ==1){
    mediaHash.showPrevious = false;
    mediaHash.showNext = true;
  }

  mediaHash.startFrom = (mediaHash.pageNumber - 1) * $scope.numberOfThumbnailsToDisplay;
};

//display next 3 itms in multimedia array
$scope.nextPage = function(mediaHash){
  mediaHash.pageNumber++;

  //see if another page is available
  if(mediaHash.pageNumber == mediaHash.totalPages) {
    mediaHash.showNext = false;
  }
  mediaHash.showPrevious = true;
  mediaHash.startFrom = (mediaHash.pageNumber - 1) * $scope.numberOfThumbnailsToDisplay;

  //make sure there are at least 3 to display
  if(mediaHash.totalItems - mediaHash.startFrom < $scope.numberOfThumbnailsToDisplay ) {
    mediaHash.startFrom--;
  }
};
}

ChannelsCtrl.$inject = ['$scope', 'apiService', 'UserData', '$stateParams', 'startFromFilter'];