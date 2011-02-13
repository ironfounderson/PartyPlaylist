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

NSString * const PPPlaylistItemAddedNotification = @"PPPlaylistItemAddedNotification";
NSString * const PPPlaylistItemUpdatedNotification = @"PPPlaylistItemUpdatedNotification";
NSString * const PPPlaylistChangeNotification = @"PPPlaylistChangeNotification";
NSString * const PPPlaylistTrackLoadedNotification = @"PPPlaylistTrackLoadedNotification";

@interface PPPlaylist()
- (PPPlaylistTrack *)findTrackWithLink:(NSString *)link;
@end

@implementation PPPlaylist

@synthesize spotifyController;
@synthesize userlist;

- (id)init {
    self = [super init];
    if (self) {
        tracks_ = [[NSMutableArray alloc] init];
        playlistQueue_ = dispatch_queue_create("com.roberthoglund.partyplaylist.playlist", NULL);
    }
    
    return self;
}

- (void)dealloc {
    [tracks_ release];
    dispatch_release(playlistQueue_);
    [super dealloc];
}

- (void)addTrackFromLink:(NSString *)link byUser:(PPPlaylistUser *)user {
    PPPlaylistTrack *plTrack = [self findTrackWithLink:link];
    if (!plTrack) {
        
        PPSpotifyTrack *spTrack = [[[PPSpotifyTrack alloc] init] autorelease];
        spTrack.link = link;
        
        plTrack = [[[PPPlaylistTrack alloc] initWithSpotifyTrack:spTrack] autorelease];
        plTrack.delegate = self;

        [self.spotifyController updateSpotifyTrack:spTrack];
                 
        [tracks_ addObject:plTrack];
        [[NSNotificationCenter defaultCenter] postNotificationName:PPPlaylistItemAddedNotification 
                                                           object:self];
         
    }
    
    [plTrack addUser:user];    
    [[NSNotificationCenter defaultCenter] postNotificationName:PPPlaylistItemUpdatedNotification 
                                                        object:plTrack];
}

- (void)playlistTrackIsLoaded:(PPPlaylistTrack *)track {
    [[NSNotificationCenter defaultCenter] postNotificationName:PPPlaylistTrackLoadedNotification 
                                                        object:track];
}

- (NSArray *)upcomingItems {
    __block NSMutableArray *items = [NSMutableArray array];
    dispatch_sync(playlistQueue_, ^{
        for (PPPlaylistTrack *track in tracks_) {
            [items addObject:track];
        }
    });    
    return items;
}

- (PPPlaylistTrack *)findTrackWithLink:(NSString *)link {
    if (tracks_.count == 0) {
        return nil;
    }
    
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
