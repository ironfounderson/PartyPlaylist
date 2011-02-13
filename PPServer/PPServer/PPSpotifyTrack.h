//
//  PPSpotifyTrack.h
//  PPServer
//
//  Created by Robert Höglund on 2/11/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPSpotifyTrack : NSObject {
@private
}

@property BOOL trackIsLoaded;
@property (copy) NSString *link;
@property (copy) NSString *artistName;
@property (copy) NSString *title;

@end
