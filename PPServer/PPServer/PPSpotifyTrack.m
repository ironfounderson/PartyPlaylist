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
@synthesize invalidLink;

- (id)init {
    self = [super init];
    if (self) {
        invalidLink = NO;
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
