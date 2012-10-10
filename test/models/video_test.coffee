Video = require '../../models/video'

describe 'Video', ->
  describe 'create', ->
    video = null
    before ->
      video = new Video
        user_id: '123'
        youtube_video_id: 'mxPXPv3oNY4'

    it 'sets the user', ->
      video.user_id.should.equal '123'

    it 'sets the video id', ->
      video.youtube_video_id.should.equal 'mxPXPv3oNY4'

    it 'sets a posted-at date', ->
      video.posted_at.should.not.equal undefined

    it 'sets started-at to null', ->
      assert.equal video.started_at, null

    it 'sets finished-at to null', ->
      assert.equal video.finished_at, null

    it 'sets its vote count to 1', ->
      video.vote_count.should.equal 1

    it 'knows the creator voted', ->
      video.votes.indexOf('123').should.not.equal -1

    it 'generates an id', ->
      video.id.should.not.equal null

