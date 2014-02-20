app.filter('startFrom', function() {
    return function(input, start) {
        start = +start; //parse to int
        //return subset of the data
        return input.slice(start);
    }
});
