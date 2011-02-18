//
//  PPHTTPConnection.h
//  PPServer
//
//  Created by Robert Höglund on 2/13/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPConnection.h"

@class PPPlaylist;

@interface PPHTTPConnection : HTTPConnection {
@private
    
}

+ (void)setPlaylist:(PPPlaylist *)playlist;

@end
