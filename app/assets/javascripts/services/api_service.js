// Service definition
app.service('apiService', ['$http', function($http){

  //args for apiCall (callback, requestMethod, action, requestData)
  this.apiCall = function(callback){

    var config = { method: arguments[1], url: arguments[2], timeout: 10000 };
    if (arguments[1] === 'GET') {
      _.extend(config, { params: arguments[3] });
    } else {
      _.extend(config, { data: arguments[3] });
    }

    $http(config).
      success(function(data, status, headers, config) {
          callback(data, status);
      }).
      error(function(data, status, headers, config) {
          callback(data, status);
      });
  };        
}]);

