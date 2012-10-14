User = require '../../models/user'

describe 'User', ->

  user = null
  before (done) ->
    User.register
      ip: '127.0.0.1'
      (u) ->
        user = u
        done()

  describe 'create', ->

    it 'generates a UUID', ->
      assert.notEqual user.id, null

    it 'saves the users ip', ->
      assert.equal user.ip, '127.0.0.1'

  describe 'authenticate', ->
    it 'returns a user with the appropriate id', (done) ->
      User.authenticate user.id, (authenticated_user) ->
        assert.notEqual authenticated_user, null
        authenticated_user.ip.should.equal '127.0.0.1'
        done()

    it 'returns null with an invalid id', (done) ->
      User.authenticate 'foobarbaz', (authenticated_user) ->
        assert.equal authenticated_user, null
        done()

