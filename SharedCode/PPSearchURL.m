//
//  PPSearchURL.m
//  PPClient
//
//  Created by Robert Höglund on 2/10/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import "PPSearchURL.h"


@implementation PPSearchURL

+ (PPSearchURL *)trackURLWithQuery:(NSString *)query {
    return [[[PPSearchURL alloc] initTrackWithQuery:query] autorelease];
}

@synthesize query = query_;
@synthesize page = page_;

- (id)initTrackWithQuery:(NSString *)query {    
    self = [super init];
    if (self) {
        baseURLString_ = @"http://ws.spotify.com/search/1/track.json";
        query_ = [query copy];
        page_ = NSUIntegerMax;
    }
    return self;
}

- (void)dealloc {
    [query_ release];
    [super dealloc];
}

- (NSString *)URLString {
    NSMutableArray *parameters = [NSMutableArray array];
    if (self.query) {
        [parameters addObject:[NSString stringWithFormat:@"q=%@", 
                               [self.query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    }
    if (self.page != NSUIntegerMax) {
        [parameters addObject:[NSString stringWithFormat:@"page=%d", self.page]];
    }
    NSString *parameterString = [parameters componentsJoinedByString:@"&"];
    return [NSString stringWithFormat:@"%@%@%@", 
            baseURLString_, 
            parameterString.length > 0 ? @"?" : @"",
            parameterString];
}

- (NSURL *)URL {
    return [NSURL URLWithString:self.URLString];
}

@end
