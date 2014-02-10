// dashboard controller
function MultimediaCtrl($scope, $stateParams, apiService) {

  $scope.init = function() {

    // go get the multimedia type and information
    apiService.apiCall(function(data, status) {
      if (status === 200) {
        
      } else {
        
      }
    }, 'GET', '/api/get-multimedia-info', { id: $stateParams.id });

    

    $('#player').flowplayer({
      embed: false,
      swf: '/flowplayer.swf',
      playlist: [
        [
          { mp4:   "http://localhost:3000/uploads/" + $stateParams.id + ".mov" }
        ]
      ]
    });

  }
  $scope.init();

}
MultimediaCtrl.$inject = ['$scope', '$stateParams', 'apiService'];
