//
//  PPSpotifyTweetParser.m
//  PPServer
//
//  Created by Robert Höglund on 2/11/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "PPSpotifyTweetParser.h"

@interface PPSpotifyTweetParserTests : SenTestCase {
@private
    NSString *tweetHandle;
    PPSpotifyTweetParser *tweetParser;
}

@end
@implementation PPSpotifyTweetParserTests

- (void)setUp {
    [super setUp];
    tweetHandle = @"mistertweet";    
    tweetParser = [[PPSpotifyTweetParser alloc] initWithTweetHandle:tweetHandle];
}

- (void)tearDown {
    [tweetParser release];
    [super tearDown];
}

// @twitterhandle ADD spotify:track:somethingsomething

- (void)test_parseTweet_tweetWithWrongHandle {
    NSString *tweet = [NSString stringWithFormat:@"@randomhandle ADD spotify:track:70O39qQUEKZpAAbuq2lsbj"];
    PPSpotifyTweetParserResult *result = [tweetParser parseTweet:tweet error:nil];
    STAssertNil(result, nil);
}


- (void)test_parseTweet_validAddTweet {
    NSString *tweet = [NSString stringWithFormat:@"%@ ADD spotify:track:70O39qQUEKZpAAbuq2lsbj", tweetHandle];
    PPSpotifyTweetParserResult *result = [tweetParser parseTweet:tweet error:nil];
    STAssertEqualObjects(@"spotify:track:70O39qQUEKZpAAbuq2lsbj", result.link, nil);
    STAssertEquals(kPPTrackAddOperation, result.operation, nil);
}

// @twitterhandle REMOVE spotify:track:somethingsomething
// @twitterhandle STATUS spotify:track:somethingsomething

@end
