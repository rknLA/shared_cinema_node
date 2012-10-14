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

