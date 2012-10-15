User = require '../../models/user'
Video = require '../../models/video'

routes = (app) ->
  app.post '/videos', (req, res) ->
    accepted = req.get('Accept')
    if accepted == 'application/json'
      #make object
      youtubeId = req.body.youtube_video_id
      User.authenticate req.body.user_id, (currentUser) ->
        if currentUser
          Video.submit
            user_id: currentUser._id
            youtube_video_id: youtubeId
            (v) ->
              if v
                res.status(201)
                res.json(v)
              else
                Video.findOne
                  youtube_video_id: youtubeId
                  (err, vid) ->
                    if err
                      res.status(422)
                      res.send(err)
                    else
                      res.status(406)
                      res.json(vid)
        else
          res.status(401)
          res.send()
    else
      res.status(406) #not acceptable
      res.send()

module.exports = routes
