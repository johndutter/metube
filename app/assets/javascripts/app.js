//= require_self
//= require_tree ./controllers
//= require_tree ./services

var app = angular.module('app', ['ui.router']);

// Sets up routing
app.config(function($locationProvider, $httpProvider, $stateProvider, $urlRouterProvider) {
  
  authToken = $("meta[name=\"csrf-token\"]").attr("content");
  $httpProvider.defaults.headers.common["X-CSRF-TOKEN"] = authToken;

	delete $httpProvider.defaults.headers.common["X-Requested-With"];

	// check if the user is connected
	var checkLoggedin = function($q, $timeout, $http, $location, $rootScope){
    // Initialize a new promise
    var deferred = $q.defer();

    // Make an AJAX call to check if the user is logged in
    $http.get('/loggedin').success(function(user){
      // Authenticated
      if (user !== '0') {
        $timeout(deferred.resolve, 0);

        // check if any global variables (failsafe)
        // if no globals, load them

      } else {
        // Not Authenticated
        // clear global user status meaning no longer logged in
        $timeout(function(){deferred.reject();}, 0);
        $location.url('/login');
      }
    });

    return deferred.promise;
  };

  // Add an interceptor for AJAX errors
	$httpProvider.responseInterceptors.push(function($q, $location) {
    return function(promise) {
      return promise.then(
        // Success: just return the response
        function(response){
          return response;
        }, 
        // Error: check the error status to get only the 401
        function(response) {
          if (response.status === 401)
            $location.url('/login'); // not working it seems
          return $q.reject(response);
        }
      );
    }
  });

	// declare routes and states
	$urlRouterProvider.otherwise('/');

	$stateProvider
	.state('home', {
	  url: '/',
	  templateUrl: 'partial/home.html',
	  controller: 'HomeCtrl'
	})
	.state('dashboard', {
	  url: '/dashboard',
	  templateUrl: 'secured/dashboard.html',
	  controller: 'DashboardCtrl',
	  resolve: {
      loggedin: checkLoggedin
    }
	})
  .state('login', {
    url: '/login',
    templateUrl: 'partial/login.html',
    controller: 'LoginCtrl'
  })
  .state('signup', {
    url: '/signup',
    templateUrl: 'partial/signup.html',
    controller: 'SignupCtrl'
  });

	$locationProvider.html5Mode(true);
});