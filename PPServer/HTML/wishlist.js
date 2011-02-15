function setPreviousAlbumInfo(imageurl) {
  var info = {'AlbumCoverPicture': imageurl, 'PlayingInfoClass': 'previous-playing-info' };
  var html = $('#nextPreviousTrackTemplate').tmpl(info);
  setAlbumCover('#previous-track', html);
}

function clearPreviousAlbumInfo() {
  $('#previous-track').empty();
}

function setNextAlbumInfo(imageurl) {
 var info = {'AlbumCoverPicture': imageurl, 'PlayingInfoClass': 'next-playing-info' };
 var html = $('#nextPreviousTrackTemplate').tmpl(info);
 setAlbumCover('#next-track', html);
}

function clearNextAlbumInfo() {
  $('#next-track').empty();
}

function setCurrentAlbumInfo(imageurl) {
  var info = {'AlbumCoverPicture': imageurl};
  var html = $('#currentTrackTemplate').tmpl(info);
  setAlbumCover('#current-track', html);
}

function clearCurrentAlbumInfo() {
  $('#current-track').empty();
}

function setAlbumCover(track, albumInfo) {
  $(track).empty();
  $(track).append(albumInfo);
}

function addTweet(trackRequest) {
  $('#incoming-list').each(function () {
     $("li:gt(4)", this).remove();
  });
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