//
//  PPPlaylist.h
//  PPServer
//
//  Created by Robert Höglund on 2/11/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGTwitterEngine.h"

@class PPSpotifyTrack;
@class PPPlaylistTrack;
@class PPPlaylistUser;
@class PPSpotifyController;

@interface PPPlaylist : NSObject {
@private
}

@property (assign) PPSpotifyController *spotifyController;

/**
 Finds the track associated with the supplied spotify URI and adds it to the playlist.
 */
- (void)addTrackFromLink:(NSString *)link byUser:(PPPlaylistUser *)user;

- (void)addTrack:(PPSpotifyTrack *)track byUser:(PPPlaylistUser *)user;


// TODO: Move user handling to separate class

- (PPPlaylistUser *)userWithTwitterId:(MGTwitterEngineID)userId;
- (PPPlaylistUser *)createTwitterUser:(NSDictionary *)userDict;
@end
