//
//  PPHTTPURLHandler.m
//  PPServer
//
//  Created by Robert Höglund on 2/18/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import "PPHTTPURLHandler.h"


@implementation PPHTTPURLHandler

@synthesize parameters = parameters_;
@synthesize pathString = pathString_;
@synthesize methodSelector = methodSelector_;

- (id)initWithMethod:(NSString *)method URI:(NSString *)path {
    self = [super init];
    if (self) {
        
        NSArray *pathSplit = [path componentsSeparatedByString:@"?"];
        pathString_ = [[[pathSplit objectAtIndex:0] substringFromIndex:1] copy];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        if (pathSplit.count > 1) {
            for (NSString *parameter in [[pathSplit objectAtIndex:1] componentsSeparatedByString:@"&"]) {
                NSArray *split = [parameter componentsSeparatedByString:@"="];
                [parameters setObject:split.count > 1 ? [split objectAtIndex:1] : [NSNull null]
                               forKey:[split objectAtIndex:0]];
            }
        }
        parameters_ = [[NSDictionary dictionaryWithDictionary:parameters] retain];
        
        // Construct the method name that will handle the repsonse
        // /search => GET_search:
        NSString *methodName;
        methodName = [NSString stringWithFormat:@"%@_%@:", 
                      method, 
                      [pathString_ stringByReplacingOccurrencesOfString:@"/" withString:@"_"]];
        
        methodSelector_ = NSSelectorFromString(methodName);
    }
    
    return self;
}

@end
