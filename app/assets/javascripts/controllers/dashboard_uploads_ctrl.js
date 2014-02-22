function DashboardUploadsCtrl($scope, $timeout, UserData, apiService, startFromFilter){
  $scope.$parent.tab = 'uploads';
  $scope.videos = [];
  $scope.images = [];
  $scope.audios = [];
  $scope.videosInProgress = [];
  $scope.progressIndex = 0;

  $scope.numberOfThumbnailsToDisplay = 3;

  $scope.init = function() {

    // get multimedia uploaded by user
    apiService.apiCall(function(data, status) {
      if (status === 200) {
        $scope.videos = data.videos;
        $scope.images = data.images;
        $scope.audios = data.audio;

        initializePagingData();
        
      } else {
        // error getting user data
      }
    }, 'GET', '/api/get-user-multimedia', {user_id: UserData.userid});
  };

  $scope.init();

  var initializePagingData = function() {
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
  }

    var getMediaInProgress = function() {
      //get multimedia objects that are being transcoded
      apiService.apiCall(function(data, status) {
        if (status === 200) {
          $scope.videosInProgress = data.videosInProgress;
          //check for video being transcoded every 30 seconds
          $timeout(function() {getMediaInProgress()}, 30000);
          
        } else {
          // error 
        }
      }, 'GET', '/api/get-user-multimedia-in-progress', {user_id: UserData.userid});

    }

    var getProgressUpdates = function() {
      //get updates on transcoding process for every media object in videosInProgress
      for(var i = 0; i < $scope.videosInProgress.length; i++) {
        $scope.progressIndex = i;

        apiService.apiCall(function(data, status) {
          if (status === 200) {
            $scope.videosInProgress[$scope.progressIndex].progress = data.progress;
          } else {
            // error 
          }
        }, 'GET', '/api/get-multimedia-progress', {multimedia_id: $scope.videosInProgress[$scope.progressIndex].id});
      }

      // get transcoding progress every 2 seconds
      $timeout(function() {getProgressUpdates()}, 2000);
    }

    //start checking for videos in progress
    getMediaInProgress();
    getProgressUpdates();
}

DashboardUploadsCtrl.$inject = ['$scope', '$timeout', 'UserData', 'apiService', 'startFromFilter'];