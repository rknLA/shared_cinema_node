mongoose = require 'mongoose'

UserSchema = new mongoose.Schema
    ip: String

UserSchema.static 'register', (attrs, callback) ->
  user = new this()
  user.ip = attrs.ip
  user.save (e, doc) ->
    if e
      console.log "a new error has emerged: #{e}"
      throw e
    else
      callback doc

UserSchema.static 'authenticate', (request, callback) ->
  uid = request.body.user_id || request.query.user_id
  this.findById uid, (err, user) ->
    callback user

User = mongoose.model('User', UserSchema)

module.exports = mongoose.model('User')
