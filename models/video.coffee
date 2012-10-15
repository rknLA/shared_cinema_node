mongoose = require 'mongoose'

VideoSchema = new mongoose.Schema
  user_id:
    type: mongoose.Schema.Types.ObjectId
    required: true
  youtube_video_id:
    type: String
    required: true
    index: true
  vote_count:
    type: Number
    default: 1
  votes: [mongoose.Schema.Types.ObjectId]
  submitted_at:
    type: Date
    default: Date.now
  started_at: Date
  finished_at: Date
  playing:
    type: Boolean
    default: false
  played:
    type: Boolean
    default: false

VideoSchema.static 'submit', (attrs, callback) ->
  ytID = attrs.youtube_video_id
  that = this
  this.findOne
    youtube_video_id: ytID
    played: false
    (err, vid) ->
      if vid
        console.log "video already exists!"
        callback()
      else
        console.log "video doesn't exist!"
        video = new that()
        video.youtube_video_id = attrs.youtube_video_id
        video.user_id = attrs.user_id
        video.votes = [attrs.user_id]
        video.vote_count = 1
        video.started_at = null
        video.finished_at = null
        video.save (e, doc) ->
          if e
            throw e
          else
            callback doc
      
VideoSchema.methods.vote = (user_id) ->
  # add a vote for users that exist, remove a vote for those that don't
  # basically, behave like a toggle
  vote_index = this.votes.indexOf user_id
  if vote_index is -1
    this.votes.push user_id
    this.vote_count += 1
  else
    this.votes.splice vote_index, 1
    this.vote_count -= 1


Video = mongoose.model('Video', VideoSchema)
module.exports = mongoose.model('Video')
