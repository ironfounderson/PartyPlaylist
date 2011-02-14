function setPreviousAlbumCover(imageurl) {
  setAlbumCover('previous-track', imageurl);
}

function setCurrentAlbumCover(imageurl) {
  setAlbumCover('current-track', imageurl);
}

function setNextAlbumCover(imageurl) {
  setAlbumCover('next-track', imageurl);
}

function setAlbumCover(track, imageurl) {
  $('#'+track).css('background-image', "url('" + imageurl + "')");
}

function addTweet(trackRequest) {
  $( "#tweetTemplate").tmpl(trackRequest )
      .prependTo( "#incoming-list" );
}

function addRequest(request) {
  $( "#requestTemplate").tmpl(request )
      .appendTo( "#requesters-list" );
}

function addRequests(requests) {
  clearRequests();
  $( "#requestTemplate").tmpl(requests )
      .appendTo( "#requesters-list" );
}

function clearRequests() {
  $('#requesters-list').empty();
}