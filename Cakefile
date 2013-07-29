# Page to fetch to trigger building of assets
PRECOMPILE_OPTS =
  hostname: 'localhost'
  path: '/'
  method: 'GET'
  port: 8888

# Message to listen for before sending HTTP request to server
PRECOMPILE_STARTUP_MESSAGE = 'server listening'

{spawn} = require 'child_process'
http = require('http')
{console} = require('colorize')

binDir = './node_modules/.bin'
nodeDev = "#{binDir}/node-dev"
mocha = "#{binDir}/mocha"
npmedge = "#{binDir}/npmedge"


option '-p', '--port [PORT_NUMBER]', 'set the port number for `start`'
option '-e', '--environment [ENVIRONMENT_NAME]', 'set the environment for `start`'
task 'start', 'start the server', (options) ->
  process.env.NODE_ENV = options.environment ? 'development'
  process.env.PORT = options.port if options.port
  spawn nodeDev, ['server.js'], stdio: 'inherit'

task 'precompile', 'precompile assets', (options) ->
  PRECOMPILE_OPTS.port ?= options.port
  process.env.NODE_ENV = 'production'
  process.env.PORT = PRECOMPILE_OPTS.port

  console.log 'Starting server...'
  server = spawn 'node', ['server.js'], stdio: ['ignore', 'pipe', 'pipe']
  server.stderr.on 'data', (data) ->
    msg = data.toString()
    if msg.indexOf('EADDRINUSE') > -1
      error "port #{PRECOMPILE_OPTS.port} already in use"
      console.log '#yellow[Please kill existing process first]'
    else
    console.log msg
  server.stdout.on 'data', (data) ->
    msg = data.toString()
    if msg.indexOf(PRECOMPILE_STARTUP_MESSAGE) > -1
      console.log '#green[started].'
      requestPrecompile()
    else
      console.log msg

  error = ->
    args = Array.prototype.slice.call(arguments)
    args.unshift '#red[ERROR] '
    console.error.apply console, args
    done()

  done = ->
    server.kill('SIGHUP')

  requestPrecompile = ->
    console.log "Requesting #{PRECOMPILE_OPTS.path}"
    req = http.get PRECOMPILE_OPTS, (res) ->
      if res.statusCode != 200
        return error "request returned #{res.statusCode}"
      console.log 'Server returned 200'
      res.on 'data', (data) ->
        console.log '#green[Assets successfully compiled]'
        done()
    req.on 'error', (e) ->
      error e


task 'test', 'run the tests', ->
  process.env.NODE_ENV = 'test'
  args = [
    '--compilers', 'coffee:coffee-script'
    '--require', './server'
    '--require', 'should'
    '--reporter', 'list'
    '--recursive'
    './app/test'
  ]
  spawn mocha, args, stdio: 'inherit'

task 'update', 'update all packages and run npmedge', ->
  (spawn 'npm', ['install', '-q'], stdio: 'inherit').on 'exit', ->
    (spawn 'npm', ['update', '-q'], stdio: 'inherit').on 'exit', ->
      spawn npmedge, [], stdio: 'inherit'

