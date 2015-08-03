var fs = require('fs');

module.exports = {
  dist: {
    css: 'html/css/',
    js: 'html/js/',
    fonts: 'html/fonts/',
    html: 'html/'
  },
  src: {
    less: 'src/less/',
    coffee: 'src/coffee/',
    jade: 'src/jade/'
  },
  var: {
    template: {
      app: 'app.jade',
    },
    assets: {
      app: {
        css: "app.css",
        js: "app.js"
      }
    }
  }
};