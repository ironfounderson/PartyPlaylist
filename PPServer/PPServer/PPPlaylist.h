//
//  PPPlaylist.h
//  PPServer
//
//  Created by Robert Höglund on 2/11/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPPlaylistTrack.h"
#import "PPTrackScheduler.h"

extern NSString * const PPPlaylistTrackAddedNotification;
extern NSString * const PPPlaylistTrackRequestedNotification;
extern NSString * const PPPlaylistTrackLoadedNotification;
extern NSString * const PPPlaylistStepNotification;


@class PPSpotifyTrack;
@class PPPlaylistUser;
@class PPSpotifyController;
@class PPUserlist;

/**
 The tracks in the play list are unique by their track's link, i.e. the Spotify URI.
 There should only be one single playlist object but instead of using a singleton I'm
 injecting the ONE instance of the playlist created in the App Delegate.
 */
@interface PPPlaylist : NSObject <PPPlaylistTrackDelegate> {
@private
    dispatch_queue_t playlistQueue_;
    NSMutableArray *tracks_;    
    NSMutableArray *playedTracks_;
}

/**
 The scheduler responsible for selecting the next track that should be played.
 If not set, PPPlaylist will just select the tracks in the order they were added.
 */
@property (retain) PPSTrackSchedulerObj *trackScheduler;

/**
 */
@property (assign) PPSpotifyController *spotifyController;

/**
 */
@property (assign) PPUserlist *userlist;

@property (readonly) PPPlaylistTrack *currentTrack;
@property (readonly) PPPlaylistTrack *nextTrack;
@property (readonly) PPPlaylistTrack *previousTrack;

/**
 Finds the track associated with the supplied spotify URI and adds it to the playlist.
 */
- (PPPlaylistTrack *)addTrackFromLink:(NSString *)link byUser:(PPPlaylistUser *)user;

/**
 Returns the tracj that should be scheduled as the next one to play.
 */
- (PPPlaylistTrack *)nextScheduledTrack;

/**
 Moves the playlist to the next track as well as finds the track that should be played next. The first time this
 method is called it just sets the next track so when starting out it's necessary to call step twice.
 */
- (void)step;

/**
 Tracks that have been loaded and not yet been scheduled to be played or been played.
 */
- (NSArray *)availableTracks;
@end
