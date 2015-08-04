var gulp = require('gulp'),
    plumber = require('gulp-plumber'),
    path = require('path'),
    globals = require('../globals');

gulp.task('fonts', function() { 

  fonts = ["./bower_components/metro/fonts/**/*.*"]

  return gulp.src(fonts)
    .pipe(plumber())
    .pipe(gulp.dest(globals.dist.fonts)); 

});
