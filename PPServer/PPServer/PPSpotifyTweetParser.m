//
//  PPSpotifyTweetParser.m
//  PPServer
//
//  Created by Robert Höglund on 2/11/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import "PPSpotifyTweetParser.h"


@implementation PPSpotifyTweetParser

@synthesize handle = handle_;

- (id)initWithTweetHandle:(NSString *)handle {
    self = [super init];
    if (self) {
        handle_ = [handle copy];
    }
    
    return self;
}

- (void)dealloc {
    [handle_ release];
    [super dealloc];
}

- (PPSpotifyTweetParserResult *)parseTweet:(NSString *)text error:(NSError **)error{
    // a propert tweet looks like: @username OPERATION spotify:link
    NSArray *components = [text componentsSeparatedByString:@" "];
    if (components.count != 3) {
        return nil;
    }
    
    NSString *handle = [components objectAtIndex:0];
    if (![handle isEqualToString:self.handle]) {
        return nil;
    }
    
    PPTrackOperation operation = kPPTrackUnknownOperation;
    NSString *op = [components objectAtIndex:1];
    if ([op compare:@"ADD" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        operation = kPPTrackAddOperation;
    }
    
    if (operation == kPPTrackUnknownOperation) {
        return nil;
    }
        
    NSString *link = [components objectAtIndex:2];
    PPSpotifyTweetParserResult *result = [[[PPSpotifyTweetParserResult alloc] init] autorelease];
    result.link = link;
    result.operation =operation;
    return result;
}


@end

@implementation PPSpotifyTweetParserResult

@synthesize link = link_;
@synthesize operation;

- (void)dealloc {
    [link_ release];
    [super dealloc];
}

@end