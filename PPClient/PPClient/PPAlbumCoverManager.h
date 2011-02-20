//
//  PPAlbumCoverManager.h
//  PPClient
//
//  Created by Robert Höglund on 2/20/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PPPlayingTrack;
@class PPBonjourBrowser;

/**
 Keeps a cache of album covers. If the album cover is not cahced it is fetched from the playlist server.
 */
@interface PPAlbumCoverManager : NSObject {
    
}
@property (nonatomic, retain) PPBonjourBrowser *bonjourBrowser;
- (void)findAlbumCoverForTrack:(PPPlayingTrack *)track;
@end
