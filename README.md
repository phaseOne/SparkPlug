# SparkPlug

A tool for designing static websites with [Bootstrap](http://twitter.github.com/bootstrap/index.html), [mustache](http://mustache.github.com/), and [less](http://lesscss.org/).

Some of the code has been modified from the original Bootstrap framework.

# Bootstrap
This version of SparkPlug includes Bootstrap 2.0.4.

# Usage
## Install
Download SparkPlug [from here](https://github.com/phaseOne/SparkPlug/zipball/master). Unzip the contents in the directory of your choosing (where ever you would like to be working on your code).

Now `cd` into the directory where you unzipped SparkPlug.

SparkPlug requires the standard suite of node.js and npm, but it also needs recess, jshint, and uglify-js, so run npm inside the folder:

    $ npm install

## The Structure
The `./dev/` directory is for the development of the site. The `./prod/` directory will be created by the builder script.

### Images
Place any images you need inside the `./dev/img/` directory. They will be copied to the `./prod/assets/img` directory.

The two PNGs in that folder already are needed for the bootstrap library.

### JavaScript
The `./dev/js/` folder is for your javascript files.

Either use the provided `main.js` file for your JavaScript code, or use your own filename. For the builder script to work, you need at least one JavaScript file inside `./dev/js/`.

The `./dev/js/bootstrap/` directory is for the Bootstrap library. You may customize your installation by removing unneeded scripts. Use [the Javascript page](http://twitter.github.com/bootstrap/javascript.html) of the Bootstrap guide to help.

All JavaScript files in the `./dev/js/` will be minified and moved to `./prod/assets/js/`.

### Less
The `./dev/less/` folder is for your less files.

It is recommended to use the `main.less` file to `@import` any other less files. This way your code is consolidated when you add the `<link>` to your HTML. In addition, the builder script will only complile the `main.less` file.

The `./dev/less/bootstrap/` directory is for the Bootstrap less library.

The less files will be minified and moved to `./prod/assets/css/`.

### Mustache
The `./dev/mustache/` directory is for your mustache templates.

The `layout.mustache` is the main template for your site. Place any header/footer/JS stuff here. It already contains the needed `<link>`s and `<script>`s to make Bootstrap/SparkPlug work.

The `./dev/mustache/pages/` directory is for the real content. A `index.mustache` file is provided already to save you time.

## Building
When you are ready to go, just run:

    $ make

Copy the files in `./prod/` to your webserver and you are off to the races.

### The Page Builder
SparkPlug ships with the site title `Site Title`. To change this, modify the file `./dev/build/index.js`. At the top you will see:

```
#!/usr/bin/env node
var hogan = require('hogan.js')
  , fs    = require('fs')
  , prod  = process.argv[2] == 'production'
  , title = 'Site Title'
```

Change the `title` var to your actual site title. Save `index.js`.

Now run `make` again.

## Watching
SparkPlug can also watch your `./dev/` directory to look for changes to files with [watchr](https://github.com/mynyml/watchr). Just install watchr if you don't already have it:

    $ gem install watchr

Now run:

    $ make watch
