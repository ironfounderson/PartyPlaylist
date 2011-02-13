function addTweet(link, text) {
    newItem = $('<li id="' + link + '">' + link + '</li>').hide();
    
    $("#tweetwishlist").prepend(newItem);
    
    newItem.fadeIn();
}

function updateTweet(link, text) {
  $('#'+link).html(text);
}