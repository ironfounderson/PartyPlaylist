//
//  PPPlaylist.m
//  PPServer
//
//  Created by Robert Höglund on 2/11/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import "PPPlaylist.h"
#import "PPSpotifyController.h"
#import "PPSpotifyTrack.h"

@implementation PPPlaylist

@synthesize spotifyController;

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (void)addTrackFromLink:(NSString *)link byUser:(PPPlaylistUser *)user {
    PPSpotifyTrack *track = [[PPSpotifyTrack alloc] init];
    track.link = link;    
    [self.spotifyController updateSpotifyTrack:track];
}

- (void)addTrack:(PPSpotifyTrack *)track byUser:(PPPlaylistUser *)user {
    
}


- (PPPlaylistUser *)userWithTwitterId:(MGTwitterEngineID)userId {
    return nil;
}

- (PPPlaylistUser *)createTwitterUser:(NSDictionary *)userDict {
    return nil;
}

@end
