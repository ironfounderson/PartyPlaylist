//
//  PPServerAppDelegate.h
//  PPServer
//
//  Created by Robert Höglund on 2/11/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PPTwitterClient;
@class PPSpotifyController;
@class PPPlaylistViewController;
@class PPPlaylist;
@class PPUserlist;
@class PPPlayingViewController;
@class PPHTTPServerController;
@class PPWebViewController;

@interface PPServerAppDelegate : NSObject <NSApplicationDelegate> {
@private
    PPTwitterClient *twitterClient_;
    PPSpotifyController *spotifyController_;
    PPPlaylist *playlist_;
    PPUserlist *userlist_;
    PPHTTPServerController *httpServerController_;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSTextField *username;
@property (assign) IBOutlet NSTextField *password;
@property (assign) IBOutlet PPPlaylistViewController *playlistController;
@property (assign) IBOutlet PPPlayingViewController *playingController;
@property (assign) IBOutlet PPWebViewController *webViewController;

- (IBAction)loginToSpotify:(id)sender;
- (IBAction)testResolveTrack:(id)sender;
- (IBAction)next:(id)sender;

@end
