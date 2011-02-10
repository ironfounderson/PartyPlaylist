//
//  PPTrackParser.h
//  PPClient
//
//  Created by Robert Höglund on 2/10/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#if TARGET_OS_IPHONE
#import <Foundation/Foundation.h>
#elif TARGET_OS_MAC
#import <Cocoa/Cocoa.h>
#endif

@interface PPTrackParser : NSObject {
    
}

- (NSArray *)parseData:(NSData *)data;

@end
