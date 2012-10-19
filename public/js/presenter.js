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
	width: 600, // the width of the player
	height: 450, // the height of the player
	preferredQuality: "default",// preferred quality: default, small, medium, large, hd720
	onPlay: function(id){}, // after the play method is called
	onPause: function(){}, // after the pause method is called
	onStop: function(){}, // after the player is stopped
	onSeek: function(time){}, // after the video has been seeked to a defined point
	onMute: function(){}, // after the player is muted
	onUnMute: function(){}, // after the player is unmuted
	onPlayerEnded: function() {
		console.log("video finished playing")
		initialize(userID);
	},
	onErrorNotFound: function() {
		console.log("video could not be found")
	},
	onErrorNotEmbedable: function() {
		console.log("video could not be embeded")
	}
});

function getPlaylist(userID, callback) {
	console.log("getting playlist")

	$.ajax({
		url: '/search',
		type: "GET",
		data: {
			q: "eminem",
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

function initialize(userID) {
	console.log("initializing")
	getPlaylist(userID, function(res) {

		if(res && res.videos && res.videos[0] && res.videos[0].video_id) {
			playVideo(res.videos[0].video_id);

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
			$("#video-2").src(video.thumbnail[0].url);
		}

		if(index == 2) {
			console.log("I am the third video: " + video.video_id)
		}

		if(index == 3) {
			console.log("I am the forth video: " + video.video_id)
		}
	});
}

setTimeout(function() {
	fetchUser(function(userID) {
		userID = userID;

		initialize(userID)
	});
}, 1000);