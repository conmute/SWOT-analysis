var gulp = require('gulp'),
    watch = require('gulp-watch'),
    globals = require('../globals'),
    livereload = require('gulp-livereload');

var extend = function (target) {
  var sources = [].slice.call(arguments, 1);
  sources.forEach(function (source) {
    for (var prop in source) {
      target[prop] = source[prop];
    }
  });
  return target;
};

var watchIt = function(files, taskNames) {
  watch(files, extend({}, {
    verbose: true
  }), function(file, buffer) {
    gulp.start(taskNames);
  });
};

var taskDescription = 'watch changes, and trigger propriate tasks';

gulp.task('watch', taskDescription, ['default'], function() {

  watchIt(globals.src.less + '**/*.less', 'less');
  watchIt(globals.src.coffee + '**/*.coffee', 'coffee');
  watchIt(globals.src.jade + '**/*.jade', 'jade');

  livereload.listen();

  watch(globals.dist.html + '**/*.*', {
    verbose: false
  }, function(file, buffer) {
    livereload.changed();
  });

});
