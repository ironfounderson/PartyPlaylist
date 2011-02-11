//
//  PPTwitterClient.h
//  PPServer
//
//  Created by Robert Höglund on 2/11/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGTwitterEngine.h"

extern NSString * const PPTwitterConsumerKey;
extern NSString * const PPTwitterConsumerSecret;
extern NSString * const PPTwitterAccessToken;
extern NSString * const PPTwitterAccessTokenSecret;

/**
 Handles the twitter communications
 */
@interface PPTwitterClient : NSObject <MGTwitterEngineDelegate> {
@private
    NSTimer *pollTimer_;
    MGTwitterEngineID highestSeenTweetId_;
}

@property (nonatomic, retain) MGTwitterEngine *twitterEngine;
@property (copy) NSString *username;

/**
 starts polling the time line to see if there are any new responses that needs to be handled
 */
- (void)startListen;

/**
 Stops listening to the twitter time line
 */
- (void)stopListen;

@end
