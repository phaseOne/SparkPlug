#!/usr/bin/env node
var hogan = require('hogan.js')
  , fs    = require('fs')
  , title = 'Site Title';

var layout, pages;

var mpath = __dirname + '/../mustache/';

// nice block of code from chjj on stack overflow
var walk = function(dir, done) {
  var results = [];
  fs.readdir(dir, function(err, list) {
    if (err) return done(err);
    var pending = list.length;
    if (!pending) return done(null, results);
    list.forEach(function(file) {
      file = dir + '/' + file;
      fs.stat(file, function(err, stat) {
        if (stat && stat.isDirectory()) {
          walk(file, function(err, res) {
            results = results.concat(res);
            if (!--pending) done(null, results);
          });
        } else {
          results.push(file);
          if (!--pending) done(null, results);
        }
      });
    });
  });
};

// walk the pages dir
walk(mpath + 'pages', function(err, results) {
  if (err) throw err;
  
  // compile layout.mustache
  layout = fs.readFileSync(mpath + 'layout.mustache', 'utf-8');
  layout = hogan.compile(layout);
  
  // loop through files
  results.forEach(function(path) {
    if (!path.match(/\.mustache$/)) return;
    
    // read the path to page, build path, turn path into filename without extension, create context var
    var page = fs.readFileSync(path, 'utf-8')
      , buildpath = path.replace(mpath + 'pages', __dirname + '/../../prod').replace(/(?:\/)?([^\/]+\.mustache$)/, '')
      , name = path.match(/(?:\/)?([^\/]+(?=\.mustache$))/)[1]
      , context = {};
    
    // make {{name}} = active, turn name into title
    context[name] = 'active';
    context.title = name.replace(/\~/, ' ');
    
    // give page a title
    context.title = (context.title == 'Index') ? title : context.title + ' · ' + title;
    
    // compile and render the page
    page = hogan.compile(page);
    page = layout.render(context, {
      body: page
    });
    
    // create directories
    if (!fs.existsSync(buildpath)) fs.mkdirSync(buildpath);
    
    // write the page
    fs.writeFileSync(path.replace(mpath + 'pages', __dirname + '/../../prod').replace(/mustache$/, 'html'), page, 'utf-8');
  });
});