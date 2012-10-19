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
				console.log("Got the user ID! " + red._id);

				var userID = res._id;
				localStorage.setItem('sc-userID', userID);
				if(typeof callback === "function") callback(userID);
			}
		});
	}
}

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