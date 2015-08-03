var gulp = require('gulp'),
    data = require('gulp-data'),
    plumber = require('gulp-plumber'),
    jade = require('gulp-jade'),
    notify = require('gulp-notify'),
    globals = require('../globals');

gulp.task('jade', 'html preprocessor - jade, we do it NICE', function() { 

  var src = [];
  src.push(globals.src.jade + '404.jade');

  return gulp.src(src)
    .pipe(plumber())
    .pipe(data({
        assets: globals.var.assets
    }))
    .pipe(jade({
      pretty: true
    }))
    .pipe(gulp.dest(globals.dist.html))
    .pipe(notify({ message: 'Markup task complete' }));

});