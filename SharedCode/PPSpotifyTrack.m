//
//  PPSpotifyTrack.m
//  PPServer
//
//  Created by Robert Höglund on 2/11/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import "PPSpotifyTrack.h"


@implementation PPSpotifyTrack

@synthesize link = link_;
@synthesize artistName = artistName_;
@synthesize title = title_;
@synthesize albumLink = albumLink_;
@synthesize albumName = albumName_;
@synthesize albumCoverPath = albumCoverPath_;
@synthesize loaded;
@synthesize invalidTrack;

- (id)initWithDictionary:(NSDictionary *)dict {
    self = [self init];
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

- (id)init {
    self = [super init];
    if (self) {
        invalidTrack = NO;
        loaded = NO;
    }
    
    return self;
}

- (void)dealloc {
    [link_ release];
    [artistName_ release];
    [title_ release];
    [albumLink_ release];
    [albumName_ release];
    [albumCoverPath_ release];
    [super dealloc];
}

@end
