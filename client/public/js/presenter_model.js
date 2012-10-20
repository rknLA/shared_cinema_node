(function() {
  var PresenterAPI;

  window.SharedCinema || (window.SharedCinema = {});

  window.SharedCinema.PresenterModel = PresenterAPI = (function() {

    function PresenterAPI(user_id) {
      this.topThree = [];
      this.currentVideo = null;
      this.userId = user_id;
      this.blockAsyncTopThreeUpdate = false;
    }

    PresenterAPI.prototype.begin = function(nextVideoCallback, topThreeCallback) {
      if (topThreeCallback) this.onUpdateTopThree(topThreeCallback);
      if (nextVideoCallback) this.onNextVideoLoaded(nextVideoCallback);
      return this.videoDidFinish();
    };

    PresenterAPI.prototype.videoDidFinish = function() {
      var videoId,
        _this = this;
      this.blockAsyncTopThreeUpdates = true;
      videoId = this.currentVideo && '_id' in this.currentVideo ? this.currentVideo._id : 'null';
      return $.ajax({
        type: 'PUT',
        url: "/videos/" + videoId + "/finish",
        headers: {
          'Accept': 'application/json'
        },
        data: {
          user_id: this.userId
        },
        error: this.handleAjaxError,
        success: function(data, response) {
          _this.setTopThree(data.topThree);
          return _this.queueNextVideo(data.nextVideo);
        }
      });
    };

    PresenterAPI.prototype.queueNextVideo = function(video) {
      this.currentVideo = video;
      if (typeof this.notifyNextVideoListener === 'function') {
        this.notifyNextVideoListener(this.currentVideo);
      }
      return this.blockAsyncTopThreeUpdates = false;
    };

    PresenterAPI.prototype.setTopThree = function(topThree) {
      this.topThree = topThree;
      console.log("notify top three listener:", this.notifyTopThreeListener);
      if (typeof this.notifyTopThreeListener === 'function') {
        this.notifyTopThreeListener(this.topThree);
      }
      return this.setPollTopThree(1000);
    };

    PresenterAPI.prototype.handleAjaxError = function(response, description) {
      console.log(description);
      return console.log(response.responseText);
    };

    PresenterAPI.prototype.setPollTopThree = function(time) {
      var _this = this;
      return this.topThreeTimeout = setTimeout(function() {
        console.log("pol the top three!");
        return $.ajax({
          type: 'GET',
          url: "/videos?user_id=" + _this.userId + "&limit=3",
          headers: {
            'Accept': 'application/json'
          },
          error: _this.handleAjaxError,
          success: function(data, response) {
            return _this.setTopThree(data.videos);
          }
        });
      }, time);
    };

    PresenterAPI.prototype.onUpdateTopThree = function(callback) {
      this.notifyTopThreeListener = callback;
      return this;
    };

    PresenterAPI.prototype.onNextVideoLoaded = function(callback) {
      this.notifyNextVideoListener = callback;
      return this;
    };

    PresenterAPI.prototype.videoFinished = function() {
      return this.updateFromFinishedVideo;
    };

    return PresenterAPI;

  })();

}).call(this);
