//
//  PPUserlist.m
//  PPServer
//
//  Created by Robert Höglund on 2/12/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import "PPUserlist.h"
#import "PPPlaylistUser.h"
#import "DDLog.h"

static int ddLogLevel = LOG_LEVEL_INFO;

@interface PPUserlist()
- (PPPlaylistUser *)findUserWithId:(NSString *)userId service:(NSString *)service;
@end

@implementation PPUserlist

- (id)init {
    self = [super init];
    if (self) {
        users_ = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)dealloc {
    [users_ release];
    [super dealloc];
}

- (PPPlaylistUser *)userWithId:(NSString *)userId service:(NSString *)service {
    return [self findUserWithId:userId service:service];
}

- (void)addUser:(PPPlaylistUser *)user {
    if (![self findUserWithId:user.userId service:user.serviceName]) {
        DDLogInfo(@"Adding new user %@", user.screenName);
        [users_ addObject:user];
    }
}

- (PPPlaylistUser *)findUserWithId:(NSString *)userId service:(NSString *)service {
    NSUInteger index = [users_ indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
        PPPlaylistUser *user = obj;
        if ([user.userId isEqualToString:userId] && [user.serviceName isEqualToString:service]) {
            *stop = YES;
            return YES;
        }
        return NO;
    }];
    return index != NSNotFound ? [users_ objectAtIndex:index] : nil;
}

@end
