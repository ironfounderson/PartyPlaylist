//
//  PPTwitterClient.m
//  PPServer
//
//  Created by Robert Höglund on 2/11/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import "PPTwitterClient.h"
#import "OAToken.h"
#import "PPPlaylist.h"
#import "PPPlaylistUser.h"

@implementation PPTwitterClient

@synthesize twitterEngine = twitterEngine_;
@synthesize username = username_;
@synthesize playlist;

- (id)init {
    self = [super init];
    if (self) {
        highestSeenTweetId_ = 0;
    }
    
    return self;
}

- (void)dealloc {
    [twitterEngine_ release];
    [super dealloc];
}

- (void)startListen {
    if (pollTimer_) {
        [pollTimer_ invalidate];
        [pollTimer_ release];
    }
    
    const int POLLTIME = 60;
    pollTimer_ = [[NSTimer scheduledTimerWithTimeInterval:POLLTIME 
                                                   target:self 
                                                 selector:@selector(pollTwitter) 
                                                 userInfo:nil
                                                  repeats:YES] retain];
    [pollTimer_ fire];
}

- (void)stopListen {
    [pollTimer_ invalidate];
    [pollTimer_ release];
    pollTimer_ = nil;
}

- (void)pollTwitter {
    [self.twitterEngine getRepliesSinceID:highestSeenTweetId_ startingAtPage:0 count:0];
}

- (MGTwitterEngine *)twitterEngine {
    if (!twitterEngine_) {
        
        username_ = [[NSString stringWithString:@"janesplayslist"] retain];
        
        twitterEngine_ = [[MGTwitterEngine alloc] initWithDelegate:self];
        [twitterEngine_ setUsesSecureConnection:NO];
        [twitterEngine_ setConsumerKey:PPTwitterConsumerKey secret:PPTwitterConsumerSecret];
        [twitterEngine_ setUsername:username_];
        
        OAToken *token = [[[OAToken alloc] initWithKey:PPTwitterAccessToken 
                                                secret:PPTwitterAccessTokenSecret] autorelease];
        [twitterEngine_ setAccessToken:token];
    }
    
    return twitterEngine_;
}

#pragma mark MGTwitterEngineDelegate methods

- (void)statusesReceived:(NSArray *)statuses forRequest:(NSString *)connectionIdentifier {
    for (NSDictionary *reply in statuses) {
        // Parse message to make sure it is in the correct format
        //
        NSString *text = [reply objectForKey:@"text"];
        MGTwitterEngineID tweetId = [[reply objectForKey:@"id"] longLongValue];
        NSString *link = @"spotify:track:70O39qQUEKZpAAbuq2lsbj";
        
        // Get or create a user associated with the twitter account that sent the request
        //
        NSDictionary *userDict = [reply objectForKey:@"user"];
        MGTwitterEngineID userId = [[userDict objectForKey:@"id"] longLongValue];
        PPPlaylistUser *playlistUser = [self.playlist userWithTwitterId:userId];
        if (!playlistUser) {
            playlistUser = [self.playlist createTwitterUser:userDict];
        }
        
        [self.playlist addTrackFromLink:link byUser:playlistUser];
        
        // This value needs to be persisted so we don't parse old requests
        //
        if (tweetId > highestSeenTweetId_) {
            highestSeenTweetId_ = tweetId;
        }
    }
}

- (void)receivedObject:(NSDictionary *)dictionary forRequest:(NSString *)connectionIdentifier {
    NSLog(@"Got an object for %@: %@", connectionIdentifier, dictionary);
}

- (void)requestSucceeded:(NSString *)connectionIdentifier {
    NSLog(@"Request succeeded for connectionIdentifier = %@", connectionIdentifier);
}

- (void)requestFailed:(NSString *)connectionIdentifier withError:(NSError *)error {
    NSLog(@"Request failed for connectionIdentifier = %@, error = %@ (%@)", 
          connectionIdentifier, 
          [error localizedDescription], 
          [error userInfo]);
}

- (void)directMessagesReceived:(NSArray *)messages forRequest:(NSString *)connectionIdentifier {
    NSLog(@"Got direct messages for %@:\r%@", connectionIdentifier, messages);
}


- (void)userInfoReceived:(NSArray *)userInfo forRequest:(NSString *)connectionIdentifier {
    NSLog(@"Got user info for %@:\r%@", connectionIdentifier, userInfo);
}


- (void)miscInfoReceived:(NSArray *)miscInfo forRequest:(NSString *)connectionIdentifier {
	NSLog(@"Got misc info for %@:\r%@", connectionIdentifier, miscInfo);
}


- (void)searchResultsReceived:(NSArray *)searchResults forRequest:(NSString *)connectionIdentifier {
	NSLog(@"Got search results for %@:\r%@", connectionIdentifier, searchResults);
}


- (void)socialGraphInfoReceived:(NSArray *)socialGraphInfo forRequest:(NSString *)connectionIdentifier {
	NSLog(@"Got social graph results for %@:\r%@", connectionIdentifier, socialGraphInfo);
}

- (void)userListsReceived:(NSArray *)userInfo forRequest:(NSString *)connectionIdentifier {
    NSLog(@"Got user lists for %@:\r%@", connectionIdentifier, userInfo);
}

- (void)imageReceived:(NSImage *)image forRequest:(NSString *)connectionIdentifier {
    NSLog(@"Got an image for %@: %@", connectionIdentifier, image);
}

- (void)connectionFinished:(NSString *)connectionIdentifier {
    NSLog(@"Connection finished %@", connectionIdentifier);
}

- (void)accessTokenReceived:(OAToken *)aToken forRequest:(NSString *)connectionIdentifier {
	NSLog(@"Access token received! %@",aToken);
}



@end
