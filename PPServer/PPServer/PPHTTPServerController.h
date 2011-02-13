//
//  PPHTTPServerController.h
//  PPServer
//
//  Created by Robert Höglund on 2/13/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const PPBonjourType;

@class HTTPServer;

@interface PPHTTPServerController : NSObject {
@private
    HTTPServer *httpServer_;
}

- (void)startServer;

@end
