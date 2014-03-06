function DashboardPlaylistsCtrl($scope, UserData, apiService, $modal, $location, $timeout, $state){
  $scope.$parent.tab = 'playlists';
  $scope.showErrors = false;
  $scope.errorMessage;
  $scope.form = {};
  $scope.formData = {};
  $scope.playlistOptions = [
    { label: 'All playlists', value: '1' },
    { label: 'My playlists', value: '2' },
    { label: 'Liked playlists', value: '3' }
  ];

  $scope.selectedOption = 'All Playlists';
  $scope.playlists;
  $scope.allPlaylists;
  $scope.uploadedPlaylists = [];
  $scope.likedPlaylists;

  $scope.maxToDisplay = 12;
  $scope.displayOffset = 0;
  $scope.counter;

  $scope.getPlaylistThumbnails = function() {
    for(var i = 0; i < $scope.playlists.length; i++) {
      //wrap call in function to save value of counter 
      (function (loopCounter) { apiService.apiCall(function(data,status){
        if(status == 200) {
          // load in default images if playlist is empty
          if(data.thumbnails[0] === undefined) {
            data.thumbnails[0] = '/uploads/thumbnails/empty_playlist_thumbnail.png'
          }
          if(data.thumbnails[1] === undefined) {
            data.thumbnails[1] = '/uploads/thumbnails/empty_playlist_thumbnail.png'
          }

          $scope.playlists[loopCounter].thumbnails = data.thumbnails;
        } else {

        }
      }, 'GET', '/api/get-playlist-thumbnails', {playlist_id: $scope.playlists[i].id});
      })(i)
    }
  };

  // bring in appropriate playlist data
  $scope.init = function(){
    apiService.apiCall(function(data, status){
      if(status == 200) {
        $scope.uploadedPlaylists = data.uploaded_playlists;
        apiService.apiCall(function(data,status){
          if( status == 200) {
            $scope.likedPlaylists = data.liked_playlists;
            $scope.playlists = $scope.allPlaylists = $scope.uploadedPlaylists.concat($scope.likedPlaylists);
            $scope.getPlaylistThumbnails();
          }

        }, 'GET', '/api/get-user-liked-playlists', {user_id: UserData.userid, limit: $scope.maxToDisplay, offset: $scope.displayOffset});
      };

    }, 'GET', '/api/get-user-playlists', {user_id: UserData.userid, limit: $scope.maxToDisplay, offset: $scope.displayOffset});
  };

  $scope.init();

  $scope.showPlaylists = function(playlistOption, optionName) {
    $scope.selectedOption = optionName;
    // change subset of playlists displayed
    switch(playlistOption) {
      // user uploaded playlists
      case '2':
        $scope.playlists = $scope.uploadedPlaylists;
        break;
      // liked playlists
      case '3':
        $scope.playlists = $scope.likedPlaylists;
        break;
        // all playlists
      default:
         $scope.playlists = $scope.allPlaylists;
         break;
    }
  };

  // display modal for playlist creation
  $scope.openModal = function(){
        $scope.modalInstance = $modal.open({
        templateUrl: '/secured/create-playlist-modal.html',
        controller: DashboardPlaylistsCtrl
      });
  };

  $scope.createPlaylist = function(){
    // check if form is valid
    if ($scope.form.createplaylist.$valid === false) {
      $scope.showErrors = true;
      return;
    }

    // add key for rails strong parameters and user data
    $scope.formData.user_id = UserData.userid;
    $scope.formData = {playlist: $scope.formData};

    // send form data to rails api
    apiService.apiCall(function(data, status){
      if(status == 200) {
        $scope.cancel();
        //reload the page
        $state.go($state.$current, null, { reload: true });
      }
      else {
        $scope.errorMessage = 'Unable to create playlist';
      }

    }, 'POST', '/api/create-playlist', $scope.formData);

  };

  // cancel form creation
  $scope.cancel = function () {
    $scope.$dismiss('cancel');
  };

  // watch error message
  $scope.$watch('errorMessage', function(newValue, oldValue) {
    if (newValue !== '') {
      $timeout(function() {
        $scope.errorMessage = '';
      }, 3000);
    }
  }, true);

}

DashboardPlaylistsCtrl.$inject = ['$scope', 'UserData', 'apiService', '$modal', '$location', '$timeout', '$state'];