//
//  PPSpotifyController.h
//  PPServer
//
//  Created by Robert Höglund on 2/11/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPSpotifySession.h"

extern NSString * const PPSpotifyLoggedInNotification;
extern NSString * const PPSpotifyLoggedOutNotification;
extern NSString * const PPSpotifyTrackEndedPlayingNotification;

@class PPSpotifyTrack;

@interface PPSpotifyController : NSObject <PPSpotifySessionDelegate> {
@private
    __block PPSpotifySessionObj *spotifySession_;
    dispatch_queue_t spotifyQueue_;
    __block NSMutableArray *updateArray_;
    __block BOOL initialized_;
}

@property (retain) PPSpotifySessionObj *spotifySession;
- (void)startSession;
- (void)loginUser:(NSString *)username password:(NSString *)password;
- (void)updateSpotifyTrack:(PPSpotifyTrack *)track;
- (void)playTrack:(PPSpotifyTrack *)track;
@end
