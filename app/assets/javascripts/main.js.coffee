# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#= require_self
#= require_tree ./controllers/main

App = angular.module('App', ['ui.router'])

# Sets up routing
App.config(($locationProvider, $httpProvider, $stateProvider, $urlRouterProvider) ->

	console.log("Angular loaded")

	delete $httpProvider.defaults.headers.common["X-Requested-With"]

	# set up states and routes
	$stateProvider
	.state('post', {
	  url: '/post/:postId',
	  templateUrl: '../assets/mainPost.html',
	  controller: 'PostCtrl'
	})
	.state('index', {
	  url: '/',
	  templateUrl: '../assets/mainIndex.html',
	  controller: 'IndexCtrl'
	})

	# $urlRouterProvider.otherwise('/'{ templateUrl: '../assets/mainIndex.html', controller: 'IndexCtrl' })

	$locationProvider.html5Mode(true)
)