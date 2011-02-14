//
//  PPWebViewController.h
//  PPServer
//
//  Created by Robert Höglund on 2/13/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WebView;
@class PPTrackRequest;
@class PPPlaylistTrack;

/**
 Responsible for updating the web view in response to changes to the play list and requests and what not
 */
@interface PPWebViewController : NSObject {
@private
    
}

@property (assign) IBOutlet WebView *webView;

- (void)showTrackRequest:(PPTrackRequest *)trackRequest;
- (void)showPreviousAlbumCoverForTrack:(PPPlaylistTrack *)track;
- (void)showCurrentAlbumCoverForTrack:(PPPlaylistTrack *)track;
- (void)showNextAlbumCoverForTrack:(PPPlaylistTrack *)track;
- (void)showRequestingUsers:(NSArray *)users;
@end
