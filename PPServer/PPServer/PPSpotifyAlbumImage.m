//
//  PPSpotifyAlbumImage.m
//  PPServer
//
//  Created by Robert Höglund on 2/14/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import "PPSpotifyAlbumImage.h"
#import "PPSpotifyTrack.h"
#import "NSFileManager+DirectoryLocations.h"

static void image_load_callback(sp_image* image, void *userData) {
    [[PPSpotifyAlbumImage sharedInstance] saveImage:image forTrack:userData];
}

@implementation PPSpotifyAlbumImage

+ (id)sharedInstance {
    static dispatch_once_t pred;
    static PPSpotifyAlbumImage *sInstance = nil;
    
    dispatch_once(&pred, ^{ sInstance = [[self alloc] init]; });
    return sInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc {
    [imageDirectory_ release];
    [super dealloc];
}

- (NSString *)imageDirectory {
    if (!imageDirectory_) {
        NSString *appSupportDirectory = [[NSFileManager defaultManager] applicationSupportDirectory];
        imageDirectory_ = [appSupportDirectory stringByAppendingPathComponent:@"images"];
        [imageDirectory_ retain];
        
        BOOL exists;
        BOOL isDirectory;
        exists = [[NSFileManager defaultManager] fileExistsAtPath:imageDirectory_ 
                                                      isDirectory:&isDirectory];
        if (!exists) {
            NSError *error = nil;
            [[NSFileManager defaultManager]
             createDirectoryAtPath:imageDirectory_
             withIntermediateDirectories:YES
             attributes:nil
             error:&error];
        }

    }
    return imageDirectory_;
}

- (void)loadImageForTrack:(PPSpotifyTrack *)spTrack album:(sp_album *)album 
                  session:(sp_session *)session {
    NSString *imagePath = [self imagePathForTrack:spTrack];
    BOOL isDirectory;
    if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath 
                                             isDirectory:&isDirectory]) {
        spTrack.albumCoverPath = imagePath;
    }
    else {
        sp_image *albumImage = sp_image_create(session, sp_album_cover(album));
        sp_image_add_load_callback(albumImage, image_load_callback, spTrack);
    }
}

- (void)saveImage:(sp_image *)image forTrack:(PPSpotifyTrack *)track {
    size_t imageSize;
    const void *imageBuffer = sp_image_data(image, &imageSize);
    NSString *imagePath = [self imagePathForTrack:track];
    NSData *imageData = [NSData dataWithBytes:imageBuffer length:imageSize];
    [imageData writeToFile:imagePath atomically:NO];
    track.albumCoverPath = imagePath;
}

- (NSString *)imagePathForTrack:(PPSpotifyTrack *)track {
    NSString *filename = [track.albumLink stringByReplacingOccurrencesOfString:@":" withString:@""];
    return [NSString stringWithFormat:@"%@/%@.jpg", self.imageDirectory, filename];
}
@end
