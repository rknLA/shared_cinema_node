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

  vote: (user_id) ->
    # add a vote for users that exist, remove a vote for those that don't
    # basically, behave like a toggle
    vote_index = @votes.indexOf user_id
    if vote_index is -1
      @votes.push user_id
      @vote_count += 1
    else
      @votes.splice vote_index, 1
      @vote_count -= 1


    

module.exports = Video
