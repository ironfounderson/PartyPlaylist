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
#import "PPSpotifyTweetParser.h"
#import "PPSpotifyController.h"
#import "PPUserlist.h"
#import "DDLog.h"

static int ddLogLevel = LOG_LEVEL_WARN;

@implementation PPTwitterClient

@synthesize twitterEngine = twitterEngine_;
@synthesize username = username_;
@synthesize playlist;
@synthesize userlist;

- (id)init {
    self = [super init];
    if (self) {
        highestSeenTweetId_ = 0;
        username_ = [[NSString stringWithString:@"janesplaylist"] retain];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(handleSpotifyLoggedIn:) 
                                                     name:PPSpotifyLoggedInNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(handleSpotifyLoggedOut:) 
                                                     name:PPSpotifyLoggedOutNotification
                                                   object:nil];
    }
    
    return self;
}

- (void)dealloc {
    [twitterEngine_ release];
    [tweetParser_ release];
    [super dealloc];
}

- (void)handleSpotifyLoggedIn:(NSNotification *)notif {
    [self startListen];
}

- (void)handleSpotifyLoggedOut:(NSNotification *)notif {
    [self stopListen];
}

- (void)startListen {
    if (tweetParser_) {
        [tweetParser_ release];
        tweetParser_ = nil;
    }
    tweetParser_ = [[PPSpotifyTweetParser alloc] initWithTweetHandle:
                    [NSString stringWithFormat:@"@%@", self.username]];
    
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
        twitterEngine_ = [[MGTwitterEngine alloc] initWithDelegate:self];
        [twitterEngine_ setUsesSecureConnection:NO];
        [twitterEngine_ setConsumerKey:PPTwitterConsumerKey secret:PPTwitterConsumerSecret];
        [twitterEngine_ setUsername:self.username];
        
        OAToken *token = [[[OAToken alloc] initWithKey:PPTwitterAccessToken 
                                                secret:PPTwitterAccessTokenSecret] autorelease];
        [twitterEngine_ setAccessToken:token];
    }
    
    return twitterEngine_;
}

#pragma mark MGTwitterEngineDelegate methods

- (void)statusesReceived:(NSArray *)statuses forRequest:(NSString *)connectionIdentifier {
    for (NSDictionary *reply in statuses) {
        MGTwitterEngineID tweetId = [[reply objectForKey:@"id"] longLongValue];
        // This value needs to be persisted so we don't parse old requests
        //
        if (tweetId > highestSeenTweetId_) {
            highestSeenTweetId_ = tweetId;
        }

        
        // Parse message to make sure it is in the correct format
        //
        NSString *text = [reply objectForKey:@"text"];
        PPSpotifyTweetParserResult *parseResult = [tweetParser_ parseTweet:text error:nil];
        if (!parseResult) {
            DDLogWarn(@"tweet in format %@ not recognized", text);
            continue;
        }
        
        // Get or create a user associated with the twitter account that sent the request
        //
        NSDictionary *userDict = [reply objectForKey:@"user"];
        MGTwitterEngineID userId = [[userDict objectForKey:@"id"] longLongValue];
        PPPlaylistUser *playlistUser = [self.userlist userWithTwitterId:userId];
        if (!playlistUser) {
            playlistUser = [self.userlist createTwitterUser:userDict];
        }
        
        // How can I make sure this is not hanging up the program ??
        [self.playlist addTrackFromLink:parseResult.link byUser:playlistUser];
    }
    DDLogWarn(@"***** UPDATE OF TWEETS IS DONE *****");
}

- (void)receivedObject:(NSDictionary *)dictionary forRequest:(NSString *)connectionIdentifier {
    DDLogInfo(@"Got an object for %@: %@", connectionIdentifier, dictionary);
}

- (void)requestSucceeded:(NSString *)connectionIdentifier {
    DDLogInfo(@"Request succeeded for connectionIdentifier = %@", connectionIdentifier);
}

- (void)requestFailed:(NSString *)connectionIdentifier withError:(NSError *)error {
    DDLogInfo(@"Request failed for connectionIdentifier = %@, error = %@ (%@)", 
          connectionIdentifier, 
          [error localizedDescription], 
          [error userInfo]);
}

- (void)directMessagesReceived:(NSArray *)messages forRequest:(NSString *)connectionIdentifier {
    DDLogInfo(@"Got direct messages for %@:\r%@", connectionIdentifier, messages);
}


- (void)userInfoReceived:(NSArray *)userInfo forRequest:(NSString *)connectionIdentifier {
    DDLogInfo(@"Got user info for %@:\r%@", connectionIdentifier, userInfo);
}


- (void)miscInfoReceived:(NSArray *)miscInfo forRequest:(NSString *)connectionIdentifier {
	DDLogInfo(@"Got misc info for %@:\r%@", connectionIdentifier, miscInfo);
}


- (void)searchResultsReceived:(NSArray *)searchResults forRequest:(NSString *)connectionIdentifier {
	DDLogInfo(@"Got search results for %@:\r%@", connectionIdentifier, searchResults);
}


- (void)socialGraphInfoReceived:(NSArray *)socialGraphInfo forRequest:(NSString *)connectionIdentifier {
	DDLogInfo(@"Got social graph results for %@:\r%@", connectionIdentifier, socialGraphInfo);
}

- (void)userListsReceived:(NSArray *)userInfo forRequest:(NSString *)connectionIdentifier {
    DDLogInfo(@"Got user lists for %@:\r%@", connectionIdentifier, userInfo);
}

- (void)imageReceived:(NSImage *)image forRequest:(NSString *)connectionIdentifier {
    DDLogInfo(@"Got an image for %@: %@", connectionIdentifier, image);
}

- (void)connectionFinished:(NSString *)connectionIdentifier {
    DDLogInfo(@"Connection finished %@", connectionIdentifier);
}

- (void)accessTokenReceived:(OAToken *)aToken forRequest:(NSString *)connectionIdentifier {
	DDLogInfo(@"Access token received! %@",aToken);
}



@end
