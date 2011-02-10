//
//  PPSearchModel.h
//  PPClient
//
//  Created by Robert Höglund on 2/10/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PPSearchModel;

@protocol PPSearchModelDelegate
@optional
@end 

/**
 Responsible for querying the Spotify Metadata API, returning the result and reporting errors
 */
@interface PPSearchModel : NSObject {
    
}

@property (nonatomic, assign) id <PPSearchModelDelegate> delegate;
- (void)searchTrack:(NSString *)query;

@end
