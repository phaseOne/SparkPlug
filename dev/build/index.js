#!/usr/bin/env node
var hogan = require('hogan.js')
  , fs    = require('fs')
  , title = 'Site Title'

var layout, pages

// compile layout template
layout = fs.readFileSync(__dirname + '/../mustache/layout.mustache', 'utf-8')
layout = hogan.compile(layout)

// retrieve pages
pages = fs.readdirSync(__dirname + '/../mustache/pages')

// iterate over pages
pages.forEach(function (name) {

  if (!name.match(/\.mustache$/)) return

  var page = fs.readFileSync(__dirname  + '/../mustache/pages/' + name, 'utf-8')
    , context = {}

  context[name.replace(/\.mustache$/, '')] = 'active'
  context.title = name
    .replace(/\.mustache/, '')
    .replace(/\-.*/, '')
    .replace(/(.)/, function ($1) { return $1.toUpperCase() })

  if (context.title == 'Index') {
    context.title = title
  } else {
    context.title += ' · ' + title
  }

  page = hogan.compile(page)
  page = layout.render(context, {
    body: page
  })

  fs.writeFileSync(__dirname + '/../../prod/' + name.replace(/mustache$/, 'html'), page, 'utf-8')
})