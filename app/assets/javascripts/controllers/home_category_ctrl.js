// homepage popular substate controller
function HomeCategoryCtrl($scope, $stateParams, apiService) {
  $scope.$parent.tab = $stateParams.category;
  $scope.category = $stateParams.category;
  $scope.popular = {
    length: 3,
    offset: 0
  }
  $scope.popularTabs = [];
  $scope.recent = {
    length: 3,
    offset: 0
  }
  $scope.recentTabs = [];
  $scope.browse = {
    length: 12,
    offset: 0
  }
  $scope.browseTabs = [];

  $scope.getPagedVideos = function(ordering, number, offset, destination) {
    var infoObj = {
      category: $scope.category,
      ordering: ordering,
      number: number,
      offset: offset
    };
    apiService.apiCall(function(data, status){
      if(status == 200){
        if (destination === 'popular') {
          $scope.popularTabs = data.multimedia;
        }
        if (destination === 'recent') {
          $scope.recentTabs = data.multimedia;
        }
        if (destination === 'browse') {
          $scope.browseTabs = data.multimedia;
        }
      } else {
      }
    }, 'GET', '/api/get-multimedia', infoObj);
  };

  $scope.getPopular = function() {
    $scope.getPagedVideos('views', $scope.popular['length'], $scope.popular['offset'], 'popular');
  };

  $scope.getMostRecent = function() {
    $scope.getPagedVideos('recent', $scope.recent['length'], $scope.recent['offset'], 'recent');
  }
  $scope.getBrowse = function() {
    $scope.getPagedVideos('recent', $scope.browse['length'], $scope.browse['offset'], 'browse');
  }

  $scope.getPopular();
  $scope.getMostRecent();
  $scope.getBrowse();

  $scope.movePopular = function(direction) {
    if (direction === 'left') {
      if ($scope.popular.offset !== 0) {
        $scope.popular['offset'] = $scope.popular['offset'] - $scope.popular['length'];
        $scope.getPopular();
      }
    } else {
      $scope.popular['offset'] = $scope.popular['offset'] + $scope.popular['length'];
      $scope.getPopular();
    }
  };

  $scope.moveRecent = function(direction) {
      if (direction === 'left') {
        if ($scope.recent.offset !== 0) {
          $scope.recent['offset'] = $scope.recent['offset'] - $scope.recent['length'];
          $scope.getMostRecent();
        }
      } else {
        $scope.recent['offset'] = $scope.recent['offset'] + $scope.recent['length'];
        $scope.getMostRecent();
      }
  };

  $scope.moveBrowse = function(direction) {
      if (direction === 'left') {
        if ($scope.browse.offset !== 0) {
          $scope.browse['offset'] = $scope.browse['offset'] - $scope.browse['length'];
          $scope.getBrowse();
        }
      } else {
        $scope.browse['offset'] = $scope.browse['offset'] + $scope.browse['length'];
        $scope.getBrowse();
      }
  };


}
HomeCategoryCtrl.$inject = ['$scope', '$stateParams', 'apiService'];