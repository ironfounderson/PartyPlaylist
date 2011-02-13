//
//  PPTrackScheduler.h
//  PPServer
//
//  Created by Robert Höglund on 2/13/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PPSTrackSchedulerObj NSObject<PPTrackScheduler>

@class PPPlaylistTrack;

@protocol PPTrackScheduler <NSObject>

/**
 Returns a track selected from tracks, or possibly playedTracks depending on the implementation.
 @param tracks a list of available tracks
 @param playedTracks a list of tracks that have already been played
 @returns a track
 */
- (PPPlaylistTrack *)nextFromTracks:(NSArray *)tracks played:(NSArray *)playedTracks;

@end
