//
//  PPPlaylistItem.m
//  PPServer
//
//  Created by Robert Höglund on 2/11/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import "PPPlaylistTrack.h"
#import "PPSpotifyTrack.h"
#import "PPPlaylistUser.h"

@interface PPPlaylistTrack()
- (void)subscribeToSpotifyTrack;
- (PPPlaylistUser *)findUser:(PPPlaylistUser *)user;
@end
@implementation PPPlaylistTrack

@synthesize delegate;
@synthesize spotifyTrack = spotifyTrack_;

- (id)initWithSpotifyTrack:(PPSpotifyTrack *)spTrack {
    self = [super init];
    if (self) {
        users_ = [[NSMutableArray alloc] init];
        spotifyTrack_ = [spTrack retain];
        [self subscribeToSpotifyTrack];
    }
    
    return self;
}

- (void)dealloc {
    [spotifyTrack_ release];
    [users_ release];
    [super dealloc];
}

- (void)subscribeToSpotifyTrack {
    [spotifyTrack_ addObserver:self forKeyPath:@"trackIsLoaded"
                       options:(NSKeyValueObservingOptionNew |
                                NSKeyValueObservingOptionOld)
                       context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqual:@"trackIsLoaded"]) {
        if (self.spotifyTrack.trackIsLoaded) {
            [self.delegate playlistTrackIsLoaded:self];
        }
    }
}

- (NSString *)link {
    return self.spotifyTrack.link;
}

- (void)addUser:(PPPlaylistUser *)user {
    // A user may only cast one vote on each track.
    if ([self findUser:user]) {
        return;
    }
    
    PPPlaylistTrackUser *trackUser = [PPPlaylistTrackUser playlistTrackUserWithUser:user 
                                                                        requestTime:[NSDate date]];
    [users_ addObject:trackUser];
}

- (NSUInteger)wishCount {
    return users_.count;
}

/**
 Convienience method for displaying data in an NSTableView
 */
- (id)valueForIdentifier:(NSString *)identifier {
    if ([identifier isEqualToString:@"artistName"]) {
        return self.spotifyTrack.artistName;
    }
    if ([identifier isEqualToString:@"title"]) {
        return self.spotifyTrack.title;
    }
    if ([identifier isEqualToString:@"wishCount"]) {
        return [NSNumber numberWithLong:self.wishCount];
    }
    
    NSLog(@"Could not handle identifier '%@'", identifier);
    return nil;
}

- (PPPlaylistUser *)findUser:(PPPlaylistUser *)user {
    NSUInteger index = [users_ indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
        PPPlaylistTrackUser *pltUser = obj;
        if ([pltUser.user.userId isEqualToString:user.userId]) {
            *stop = YES;
            return YES;
        }
        return NO;
    }];
    return index != NSNotFound ? [users_ objectAtIndex:index] : nil;
}

@end

@implementation PPPlaylistTrackUser

@synthesize user = user_;
@synthesize requestTime = requestTime_;

+ (id)playlistTrackUserWithUser:(PPPlaylistUser *)user requestTime:(NSDate *)time {
    return [[[self alloc] initWithUser:user requestTime:time] autorelease];
}

- (id)initWithUser:(PPPlaylistUser *)user requestTime:(NSDate *)time {
    self = [super init];
    if (self) {
        user_ = [user retain];
        requestTime_ = [requestTime_ retain];
    }
    return self;
}

- (void)dealloc {
    [user_ release];
    [requestTime_ release];
    [super dealloc];
}
@end