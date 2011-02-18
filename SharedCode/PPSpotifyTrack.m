//
//  PPSpotifyTrack.m
//  PPServer
//
//  Created by Robert Höglund on 2/11/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import "PPSpotifyTrack.h"


@implementation PPSpotifyTrack

@synthesize link = link_;
@synthesize artistName = artistName_;
@synthesize title = title_;
@synthesize albumLink = albumLink_;
@synthesize albumName = albumName_;
@synthesize albumCoverPath = albumCoverPath_;
@synthesize loaded;
@synthesize invalidTrack;

- (id)initWithDictionary:(NSDictionary *)dict {
    self = [self init];
    if (self) {
        title_ = [[dict objectForKey:@"name"] copy];
        link_ = [[dict objectForKey:@"href"] copy];
        
        NSDictionary *albumDict = [dict objectForKey:@"album"];
        albumName_ = [[albumDict objectForKey:@"name"] copy];
        albumLink_ = [[albumDict objectForKey:@"href"] copy];
        NSArray *artists = [dict objectForKey:@"artists"];
        if (artists.count > 0) {
            NSDictionary *firstArtist = [artists objectAtIndex:0];
            artistName_ = [[firstArtist objectForKey:@"name"] copy];
        }
    }
    return self;
}

- (NSDictionary *)dictionary {
    NSMutableDictionary *trackDict = [NSMutableDictionary dictionary];
    [trackDict setObject:self.link forKey:@"href"];
    [trackDict setObject:self.title forKey:@"name"];
    
    NSDictionary *albumDict = [NSDictionary dictionaryWithObjectsAndKeys:
                               self.albumName, @"name", 
                               self.albumLink, @"href", nil];
    [trackDict setObject:albumDict forKey:@"album"];
    
    NSDictionary *artistDict = [NSDictionary dictionaryWithObjectsAndKeys:
                               self.artistName, @"name", nil];
    [trackDict setObject:[NSArray arrayWithObject:artistDict] forKey:@"artists"];
    return trackDict;
}

- (NSString *)jsonFromSpotifyTrack:(PPSpotifyTrack *)spotifyTrack {
    return nil;
}


- (id)init {
    self = [super init];
    if (self) {
        invalidTrack = NO;
        loaded = NO;
    }
    
    return self;
}

- (void)dealloc {
    [link_ release];
    [artistName_ release];
    [title_ release];
    [albumLink_ release];
    [albumName_ release];
    [albumCoverPath_ release];
    [super dealloc];
}

@end
