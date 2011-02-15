//
//  PPSpotifyController.m
//  PPServer
//
//  Created by Robert Höglund on 2/11/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import "PPSpotifyController.h"
#import "PPSpotifyTrack.h"
#import "PPSpotifySessionImpl.h"
#import "PPSpotifyAlbumImage.h"
#import "DDLog.h"

static int ddLogLevel = LOG_LEVEL_INFO;

NSString * const PPSpotifyLoggedInNotification = @"PPSpotifyLoggedInNotification";
NSString * const PPSpotifyLoggedOutNotification = @"PPSpotifyLoggedOutNotification";
NSString * const PPSpotifyTrackEndedPlayingNotification = @"PPSpotifyTrackEndedPlayingNotification";



/**
 Internal wrapper class to contain a PPSpotifyTrack and a sp_track
 */
@interface PPTrackWrapper : NSObject {
    
}
+ (id)wrapperWithSpotifyTrack:(PPSpotifyTrack *)spTrack track:(sp_track *)t;
- (id)initWithSpotifyTrack:(PPSpotifyTrack *)spTrack track:(sp_track *)t;

@property (readonly) PPSpotifyTrack *spotifyTrack;
@property (readonly) sp_track *track;

@end

@interface PPSpotifyController()
@property (copy) NSString *playingLink;
@property BOOL isPlaying;
@property (readonly) sp_session *session;
@property (retain) PPTrackWrapper *queuedTrack;
@property (readonly) PPSpotifyAlbumImage *albumImages;
- (void)updateSpotifyTrack:(PPSpotifyTrack *)spTrack fromTrack:(sp_track *)track;
@end

@implementation PPSpotifyController

@synthesize playingLink = playingLink_;
@synthesize isPlaying;
@synthesize spotifySession = spotifySession_;
@synthesize  queuedTrack = queuedTrack_;
@synthesize albumImages = albumImages_;

- (id)init {
    self = [super init];
    if (self) {
        spotifyQueue_ = dispatch_queue_create("com.roberthoglund.partyplaylist", NULL);
        updateArray_ = [[NSMutableArray alloc] init];
        initialized_ = NO;
        albumImages_ = [[PPSpotifyAlbumImage alloc] init];
    }
    
    return self;
}

- (void)dealloc {
    dispatch_release(spotifyQueue_);
    [spotifySession_ release];
    [updateArray_ release];
    [playingLink_ release];
    [queuedTrack_ release];
    [albumImages_ release];
    [super dealloc];
}

- (sp_session *)session {
    return (sp_session *) self.spotifySession.session;
}

- (void)startSession {
    if (initialized_) {
        return;
    }
    
    dispatch_async(spotifyQueue_, ^{
        NSError *error;
        BOOL success = [spotifySession_ createSession:&error];
        if (!success) {
            DDLogError(@"Could not create Spotify session. Got error: %@", error);
            return;
        }
        spotifySession_.delegate = self;
        initialized_ = YES;
        DDLogInfo(@"Spotify session initialized");
    });
}

- (void)loginUser:(NSString *)username password:(NSString *)password {
    dispatch_async(spotifyQueue_, ^{
        NSError *error = nil;
        if (![spotifySession_ loginUser:username password:password error:&error]) {
            DDLogWarn(@"Could not log in to Spotify: %@", error.localizedDescription);
        }
    });
}

- (void)updateSpotifyTrack:(PPSpotifyTrack *)spTrack {
    dispatch_async(spotifyQueue_, ^{
        sp_link *link = sp_link_create_from_string([spTrack.link UTF8String]);
        if (link == NULL || sp_link_type(link) != SP_LINKTYPE_TRACK) {
            spTrack.invalidTrack = YES;
            DDLogWarn(@"'%@' not a valid track link", spTrack.link);
            if (link) {
                sp_link_release(link);
            }
            return;
        }

        sp_track *track = sp_link_as_track(link);
        if (sp_track_is_loaded(track)) {
            [self updateSpotifyTrack:spTrack fromTrack:track];
        }
        else {
            // By adding the sp_track we can update PPSpotifyTrack with the loaded meta data 
            // once libspotify returns it.
            //
            spTrack.loaded = NO;
            [updateArray_ addObject:[PPTrackWrapper wrapperWithSpotifyTrack:spTrack track:track]];
        }
        
        sp_link_release(link);
    });

}

