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
    queueResults = null
    queueResponse = null

    before (done) ->
      rest.get("http://localhost:#{app.settings.port}/videos",
        headers:
          'Accept': 'application/json'
      ).on 'complete', (data, response) ->
        queueResults = data
        queueResponse = response
        done()

    it 'should contain the total number of unplayed videos in the queue', ->
      assert 'total_video_count' of queueResults
      queueResults.total_video_count.should.equal 3

    it 'should contain the number of unplayed videos in this response', ->
      assert 'video_count' of queueResults
      queueResults.video_count.should.equal 3

    it 'should contain the queue starting index', ->
      assert 'offset' of queueResults
      queueResults.offset.should.equal 0

    it 'should contain submitted videos in order of rank', ->
      assert 'queue' of queueResults
      queueResults.queue[0].video_id.should.equal Fixtures.video.dogDreams.video_id
      queueResults.queue[1].video_id.should.equal Fixtures.video.endOfWorld.video_id
      queueResults.queue[2].video_id.should.equal Fixtures.video.stewart.video_id


  describe 'with completed videos', ->

    before (done) ->
      Video.submit
        user_id: user1._id
        video_metadata: Fixtures.video.badger
        (v) ->
          playedVideo = v
          done()


    it 'should only display unplayed videos'
