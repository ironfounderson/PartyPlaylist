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

@property (getter=isLoaded) BOOL loaded;
@property BOOL invalidLink;
@property (copy) NSString *link;
@property (copy) NSString *artistName;
@property (copy) NSString *title;

@end
