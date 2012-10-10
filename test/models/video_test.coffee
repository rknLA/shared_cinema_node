Video = require '../../models/video'

describe 'Video', ->
  describe 'create', ->
    video = null
    before ->
      video = new Video
        user_id: 123
        youtube_video_id: 'mxPXPv3oNY4'
    it 'sets the user'
    it 'sets the video id'
    it 'sets a posted-at date'
    it 'sets started-at to null'
    it 'sets finished-at to null'
    it 'sets its votes to 1'
