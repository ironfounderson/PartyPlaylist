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
@synthesize trackIsLoaded;

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc {
    if (track_) {
        sp_track_release(track_);
    }
    [link_ release];
    [super dealloc];
}

-(void)setTrack:(sp_track *)track {
    if (track_) {
        sp_track_release(track_);
        track_ = NULL;
    }

    track_ = track;
    if (track_) {
        sp_track_add_ref(track);
    }
}

- (sp_track *)track {
    return track_;
}

@end
