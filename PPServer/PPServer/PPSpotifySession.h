//
//  PPSpotifySession.h
//  PPServer
//
//  Created by Robert Höglund on 2/13/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import <Foundation/Foundation.h>


#define PPSpotifySessionObj NSObject<PPSpotifySession>

@protocol PPSpotifySession;

@protocol PPSpotifySessionDelegate
@optional
- (void)sessionLoggedIn:(PPSpotifySessionObj *)session;
- (void)session:(PPSpotifySessionObj *)session loginFailedWithError:(NSError *)error;
- (void)sessionLoggedOut:(PPSpotifySessionObj *)session;
- (void)sessionUpdatedMetadata:(PPSpotifySessionObj *)session;
- (void)session:(PPSpotifySessionObj *)session connectionError:(NSError*)error;
- (void)session:(PPSpotifySessionObj *)session hasMessageToUser:(NSString*)message;
- (void)sessionLostPlayToken:(PPSpotifySessionObj *)session;
- (void)session:(PPSpotifySessionObj *)session logged:(NSString*)logmsg;
- (void)sessionEndedPlayingTrack:(PPSpotifySessionObj *)session;
- (void)session:(PPSpotifySessionObj *)session streamingError:(NSError*)error;
- (void)sessionUpdatedUserinfo:(PPSpotifySessionObj *)session;
@end

@protocol PPSpotifySession  


@property (assign) NSObject<PPSpotifySessionDelegate> *delegate;
- (BOOL)createSession:(NSError **)error;
- (BOOL)loginUser:(NSString*)user password:(NSString*)passwd error:(NSError**)err;
- (void)logout;

@end
