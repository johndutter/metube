// homepage popular substate controller
function HomePopularCtrl($scope, apiService) {
  $scope.$parent.tab = 'popular';
  $scope.categories = [];

  $scope.getPagedVideos = function(category, ordering, number, offset, destination) {
    var infoObj = {
      category: category,
      ordering: ordering,
      number: number,
      offset: offset
    };
    apiService.apiCall(function(data, status){
      if(status == 200){
        $scope.categories[destination]['multimedia'] = data.multimedia;
      } else {
      }
    }, 'GET', '/api/get-multimedia', infoObj);
  };

  $scope.getCategories = function() {
    apiService.apiCall(function(data, status){
      if(status == 200){
        $scope.categories = data.categories;

        // set up paging info
        for (var i = 0; i < $scope.categories.length; ++i) {
          $scope.categories[i]['paging'] = {
            length: 3,
            offset: 0
          }
        }

        $scope.getAllMultimedia();
      } else {
      }
    }, 'GET', '/api/get-categories', {});
  };

  $scope.getAllMultimedia = function() {
    for (var i = 0; i < $scope.categories.length; ++i) {
      $scope.getPagedVideos($scope.categories[i]['name'], 'views', $scope.categories[i]['paging']['length'], $scope.categories[i]['paging']['offset'], i);
    }
  };

  $scope.move = function(direction, index) {
      if (direction === 'left') {
        if ($scope.categories[index]['paging']['offset'] !== 0) {
          $scope.categories[index]['paging']['offset'] = $scope.categories[index]['paging']['offset'] - $scope.categories[index]['paging']['length'];
          $scope.getPagedVideos($scope.categories[index]['name'], 'views', $scope.categories[index]['paging']['length'], $scope.categories[index]['paging']['offset'], index);
        }
      } else {
        $scope.categories[index]['paging']['offset'] = $scope.categories[index]['paging']['offset'] + $scope.categories[index]['paging']['length'];
        $scope.getPagedVideos($scope.categories[index]['name'], 'views', $scope.categories[index]['paging']['length'], $scope.categories[index]['paging']['offset'], index);
      }
  };

  $scope.getCategories();
}
HomePopularCtrl.$inject = ['$scope', 'apiService'];