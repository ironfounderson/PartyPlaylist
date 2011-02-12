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
    /**
     List of of all users that requested this track
     */
    NSMutableArray *users_;
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

/**
 The time of a request will probably be included in how a track is selected for playing in the playlist. 
 This way we now when each user made the request. This class can be excluded if it turns out that only the first
 time a request was made is important.
 */
@interface PPPlaylistTrackUser : NSObject {
    
}

+ (id)playlistTrackUserWithUser:(PPPlaylistUser *)user requestTime:(NSDate *)time;
- (id)initWithUser:(PPPlaylistUser *)user requestTime:(NSDate *)time;

@property (retain) PPPlaylistUser *user;
@property (retain) NSDate *requestTime;

@end