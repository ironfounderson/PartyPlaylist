//
//  PPPlaylistUser.h
//  PPServer
//
//  Created by Robert Höglund on 2/11/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Information about a user that has reuqested a track to be played. PPServer will handle twitter users
 as well as iPhone client users.
 */
@interface PPPlaylistUser : NSObject {
@private
    
}

@property (copy) NSString *name;
@property (copy) NSString *screenName;
@property (copy) NSString *userId;
@property (copy) NSString *profileImageURL;

@end
