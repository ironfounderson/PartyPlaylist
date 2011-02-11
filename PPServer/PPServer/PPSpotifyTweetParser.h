//
//  PPSpotifyTweetParser.h
//  PPServer
//
//  Created by Robert Höglund on 2/11/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PPSpotifyTweetParserResult;

typedef enum PPTrackOperation {
    kPPTrackUnknownOperation,
    kPPTrackAddOperation,
    kPPTrackRemoveOperation,
    kPPTrackStatusOperation
} PPTrackOperation;


@interface PPSpotifyTweetParser : NSObject {
@private
    
}
- (id)initWithTweetHandle:(NSString *)handle;

@property (copy) NSString *handle;

- (PPSpotifyTweetParserResult *)parseTweet:(NSString *)text error:(NSError **)error;

@end



@interface PPSpotifyTweetParserResult : NSObject {
    
}

@property PPTrackOperation operation;
@property (copy) NSString *link;

@end