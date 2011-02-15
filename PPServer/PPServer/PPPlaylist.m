//
//  PPPlaylist.m
//  PPServer
//
//  Created by Robert Höglund on 2/11/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import "PPPlaylist.h"
#import "PPSpotifyController.h"
#import "PPSpotifyTrack.h"
#import "PPTrackRequest.h"
#import "DDLog.h"

static int ddLogLevel = LOG_LEVEL_INFO;

NSString * const PPPlaylistTrackAddedNotification = @"PPPlaylistTrackAddedNotification";
NSString * const PPPlaylistTrackLoadedNotification = @"PPPlaylistTrackLoadedNotification";
NSString * const PPPlaylistAlbumCoverLoadedNotification = @"PPPlaylistTrackAlbumCoverLoadedNotification";
NSString * const PPPlaylistStepNotification = @"PPPlaylistStepNotification";
NSString * const PPPlaylistTrackRequestedNotification = @"PPPlaylistTrackRequestedNotification";


@interface PPPlaylist()
- (PPPlaylistTrack *)findTrackWithLink:(NSString *)link;
@end

@implementation PPPlaylist

@synthesize spotifyController;
@synthesize userlist;
@synthesize trackScheduler = trackScheduler_;
@synthesize currentTrack = currentTrack_;
@synthesize nextTrack = nextTrack_;
@synthesize previousTrack = previousTrack_;

- (id)init {
    self = [super init];
    if (self) {
        tracks_ = [[NSMutableArray alloc] init];
        playedTracks_ = [[NSMutableArray alloc] init];
        playlistQueue_ = dispatch_queue_create("com.roberthoglund.partyplaylist.playlist", NULL);
    }
    
    return self;
}

- (void)dealloc {
    [tracks_ release];
    [playedTracks_ release];
    [trackScheduler_ release];
    [currentTrack_ release];
    [nextTrack_ release];
    [previousTrack_ release];
    dispatch_release(playlistQueue_);
    [super dealloc];
}

- (PPPlaylistTrack *)addTrackFromLink:(NSString *)link byUser:(PPPlaylistUser *)user {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    PPPlaylistTrack *plTrack = [self findTrackWithLink:link];
    if (!plTrack) {
        DDLogInfo(@"Adding track %@ to playlist", link);
        PPSpotifyTrack *spTrack = [[[PPSpotifyTrack alloc] init] autorelease];
        spTrack.link = link;
        
        plTrack = [[[PPPlaylistTrack alloc] initWithSpotifyTrack:spTrack] autorelease];
        plTrack.delegate = self;
        
        [self.spotifyController updateSpotifyTrack:spTrack];
        [tracks_ addObject:plTrack];
        [nc postNotificationName:PPPlaylistTrackAddedNotification 
                          object:plTrack];
    }
    
    if ([plTrack addUser:user]) {
        PPTrackRequest *trackRequest = [PPTrackRequest requestWithTrack:plTrack user:user];
        [nc postNotificationName:PPPlaylistTrackRequestedNotification 
                          object:trackRequest];
    }
    return plTrack;
}

#pragma mark - PPPlaylistTrack Delegate

- (void)playlistTrackIsLoaded:(PPPlaylistTrack *)track {
    [[NSNotificationCenter defaultCenter] postNotificationName:PPPlaylistTrackLoadedNotification 
                                                        object:track];
}

- (void)playlistTrackHasAlbumCover:(PPPlaylistTrack *)track {
    
}

- (void)playlistTrackIsInvalid:(PPPlaylistTrack *)track {
    if (track == self.currentTrack) {
        [self step];
    }
}

- (NSArray *)availableTracks {
    __block NSMutableArray *items = [NSMutableArray array];
    dispatch_sync(playlistQueue_, ^{
        for (PPPlaylistTrack *track in tracks_) {
            if (track.spotifyTrack.isLoaded && !track.spotifyTrack.invalidTrack) {
                [items addObject:track];
            }
        }
    });    
    return items;
}

- (PPPlaylistTrack *)nextScheduledTrack {
    if (self.trackScheduler) {
        return [self.trackScheduler nextFromTracks:[self availableTracks] played:playedTracks_];
    }
    
    NSArray *tracks = [self availableTracks];
    return tracks.count > 0 ? [tracks objectAtIndex:0] : nil;
}

- (void)setCurrentTrack:(PPPlaylistTrack *)track {
    if (currentTrack_ != track) {
        [currentTrack_ release];
        currentTrack_ = [track retain];
    }
}

- (void)setPreviousTrack:(PPPlaylistTrack *)track {
    if (previousTrack_ != track) {
        [previousTrack_ release];
        previousTrack_ = [track retain];
    }
}

- (void)setNextTrack:(PPPlaylistTrack *)track {
    if (nextTrack_ != track) {
        [nextTrack_ release];
        nextTrack_ = [track retain];
    }
}

- (void)step {
    
    // First we move the tracks we have
    if (self.previousTrack) {
        [playedTracks_ addObject:self.previousTrack];
        [self setPreviousTrack:nil];
    }
    if (self.currentTrack) {
        [self setPreviousTrack:self.currentTrack];
        [self setCurrentTrack:nil];
    }
    if (self.nextTrack) {
        [self setCurrentTrack:self.nextTrack];
        [self setNextTrack:nil];
    }

    // Simple fix to wrap around the playlist
    if ([[self availableTracks] count] == 0) {        
        for (PPPlaylistTrack *track in playedTracks_) {
            if (![self findTrackWithLink:track.link]) {
                [tracks_ addObject:track];
            }
        }
        [playedTracks_ removeAllObjects];
    }

    // Then we schedule the next
    __block PPPlaylistTrack *scheduledTrack = [self nextScheduledTrack];
    dispatch_sync(playlistQueue_, ^{
        if ([tracks_ containsObject:scheduledTrack]) {
            [tracks_ removeObject:scheduledTrack];
            [playedTracks_ addObject:scheduledTrack];
        }
    });
    [self setNextTrack:scheduledTrack];
    [[NSNotificationCenter defaultCenter] postNotificationName:PPPlaylistStepNotification 
                                                        object:self];
}

- (PPPlaylistTrack *)findTrackWithLink:(NSString *)link {
    NSUInteger index = [tracks_ indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
        PPPlaylistTrack *plTrack = obj;
        if ([plTrack.link isEqualToString:link]) {
            *stop = YES;
            return YES;
        }
        return NO;
    }];
    return index != NSNotFound ? [tracks_ objectAtIndex:index] : nil;
}

@end
