var gulp = require('gulp'),
    globals = require('../globals'),
    plumber = require('gulp-plumber'),
    less = require('gulp-less'),
    notify = require('gulp-notify'),
    sourcemaps = require('gulp-sourcemaps'),
    path = require('path');


gulp.task('less', 'compiles project less files', function () {

  gulp.src( globals.src.less + 'app.less' )
    .pipe(plumber())
    .pipe(sourcemaps.init())
    .pipe(less())
    .pipe(sourcemaps.write( './' ))
    .pipe(gulp.dest( globals.dist.css ))
    .pipe(notify({ message: 'Styles task complete' }));

});