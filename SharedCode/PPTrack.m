//
//  PPTrack.m
//  PPClient
//
//  Created by Robert Höglund on 2/10/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import "PPTrack.h"


@implementation PPTrack

- (id)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        trackDict_ = [dict retain];
    }
    return self;
}

- (NSString *)title {
    return [trackDict_ objectForKey:@"name"];
}

- (NSString *)link {
    return [trackDict_ objectForKey:@"href"];
}

- (NSString *)albumName {
    NSDictionary *albumDict = [trackDict_ objectForKey:@"album"];
    return [albumDict objectForKey:@"name"];
}

- (NSString *)artistName {
    NSArray *artists = [trackDict_ objectForKey:@"artists"];
    if (artists.count == 0) {
        return nil;
    }
    NSDictionary *firstArtist = [artists objectAtIndex:0];
    return [firstArtist objectForKey:@"name"];
}

@end
