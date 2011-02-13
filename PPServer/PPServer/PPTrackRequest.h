//
//  PPTrackRequest.h
//  PPServer
//
//  Created by Robert Höglund on 2/13/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PPPlaylistTrack;
@class PPPlaylistUser;

@interface PPTrackRequest : NSObject {
@private
    
}

+ (id)requestWithTrack:(PPPlaylistTrack *)track user:(PPPlaylistUser *)user;
- (id)initWithTrack:(PPPlaylistTrack *)track user:(PPPlaylistUser *)user;

@property (retain) PPPlaylistTrack *track;
@property (retain) PPPlaylistUser *user;
@property (readonly) BOOL isLoaded;
@end
