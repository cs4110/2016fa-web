var Metalsmith  = require('metalsmith');
var markdown    = require('metalsmith-markdown');
var layouts     = require('metalsmith-layouts');
var sass        = require('metalsmith-sass');
var metadata    = require('metalsmith-metadata');
var relative    = require('metalsmith-relative');
var collections = require('metalsmith-collections');
var filepath    = require('metalsmith-filepath');

var serveMode = process.argv.indexOf('--serve') != -1;

var site = Metalsmith(__dirname)
  .source('./src')
  .destination('./build')
  .metadata({
    serve: serveMode,
  })
  .use(collections({
    pages: {
      pattern: '*.md'
    }
  }))
  .use(relative())
  .use(markdown({
    smartypants: true,
  }))
  .use(sass())
  .use(filepath({
    absolute: true
  }))
  .use(metadata({
    course: 'course.yaml'
  }))
  .use(layouts('handlebars'));

if (serveMode) {
  var serve = require('metalsmith-serve');
  var watch = require('metalsmith-watch');
  site = site
    .use(serve())
    .use(watch({
      paths: {
        "${source}/**/*": true,
        "layouts/**/*": "**/*.md",
      },
      livereload: true
    }));
}

site.build(function(err) {
  if (err) throw err;
});
