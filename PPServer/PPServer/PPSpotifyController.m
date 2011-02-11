//
//  PPSpotifyController.m
//  PPServer
//
//  Created by Robert Höglund on 2/11/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import "PPSpotifyController.h"


@implementation PPSpotifyController

- (id)init {
    self = [super init];
    if (self) {
        spotifyQueue_ = dispatch_queue_create("com.roberthoglund.partyplaylist", NULL);
    }
    
    return self;
}

- (void)dealloc {
    dispatch_release(spotifyQueue_);
    [spotifySession_ release];
    [super dealloc];
}

- (void)startSession {
    if (spotifySession_) {
        return;
    }
    
    spotifySession_ = [[PPSpotifySession alloc] init];
    
    dispatch_async(spotifyQueue_, ^{
        NSError *error;
        BOOL success = [spotifySession_ createSession:&error];
        if (!success) {
            NSLog(@"Could not create Spotify session. Got error: %@", error);
            return;
        }
        spotifySession_.delegate = self;
        
        NSLog(@"Spotify session initialized");
    });
}

- (void)loginUser:(NSString *)username password:(NSString *)password {
    dispatch_async(spotifyQueue_, ^{
        NSError *error = nil;
        if (![spotifySession_ loginUser:username password:password error:&error]) {
            NSLog(@"Could not log in to Spotify: %@", error.localizedDescription);
        }
    });
}

#pragma mark - Spotify Session

- (void)sessionLoggedIn:(PPSpotifySession *)session {
    NSLog(@"Logged in to spotify");
}

- (void)session:(PPSpotifySession *)session loginFailedWithError:(NSError *)error {
    NSLog(@"Login to Spotify failed:%@", error);
}

@end
