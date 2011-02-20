//
//  PPPlayingTrackView.h
//  PPClient
//
//  Created by Robert Höglund on 2/18/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PPPlayingTrack;

@interface PPPlayingTrackView : UIView {
}

@property (nonatomic, copy) NSString *title;
@property float arrowSize;
@property float imageMargin;
- (void)displaySpotifyTrack:(PPPlayingTrack *)track;
@end
