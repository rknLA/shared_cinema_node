sys = require 'util'

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
        sys.puts data
        response.should.not.equal undefined
        response.statusCode.should.equal 201
        done()
