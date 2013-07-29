NodeStack
=======

Node.js assets pipeline skeleton.

NodeStack is a minimalist skeleton designed to get up and running quickly with a
CoffeeScript + Jade + Stylus web app. It includes all the benefits of the
Rails assets pipeline and predictable assets code layout without any cruft.

### Features

* [Express](http://expressjs.com/) - web server
* [Connect Assets](https://github.com/adunkman/connect-assets) - asset pipeline
* [CoffeeScript](http://coffeescript.org/) - better JavaScript
* [Jade](http://jade-lang.com/) - better HAML
* [Stylus](http://learnboost.github.io/stylus/) - better SASS
* [Nib](https://github.com/visionmedia/nib) - stylus mixins
* [Foundation](https://github.com/blai/foundation) - stylus port of [Foundation](http://foundation.zurb.com/) front-end framework
* [Zepto](http://zeptojs.com/) or [jQuery](http://jquery.com/) – Zepto is enabled by default

### Non-features

* ORM - add your ORM of choice as needed
* Pretty much anything else not explicitly mentioned in features

The goal of NodeStack is to be as minimal as possible while providing the
niceties of an assets pipeline.

### Alternatives

* https://github.com/dweldon/frappe
* https://nodejsmodules.org/tags/skeleton


# Installation

Node.js and npm must already be installed.

```bash
git clone https://github.com/simple10/nodestack.git
cd nodestack
npm install
```


# Development

NodeStack uses cake to start an express server. Cake is the Node.js equivalent of rake.

```bash
# Start web server on port 3000
npm start
```

[localhost:3000](http://localhost:3000)


### How It Works

The command `npm start` is just an alias for `cake start`. See package.json "scripts" section.
By convention, startup scripts are defined in package.json to make them easy to find.

When `npm start` is run, server.js is executed which in turn loads the CoffeeScript compiler
and runs app/app.coffee. The app script loads plugins and routes and starts an express
server that listens for incoming connections. No magic.

Express is built on top of [connect](http://www.senchalabs.org/connect/) which is analogous
to rack. Connect is a middleware framework. All the work handling cookies, sessions, assets,
etc. is performed in optional middleware.

Connect Assets is middleware that handles compiling assets (CoffeeScript, Jade
templates, Stylus stylesheets, etc.) on the fly or to disk.

Connect Assets compiles assets into the **builtAssets** directory if the build config option
is set to true in app/app.coffee.

For development, build is turned off to make it easier to inspect and debug JavaScript and
CSS. Alternatively, build could be turned on by default and source files used for debugging.


# Production

As a best practice and required by hosts like Heroku, assets should be precompiled before
deploying to production.

Precompiling assets for production will combine and uglify javascript and stylesheet files.
Just like the Rails asset pipeline.

```bash
# make sure NODE_ENV is set on heroku
heroku config:set NODE_ENV=production

# switch to a branch (optional)
git checkout -b production

# compile assets into the builtAssets directory
cake precompile

# lock down the modules versions
# this is analogous to Gemfile.lock in ruby
npm shrinkwrap

git add .
git commit -m "Compile assets for production"

# deploy to heroku
git push heroku production:master
```

Example: http://nodestack.herokuapp.com/


# Code Layout

NodeStack mimics Rails code layout for routes and assets.

```bash
# routes
config/routes.coffee

# javascript
app/assets/js
  head.coffee    # included in HEAD
  app.coffee     # included at bottom of BODY
                 # add your app scripts to app.coffee
  vendor/        # selectively required in app.coffee

# css
app/assets/css
  app.styl       # included in HEAD
                 # add your app stylesheets to app.styl
  variables.styl # your app variables
  vendor/        # selectively required in app.styl
```


# Front-end Frameworks

By default, Zepto and Foundation are enabled.

To switch to jQuery, change the require statement in app/assets/js/app.coffee.

jQuery 2.x is included which does not work in older browsers.
If needed, download and use jQuery 1.x instead.

### Updating Foundation

NodeStack includes a [stylus port](https://github.com/blai/foundation.git) of Zurb Foundation.
To update Foundation, download the latest files from Github and copy them into the appropriate
vendor directories.

```bash
# from parent directory of nodestack
git clone https://github.com/blai/foundation.git
cp foundation/stylus/*.styl nodestack/app/assets/css/vendor/
cp -a foundation/js/foundation nodestack/app/assets/js/vendor
cp foundation/js/vendor/custom.modernizr.js nodestack/app/assets/js/vendor/modernizr.custom.js
```

### Switching to Twitter Bootstrap

See [Connect Assets](https://github.com/adunkman/connect-assets) for serving Bootstrap from an
npm module.

Once you switch to Bootstrap, remove the app/assets/[css|js]/vendor foundation files.


