var Metalsmith  = require('metalsmith');
var markdown    = require('metalsmith-markdown');
var layouts     = require('metalsmith-layouts');
var sass        = require('metalsmith-sass');
var metadata    = require('metalsmith-metadata');
var relative    = require('metalsmith-relative');
var collections = require('metalsmith-collections');
var filepath    = require('metalsmith-filepath');

Metalsmith(__dirname)
  .source('./src')
  .destination('./build')
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
  .use(layouts('handlebars'))
  .build(function(err) {
    if (err) throw err;
  });
