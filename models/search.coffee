querystring = require 'querystring'
rest = require 'restler'
mongoose = require 'mongoose'

SearchSchema = new mongoose.Schema
  user:
    type: mongoose.Schema.Types.ObjectId
    required: true
  query:
    type: String
    required: true
  videos:
    type: Array
    required: true
  pageSize:
    type: Number
    required: true
    default: 20
  

consolidateYouTubeResults = (jsonInput) ->
  output = []
  for rawVideo in jsonInput.feed.entry
    video =
      title: rawVideo.title.$t
      description: rawVideo.media$group.media$description.$t
      author: rawVideo.media$group.media$credit[0].yt$display
      thumbnail: rawVideo.media$group.media$thumbnail
      video_id: rawVideo.media$group.yt$videoid.$t
    output.push video
  output

SearchSchema.static 'createWithQuery', (attrs, callback) ->
  search = new this()
  search.user = attrs.user_id
  search.query = attrs.q
  search.pageSize = 20

  query =
    q: attrs.q
    'max-results': 20
    v: 2
    alt: 'json'
  queryStr = querystring.stringify query
  rest.get("https://gdata.youtube.com/feeds/api/videos?#{queryStr}", {
    headers:
      'X-GData-Key': "key=#{attrs.googleApiKey}"
  }).on 'complete', (data, response) ->
    results = consolidateYouTubeResults data
    search.videos = results
    search.save (e, doc) ->
      throw e if e
      callback doc


SearchSchema.static 'page', (search_id, page_number, callback) ->
  callback

Search = mongoose.model('Search', SearchSchema)

module.exports = mongoose.model('Search')
