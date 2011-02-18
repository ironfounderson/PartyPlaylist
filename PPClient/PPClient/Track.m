#import "Track.h"
#import "PPSpotifyTrack.h"

@implementation Track

// Custom logic goes here.

- (PPSpotifyTrack *)spotifyTrack {
    PPSpotifyTrack *track = [[PPSpotifyTrack alloc] init];
    track.title = self.title;
    track.albumName = self.albumName;
    track.link = self.link;
    track.artistName = self.artistName;
    return [track autorelease];
}

@end
