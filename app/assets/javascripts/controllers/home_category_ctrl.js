// homepage popular substate controller
function HomeCategoryCtrl($scope, $stateParams) {
  $scope.$parent.tab = $stateParams.category;
}
HomeCategoryCtrl.$inject = ['$scope', '$stateParams'];