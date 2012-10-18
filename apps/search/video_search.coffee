User = require '../../models/user'
Search = require '../../models/search'

routes = (app) ->
  app.get '/search', (req, res) ->
    accepted = req.get 'Accept'
    if accepted == 'application/json'
      User.authenticate req.query.user_id, (currentUser) ->
        if currentUser
          if req.body.search_id
            # next page
            Search.page req.body.search_id, 2, (results) ->
              console.log results
              res.status 500
              res.send("UNIMPLEMENTED")
          else
            # new search
            Search.createWithQuery
              q: req.query.q
              googleApiKey: app.settings.googleApiKey
              user_id: currentUser._id
              (results) ->
                res.status 201
                results.next = req.url
                console.log "results with next: ", results
                console.log "request url: ", req.url
                res.json results
        else
          res.status 401 # unauthorized
          res.send()
    else
      res.status 406 # not acceptable
      res.send()

module.exports = routes

