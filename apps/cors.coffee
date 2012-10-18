routes = (app) ->
  app.options '*', (req, res) ->
    res.header 'Access-Control-Allow-Origin', '*.sharedcinema.com'
    res.header 'Access-Control-Allow-Methods', '*'
    res.status 200
    res.send()

module.exports = routes
