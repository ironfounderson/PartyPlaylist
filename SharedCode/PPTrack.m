//
//  PPTrack.m
//  PPClient
//
//  Created by Robert Höglund on 2/10/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import "PPTrack.h"


@implementation PPTrack

@synthesize title = title_;
@synthesize link = link_;
@synthesize albumName = albumName_;
@synthesize artistName = artistName_;


- (id)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        title_ = [[dict objectForKey:@"name"] copy];
        link_ = [[dict objectForKey:@"href"] copy];
        
        NSDictionary *albumDict = [dict objectForKey:@"album"];
        albumName_ = [[albumDict objectForKey:@"name"] copy];

        NSArray *artists = [dict objectForKey:@"artists"];
        if (artists.count > 0) {
            NSDictionary *firstArtist = [artists objectAtIndex:0];
            artistName_ = [[firstArtist objectForKey:@"name"] copy];
        }
    }
    return self;
}

- (void)dealloc {
    [title_ release];
    [link_ release];
    [albumName_ release];
    [artistName_ release];
    [super dealloc];
}
@end
