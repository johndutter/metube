// browse channel ctrl controller
function BrowseChannelCtrl($scope, apiService, UserData) {
  $scope.channels = [];
  $scope.subscriptions = [];
  $scope.userdata = UserData;

  $scope.getChannels = function() {
    apiService.apiCall(function(data, status){
      if(status == 200){
        $scope.channels = data.channels;
      } else {
      }
    }, 'GET', '/api/get-channels', {});
  };

  $scope.getSubscriptions = function() {
    apiService.apiCall(function(data, status){
      if(status == 200){
        $scope.subscriptions = data.subscriptions;
      } else {
      }
    }, 'GET', '/api/get-user-subscriptions', {user_id: $scope.userdata.userid});
  };

  $scope.isSubscribed = function(i) {
    for (var n = 0; n < $scope.subscriptions.length; ++n) {
      if ($scope.channels[i].id === $scope.subscriptions[n].subscription_id) {
        return true;
      }
    }
    return false;
  };

  $scope.isClass = function(i) {
    if ($scope.isSubscribed(i)) {
      return 'btn-success';
    } else {
      return 'btn-danger';
    }
  };

  $scope.condText = function(i) {
    if ($scope.isSubscribed(i)) {
      return 'Subscribed';
    } else {
      return 'Subscribe';
    }
  };

  $scope.subscribe = function(i) {
    apiService.apiCall(function(data, status){
      if(status == 200){
        $scope.getChannels();
        $scope.getSubscriptions();
      } else {
      }
    }, 'POST', '/api/subscribe', {user_id: $scope.userdata.userid, subscription_id: $scope.channels[i].id});
  };

  $scope.getChannels();
  if ($scope.userdata.loggedin) {
    $scope.getSubscriptions();
  }

}
BrowseChannelCtrl.$inject = ['$scope', 'apiService', 'UserData'];