;(function($, window, undefined) {
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

	$(document).on('pageshow', '#vote', function() {
		$.getJSON('data/videos.json', function(res) {
			renderItems('#video-list', res);
		});
	});

	$(document).on('pageshow', '#search', function() {
		fetchUser(function(userID) {
			setupVideoSearch(userID);
		});
	});

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

	function renderItems(id, res, callback) {
		console.log("Rendering Video Items...");

		var list = $(id);
		console.log(res)
		list.html('');

		$.each(res.videos, function(index, video) {
			//List element
			var li = document.createElement('li');

			//Anchor element
			var a  = document.createElement('a');
			a.href = '#';
			//a.innerHTML = video.title;

			//Left
			var left = document.createElement('div');
			left.className += ' video-list-left';

			//Image
			var img = document.createElement('img');
			img.className += ' video-list-img';
			img.src = video.thumbnail[0].url;
			left.appendChild(img);

			//Right
			var right = document.createElement('div');
			right.className += ' video-list-right';

			//Title
			var h3 = document.createElement('h3');
			h3.innerHTML = video.title;
			right.appendChild(h3);

			//Description
			var span = document.createElement('span');
			span.innerHTML = video.description;
			right.appendChild(span);

			//Append left and right to anchor
			a.appendChild(left);
			a.appendChild(right);

			//Thumb
			var thumb = document.createElement('button');
			thumb.className += ' thumb';
			thumb.type = 'button';
			thumb.innerHTML = '&nbsp;';
			a.appendChild(thumb);

			//Append anchor to list
			li.appendChild(a);

			//Append list element to list
			list.append(li);
		});

		list.listview('refresh');

		list.on('click', function(e) {
			e.preventDefault();

			if(e.target.tagName == "BUTTON") {
				var el = e.target;

				console.log("I am the upvote button");
			}
		});

		if(typeof callback === "function") callback();
	}

	function setupVideoSearch(userID) {
		console.log("Setting up the video search...");

		var timer = null;
		var $searchInput = $('#search .ui-input-search [data-type=search]');

		$searchInput.keyup(function(e) {
			var _this = this;
			console.log("Keyup detected...");
			//Only make video search when user stops typing for > half a second
			clearTimeout(timer); 
			timer = setTimeout(function() {
				console.log("Timer cleared..fetching videos...");
				$.ajax({
					url: '/search',
					type: "GET",
					data: {
						q: $(_this).val(),
						user_id: userID
					},
					headers: {
						Accept: 'application/json'
					},                                                             
					success: function(res) {
						console.log("Got the videos");
						renderItems('#search-list', res);
					},
					error: function(xhr) {
						console.log("Failed fetching the videos...");
						console.log(xhr.responseText)
					}
				});
				console.log("am i getting here?")
			}, 500);
		});
	}

}(jQuery, window));