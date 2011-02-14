function addTweet(link, text) {
    newItem = $('<li id="' + link + '">' + link + '</li>').hide();
    
    $("#tweetwishlist").prepend(newItem);
    
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

function addRequest(trackRequest) {
    
var markup =  
  '<li class="request-item">\
  <div class="profile-picture">\
    <img src="${ProfilePicture}" />\
  </div>\
  <div class="profile-name">\
  ${ProfileName} requested\
  </div>\
  <div class="track-request">\
  ${TrackRequestText}\
  </div>\
  </li>';
  
  // Compile the markup as a named template
  $.template( "requestTemplate", markup );

  // Render the template with the movies data and insert
  // the rendered HTML under the "movieList" element
  $.tmpl( "requestTemplate", trackRequest )
      .appendTo( "#incoming-list" );
}