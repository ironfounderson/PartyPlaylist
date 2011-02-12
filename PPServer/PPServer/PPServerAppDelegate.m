//
//  PPServerAppDelegate.m
//  PPServer
//
//  Created by Robert Höglund on 2/11/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import "PPServerAppDelegate.h"
#import "PPTwitterClient.h"
#import "PPSpotifyController.h"
#import "PPPlaylist.h"
#import "PPPlaylistViewController.h"

@implementation PPServerAppDelegate

@synthesize window;
@synthesize username;
@synthesize password;
@synthesize playlistController;
@synthesize playingController;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    spotifyController_ = [[PPSpotifyController alloc] init];

    playlist_ = [[PPPlaylist alloc] init];
    playlist_.spotifyController = spotifyController_;
    
    self.playlistController.playlist = playlist_;
    
    twitterClient_ = [[PPTwitterClient alloc] init];
    twitterClient_.playlist = playlist_;
    
    [spotifyController_ startSession];    
}

- (IBAction)loginToSpotify:(id)sender {
    [spotifyController_ loginUser:self.username.stringValue 
                         password:self.password.stringValue];
}

- (IBAction)testResolveTrack:(id)sender {
    [playlist_ addTrackFromLink:@"spotify:track:70O39qQUEKZpAAbuq2lsbj" byUser:nil];
}

@end
