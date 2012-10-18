querystring = require 'querystring'

describe "Video Search Endpoint", ->
  user = null

  before (done) ->
    User.register
      ip: '127.0.0.1'
      (u) ->
        user = u
        done()

  describe 'new complete searches', ->
    # this is only really semi-valid, since testing this relies on youtube.
    searchResults = null
    searchResponse = null

    before (done) ->
      data =
        q: 'maru jumps out of a box'
        user_id: user.id
      dataStr = querystring.stringify data
      rest.get("http://localhost:#{app.settings.port}/search?#{dataStr}",
        headers:
          'Accept': 'application/json'
      ).on 'complete', (data, response) ->
        searchResults = data
        searchResponse = response
        console.log "searchResults in test: ", searchResults
        done()

    it 'should respond with created', ->
      searchResponse.statusCode.should.equal 201

    it 'should have a search id', ->
      assert.notEqual searchResults._id, null

    it 'should have a URL to the next search'#, ->
    #      searchResults.next.should.equal "http://localhost:#{app.settings.port}/search?id=#{searchResults._id}&page=2"

    it 'should have an array of videos', ->
      searchResults.videos.length.should.equal 20

    describe 'getting the next page', ->

      secondPageResults = null
      secondPageResponse = null

      before (done) ->
        rest.get(searchResults.next,
          headers:
            'Accept': 'application/json'
        ).on 'complete', (data, response) ->
          secondPageResults = data
          secondPageResponse = response

          done()



