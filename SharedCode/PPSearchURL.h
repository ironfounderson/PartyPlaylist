//
//  PPSearchURL.h
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

/**
 Generates the URL used by Spotify's Metadata API
 */
@interface PPSearchURL : NSObject {
@private
    NSString *baseURLString_;
}

+ (PPSearchURL *)trackURLWithQuery:(NSString *)query;

/**
 Inits class with the track URL as the base URL
 */
- (id)initTrackWithQuery:(NSString *)query;


@property (nonatomic, readonly) NSString *URLString;
@property (nonatomic, copy) NSString *query;
@property (nonatomic) NSUInteger page;

@end
