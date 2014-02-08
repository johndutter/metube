// dashboard controller
function MultimediaCtrl($scope) {
  $(function() { // make sure the DOM is ready
    console.log("inside");
    $("#player").flowplayer({
      ratio: 5/12,
      rtmp: "rtmp://s3b78u0kbtx79q.cloudfront.net/cfx/st",
      playlist: [
        [
          { mp4:   "http://stream.flowplayer.org/bauhaus/624x260.mp4" }
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
  });

}
MultimediaCtrl.$inject = ['$scope'];