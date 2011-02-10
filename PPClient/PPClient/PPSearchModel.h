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
- (void)searchModel:(PPSearchModel *)model 
   receivedResponse:(NSData *)response 
         withStatus:(int)statusCode;
@end 

/**
 Responsible for querying the Spotify Metadata API, returning the result and reporting errors
 */
@interface PPSearchModel : NSObject {
    
}

/**
 The delegate that will be notified about the result of a search
 */
@property (nonatomic, assign) id <PPSearchModelDelegate> delegate;

/**
 Searches for a track
 @param query strign to search for
 */
- (void)searchTrack:(NSString *)query;

@end
