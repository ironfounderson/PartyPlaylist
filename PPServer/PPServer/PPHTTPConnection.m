//
//  PPHTTPConnection.m
//  PPServer
//
//  Created by Robert Höglund on 2/13/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import "PPHTTPConnection.h"
#import "HTTPLogging.h"
const int httpLogLevel = HTTP_LOG_LEVEL_VERBOSE;

@implementation PPHTTPConnection

- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method 
                                              URI:(NSString *)path {
    return [super httpResponseForMethod:method URI:path];
}

@end
