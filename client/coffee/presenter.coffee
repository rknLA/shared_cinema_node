window.SharedCinema ||= { }

window.SharedCinema.PresenterModel = class PresenterAPI
  constructor: (user_id) ->
    @topThree = []
    @currentVideo = null
    @userId = user_id
    @blockAsyncTopThreeUpdate = false

  begin: (nextVideoCallback, topThreeCallback) ->
    @onUpdateTopThree topThreeCallback if topThreeCallback
    @onNextVideoLoaded nextVideoCallback if nextVideoCallback
    @videoDidFinish()

  videoDidFinish: () ->
    @blockAsyncTopThreeUpdates = true
    videoId = if @currentVideo and '_id' of @currentVideo then @currentVideo._id else 'null'
    $.ajax
      type: 'PUT'
      url: "/videos/#{videoId}/finish"
      headers:
        'Accept': 'application/json'
      data:
        user_id: @userId
      error: @handleAjaxError
      success: (data, response) =>
        @setTopThree(data.topThree)
        @queueNextVideo(data.nextVideo)

  queueNextVideo: (video) ->
    @currentVideo = video
    @notifyNextVideoListener(@currentVideo) if typeof @notifyNextVideoListener is 'function'
    $.ajax
      type: 'PUT'
      url: "/videos/#{video._id}/play?user_id=#{@userId}"
      headers:
        'Accept': 'application/json'
      error: @handleAjaxError
      success: (data, response) ->
        @blockAsyncTopThreeUpdates = false


  setTopThree: (topThree) ->
    @topThree = topThree
    #console.log "notify top three listener:", @notifyTopThreeListener
    @notifyTopThreeListener(@topThree) if typeof @notifyTopThreeListener is 'function'
    @setPollTopThree(1000)

  handleAjaxError: (response, description) ->
    #console.log description
    #console.log response.responseText

  setPollTopThree: (time) ->
    @topThreeTimeout = setTimeout( =>
      #console.log "pol the top three!"
      $.ajax
        type: 'GET'
        url: "/videos?user_id=#{@userId}&limit=3"
        headers:
          'Accept': 'application/json'
        error: @handleAjaxError
        success: (data, response) =>
          @setTopThree(data.videos)
    , time)


  #public-ish
  onUpdateTopThree: (callback) ->
    @notifyTopThreeListener = callback
    this

  onNextVideoLoaded: (callback) ->
    @notifyNextVideoListener = callback
    this

  videoFinished: () ->
    @updateFromFinishedVideo




