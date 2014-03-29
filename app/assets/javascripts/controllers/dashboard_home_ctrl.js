// dashboard profile controller
function DashboardHomeCtrl($scope, apiService) {
  $scope.$parent.tab = 'home';
  $scope.info = {};
  $scope.mult_data = [];

  $scope.drawGraph = function() {
    var svg = dimple.newSvg("#chartContainer", 666, 470);
    var data = $scope.mult_data;
    var myChart = new dimple.chart(svg, data);
    myChart.setBounds(45, 50, 610, 380);

    var y = myChart.addAxis('y', null, 'Views');
    var x = myChart.addTimeAxis('x', 'Date', "%Y-%m-%d %H:%M:%S", "%b %d");
    var z = myChart.addAxis('z', null, 'sentiments');

    z.overrideMin = 0;

    x.overrideMin = new Date($scope.info.early_side);
    x.overrideMax = new Date($scope.info.late_side);

    var s = myChart.addSeries(['thumbnail_path','id', 'mediaType'], dimple.plot.bubble);
    s.addEventHandler("mouseover", onHover);
    s.addEventHandler("mouseleave", onLeave);
    s.addEventHandler("click", onClick);

    myChart.addLegend(240, 10, 360, 20, 'right');
    myChart.draw();

    // Event to handle mouse enter
    function onHover(e) {
      // Get the properties of the selected shape
      var cx = parseFloat(e.selectedShape.attr("cx")),
          cy = parseFloat(e.selectedShape.attr("cy")),
          r = parseFloat(e.selectedShape.attr("r")),
          fill = e.selectedShape.attr("fill"),
          stroke = e.selectedShape.attr("stroke");
          
      // Set the size and position of the popup
      var width = 155,
          height = 100,
          x = (cx + r + width + 10 < svg.attr("width") ?
                cx + r + 10 :
                cx - r - width - 20);
          y = (cy - height / 2 < 0 ?
                15 :
                cy - height / 2);
              
      // Fade the popup fill mixing the shape fill with 80% white
      var popupFillColor = d3.rgb(
                  d3.rgb(fill).r + 0.8 * (255 - d3.rgb(fill).r),
                  d3.rgb(fill).g + 0.8 * (255 - d3.rgb(fill).g),
                  d3.rgb(fill).b + 0.8 * (255 - d3.rgb(fill).b)
              );
      
      // Create a group for the popup objects
      popup = svg.append("g");
      
      // Add a rectangle surrounding the chart
      popup
        .append("rect")
        .attr("x", x + 5)
        .attr("y", y - 5)
        .attr("width", width)
        .attr("height", height)
        .attr("rx", 5)
        .attr("ry", 5)
        .style("fill", popupFillColor)
        .style("stroke", stroke)
        .style("stroke-width", 2);
      
      // Add the series value text
      popup
        .append("svg:image")
        .attr('x',x + 12)
        .attr('y', y + 3)
        .attr('width', 140)
        .attr('height', 84)
        .attr("xlink:href",e.seriesValue[0]);
    };
    
    // Event to handle mouse exit
    function onLeave(e) {
      // Remove the popup
      if (popup !== null) {
        popup.remove();
      }
    };

    // Event to handle mouse click
    function onClick(e) {
      window.location = '/multimedia/' + e.seriesValue[1];
    };
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