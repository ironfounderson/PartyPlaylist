//
//  PPSpotifyTrack.h
//  PPServer
//
//  Created by Robert Höglund on 2/11/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Represents an sp_track where the spotify URI is used as the link. 
 */
@interface PPSpotifyTrack : NSObject {
@private
}

- (id)initWithDictionary:(NSDictionary *)dict;

@property (getter=isLoaded) BOOL loaded;
@property BOOL invalidTrack;
@property (copy) NSString *link;
@property (copy) NSString *artistName;
@property (copy) NSString *title;
@property (copy) NSString *albumLink;
@property (copy) NSString *albumName;
@property (copy) NSString *albumCoverPath;

@end
