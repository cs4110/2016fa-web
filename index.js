var Metalsmith  = require('metalsmith');
var markdown    = require('metalsmith-markdown');
var layouts     = require('metalsmith-layouts');
var sass        = require('metalsmith-sass');
var metadata    = require('metalsmith-metadata');
var relative    = require('metalsmith-relative');
var collections = require('metalsmith-collections');

Metalsmith(__dirname)
  .source('./src')
  .destination('./build')
  .use(relative())
  .use(markdown())
  .use(sass())
  .use(collections({
    pages: '*.md'
  }))
  .use(metadata({
    course: 'course.yaml'
  }))
  .use(layouts('handlebars'))
  .build(function(err) {
    if (err) throw err;
  });
