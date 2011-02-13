//
//  PPPlaylist.h
//  PPServer
//
//  Created by Robert Höglund on 2/11/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPPlaylistTrack.h"

extern NSString * const PPPlaylistChangeNotification;
extern NSString * const PPPlaylistTrackLoadedNotification;

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
    __block NSMutableArray *tracks_;
}

/**
 */
@property (assign) PPSpotifyController *spotifyController;

/**
 */
@property (assign) PPUserlist *userlist;

/**
 Finds the track associated with the supplied spotify URI and adds it to the playlist.
 */
- (void)addTrackFromLink:(NSString *)link byUser:(PPPlaylistUser *)user;

- (NSArray *)upcomingItems;
@end
