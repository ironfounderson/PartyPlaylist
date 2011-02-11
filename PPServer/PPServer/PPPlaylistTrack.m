//
//  PPPlaylistItem.m
//  PPServer
//
//  Created by Robert Höglund on 2/11/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import "PPPlaylistTrack.h"
#import "PPSpotifyTrack.h"

@interface PPPlaylistTrack()
- (void)subscribeToSpotifyTrack;
@end
@implementation PPPlaylistTrack

@synthesize delegate;
@synthesize spotifyTrack = spotifyTrack_;

- (id)initWithSpotifyTrack:(PPSpotifyTrack *)spTrack {
    self = [super init];
    if (self) {
        spotifyTrack_ = [spTrack retain];
        [self subscribeToSpotifyTrack];
    }
    
    return self;
}

- (void)dealloc {
    [spotifyTrack_ release];
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
    NSLog(@"adding user");
}

- (NSUInteger)wishCount {
    return 0;
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

@end
