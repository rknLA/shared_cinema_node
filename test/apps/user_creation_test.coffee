mongoose = require 'mongoose'

describe 'Users Endpoint', ->

  after (done) ->
    User.remove done

  describe 'when none exist', ->

    it 'should allow new users', (done) ->
      rest.post("http://localhost:#{app.settings.port}/users", {
        headers:
          'Accept': 'application/json'
      }).on 'complete', (data, response) ->
        console.log data
        response.should.not.equal undefined
        response.statusCode.should.equal 201
        assert.notEqual data._id, null
        done()
