//
//  PPSpotifyTrack.h
//  PPServer
//
//  Created by Robert Höglund on 2/11/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <libspotify/api.h>

@interface PPSpotifyTrack : NSObject {
@private
    sp_track *track_;   
}

@property BOOL trackIsLoaded;
@property (copy) NSString *link;
@property (readonly) NSString *artistName;
@property (readonly) NSString *title;
- (void)setTrack:(sp_track *)track;
- (sp_track *)track;

@end
