//
//  PPPlaylist.h
//  PPServer
//
//  Created by Robert Höglund on 2/11/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGTwitterEngine.h"
#import "PPPlaylistTrack.h"

extern NSString * const PPPlaylistChangeNotification;
extern NSString * const PPPlaylistTrackLoadedNotification;

@class PPSpotifyTrack;
@class PPPlaylistUser;
@class PPSpotifyController;

@interface PPPlaylist : NSObject <PPPlaylistTrackDelegate> {
@private
    dispatch_queue_t playlistQueue_;
    __block NSMutableArray *tracks_;
}

@property (assign) PPSpotifyController *spotifyController;

/**
 Finds the track associated with the supplied spotify URI and adds it to the playlist.
 */
- (void)addTrackFromLink:(NSString *)link byUser:(PPPlaylistUser *)user;

- (void)addTrack:(PPSpotifyTrack *)track byUser:(PPPlaylistUser *)user;

- (NSArray *)upcomingItems;

// TODO: Move user handling to separate class

- (PPPlaylistUser *)userWithTwitterId:(MGTwitterEngineID)userId;
- (PPPlaylistUser *)createTwitterUser:(NSDictionary *)userDict;

@end
