//
//  PPSpotifySession.h
//  PPServer
//
//  Created by Robert Höglund on 2/11/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <libspotify/api.h>
#import "audio.h"

@class PPSpotifySession;

@protocol PPSpotifySessionDelegate
@optional
- (void)sessionLoggedIn:(PPSpotifySession *)session;
- (void)session:(PPSpotifySession *)session loginFailedWithError:(NSError *)error;
- (void)sessionLoggedOut:(PPSpotifySession *)session;
- (void)sessionUpdatedMetadata:(PPSpotifySession *)session;
- (void)session:(PPSpotifySession *)session connectionError:(NSError*)error;
- (void)session:(PPSpotifySession *)session hasMessageToUser:(NSString*)message;
- (void)sessionLostPlayToken:(PPSpotifySession *)session;
- (void)session:(PPSpotifySession *)session logged:(NSString*)logmsg;
- (void)sessionEndedPlayingTrack:(PPSpotifySession *)session;
- (void)session:(PPSpotifySession *)session streamingError:(NSError*)error;
- (void)sessionUpdatedUserinfo:(PPSpotifySession *)session;
@end

@interface PPSpotifySession : NSObject {
@private
    NSString *cachesDir_;
    NSString *supportDir_;
    sp_session_config config_;
	sp_session_callbacks callbacks_;
    sp_session *session_;
    audio_fifo_t audiofifo;
    NSObject<PPSpotifySessionDelegate> *delegate_;

}

@property (assign)  NSObject<PPSpotifySessionDelegate> *delegate;
@property (readonly) sp_session *session;
- (BOOL)createSession:(NSError **)error;
- (BOOL)loginUser:(NSString*)user password:(NSString*)passwd error:(NSError**)err;
- (void)logout;

@end
