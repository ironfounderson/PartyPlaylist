//
//  PPHTTPResponse.h
//  PPServer
//
//  Created by Robert Höglund on 2/18/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPDataResponse.h"


@interface PPHTTPResponse : HTTPDataResponse {
@private
    
}

+ (PPHTTPResponse *)responseWithData:(NSData *)data;
+ (PPHTTPResponse *)responseWithData:(NSData *)data statusCode:(NSInteger)status;
+ (PPHTTPResponse *)errorResponseWithMessage:(NSString *)message;
+ (PPHTTPResponse *)jsonResponseWithDictionary:(NSDictionary *)dict;


@property NSInteger status;
@end
