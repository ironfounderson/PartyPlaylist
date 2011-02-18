//
//  PPHTTPURLHandler.h
//  PPServer
//
//  Created by Robert Höglund on 2/18/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PPHTTPURLHandler : NSObject {
@private
    
}

- (id)initWithMethod:(NSString *)method URI:(NSString *)path;

@property (readonly) NSDictionary *parameters;
@property (readonly) NSString *pathString;
@property (readonly) SEL methodSelector;
@end
