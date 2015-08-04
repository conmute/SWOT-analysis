var gulp = require('gulp'),
    globals = require('../globals'),
    plumber = require('gulp-plumber'),
    merge = require('ordered-merge-stream'),
    concat = require('gulp-concat'),
    gulputil = require('gulp-util'),
    notify = require('gulp-notify'),
    coffee = require('gulp-coffee'),
    sourcemaps = require('gulp-sourcemaps'),
    coffeelint = require('gulp-coffeelint'),
    lintThreshold = require('gulp-coffeelint-threshold'),
    colors = require('colors'),
    path = require('path');

var lintThresholdHandler = function(numberOfWarnings, numberOfErrors) {
  var msg;
  gulputil.beep();
  msg = 'CoffeeLint failure; see above. Warning count: ';
  msg += numberOfWarnings;
  msg += '. Error count: ' + numberOfErrors + '.';
  // throw new Error(msg);
  gulputil.log(msg);
  // this.emit('end');
};

var check_existance_missing = function (array_of_urls) {
  var fs = require('fs');
  var oneMissing = false;
  for (var i = 0; i < array_of_urls.length; i++) {
    var fileIsMissing = false;
    if( !fs.existsSync(array_of_urls[i]) ) {
      console.warn('File not exists: ' + array_of_urls[i].magenta);
      fileIsMissing = true;
      oneMissing = true;
    }
  }

  if (oneMissing) {
    console.error('Necessary files missing!'.red);
    console.error('Pleace run `' + 'bower install'.yellow +
      '` to compile `' + 'scripts'.cyan + '`');
  }

  return oneMissing;
};

include_from_bower = [
  './bower_components/markdown/lib/markdown.js',
  './bower_components/ace-builds/src-min-noconflict/ace.js',
  './bower_components/ace-builds/src-min-noconflict/ace.js',
  './bower_components/ace-builds/src-noconflict/theme-github.js',
  './bower_components/ace-builds/src-noconflict/mode-markdown.js',
  './bower_components/metro/js/requirements.js',
  './bower_components/metro/js/global.js',
  './bower_components/metro/js/widget.js',
  './bower_components/metro/js/initiator.js',
  './bower_components/metro/js/widgets/charm.js'
  // './bower_components/Hyphenator/Hyphenator.js',
  // './bower_components/Hyphenator/patterns/en-us.js',
  // './bower_components/Hyphenator/patterns/uk.js'
];

gulp.task('coffee', 'compiles project coffeescript files', function() {

  if (check_existance_missing(include_from_bower)) {
    return;
  }

  jsfiles = gulp.src([].concat(include_from_bower));

  src = [globals.src.coffee + '**/*.coffee']

  coffeed = gulp.src(src)
    .pipe(plumber())
    .pipe(coffeelint({
      "no_backticks": {
        "level": "ignore"
      }
    }))
    .pipe(coffeelint.reporter())
    .pipe(lintThreshold(10, 0, lintThresholdHandler))
    .pipe(coffee({
      bare: true
    }));

  return merge([jsfiles, coffeed])
    .pipe(concat("app.js"))
    .pipe(gulp.dest(globals.dist.js))
    .pipe(notify({ message: 'Scripts task complete' }));
});