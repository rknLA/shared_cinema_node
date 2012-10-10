sys = require 'util'
Video = require '../../models/video'

routes = (app) ->
  app.post '/videos', (req, res) ->
    accepted = req.get('Accept')
    if accepted == 'application/json'
      #make object
      youtubeId = req.body.youtube_video_id
      video = new Video
        user_id: req.body.user_id
        youtube_video_id: req.body.youtube_video_id
      res.status(201)
      res.json(video)
    else
      res.status(406) #not acceptable
      res.send()

module.exports = routes
