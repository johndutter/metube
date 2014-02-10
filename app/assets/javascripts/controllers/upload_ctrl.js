function UploadCtrl($scope, $timeout, $http, apiService, $location){
  $scope.hasThreeTags = false;
  $scope.showErrors = false;
  $scope.invalidFileType = false;
  
  $scope.formData = {};
  $scope.errorMessage = '';

  $scope.videoWhiteList = ['.mov', '.mp4', '.avi', '.wmv', '.flv', '.m4v'];
  $scope.imageWhiteList = ['.jpg', '.jpeg', '.gif', '.png', '.bmp'];
  $scope.audioWhiteList = ['.mp3', '.aac'];
  
  /*
    Angular does not support data binding for input tags with type=file.
    For now a workaround will be used that takes advantage of onchange event in js.
    The name will be retrieved and stored in the scope, when the field is updated.
  */
  $scope.getFile = function(element){
    $scope.fileData = element.files[0];
  }
  
  $scope.upload = function(){
    //check if form is valid
    if ($scope.uploadform.$valid === false) {
      $scope.showErrors = true;
      return;
    }
    
    //check if file type is supported and determine media type
    var mediaFileType = $scope.fileData.name.match(/\.[a-zA-z0-9]+$/)[0];
    $scope.formData.fileExtension = mediaFileType;

    if($scope.videoWhiteList.indexOf(mediaFileType) >= 0){
      $scope.formData.type = 'video';
    }
    else if($scope.audioWhiteList.indexOf(mediaFileType) >= 0){
      $scope.formData.type = 'audio';
    }
    else if($scope.imageWhiteList.indexOf(mediaFileType) >= 0){
      $scope.formData.type = 'image';
    }
    else{
      $scope.showErrors = true;
      $scope.invalidFiletype = true;
      return;
    }
    
    //add in extra form data needed in controller
    $scope.formData = {multimedia: $scope.formData};
    
    //make formData object out of the uploaded file data, so that angular can post it
    var fd = new FormData();
    fd.append('fileData', $scope.fileData);
    fd.append('mediaType', mediaFileType);

    /* we will need to make two calls to api
       one call to save file information and return an id
       second call to save file on our server 
    */
    apiService.apiCall(function(data, status){
      if(status == 200){
        fd.append('multimedia_id', data.multimedia);

        /* Second API Call */
        /* NOTE:  We might need record of pending file upload for particular user so that this api function cannot be called anytime. */
        $http.post('/api/upload-file', fd, {
            transformRequest: angular.identity,
            headers: {'Content-Type': undefined}
        })
        .success(function(){
          $location.url('/dashboard/home');
        })
        .error(function(){
          //call function to delete db entry related to file
          $scope.errorMessage = 'Unable to upload file.';
        });   
        /* End Second API Call */ 
        
      } else{
        //title must be unique, return error
        $scope.errorMessage = 'Unable to upload file. This title is taken. Please choose another one.';
      }
    }, 'POST', '/api/upload', $scope.formData);
  }; 

  //remove error message after 3 seconds
  $scope.$watch('errorMessage', function(newValue, oldValue) {
    if (newValue !== '') {
      $timeout(function() {
        $scope.errorMessage = '';
      }, 3000);
    }
  }, true);
}

UploadCtrl.$inject = ['$scope', '$timeout', '$http', 'apiService', '$location'];