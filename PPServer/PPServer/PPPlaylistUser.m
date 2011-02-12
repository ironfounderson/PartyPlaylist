//
//  PPPlaylistUser.m
//  PPServer
//
//  Created by Robert Höglund on 2/11/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import "PPPlaylistUser.h"


@implementation PPPlaylistUser

@synthesize name = name_;
@synthesize screenName = screenName_;
@synthesize userId = userId_;

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc {
    [name_ release];
    [screenName_ release];
    [userId_ release];
    [super dealloc];
}

@end
