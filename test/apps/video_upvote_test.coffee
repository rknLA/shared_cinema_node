describe 'Vote Endpoint', ->
  user1 = null
  user2 = null
  user1_video = null

  before (done) ->
    User.register
      ip: '127.0.0.1'
      (u) ->
        user1 = u
        User.register
          ip: '168.0.1.12'
          (u) ->
            user2 = u
            Video.submit
              user_id: user1.id
              youtube_video_id: 'AyzOUbkUf3M'
              (v) ->
                user1_video = v
                done()

  describe "voting on someone elses's video", ->

    it 'should register the vote', (done) ->
      rest.post("http://localhost:#{app.settings.port}/vote",
        headers:
          'Accept': 'application/json'
        data:
          user_id: user1.id
          youtube_video_id: 'AyzOUbkUf3M'
      ).on 'complete', (data, response) ->
        assert.notEqual response, undefined
        response.statusCode.should.equal 200
        done()





