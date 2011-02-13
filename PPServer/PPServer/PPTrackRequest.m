//
//  PPTrackRequest.m
//  PPServer
//
//  Created by Robert Höglund on 2/13/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import "PPTrackRequest.h"
#import "PPPlaylistTrack.h"
#import "PPSpotifyTrack.h"

@implementation PPTrackRequest
@synthesize track = track_;
@synthesize user = user_;


+ (id)requestWithTrack:(PPPlaylistTrack *)track user:(PPPlaylistUser *)user {
    return [[[PPTrackRequest alloc] initWithTrack:track user:user] autorelease];
}

- (id)initWithTrack:(PPPlaylistTrack *)track user:(PPPlaylistUser *)user {
    self = [super init];
    if (self) {
        track_ = [track retain];
        user_ = [user retain];
    }
    return self;
}

- (void)dealloc {
    [track_ release];
    [user_ release];
    [super dealloc];
}

- (BOOL)isLoaded {
    return self.track.spotifyTrack.isLoaded;
}

@end
