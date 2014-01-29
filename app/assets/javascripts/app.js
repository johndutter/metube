//= require_self
//= require_tree ./controllers
//= require_tree ./services

var app = angular.module('app', ['ui.router']);

// Sets up routing
app.config(function($locationProvider, $httpProvider, $stateProvider, $urlRouterProvider) {
  
  authToken = $("meta[name=\"csrf-token\"]").attr("content");
  $httpProvider.defaults.headers.common["X-CSRF-TOKEN"] = authToken;

	delete $httpProvider.defaults.headers.common["X-Requested-With"];

    $httpProvider.interceptors.push(function($q, $location) {
      return {
        'response': function(response) {
          //check if response is from our rails api
          if('data' in response.config && response.config.data.hasOwnProperty('success')){
            if(!response.config.data.success){
              $location.path('login');
            }
            return response;
          }
          
          //resolve promise, angular controllers will handle response
          return response;
        },
        'responseError': function(rejection){
          if(rejection.status == '401'){
            $location.path('/dashboard');
          }
          //resolve promise
          return rejection;
        }
      };
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
	  controller: 'DashboardCtrl'
	  /*resolve: {
      loggedin: checkLoggedin
    }*/
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