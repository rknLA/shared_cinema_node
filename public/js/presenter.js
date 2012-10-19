var url;
var local = "local.m.sharedcinema.com";
if(document.domain == local) {
	url = 'http://' + local;
}

else {
	url = 'http://m.sharedcinema.com';
}

console.log("Using this url: " + url);

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

function getPlaylist(userID, callback) {
	console.log("getting playlist")

	$.ajax({
		url: '/search',
		type: "GET",
		data: {
			q: "katie%20perry",
			user_id: userID
		},
		headers: {
			Accept: 'application/json'
		},                                                             
		success: function(res) {
			console.log("Got the playlist");
			videos = res.videos;
			if(typeof callback === "function") callback(res);
		},
		error: function(xhr) {
			console.log("Failed fetching the videos...");
			console.log(xhr.responseText)
		}
	});
}

function initialize(userID, reload) {
	reload = typeof reload !== 'undefined' ? reload : false;

	console.log("initializing")
	getPlaylist(userID, function(res) {

		if(res && res.videos && res.videos[0] && res.videos[0].video_id) {
			if(!reload) {
				playVideo(res.videos[0].video_id);
			}

			renderPlaylist(res);
		}
	});
}

function playVideo(id) {
	console.log("playing video: " + id)
	$videoPlayer.tubeplayer("play", id);
}

function renderPlaylist(res) {
	console.log("rendering playlist")
	console.log(res)
	$.each(res.videos, function(index, video) {

		if(index == 1) {
			console.log("I am the second video: " + video.video_id)
			$("#video-2").attr("src", video.thumbnail[1].url);
		}

		if(index == 2) {
			console.log("I am the third video: " + video.video_id)
			$("#video-3").attr("src", video.thumbnail[2].url);
		}

		if(index == 3) {
			console.log("I am the forth video: " + video.video_id)
			$("#video-4").attr("src", video.thumbnail[3].url);
		}
	});
}

//This is where the presenter starts when it first loads
setTimeout(function() {
	fetchUser(function(userID) {
		userID = userID;

		initialize(userID)
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