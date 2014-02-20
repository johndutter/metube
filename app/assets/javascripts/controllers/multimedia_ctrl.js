// dashboard controller
function MultimediaCtrl($scope, $stateParams, apiService) {
  $scope.multInfo = {};
  $scope.uploader = {};
  $scope.sentimentInfo = {};
  $scope.show = {
    video: false,
    image: false,
    audio: false
  };

  $scope.init = function() {

    // go get the multimedia type and information
    apiService.apiCall(function(data, status) {
      if (status === 200) {
        $scope.multInfo = data;

        if ($scope.multInfo.mediaType === 'video') {
          $scope.initFlowplayer();  
        }
        if ($scope.multInfo.mediaType === 'image') {
          $scope.initImage();  
        }

        $scope.getUploaderInfo();
        $scope.getSentimentInfo();
        $scope.updateViewCount();
      } else {
        
      }
    }, 'GET', '/api/get-multimedia-info', { id: $stateParams.id });

    $scope.initFlowplayer = function() {
      $scope.show.video = true;
      var ending = $scope.multInfo.path.substr($scope.multInfo.path.lastIndexOf('.'));
      var movieFormat = {};
      if (ending === '.mov' || ending === '.mp4' || ending === '.m4v') {
        movieFormat['mp4'] = $scope.multInfo.path;
      }
      if (ending === '.flv') {
        movieFormat['flv'] = $scope.multInfo.path;
      }

      $('#player').flowplayer({
        embed: false,
        flashfit: true,
        swf: '/flowplayer.swf',
        playlist: [
          [
            movieFormat
          ]
        ]
      });
    };

    $scope.initImage = function() {
      $scope.show.image = true;
    };

    $scope.getUploaderInfo = function() {
      apiService.apiCall(function(data, status) {
        if (status === 200) {
          $scope.uploader = data;
        } else {
        }
      }, 'GET', '/api/get-uploader-info', { id: $scope.multInfo.user_id });
    }

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
    }
    

  }
  $scope.init();

  $scope.sentiment = function(sentiment) {
    apiService.apiCall(function(data, status) {
      if (status === 200) {
        $scope.sentimentInfo = data;
      } else {
      }
    }, 'POST', '/api/sentiment-multimedia', { multimedia_id: $scope.multInfo.id, option: sentiment });
  }

  $scope.clickedDownload = function($event) {
    $event.preventDefault();
    alert('Please right click and save link as.');
  }

}
MultimediaCtrl.$inject = ['$scope', '$stateParams', 'apiService'];
