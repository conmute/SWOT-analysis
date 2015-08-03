var gulp = require('gulp');

var taskDescription = 'or simple `gulp` command. Launches all generating stuff';
gulp.task('default', taskDescription, ['clean'], function() {
  gulp.start(
    'coffee',
    'jade',
    'less',
    'fonts'
  );
});
