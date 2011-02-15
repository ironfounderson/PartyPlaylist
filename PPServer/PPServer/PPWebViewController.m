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
#import "DDLog.h"

static int ddLogLevel = LOG_LEVEL_INFO;


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
        DDLogInfo(@"Calling: %@", function);
        [[self.webView windowScriptObject] evaluateWebScript:function];
    });
}


#pragma mark - Update requests

- (NSString *)trackRequestHTML:(PPTrackRequest *)trackRequest {
    PPSpotifyTrack *spTrack = trackRequest.track.spotifyTrack;
    NSString *message = [NSString stringWithFormat:@"{ProfilePicture: '%@', ProfileName: '%@', TrackRequestText: '%@ by %@'}",
                         trackRequest.user.profileImageURL,
                         trackRequest.user.screenName, 
                         [spTrack.title stringByReplacingOccurrencesOfString:@"'" withString:@""], 
                         spTrack.artistName];
    return message;
}

- (void)showTrackRequest:(PPTrackRequest *)trackRequest {
    NSString *html = [self trackRequestHTML:trackRequest];
    
    NSString *method = [NSString stringWithFormat:@"addTweet(%@);", html];
    [self updateWebView:method];
}



#pragma mark - Update playing status

- (void)showAlbumCoverForTrack:(PPPlaylistTrack *)track usingMethod:(NSString *)method {
    NSString *function;
    if (track) {
        PPSpotifyTrack *spTrack = track.spotifyTrack;
        function = [NSString stringWithFormat:@"set%@('%@')", method, spTrack.albumCoverPath];
    }
    else {
        function = [NSString stringWithFormat:@"clear%@()", method];        
    }
    [self updateWebView:function];        
}

- (void)showPreviousAlbumCoverForTrack:(PPPlaylistTrack *)track {
    [self showAlbumCoverForTrack:track usingMethod:@"PreviousAlbumInfo"];
}

- (void)showCurrentAlbumCoverForTrack:(PPPlaylistTrack *)track {
    [self showAlbumCoverForTrack:track usingMethod:@"CurrentAlbumInfo"];}

- (void)showNextAlbumCoverForTrack:(PPPlaylistTrack *)track {
    [self showAlbumCoverForTrack:track usingMethod:@"NextAlbumInfo"];
}

- (void)showRequestingUsers:(NSArray *)users {
    NSMutableArray *requests = [NSMutableArray arrayWithCapacity:users.count];
    for (PPPlaylistUser *user in users) {
        [requests addObject:[NSString stringWithFormat:@"{ProfilePicture: '%@'}", user.profileImageURL]];
    }
    NSString *parameter = [NSString stringWithFormat:@"[%@]", [requests componentsJoinedByString:@","]];
    NSString *function = [NSString stringWithFormat:@"addRequests(%@)", parameter];
    [self updateWebView:function];
}
@end
