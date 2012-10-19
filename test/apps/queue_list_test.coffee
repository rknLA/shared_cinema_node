async = require 'async'

describe 'The Queue', ->

  user1 = null
  user2 = null
  user3 = null

  video1 = null
  video2 = null
  video3 = null
  playedVideo = null

  before (done) ->
    async.series [
      (callback) ->
        User.register
          ip: '127.0.0.1'
          (u) ->
            user1 = u
            callback()
    ,
      (callback) ->
        User.register
          ip: '127.0.0.2'
          (u) ->
            user2 = u
            callback()
    ,
      (callback) ->
        User.register
          ip: '127.0.0.3'
          (u) ->
            user3 = u
            callback()
    ,
      (callback) ->
        Video.submit
          user_id: user1._id
          video_metadata: Fixtures.video.endOfWorld
          (v) ->
            video1 = v
            callback()
    ,
      (callback) ->
        Video.submit
          user_id: user1._id
          video_metadata: Fixtures.video.dogDreams
          (v) ->
            video2 = v
            callback()
    ,
      (callback) ->
        Video.submit
          user_id: user1._id
          video_metadata: Fixtures.video.stewart
          (v) ->
            video3 = v
            callback()
    ,
      (callback) ->
        Video.submit
          user_id: user1._id
          video_metadata: Fixtures.video.badger
          (v) ->
            playedVideo = v
            callback()
    ],
    (err, callback) ->
      video1.vote user2._id
      video1.save (err, vid) ->
        video1 = vid
        video2.vote user2._id
        video2.vote user3._id
        video2.save (err, vid) ->
          video2 = vid
          done()

  describe 'getting all unplayed videos', ->

    it 'should display submitted videos', ->


  describe 'with completed videos', ->

    it 'should only display unplayed videos'
