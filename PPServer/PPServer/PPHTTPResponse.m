//
//  PPHTTPResponse.m
//  PPServer
//
//  Created by Robert Höglund on 2/18/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import "PPHTTPResponse.h"
#import "CJSONSerializer.h"

@implementation PPHTTPResponse

@synthesize status;

+ (PPHTTPResponse *)responseWithData:(NSData *)data {
    return [PPHTTPResponse responseWithData:data statusCode:200];
}

+ (PPHTTPResponse *)responseWithData:(NSData *)data statusCode:(NSInteger)status {
    PPHTTPResponse *response = [[[PPHTTPResponse alloc] initWithData:data] autorelease];
    response.status = status;
    return response;    
}

+ (PPHTTPResponse *)errorResponseWithMessage:(NSString *)message {
    NSDictionary *errorDict = [NSDictionary dictionaryWithObject:message 
                                                          forKey:@"error"];
    NSData *data = [[CJSONSerializer serializer] serializeObject:errorDict
                                                           error:nil];
    return [PPHTTPResponse responseWithData:data statusCode:400];
}

+ (PPHTTPResponse *)jsonResponseWithDictionary:(NSDictionary *)dict {
    NSData *data = [[CJSONSerializer serializer] serializeObject:dict
                                                           error:nil];
    return [PPHTTPResponse responseWithData:data];
}
@end
