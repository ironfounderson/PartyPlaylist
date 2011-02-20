//
//  PPTrackInfo.h
//  PPClient
//
//  Created by Robert Höglund on 2/20/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PPSpotifyTrack;
@class PPPlayingTrack;

/**
 Encapsulates a PPSpotifyTrack object and an UIImage
 */
@interface PPPlayingTrack : NSObject {
    
}

@property (nonatomic, retain) PPSpotifyTrack *track;
@property (nonatomic, retain) UIImage *albumCover;
@end
