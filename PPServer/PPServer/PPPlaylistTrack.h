//
//  PPPlaylistItem.h
//  PPServer
//
//  Created by Robert Höglund on 2/11/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PPSpotifyTrack;
@class PPPlaylistUser;
@class PPPlaylistTrack;

@protocol PPPlaylistTrackDelegate <NSObject>
- (void)playlistTrackIsLoaded:(PPSpotifyTrack *)track;
@end

@interface PPPlaylistTrack : NSObject {
@private
}

- (id)initWithSpotifyTrack:(PPSpotifyTrack *)spTrack;

@property (assign) NSObject<PPPlaylistTrackDelegate> *delegate;
@property (retain) PPSpotifyTrack *spotifyTrack;
@property (readonly) NSString *link;

- (void)addUser:(PPPlaylistUser *)user;

@end