- (void)playTrack:(PPSpotifyTrack *)spTrack {
    
    // TODO: You should be able to pause tracks so somehow I need to fix that
    
    if ([self.playingLink isEqualToString:spTrack.link]) {
        BOOL shouldPlay = !self.isPlaying;
        dispatch_async(spotifyQueue_, ^{
            sp_session_player_play(self.session, shouldPlay);
            self.isPlaying = shouldPlay;
        });
    }
    
    /*
    if (self.playingLink) {
        // This is just so I can fake the ending of one song
        self.playingLink= nil;
        sp_session_player_play(self.session, NO);
        [[NSNotificationCenter defaultCenter] postNotificationName:PPSpotifyTrackEndedPlayingNotification
                                                            object:self];
        return;
    }
    */
    
    __block __typeof__(self) _self = self;
    dispatch_async(spotifyQueue_, ^{
        sp_link *link = sp_link_create_from_string([spTrack.link UTF8String]);
        sp_track *track = sp_link_as_track(link);
        sp_error loadError = sp_session_player_load(self.session, track);
        if (loadError == SP_ERROR_RESOURCE_NOT_LOADED) {
            // When we get this error we should be notified later when the track has loaded and is ready to
            // be played
            _self.queuedTrack = [PPTrackWrapper wrapperWithSpotifyTrack:spTrack track:track];
            return;
        }
        if (loadError != SP_ERROR_OK) {
            spTrack.invalidTrack = YES;
            DDLogError(@"Track could not be loaded with error code = %d", loadError);
            return;
        }

        _self.playingLink = spTrack.link;
        sp_session_player_play(self.session, YES);
        _self.isPlaying = YES;
    });
    

}

- (void)updateSpotifyTrack:(PPSpotifyTrack *)spTrack fromTrack:(sp_track *)track {
    spTrack.title = [NSString stringWithUTF8String:sp_track_name(track)];
    if (sp_track_num_artists(track) > 0) {
        sp_artist *artist = sp_track_artist(track, 0);
        spTrack.artistName = [NSString stringWithUTF8String:sp_artist_name(artist)];
    }
    else {
        DDLogWarn(@"Could not find artist for track %@ (%@)", spTrack.title, spTrack.link);
        spTrack.artistName = @"UNKNOWN";
    }
    
    sp_album *album = sp_track_album(track);
    sp_link *albumLink = sp_link_create_from_album(album);
    char linkBuffer[255];
    sp_link_as_string(albumLink, linkBuffer, 255);
    spTrack.albumLink = [NSString stringWithUTF8String:linkBuffer];
    spTrack.albumName = [NSString stringWithUTF8String:sp_album_name(album)];
    [[PPSpotifyAlbumImage sharedInstance] loadImageForTrack:spTrack album:album session:self.session];

    spTrack.loaded = YES;
}

#pragma mark - Spotify Session

- (void)sessionLoggedIn:(PPSpotifySessionObj *)session {
    [[NSNotificationCenter defaultCenter] postNotificationName:PPSpotifyLoggedInNotification 
                                                        object:self];
}

- (void)session:(PPSpotifySessionObj *)session loginFailedWithError:(NSError *)error {
    [[NSNotificationCenter defaultCenter] postNotificationName:PPSpotifyLoggedOutNotification 
                                                        object:self];
}

- (void)playQueuedTrack {
    __block __typeof__(self) _self = self;
    dispatch_async(spotifyQueue_, ^{
        if (sp_track_is_loaded(_self.queuedTrack.track)) {
            sp_error loadError = sp_session_player_load(self.session, _self.queuedTrack.track);
            if (loadError != SP_ERROR_OK) {
                _self.queuedTrack.spotifyTrack.invalidTrack = YES;
                DDLogError(@"Track could not be loaded with error code = %d", loadError);
                return;
            }

            _self.playingLink = _self.queuedTrack.spotifyTrack.link;
            sp_session_player_play(self.session, YES);
            _self.isPlaying = YES;
            _self.queuedTrack = nil;
        }
    });  
}

- (void)updateTracks {
     __block __typeof__(self) _self = self;
    dispatch_async(spotifyQueue_, ^{
        __block NSMutableIndexSet *discardedItems = [NSMutableIndexSet indexSet];
        [updateArray_ enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            PPTrackWrapper *wrapper = obj;
            if (sp_track_is_loaded(wrapper.track)) {
                [_self updateSpotifyTrack:wrapper.spotifyTrack
                                fromTrack:wrapper.track];
                [discardedItems addIndex:idx];
            }
        }];
        [updateArray_ removeObjectsAtIndexes:discardedItems];
    });
}
- (void)sessionUpdatedMetadata:(PPSpotifySessionObj *)session {
    if (self.queuedTrack) {
        [self playQueuedTrack];    
    }
    if (updateArray_.count > 0) {
        [self updateTracks];
    }
}

- (void)sessionEndedPlayingTrack:(PPSpotifySessionObj *)session {
    self.playingLink = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:PPSpotifyTrackEndedPlayingNotification
                                                        object:self];
}

#pragma mark - Dynamic Logging

+ (int)ddLogLevel {
    return ddLogLevel;
}

+ (void)ddSetLogLevel:(int)logLevel {
    ddLogLevel = logLevel;
}

@end

@implementation PPTrackWrapper

@synthesize spotifyTrack;
@synthesize track;

+ (id)wrapperWithSpotifyTrack:(PPSpotifyTrack *)spTrack track:(sp_track *)t {
    return [[[PPTrackWrapper alloc] initWithSpotifyTrack:spTrack track:t] autorelease];
}

- (id)initWithSpotifyTrack:(PPSpotifyTrack *)spTrack track:(sp_track *)t {
    self = [super init];
    if (self) {
        spotifyTrack = [spTrack retain];
        track = t;
        sp_track_add_ref(track);
    }
    return self;
}

- (void)dealloc {
    [spotifyTrack release];
    sp_track_release(track);
    [super dealloc];
}

@end