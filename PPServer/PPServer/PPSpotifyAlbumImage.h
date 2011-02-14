//
//  PPSpotifyAlbumImage.h
//  PPServer
//
//  Created by Robert Höglund on 2/14/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <libspotify/api.h>

@class PPSpotifyTrack;

@interface PPSpotifyAlbumImage : NSObject {
@private
    NSString *imageDirectory_;
}

+ (id)sharedInstance;

@property (readonly) NSString *imageDirectory;

- (void)loadImageForTrack:(PPSpotifyTrack *)spTrack album:(sp_album *)album 
                  session:(sp_session *)session;
- (void)saveImage:(sp_image *)image forTrack:(PPSpotifyTrack *)track;
- (NSString *)imagePathForTrack:(PPSpotifyTrack *)track;

@end
