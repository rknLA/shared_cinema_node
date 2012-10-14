User = require '../../models/user'
Video = require '../../models/video'

describe 'video submission', ->
  user = null

  before (done) ->
    User.register
      ip: '127.0.0.1'
      (u) ->
        user = u
        done()


  describe 'when none exist', ->

    it 'should allow new submissions', (done) ->
      rest.post("http://localhost:#{app.settings.port}/videos", {
        headers:
          'Accept': 'application/json'
        data:
          user_id: user.id
          youtube_video_id: 'mxPXPv3oNY4'
      }).on 'complete', (data, response) ->
        response.should.not.equal undefined
        response.statusCode.should.equal 201
        console.log data
        data.user_id.should.equal user.id
        data.youtube_video_id.should.equal 'mxPXPv3oNY4'
        data.vote_count.should.equal 1
        data.votes.indexOf(user.id).should.not.equal -1
        done()

  describe 'when some are in the queue', ->

    before ->
      video = new Video
        user_id: user.id
        youtube_video_id: 'Y8-CZaHFTdQ'

    describe 'a new video', ->

      it 'should get created like normal', (done) ->

        rest.post("http://localhost:#{app.settings.port}/videos", {
          headers:
            'Accept': 'application/json'
          data:
            user_id: user.id
            youtube_video_id: 'mxPXPv3oNY4'
        }).on 'complete', (data, response) ->
          response.statusCode.should.equal 201
          data.user_id.should.equal user.id
          data.youtube_video_id.should.equal 'mxPXPv3oNY4'
          data.vote_count.should.equal 1
          data.votes.indexOf(user.id).should.not.equal -1
          done()

    describe 'a duplicate video', ->
      it 'should not get created', (done) ->
        rest.post("http://localhost:#{app.settings.port}/videos", {
          headers:
            'Accept': 'application/json'
          data:
            user_id: user.id
            youtube_video_id: 'Y8-CZaHFTdQ'
        }).on 'complete', (data, response) ->
          response.should.not.equal undefined
          response.statusCode.should.equal 406 # conflict
          #right now test fails here
          data.user_id.should.equal user.id
          data.youtube_video_id.should.equal 'Y8-CZaHFTdQ'
          data.vote_count.should.equal 1
          data.votes.indexOf(123).should.equal -1
          done()



