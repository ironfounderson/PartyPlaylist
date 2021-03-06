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
#import "DDLog.h"

static int ddLogLevel = LOG_LEVEL_INFO;

NSString * const PPPlaylistTrackArtistNameIdentifier = @"artistName";
NSString * const PPPlaylistTrackWishCountIdentifier = @"wishCount";
NSString * const PPPlaylistTrackTitleIdentifier = @"title";

typedef void(^voidBlock)();

@interface PPPlaylistTrack()
- (void)subscribeToSpotifyTrack;
- (void)unsubscribeFromSpotifyTrack;
- (PPPlaylistUser *)findUser:(PPPlaylistUser *)user;
@end

@implementation PPPlaylistTrack

@synthesize delegate;
@synthesize spotifyTrack = spotifyTrack_;

+ (id)playlistTrackWithSpotifyTrack:(PPSpotifyTrack *)spTrack {
    return [[[PPPlaylistTrack alloc] initWithSpotifyTrack:spTrack] autorelease];
}

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
    [self unsubscribeFromSpotifyTrack];
    [observedKeyPaths_ release];
    [spotifyTrack_ release];
    [users_ release];
    [super dealloc];
}

- (void)subscribeToSpotifyTrack {
    observedKeyPaths_ = [NSArray arrayWithObjects:@"loaded", @"albumCoverPath", @"invalidTrack", nil];
    [observedKeyPaths_ retain];
    for (NSString *keyPath in observedKeyPaths_) {
        [spotifyTrack_ addObserver:self forKeyPath:keyPath
                           options:(NSKeyValueObservingOptionNew |
                                    NSKeyValueObservingOptionOld)
                           context:nil];        
   
    }

}

- (void)unsubscribeFromSpotifyTrack {
    for (NSString *keyPath in observedKeyPaths_) {
        [spotifyTrack_ removeObserver:self forKeyPath:keyPath];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqual:@"loaded"]) {
        if (self.spotifyTrack.isLoaded) {
            [self.delegate playlistTrackIsLoaded:self];
        }
    }
    else if ([keyPath isEqual:@"albumCoverPath"]) {
        [self.delegate playlistTrackHasAlbumCover:self];
    }
    else if ([keyPath isEqualToString:@"invalidTrack"]) {
        if (self.spotifyTrack.invalidTrack) {
            [self.delegate playlistTrackIsInvalid:self];        
        }
    }
}

- (NSString *)link {
    return self.spotifyTrack.link;
}

- (BOOL)addUser:(PPPlaylistUser *)user {
    // A user may only cast one vote on each track.
    if ([self findUser:user]) {
        return NO;
    }
    
    PPPlaylistTrackUser *trackUser = [PPPlaylistTrackUser playlistTrackUserWithUser:user 
                                                                        requestTime:[NSDate date]];
    [users_ addObject:trackUser];
    return YES;
}

- (NSArray *)users {
    NSMutableArray *users = [NSMutableArray arrayWithCapacity:users_.count];
    for (PPPlaylistTrackUser *pltUser in users_) {
        [users addObject:pltUser.user];
    }
    return users;
}

- (NSUInteger)wishCount {
    return users_.count;
}

/**
 Convienience method for displaying data in an NSTableView
 */
- (id)valueForIdentifier:(NSString *)identifier {
    if ([identifier isEqualToString:PPPlaylistTrackArtistNameIdentifier]) {
        return self.spotifyTrack.artistName;
    }
    if ([identifier isEqualToString:PPPlaylistTrackTitleIdentifier]) {
        return self.spotifyTrack.title;
    }
    if ([identifier isEqualToString:PPPlaylistTrackWishCountIdentifier]) {
        return [NSNumber numberWithLong:self.wishCount];
    }
    
    DDLogWarn(@"Could not handle identifier '%@'", identifier);
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

#pragma mark - Dynamic Logging

+ (int)ddLogLevel {
    return ddLogLevel;
}

+ (void)ddSetLogLevel:(int)logLevel {
    ddLogLevel = logLevel;
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