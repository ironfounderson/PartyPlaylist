//
//  PPWebViewController.m
//  PPServer
//
//  Created by Robert Höglund on 2/13/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import "PPWebViewController.h"
#import <WebKit/WebKit.h>
#import "PPSpotifyTrack.h"
#import "PPTrackRequest.h"
#import "PPPlaylistTrack.h"
#import "PPPlaylistUser.h"

@implementation PPWebViewController

@synthesize webView;

- (id)init {
    self = [super init];
    if (self) {
    }
    
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (void)updateWebView:(NSString *)function {
    dispatch_async(dispatch_get_main_queue(), ^ {
        [[self.webView windowScriptObject] evaluateWebScript:function];
    });
}


#pragma mark - Update requests

- (NSString *)trackRequestHTML:(PPTrackRequest *)trackRequest {
    PPSpotifyTrack *spTrack = trackRequest.track.spotifyTrack;
    NSString *message = [NSString stringWithFormat:@"%@ requested %@ by %@", 
                         trackRequest.user.screenName, 
                         [spTrack.title stringByReplacingOccurrencesOfString:@"'" withString:@""], 
                         spTrack.artistName];
    return message;
}

- (void)showTrackRequest:(PPTrackRequest *)trackRequest {
    NSString *html = [self trackRequestHTML:trackRequest];
    
    NSString *method = [NSString stringWithFormat:@"addRequest('', '%@');", html];
    [self updateWebView:method];
}



#pragma mark - Update playing status



@end
