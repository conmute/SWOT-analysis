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
  data: {
    example: JSON.parse(fs.readFileSync("data/example.json", "utf8")),
    lang: {
      en: JSON.parse(fs.readFileSync("data/lang/en.json", "utf8"))
    }
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