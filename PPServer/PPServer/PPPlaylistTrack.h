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
- (void)playlistTrackIsLoaded:(PPPlaylistTrack *)track;
@end

@interface PPPlaylistTrack : NSObject {
@private
}

- (id)initWithSpotifyTrack:(PPSpotifyTrack *)spTrack;

@property (assign) NSObject<PPPlaylistTrackDelegate> *delegate;
@property (retain) PPSpotifyTrack *spotifyTrack;
@property (readonly) NSString *link;
@property (readonly) NSUInteger wishCount;

- (void)addUser:(PPPlaylistUser *)user;

/**
 Convienience method for displaying data in an NSTableView
 */
- (id)valueForIdentifier:(NSString *)identifier;


@end
