//= require_self
//= require_tree ./controllers
//= require_tree ./services
//= require_tree ./filters

var app = angular.module('app', ['ui.router', 'ui.bootstrap'])
.config(['$locationProvider', '$httpProvider', '$stateProvider', '$urlRouterProvider', function($locationProvider, $httpProvider, $stateProvider, $urlRouterProvider) {
  
  authToken = $("meta[name=\"csrf-token\"]").attr("content");
  $httpProvider.defaults.headers.common["X-CSRF-TOKEN"] = authToken;

  delete $httpProvider.defaults.headers.common["X-Requested-With"];

  // check if the user is connected
  var checkLoggedin = function($q, $timeout, apiService, $location){
    // Initialize a new promise
    var deferred = $q.defer();
    
    //call api and check if user is logged in
    apiService.apiCall(function(data, status) {
      // Authenticated
      if (data.userid !== '0') {
        $timeout(deferred.resolve, 0);

        // check if any global variables (failsafe)
        // if no globals, load them

      } else {
        // Not Authenticated
        // clear global user status meaning no longer logged in
        $timeout(function(){deferred.reject();}, 0);
        $location.url('/login');
      }
      
    }, 'GET', '/api/loggedin', {});

    return deferred.promise;
  };

  $httpProvider.interceptors.push(function($q, $location) {
    return {
      //if there in unauthorized call to api redirect to login
      'responseError': function(rejection){
        if(rejection.status == 401){
          // window.location is used because the rejection status of promise affects $location
          // promise isn't resolved so scope-life cycle is incomplete and observers/watchers are not notified of change in $location
          // http://docs.angularjs.org/guide/dev_guide.services.$location#caveats
          window.location = '/login'; 
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
    url: '',
    templateUrl: '/partial/home.html',
    controller: 'HomeCtrl',
    abstract: true
	})
  .state('home.popular', {
    url: '/',
    templateUrl: '/partial/home-popular.html',
    controller: 'HomePopularCtrl'
  })
  .state('home.category', {
    url: '/category/:category',
    templateUrl: '/partial/home-category.html',
    controller: 'HomeCategoryCtrl'
  })
	.state('dashboard', {
	  url: '/dashboard',
	  templateUrl: '/secured/dashboard.html',
	  controller: 'DashboardCtrl',
	  resolve: {
      loggedin: checkLoggedin
    }
  })
  .state('dashboard.home', {
    url: '/home',
    templateUrl: '/secured/dashboard-home.html',
    controller: 'DashboardHomeCtrl',
    resolve: {
      loggedin: checkLoggedin
    }
  })
  .state('dashboard.profile', {
    url: '/profile',
    templateUrl: '/secured/dashboard-profile.html',
    controller: 'DashboardProfileCtrl',
    resolve: {
      loggedin: checkLoggedin
    }
  })
  .state('dashboard.uploads', {
    url: '/uploads',
    templateUrl: '/secured/dashboard-uploads.html',
    controller: 'DashboardUploadsCtrl',
    resolve: {
      loggedin: checkLoggedin
    }
  })
  .state('dashboard.playlists', {
    url: '/playlists',
    templateUrl: '/secured/dashboard-playlists.html',
    controller: 'DashboardPlaylistsCtrl',
    resolve: {
      loggedin: checkLoggedin
    }
  })
  .state('dashboard.subscriptions', {
    url: '/subscriptions',
    templateUrl: '/secured/dashboard-subscriptions.html',
    controller: 'DashboardSubscriptionsCtrl',
    resolve: {
      loggedin: checkLoggedin
    }
  })
  .state('login', {
    url: '/login',
    templateUrl: '/partial/login.html',
    controller: 'LoginCtrl'
  })
  .state('signup', {
    url: '/signup',
    templateUrl: '/partial/signup.html',
    controller: 'SignupCtrl'
  })
  .state('upload', {
    url: '/upload',
    templateUrl: '/secured/upload.html',
    controller: 'UploadCtrl',
    resolve: {
      loggedin: checkLoggedin
    }
  })
  .state('multimedia', {
    url: '/multimedia/:id',
    abstract: true,
    templateUrl: '/partial/multimedia.html',
    controller: 'MultimediaCtrl'
  })
  .state('multimedia.sidebar', {
    url: '',
    templateUrl: '/partial/multimedia-sidebar.html',
    controller: 'MultimediaSidebarCtrl'
  })
  .state('multimedia.playlist', {
    url: '/playlist/:playlist_id',
    templateUrl: '/partial/multimedia-playlist.html',
    controller: 'MultimediaPlaylistCtrl'
  })
  .state('channel', {
    url: '/channel/:id',
    templateUrl: '/partial/channel.html',
    controller: 'ChannelsCtrl'
  })
  .state('playlist', {
    url: '/playlist/:id',
    templateUrl: '/partial/playlist.html',
    controller: 'PlaylistsCtrl'
  })
  .state('browse', {
    url: '/browse',
    abstract: true,
    templateUrl: '/partial/browse.html',
    controller: 'BrowseCtrl'
  })
  .state('browse.channels', {
    url: '/channels',
    templateUrl: '/partial/browse-channels.html',
    controller: 'BrowseChannelCtrl'
  })
  .state('browse.playlists', {
    url: '/playlists',
    templateUrl: '/partial/browse-playlists.html',
    controller: 'BrowsePlaylistCtrl'
  });

	$locationProvider.html5Mode(true);
}])
.run(['$rootScope', '$location', 'apiService', 'UserData', function ($rootScope, $location, apiService, UserData) {
  var userdata = UserData;

  // get some global user data
  apiService.apiCall(function(data, status) {
    if (status === 200) {
      // set global data
      delete data.success;
      userdata.username = data.username;
      userdata.userid = data.userid;
      userdata.loggedin = data.loggedin;
    } else {
      // error getting user data
    }
  }, 'GET', '/api/get-user-info', {});

}]);