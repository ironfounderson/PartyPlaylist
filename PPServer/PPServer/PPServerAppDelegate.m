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
#import "PPUserlist.h"
#import "PPHTTPServerController.h"
#import "DDTTYLogger.h"
#import "DDLog.h"

static int ddLogLevel = LOG_LEVEL_INFO;

@implementation PPServerAppDelegate

@synthesize window;
@synthesize username;
@synthesize password;
@synthesize playlistController;
@synthesize playingController;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    // These are the only instances of spotifycontroller, userlist and playlist that should be created.
    // They are considered singletons but they are not implemented as such but rather injected where they
    // are needed.
    spotifyController_ = [[PPSpotifyController alloc] init];
    userlist_ = [[PPUserlist alloc] init];
    playlist_ = [[PPPlaylist alloc] init];
    httpServerController_ = [[PPHTTPServerController alloc] init];
    
    playlist_.spotifyController = spotifyController_;
    playlist_.userlist = userlist_;
    
    twitterClient_ = [[PPTwitterClient alloc] init];
    twitterClient_.playlist = playlist_;
    twitterClient_.userlist = userlist_;
    
    self.playlistController.playlist = playlist_;
    self.playlistController.spotifyController = spotifyController_;
    
    [spotifyController_ startSession];
    [httpServerController_ startServer];
}

- (void)dealloc {
    [userlist_ release];
    [playlist_ release];
    [spotifyController_ release];
    [super dealloc];
}


- (IBAction)loginToSpotify:(id)sender {
    [spotifyController_ loginUser:self.username.stringValue 
                         password:self.password.stringValue];
}

- (IBAction)testResolveTrack:(id)sender {
    [playlist_ addTrackFromLink:@"spotify:track:70O39qQUEKZpAAbuq2lsbj" byUser:nil];
}

#pragma mark - Dynamic Logging

+ (int)ddLogLevel {
    return ddLogLevel;
}

+ (void)ddSetLogLevel:(int)logLevel {
    ddLogLevel = logLevel;
}

@end
