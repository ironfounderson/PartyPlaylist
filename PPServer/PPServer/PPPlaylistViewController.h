//
//  PPPlaylistViewController.h
//  PPServer
//
//  Created by Robert Höglund on 2/11/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@class PPPlaylist;
@class PPSpotifyController;

@interface PPPlaylistViewController : NSViewController {
@private
    dispatch_queue_t webUpdateQueue_;
    NSMutableArray *notifications_;
    NSMutableArray *trackRequests_;
}

@property (assign) IBOutlet WebView *webView;
@property (retain) PPPlaylist *playlist;
@property (assign) PPSpotifyController *spotifyController;

@end
