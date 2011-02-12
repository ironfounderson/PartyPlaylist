//
//  PPUserlist.h
//  PPServer
//
//  Created by Robert Höglund on 2/12/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGTwitterEngine.h"

@class PPPlaylistUser;

@interface PPUserlist : NSObject {
@private
    NSMutableArray *users_;
}

- (PPPlaylistUser *)userWithTwitterId:(MGTwitterEngineID)userId;
- (PPPlaylistUser *)createTwitterUser:(NSDictionary *)userDict;

@end
