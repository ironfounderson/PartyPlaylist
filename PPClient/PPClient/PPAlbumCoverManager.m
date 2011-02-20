//
//  PPAlbumCoverManager.m
//  PPClient
//
//  Created by Robert Höglund on 2/20/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import "PPAlbumCoverManager.h"
#import "ASIHTTPRequest.h"
#import "PPBonjourBrowser.h"
#import "PPPlayingTrack.h"
#import "PPSpotifyTrack.h"
@implementation PPAlbumCoverManager

@synthesize bonjourBrowser;

- (void)dealloc {
    [bonjourBrowser release];
    [super dealloc];
}
- (void)findAlbumCoverForTrack:(PPPlayingTrack *)track {
    NSString *hostAddress = self.bonjourBrowser.playlistAddress;
    NSString *urlString = [NSString stringWithFormat:@"http://%@/albumimage?link=%@", 
                           hostAddress, track.track.albumLink];
    NSLog(@"Request image using URL: '%@'", urlString);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    request.delegate = self;
    request.userInfo = [NSDictionary dictionaryWithObject:track forKey:@"track"];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    PPPlayingTrack *track = [request.userInfo objectForKey:@"track"];
    if (request.responseStatusCode == 200) {
        NSData *response = [request responseData];
        track.albumCover = [UIImage imageWithData:response];
    }
    else {
        NSLog(@"Did not find image for track %@", track.track.title);        
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    PPPlayingTrack *track = [request.userInfo objectForKey:@"track"];
    NSLog(@"Failed finding image for track %@", track.track.title);
}
@end
