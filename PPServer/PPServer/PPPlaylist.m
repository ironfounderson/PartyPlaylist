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

@interface PPPlaylist()
- (PPPlaylistTrack *)findTrackWithLink:(NSString *)link;
@end

@implementation PPPlaylist

@synthesize spotifyController;

- (id)init {
    self = [super init];
    if (self) {
        tracks_ = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)dealloc {
    [tracks_ release];
    [super dealloc];
}

- (void)addTrackFromLink:(NSString *)link byUser:(PPPlaylistUser *)user {
    PPPlaylistTrack *plTrack = [self findTrackWithLink:link];
    if (!plTrack) {
        PPSpotifyTrack *spTrack = [[PPSpotifyTrack alloc] init];
        spTrack.link = link;
        
        plTrack = [[[PPPlaylistTrack alloc] initWithSpotifyTrack:spTrack] autorelease];
        plTrack.delegate = self;
        [tracks_ addObject:plTrack];
        
        [self.spotifyController updateSpotifyTrack:spTrack];
        [spTrack release];
    }
    
    [plTrack addUser:user];
}

- (void)addTrack:(PPSpotifyTrack *)track byUser:(PPPlaylistUser *)user {
    
}

- (void)playlistTrackIsLoaded:(PPSpotifyTrack *)track {
    
}

- (PPPlaylistUser *)userWithTwitterId:(MGTwitterEngineID)userId {
    return nil;
}

- (PPPlaylistUser *)createTwitterUser:(NSDictionary *)userDict {
    return nil;
}

- (PPPlaylistTrack *)findTrackWithLink:(NSString *)link {
    NSUInteger index = [tracks_ indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
        PPPlaylistTrack *plTrack = obj;
        if ([plTrack.link isEqualToString:link]) {
            *stop = YES;
            return YES;
        }
        return NO;
    }];
    return index != NSNotFound ? [tracks_ objectAtIndex:index] : nil;
}

@end
