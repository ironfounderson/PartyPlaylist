//
//  PPSpotifyController.h
//  PPServer
//
//  Created by Robert Höglund on 2/11/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPSpotifySession.h"

@interface PPSpotifyController : NSObject <PPSpotifySessionDelegate> {
@private
    __block PPSpotifySession *spotifySession_;
    dispatch_queue_t spotifyQueue_;
}

- (void)startSession;
- (void)loginUser:(NSString *)username password:(NSString *)password;

@end
