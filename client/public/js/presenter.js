var document = window.document;
window.scrollTo(0, 1);

var url;
var local = "local.m.sharedcinema.com";
if(document.domain == local) {
	url = 'http://' + local;
}

else {
	url = 'http://m.sharedcinema.com';
}

console.log("Using this url: " + url);

$( function() {
  var userID,
    presenter,
    $videoPlayer = $("#youtube-player-container");

  function fetchUser(callback) {
    console.log("Fetching user...");

    //Is userID in localstorage?
    var userID = localStorage.getItem('sc-userID');

    if(userID) {
      console.log("User was in cache");
      console.log(userID)
      callback(userID); return;
    } else {
      console.log("New user detected..getting ID");

      $.ajax({
        url: '/users',
        type: "POST",
        headers: {
          "Accept": 'application/json'
        },                                                          
        error: function(res) {
          console.log("There was an error fetching the ID")
          console.log(res.responseText)
        },
        success: function(res) {
          console.log("Got the user ID! " + res._id);

          var userID = res._id;
          localStorage.setItem('sc-userID', userID);
          if(typeof callback === "function") callback(userID);
        }
      });
    }
  }


// initialize the presenter api interface
  fetchUser(function (userId) {
    presenter = new window.SharedCinema.PresenterModel(userId)
  });



  $videoPlayer.tubeplayer({
    width: 640, // the width of the player
    height: 480, // the height of the player
    preferredQuality: "default",// preferred quality: default, small, medium, large, hd720
    onPlay: function(id){
      console.log("video " + id + " started playing");
    }, // after the play method is called
    onPause: function(){}, // after the pause method is called
    onStop: function(){}, // after the player is stopped
    onSeek: function(time){}, // after the video has been seeked to a defined point
    onMute: function(){}, // after the player is muted
    onUnMute: function(){}, // after the player is unmuted
    onPlayerEnded: function() {
      console.log("video finished playing")
      presenter.videoDidFinish()
    },
    onErrorNotFound: function() {
      console.log("video could not be found")
      presenter.begin()
    },
    onErrorNotEmbedable: function() {
      console.log("video could not be embeded")
      presenter.begin()
    },
    onErrorInvalidParameter: function() {
      console.log("something went wrong loading the video")
      presenter.begin()
    }
  });

  presenter.onUpdateTopThree(function(topThree) {
    console.log("top 3 called back with array");
    console.log(topThree);
    renderPlaylist(topThree);
  });
  presenter.onNextVideoLoaded(function(nextVideo) {
    console.log("next video loaded called back with video");
    console.log(nextVideo);
    playVideo(nextVideo.video_metadata.video_id)
  });
  presenter.begin()

  function playVideo(id) {
    console.log("playing video: " + id)
    $videoPlayer.tubeplayer("play", id);
  }

  function renderPlaylist(videos) {
    console.log("rendering playlist")
    console.log(videos)
    $.each(videos, function(index, video) {

      if(index == 0) {
        console.log("I am the second video: " + video.video_metadata.video_id)
        $("#video-2").attr("src", video.video_metadata.thumbnail[1].url);
      }

      if(index == 1) {
        console.log("I am the third video: " + video.video_metadata.video_id)
        $("#video-3").attr("src", video.video_metadata.thumbnail[2].url);
      }

      if(index == 2) {
        console.log("I am the forth video: " + video.video_metadata.video_id)
        $("#video-4").attr("src", video.video_metadata.thumbnail[3].url);
      }
    });
  }
});
