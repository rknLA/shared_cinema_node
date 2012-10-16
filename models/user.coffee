mongoose = require 'mongoose'

UserSchema = new mongoose.Schema
    ip: String

UserSchema.static 'register', (attrs, callback) ->
  user = new this()
  user.ip = attrs.ip
  console.log "registering user: #{user}"
  user.save (e, doc) ->
    if e
      console.log "a new error has emerged: #{e}"
      throw e
    else
      callback doc

UserSchema.static 'authenticate', (uid, callback) ->
  this.findById uid, (err, user) ->
    callback user

User = mongoose.model('User', UserSchema)

module.exports = mongoose.model('User')
