// dashboard controller
function MultimediaCtrl($scope, $stateParams, apiService) {

  $scope.init = function() {

    // go get the multimedia type and information
    apiService.apiCall(function(data, status) {
      if (status === 200) {

      } else {
        
      }
    }, 'GET', '/api/get-multimedia-info', { id: $stateParams.id });

    $("#player").flowplayer({
      ratio: 5/12,
      rtmp: "rtmp://s3b78u0kbtx79q.cloudfront.net/cfx/st",
      playlist: [
        [
          { mp4:   "http://localhost:3000/uploads/" + $stateParams.id + ".mov" }
        ]
      ],
      /* DOESNT SEEM TO WORK?? */
      plugsin:{
        controls: {
          url: 'http://releases.flowplayer.org/js/flowplayer.controls-3.2.11.min.js'
        }
      },
      // set an event handler in the configuration
      onFinish: function() {
          alert("Click Player to start video again");
      }
    });

  }
  $scope.init();

}
MultimediaCtrl.$inject = ['$scope', '$stateParams', 'apiService'];
