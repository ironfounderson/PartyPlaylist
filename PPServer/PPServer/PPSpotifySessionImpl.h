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
#import "PPSpotifySession.h"

@interface PPSpotifySessionImpl : NSObject<PPSpotifySession> {
@private
    NSString *cachesDir_;
    NSString *supportDir_;
    sp_session_config config_;
	sp_session_callbacks callbacks_;
    sp_session *session_;
    audio_fifo_t audiofifo;
}

@property (readonly) sp_session *session;

@end
