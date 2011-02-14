function addTweet(link, text) {
    newItem = $('<li id="' + link + '">' + link + '</li>').hide();
    
    $("#tweetwishlist").prepend(newItem);
    
    newItem.fadeIn();
}

function addRequest(link, text) {
    newItem = $('<li>' + text + '</li>').hide();
    
    $("#incoming-list").prepend(newItem);
    $("#incoming-list li:even").addClass("incoming-alt");
    newItem.fadeIn();
}

function updateTweet(link, text) {
  $('#'+link).html(text);
}

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