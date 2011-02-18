#import "Track.h"
#import "PPTrack.h"

@implementation Track

// Custom logic goes here.

- (PPTrack *)ppTrack {
    PPTrack *track = [[PPTrack alloc] init];
    track.title = self.title;
    track.albumName = self.albumName;
    track.link = self.link;
    track.artistName = self.artistName;
    return [track autorelease];
}

@end
