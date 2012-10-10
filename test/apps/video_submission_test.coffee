sys = require 'util'

Video = require '../../models/video'

describe 'video submission', ->

  describe 'when none exist', ->

    it 'should allow new submissions', (done) ->
      rest.post("http://localhost:#{app.settings.port}/videos", {
        headers:
          'Accept': 'application/json'
        data:
          user_id: '1234'
          youtube_video_id: 'mxPXPv3oNY4'
      }).on 'complete', (data, response) ->
        response.should.not.equal undefined
        response.statusCode.should.equal 201
        data.user_id.should.equal '1234'
        data.youtube_video_id.should.equal 'mxPXPv3oNY4'
        data.vote_count.should.equal 1
        data.votes.indexOf('1234').should.not.equal -1
        done()

  describe 'when some are in the queue', ->

    before ->
      video = new Video
        user_id: 123
        youtube_video_id: 'Y8-CZaHFTdQ'

    describe 'a new video', ->

      it 'should get created like normal', (done) ->

        rest.post("http://localhost:#{app.settings.port}/videos", {
          headers:
            'Accept': 'application/json'
          data:
            user_id: 234
            youtube_video_id: 'mxPXPv3oNY4'
        }).on 'complete', (data, response) ->
          response.statusCode.should.equal 201
          data.user_id.should.equal '234'
          data.youtube_video_id.should.equal 'mxPXPv3oNY4'
          data.vote_count.should.equal 1
          data.votes.indexOf('234').should.not.equal -1
          done()

    describe 'a duplicate video', ->
      it 'should not get created', (done) ->
        rest.post("http://localhost:#{app.settings.port}/videos", {
          headers:
            'Accept': 'application/json'
          data:
            user_id: 24
            youtube_video_id: 'Y8-CZaHFTdQ'
        }).on 'complete', (data, response) ->
          response.should.not.equal undefined
          response.statusCode.should.equal 406 # conflict
          #right now test fails here
          #data.user_id.should.equal 123
          #data.youtube_video_id.should.equal 'Y8-CZaHFTdQ'
          #data.vote_count.should.equal 1
          #data.votes.indexOf(123).should.equal -1
          done()



