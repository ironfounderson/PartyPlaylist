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
#import "PPSpotifySessionImpl.h"

#import "PPSpotifyTrack.h"
#import "PPPlaylistUser.h"

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
    
    spotifyController_.spotifySession = [[[PPSpotifySessionImpl alloc] init] autorelease];
    [spotifyController_ startSession];
    [httpServerController_ startServer];
}

- (PPPlaylistUser *)sampleUserWithId:(NSString *)userId {
    PPPlaylistUser *user = [[PPPlaylistUser alloc] init];
    user.userId = userId;
    return [user autorelease];
}

- (void)test_addTrackFromLink {
    NSString *link = @"link it baby";
    [playlist_ addTrackFromLink:link byUser:[self sampleUserWithId:@"userid"]];
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
    PPSpotifyTrack *spTrack = [[[PPSpotifyTrack alloc] init] autorelease];
    spTrack.link = @"spotify:track:6AqNpQbWeNdjcpFP4WTvWR";
    [spotifyController_ playTrack:spTrack];
}

#pragma mark - Dynamic Logging

+ (int)ddLogLevel {
    return ddLogLevel;
}

+ (void)ddSetLogLevel:(int)logLevel {
    ddLogLevel = logLevel;
}

@end
