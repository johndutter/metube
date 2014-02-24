// signup controller
function SignupCtrl($scope, $location, $timeout, apiService) {
  $scope.formData = {};
  $scope.errorMessage = '';
  $scope.showErrors = false;
  $scope.defaultPlaylistInfo = {
    playlist: {
      user_id: '',
      name: 'Favorites',
      description: 'This playlist contains all of your favorite media.'
    }
  }

  // ==========================================================
  // Handle form validation and attempt to sign up user
  // ==========================================================
  $scope.signUp = function() {

    // handle form validation
    if ($scope.signupform.$valid === false) {
      $scope.showErrors = true;
      return;
    }

    // ensure matching passwords
    if ($scope.formData.encrypted_password !== $scope.formData.password_confirmation) {
      $scope.showErrors = true;
      return;
    }

    apiService.apiCall(function(data, status) {
      if (status === 200 && data.user_id !== '') {
        $scope.defaultPlaylistInfo.playlist.user_id = data.user_id;

        createDefaultPlaylist();
        $location.path('/login');
      } else {
        $scope.errorMessage = 'try a different email and username';
      }
    }, 'POST', '/api/signup', $scope.formData);

  };

  var createDefaultPlaylist = function(){
    apiService.apiCall(function(data, status) {
      if (status !== 200) {
        // display error, but don't halt user creation
        // default favorites playlist can be generated later
        $scope.errorMessage = 'unable to create default favorites playlist';
      }

    }, 'POST', '/api/create_playlist', $scope.defaultPlaylistInfo)
  };

  // watch error message
  $scope.$watch('errorMessage', function(newValue, oldValue) {
    if (newValue !== '') {
      $timeout(function() {
        $scope.errorMessage = '';
      }, 3000);
    }
  }, true);
}
SignupCtrl.$inject = ['$scope', '$location', '$timeout', 'apiService'];
