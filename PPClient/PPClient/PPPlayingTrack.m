//
//  PPTrackInfo.m
//  PPClient
//
//  Created by Robert Höglund on 2/20/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import "PPPlayingTrack.h"


@implementation PPPlayingTrack

@synthesize track;
@synthesize albumCover;

- (void)dealloc {
    [track release];
    [albumCover release];
    [super dealloc];
}
@end
