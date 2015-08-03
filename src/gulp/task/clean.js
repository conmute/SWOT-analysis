var gulp = require('gulp'),
  del = require('del'),
  globals = require('../globals');

gulp.task('clean', 'clean generated stuff', function(cb) {
  del([globals.dist.html], cb);
});