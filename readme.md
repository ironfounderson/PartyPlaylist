# Party Playlist #

Weekend hack prototype that uses Twitter and libspotify to create a playlist and play the tracks.

## Prototype? ##

Yes, this is very much a prototype. It's your common happy path application with no error handling and the assumption is that whoever is using it know what to do and in what order. This will improve by time and this little side project may or may not grow beyond this stage.

## Compiling ##

There are two files missing when checking out the source. appkey.c and twitterkey.m. appkey.c can be received from Spotify if you have a premium account and apply for a key. The appkey.c file should be placed in ProjectRoot/ExternalCode/libspotify/.

This application also uses a Twitter account to listen to song requests. At this stage the twitter user account is hard coded in the application and the following strings should be defined in ProjectRoot/PPServer/PPServer/twitterkey.m

    NSString * const PPTwitterUsername = ...;
    NSString * const PPTwitterConsumerKey = ...;
    NSString * const PPTwitterConsumerSecret = ...;
    NSString * const PPTwitterAccessToken = ...;
    NSString * const PPTwitterAccessTokenSecret = ...;

## On the shoulder of giants ##

The following third party libraries are used:

[ASIHTTP](http://allseeing-i.com/ASIHTTPRequest/)

[MGTwitterEngine](https://github.com/mattgemmell/MGTwitterEngine)

[cocoahhtpserver](http://code.google.com/p/cocoahttpserver/)

[libspotify](https://github.com/ctshryock/oauthconsumer)

[oauthconsumer](https://github.com/ctshryock/oauthconsumer)

[jquery](http://jquery.com/)

[jquery.tmpl](https://github.com/jquery/jquery-tmpl)

[less](http://lesscss.org/)

## License ##

At the moment there are no license attached to any of the code I have written.  Basically I you find something useful please feel free to use it. If this project moves beyond the prototype stage an appropriate license will be added. Something like MIT or similar that allows you to do what you please with the code. The third party libraries have their own licenses.
