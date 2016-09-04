var Metalsmith  = require('metalsmith');
var markdown    = require('metalsmith-markdown');
var layouts     = require('metalsmith-layouts');
var sass        = require('metalsmith-sass');
var metadata    = require('metalsmith-metadata');

Metalsmith(__dirname)
  .source('./src')
  .destination('./build')
  .use(markdown())
  .use(sass())
  .use(metadata({
    course: 'course.yaml'
  }))
  .use(layouts('handlebars'))
  .build(function(err) {
    if (err) throw err;
  });
