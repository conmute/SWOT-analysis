var gulp = require('gulp'),
    data = require('gulp-data'),
    plumber = require('gulp-plumber'),
    jade = require('gulp-jade'),
    notify = require('gulp-notify'),
    globals = require('../globals');

gulp.task('jade', 'html preprocessor - jade, we do it NICE', function() { 

  var src = [globals.src.jade + '**/*.jade'];
  console.log(src);
  return gulp.src(src)
    .pipe(plumber())
    .pipe(data({
      lang: globals.data.lang.en,
      example: globals.data.example,
      assets: globals.var.assets
    }))
    .pipe(jade({
      pretty: true
    }))
    .pipe(gulp.dest(globals.dist.html))
    .pipe(notify({ message: 'Markup task complete' }));

});