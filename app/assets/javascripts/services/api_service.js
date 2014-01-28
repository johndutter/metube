// Service definition
app.service('apiService', ['$http', function($http){
    //args for apiCall (callback, requestMethod, action, requestData)
    this.apiCall = function(callback){
      $http({ method: arguments[1], url: "/api/" + arguments[2], timeout: 10000, data: arguments[3]}).
          success(function(data, status, headers, config) {
              callback(data, status);
          }).
          error(function(data, status, headers, config) {
              callback(data, status);
          });
    };        
}]);

