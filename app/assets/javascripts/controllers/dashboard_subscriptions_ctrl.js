function DashboardSubscriptionsCtrl($scope, apiService, UserData) {
  $scope.$parent.tab = 'subscriptions';
  $scope.subscriptions = [];

  $scope.init = function() {
    apiService.apiCall(function(data, status) {
      if(status == 200) {
        $scope.subscriptions = data.subscriptions;
        $scope.getSubscriptionMedia();
      }
    }, 'GET', '/api/get-user-subscriptions', {user_id: UserData.userid});

    $scope.getSubscriptionMedia = function () {
      for(var i = 0; i < $scope.subscriptions.length; i++) {
      (function (loopCounter) {apiService.apiCall(function(data, status) {
        if(status == 200) {
          $scope.subscriptions[loopCounter].multimedia = data.all_multimedia;
          $scope.subscriptions[loopCounter].username = $scope.getSubscriptionInfo($scope.subscriptions[loopCounter]);
        }
      }, 'GET', '/api/get-user-multimedia', {user_id: $scope.subscriptions[loopCounter].subscription_id});}) (i)
      }
    };

    $scope.getSubscriptionInfo = function (subscription) {
      apiService.apiCall(function(data, status) {
        if(status == 200 ) {
         subscription.username = data.username;
        } 
      }, 'GET', '/api/get-uploader-info', {id: subscription.subscription_id});
    }
  };

  $scope.init();
}

DashboardSubscriptionsCtrl.$inject = ['$scope', 'apiService', 'UserData'];