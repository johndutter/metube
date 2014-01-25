//= require_self
//= require_tree ./controllers

var App = angular.module('App', ['ui.router']);

// Sets up routing
App.config(function($locationProvider, $httpProvider, $stateProvider, $urlRouterProvider) {

	console.log('Angular loaded');

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
	});

	$locationProvider.html5Mode(true);
});