//= require_self
//= require_tree ./controllers

var app = angular.module('app', ['ui.router']);

// Sets up routing
app.config(function($locationProvider, $httpProvider, $stateProvider, $urlRouterProvider) {
  
  authToken = $("meta[name=\"csrf-token\"]").attr("content");
  $httpProvider.defaults.headers.common["X-CSRF-TOKEN"] = authToken;

	delete $httpProvider.defaults.headers.common["X-Requested-With"];

	$urlRouterProvider.otherwise('/');

	// set up states and routes
	$stateProvider
	.state('home', {
	  url: '/',
	  templateUrl: 'partial/home.html',
	  controller: 'HomeCtrl'
	})
	.state('dashboard', {
	  url: '/dashboard',
	  templateUrl: 'partial/dashboard.html',
	  controller: 'DashboardCtrl'
	})
  .state('login', {
    url: '/login',
    templateUrl: 'partial/login.html',
    controller: 'LoginCtrl'
  });

	$locationProvider.html5Mode(true);
});