// dashboard controller
function MultimediaCtrl($scope, $stateParams, apiService) {
  $scope.multInfo = {};
  $scope.uploader = {};

  $scope.init = function() {

    // go get the multimedia type and information
    apiService.apiCall(function(data, status) {
      if (status === 200) {
        console.log(data);
        $scope.multInfo = data;
        $scope.initFlowplayer();
        $scope.getUploaderInfo();
      } else {
        
      }
    }, 'GET', '/api/get-multimedia-info', { id: $stateParams.id });

    
    $scope.initFlowplayer = function() {
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

    $scope.getUploaderInfo = function() {
      // go get the multimedia type and information
      apiService.apiCall(function(data, status) {
        if (status === 200) {
          $scope.uploader = data;
        } else {
          
        }
      }, 'GET', '/api/get-uploader-info', { id: $scope.multInfo.user_id });
    }
    

  }
  $scope.init();

}
MultimediaCtrl.$inject = ['$scope', '$stateParams', 'apiService'];
