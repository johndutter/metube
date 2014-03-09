function DashboardSubscriptionsCtrl($scope, apiService, UserData) {
  $scope.$parent.tab = 'subscriptions';
  $scope.subscriptions = [];

  $scope.init = function() {
    apiService.apiCall(function(data, status) {
      if(status == 200) {
        $scope.subscriptions = data.subscriptions;
        $scope.getSubscriptionMedia();
      }
    }, 'GET', '/api/get-user-subscriptions', {user_id: UserData.id});

    $scope.getSubscriptionMedia = function () {
      for(var i = 0; i < $scope.subscriptions.length; i++) {
      (function (loopCounter) {apiService.apiCall(function(data, status) {
        if(status == 200) {
          $scope.subscriptions[loopCounter].multimedia = data.multimedia;
          $scope.subscriptions[loopCounter].username = data.multimedia.username;
        }
      }, 'GET', '/api/get-user-media');}) (i)
      }
    };
  };

  $scope.init();
}

DashboardSubscriptionsCtrl.$inject = ['$scope', 'apiService', 'UserData'];