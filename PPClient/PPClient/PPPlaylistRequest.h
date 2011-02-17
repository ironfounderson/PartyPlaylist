//
//  PPServerRequest.h
//  PPClient
//
//  Created by Robert Höglund on 2/17/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PPPlaylistRequest;

@protocol PPPlaylistRequestDelegate
@end

@interface PPPlaylistRequest : NSObject {

}
@property (nonatomic, assign) id<PPPlaylistRequestDelegate> delegate;

- (void)twitterNameAtHost:(NSString *)hostAddress;

@end
