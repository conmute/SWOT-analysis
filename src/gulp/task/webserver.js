var gulp = require('gulp'),
    webserver = require('gulp-webserver'),
    globals = require('../globals');

gulp.task('webserver', function() {
  gulp.src([globals.dist.html])
    .pipe(webserver({
      open: true
    }));
});
