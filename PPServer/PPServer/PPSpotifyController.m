//
//  PPSpotifyController.m
//  PPServer
//
//  Created by Robert Höglund on 2/11/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import "PPSpotifyController.h"
#import "PPSpotifyTrack.h"

NSString * const PPSpotifyLoggedInNotification = @"PPSpotifyLoggedInNotification";
NSString * const PPSpotifyLoggedOutNotification = @"PPSpotifyLoggedOutNotification";
NSString * const PPSpotifyTrackEndedPlayingNotification = @"PPSpotifyTrackEndedPlayingNotification";

@interface PPSpotifyController()
@property (copy) NSString *playingLink;
@property BOOL isPlaying;
@end

@implementation PPSpotifyController

@synthesize playingLink = playingLink_;
// What is the Emacs or vim command for changing ispLaying to isPlaying ??
@synthesize isPlaying;

- (id)init {
    self = [super init];
    if (self) {
        spotifyQueue_ = dispatch_queue_create("com.roberthoglund.partyplaylist", NULL);
        updateArray_ = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)dealloc {
    dispatch_release(spotifyQueue_);
    [spotifySession_ release];
    [updateArray_ release];
    [playingLink_ release];
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

- (void)updateSpotifyTrack:(PPSpotifyTrack *)track {
    dispatch_async(spotifyQueue_, ^{
        sp_link *link = sp_link_create_from_string([track.link UTF8String]);
        if (link == NULL || sp_link_type(link) != SP_LINKTYPE_TRACK) {
            [track setTrack:NULL];
            NSLog(@"'%@' not a valid track link", track.link);
            if (link) {
                sp_link_release(link);
            }
            return;
        }

        sp_track *t = sp_link_as_track(link);
        [track setTrack:t];
        if (sp_track_is_loaded(t)) {
            track.trackIsLoaded = YES;
        }
        else {
            track.trackIsLoaded = NO;
            [updateArray_ addObject:track];
        }
        sp_link_release(link);
    });

}

- (void)playTrack:(PPSpotifyTrack *)track {
    
    // TODO: You should be able to pause tracks so somehow I need to fix that
    
    if ([self.playingLink isEqualToString:track.link]) {
        BOOL shouldPlay = !self.isPlaying;
        dispatch_async(spotifyQueue_, ^{
            sp_session_player_play(spotifySession_.session, shouldPlay);
            self.isPlaying = shouldPlay;
        });
    }
    
    if (self.playingLink) {
        // This is just so I can fake the ending of one song
        self.playingLink= nil;
        sp_session_player_play(spotifySession_.session, NO);
        [[NSNotificationCenter defaultCenter] postNotificationName:PPSpotifyTrackEndedPlayingNotification
                                                            object:self];
        return;
    }
    
    self.playingLink = track.link;
    
    dispatch_async(spotifyQueue_, ^{
        
        sp_error loadError = sp_session_player_load(spotifySession_.session, [track track]);
        if (loadError != SP_ERROR_OK) {
            NSLog(@"Could not load track in player :(");
            return;
        }
        
        sp_session_player_play(spotifySession_.session, YES);
        self.isPlaying = YES;
    });
    

}

- (void)trackFromLink:(NSString *)text {
    
}

#pragma mark - Spotify Session

- (void)sessionLoggedIn:(PPSpotifySession *)session {
    [[NSNotificationCenter defaultCenter] postNotificationName:PPSpotifyLoggedInNotification 
                                                        object:self];
}

- (void)session:(PPSpotifySession *)session loginFailedWithError:(NSError *)error {
    [[NSNotificationCenter defaultCenter] postNotificationName:PPSpotifyLoggedOutNotification 
                                                        object:self];}

- (void)sessionUpdatedMetadata:(PPSpotifySession *)session {
    dispatch_async(spotifyQueue_, ^{
        __block NSMutableIndexSet *discardedItems = [NSMutableIndexSet indexSet];
        [updateArray_ enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            PPSpotifyTrack *track = obj;
            if (sp_track_is_loaded([track track])) {
                track.trackIsLoaded = YES;
                [discardedItems addIndex:idx];
            }
        }];
        [updateArray_ removeObjectsAtIndexes:discardedItems];
    });
}

- (void)sessionEndedPlayingTrack:(PPSpotifySession *)session {
    self.playingLink = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:PPSpotifyTrackEndedPlayingNotification
                                                        object:self];
}
@end
