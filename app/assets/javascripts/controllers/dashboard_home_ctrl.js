// dashboard profile controller
function DashboardHomeCtrl($scope, apiService) {
  $scope.$parent.tab = 'home';
  $scope.info = {};
  $scope.mult_data = [];

  $scope.drawGraph = function() {
    var svg = dimple.newSvg("#chartContainer", 666, 425);
    var myChart = new dimple.chart(svg, $scope.mult_data);
    myChart.setBounds(40, 30, 620, 360);

    var x = myChart.addTimeAxis('x', 'Date', "%Y-%m-%d %H:%M:%S", "%b %d");
    var y = myChart.addAxis('y', 'Views');
    var z = myChart.addMeasureAxis('z', 'sentiments');

    x.overrideMin = new Date($scope.info.early_side);
    x.overrideMax = new Date($scope.info.late_side);

    myChart.addSeries('mediaType', dimple.plot.bubble);
    myChart.addLegend(240, 10, 360, 20, 'right');
    myChart.draw();
  };

  $scope.getAnalytics = function() {
    apiService.apiCall(function(data, status) {
      if (status === 200) {
        $scope.mult_data = data.multimedia;
        $scope.info = data.info;
        $scope.drawGraph();
      } else {
      }
    }, 'GET', '/api/get-analytics', {});
  };

  $scope.getAnalytics();

}
DashboardHomeCtrl.$inject = ['$scope', 'apiService'];