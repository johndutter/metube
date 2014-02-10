// dashboard controller
function MultimediaCtrl($scope, $stateParams, apiService) {
  $scope.multInfo = {};

  $scope.init = function() {

    // go get the multimedia type and information
    apiService.apiCall(function(data, status) {
      if (status === 200) {
        console.log(data);
        $scope.multInfo = data;
        $scope.initFlowplayer();
      } else {
        
      }
    }, 'GET', '/api/get-multimedia-info', { id: $stateParams.id });

    
    $scope.initFlowplayer = function() {
      console.log($scope.multInfo.path);
      $('#player').flowplayer({
        embed: false,
        swf: '/flowplayer.swf',
        playlist: [
          [
            { mp4: $scope.multInfo.path },
            { webm: $scope.multInfo.path },
            { flv: $scope.multInfo.path }
          ]
        ]
      });
    };
    

  }
  $scope.init();

}
MultimediaCtrl.$inject = ['$scope', '$stateParams', 'apiService'];
