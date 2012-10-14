User = require '../../models/user'
Video = require '../../models/video'

mongoose = require 'mongoose'
mongoose.connect 'mongodb://localhost/cinema_test'


describe 'Video', ->

  video = null
  user = null

  before (done) ->
    User.register
      ip: '127.0.0.1'
      (u) ->
        user = u
        Video.submit
          user_id: user._id
          youtube_video_id: 'mxPXPv3oNY4'
          (v) ->
            video = v
            console.log "video: #{video}"
            done()


  describe 'create', ->
    it 'sets the user', ->
      video.user_id.should.equal user._id

    it 'sets the video id', ->
      video.youtube_video_id.should.equal 'mxPXPv3oNY4'

    it 'sets a posted-at date', ->
      video.submitted_at.should.not.equal undefined

    it 'sets started-at to null', ->
      assert.equal video.started_at, null

    it 'sets finished-at to null', ->
      assert.equal video.finished_at, null

    it 'sets its vote count to 1', ->
      video.vote_count.should.equal 1

    it 'knows the creator voted', ->
      video.votes.indexOf(user._id).should.not.equal -1

    it 'generates an id', ->
      video._id.should.not.equal null


  describe 'vote', ->
    newUser = null

    before (done) ->
      User.register
        ip: '0.0.0.0'
        (u) ->
          newUser= u
          console.log "newUser: #{newUser}"
          video.vote newUser._id
          video.save (err) ->
            throw err if err
            done()


    it 'should increment the vote count', ->
      video.vote_count.should.equal 2

    it 'should know i voted', ->
      video.votes.indexOf(newUser._id).should.not.equal -1

    describe 'voting twice', ->

      before (done) ->
        video.vote newUser._id
        video.save (err) ->
          throw err if err
          done()

      it 'should decrement the vote count', ->
        video.vote_count.should.equal 1

      it 'should remove me from the voted list', ->
        video.votes.indexOf(newUser._id).should.equal -1
      
      describe 'triple voting', ->

        before (done) ->
          video.vote newUser._id
          video.save (err) ->
            throw err if err
            done()

        it 'should count my vote again', ->
          video.vote_count.should.equal 2
          video.votes.indexOf(newUser._id).should.not.equal -1


