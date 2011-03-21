//
//  PPUserlist.h
//  PPServer
//
//  Created by Robert Höglund on 2/12/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PPPlaylistUser;

@interface PPUserlist : NSObject {
@private
    NSMutableArray *users_;
}

- (PPPlaylistUser *)userWithId:(NSString *)userId service:(NSString *)service;
- (void)addUser:(PPPlaylistUser *)user;

@end
