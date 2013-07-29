module.exports = (app) ->

  app.get '/', (req, res) ->
    res.render 'index', title: 'Express'

  app.get 'users', (req, res) ->
    res.send 'respond with a resource'
