class Video
  constructor: (attributes) ->
    @user_id = attributes.user_id
    @youtube_video_id = attributes.youtube_video_id
    @setDefaults()

  setDefaults: ->
    @posted_at = new Date
    @vote_count = 1
    @votes = [@user_id]
    @id = 1
    

module.exports = Video
