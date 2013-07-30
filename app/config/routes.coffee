module.exports = (app) ->

  app.get '/', (req, res) ->
    res.render 'index', title: 'Express'

  app.get '/test/lz', (req, res) ->
    res.render 'test/lz', title: 'Test LZ String'
