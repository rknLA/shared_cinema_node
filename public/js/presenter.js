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

var userID,
	videos,
	$videoPlayer = $("#youtube-player-container");

$videoPlayer.tubeplayer({
	width: 640, // the width of the player
	height: 480, // the height of the player
	preferredQuality: "default",// preferred quality: default, small, medium, large, hd720
	onPlay: function(id){}, // after the play method is called
	onPause: function(){}, // after the pause method is called
	onStop: function(){}, // after the player is stopped
	onSeek: function(time){}, // after the video has been seeked to a defined point
	onMute: function(){}, // after the player is muted
	onUnMute: function(){}, // after the player is unmuted
	onPlayerEnded: function() {
		console.log("video finished playing")
		fetchUser(function(userID) {
			userID = userID;

			initialize(userID)
		});
	},
	onErrorNotFound: function() {
		console.log("video could not be found")
		fetchUser(function(userID) {
			userID = userID;

			initialize(userID)
		});
	},
	onErrorNotEmbedable: function() {
		console.log("video could not be embeded")
		fetchUser(function(userID) {
			userID = userID;

			initialize(userID)
		});
	},
	onErrorInvalidParameter: function() {
		console.log("something went wrong loading the video")
		fetchUser(function(userID) {
			userID = userID;

			initialize(userID)
		});
	}
});

function initialize(userID, reload) {
	reload = typeof reload !== 'undefined' ? reload : false;

	//First time page load
	if(reload == "first") {
		console.log("initializing for the first time")

		$.ajax({
		    type: 'GET',
		    url: '/videos',
		    headers: {
		      'Accept': 'application/json'
		    },
		    data: {
		      user_id: userID,
		      limit: 4
		    },
		    error: function(res) {
		      console.log("There was an error getting the videos");
		      console.log(res.responseText);
		    },
		    success: function(data, response) {
		      console.log("Initialized successfully for the first time!");

		      	var startingQueue = data;

          		var firstVideo = startingQueue.videos[0];
		    }
		  });
	}


	refreshVideoQueue(userID, function(res) {
		console.log("initializing")
		console.log(res)
		if(res && res.videos && res.videos[0] && res.videos[0].video_metadata && res.videos[0].video_metadata.video_id) {
			console.log("fired")
			

			if(!reload) {
				playVideo(res.videos[0].video_metadata.video_id);
			}

			renderPlaylist(res);
		}
	});
}

function finishVideo(userID, videoID) {
	if() {
		console.log("Finished first video")

		$.ajax({
		    type: 'PUT',
		    url: '/videos/null/finish',
		    headers: {
		      'Accept': 'application/json'
		    },
		    data: {
		      user_id: userID
		    },
		    error: function(res) {
		      console.log("There was an error finishing the first video");
		      console.log(res.responseText);
		    },
		    success: function(data, response) {
		      console.log("Got the data back!");
		      var formerVideo = data.finishedVideo;
              var initVideo   = data.nextVideo;
              var initQueue   = data.topThree;

		      //if(typeof callback === "function") callback(res);
		    }
		});
	}

	//
	else {
		console.log("Finished video")

		$.ajax({
		    type: 'PUT',
		    url: '/videos/'+videoID+'/finish',
		    headers: {
		      'Accept': 'application/json'
		    },
		    data: {
		      user_id: userID
		    },
		    error: function(res) {
		      console.log("There was an error finishing the first video");
		      console.log(res.responseText);
		    },
		    success: function(data, response) {
		      console.log("Got the data back!");
		      var formerVideo = data.finishedVideo;
              var initVideo   = data.nextVideo;
              var initQueue   = data.topThree;

		      //if(typeof callback === "function") callback(res);
		    }
		});
	}
}

function playVideo(id) {
	console.log("playing video: " + id)
	$videoPlayer.tubeplayer("play", id);
}

function refreshVideoQueue(userID, callback) {
  console.log("Refreshing the video queue");

  $.ajax({
    type: 'GET',
    url: '/videos',
    headers: {
      'Accept': 'application/json'
    },
    data: {
      user_id: userID
    },
    error: function(res) {
      console.log("There was an error refreshing the video queue");
      console.log(res.responseText);
    },
    success: function(res) {
      console.log("Queue updated successfully!");

      if(typeof callback === "function") callback(res);
    }
  });
};

function renderPlaylist(res) {
	console.log("rendering playlist")
	console.log(res)
	$.each(res.videos, function(index, video) {

		if(index == 1) {
			console.log("I am the second video: " + video.video_id)
			$("#video-2").attr("src", video.video_metadata.thumbnail[1].url);
		}

		if(index == 2) {
			console.log("I am the third video: " + video.video_id)
			$("#video-3").attr("src", video.video_metadata.thumbnail[2].url);
		}

		if(index == 3) {
			console.log("I am the forth video: " + video.video_id)
			$("#video-4").attr("src", video.video_metadata.thumbnail[3].url);
		}
	});
}

//This is where the presenter starts when it first loads
setTimeout(function() {
	fetchUser(function(userID) {
		userID = userID;

		initialize(userID, "first")
	});
}, 1000);

//Every 15 seconds, reload the playlist
var reloadPlaylist = null;
clearInterval(reloadPlaylist);
reloadPlaylist = setInterval(function() {
	console.log("reloading playlist")
	fetchUser(function(userID) {
		userID = userID;

		initialize(userID, true)
	});
}, 15000);