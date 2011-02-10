//
//  PPSearchURLTests.m
//  PPClient
//
//  Created by Robert Höglund on 2/10/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "PPSearchURL.h"

@interface PPSearchURLTests : SenTestCase {
    
}

@end

@implementation PPSearchURLTests

- (void)testURLString_WithSingleWordQuery {
    PPSearchURL *searchURL = [PPSearchURL trackURLWithQuery:@"backstreet"];
    STAssertEqualObjects(@"http://ws.spotify.com/search/1/track?q=backstreet", searchURL.URLString, nil);
}

- (void)testURLString_WithQueryAndPage {
    PPSearchURL *searchURL = [PPSearchURL trackURLWithQuery:@"backstreet"];
    searchURL.page = 2;
    STAssertEqualObjects(@"http://ws.spotify.com/search/1/track?q=backstreet&page=2", searchURL.URLString, nil);
}

- (void)testURLString_WithTwoWordQuery {
    PPSearchURL *searchURL = [PPSearchURL trackURLWithQuery:@"new york"];
    STAssertEqualObjects(@"http://ws.spotify.com/search/1/track?q=new%20york", searchURL.URLString, nil);
}
@end
