Started by creating a TabBar application with four tabs: Playing, Wishlist, Search and Settings.
I'm going to start by getting data from the Spotify Metadata API. It's a REST API that is quite
simple. I need to create a properly constructed URL, make a request and parse the result. The idea
of the application is to add tracks which means supporting searching for albums and artists will be
a bit more work. But the idea is to have the search functionality work much the same as it does in
Spotify's iPhone app. 

First step is to create the URLs. Off to the unit tests. Generating proper URLs for querying tracks
is quite simple so now we can move to use PPSearchURL.