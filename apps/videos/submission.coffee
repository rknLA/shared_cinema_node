sys = require 'util'

routes = (app) ->
  app.post '/videos', (req, res) ->
    accepted = req.get('Accept')
    if accepted == 'application/json'
      #make object
      res.status(201)
      res.send()
    else
      res.status(406) #not acceptable
      res.send()

module.exports = routes
