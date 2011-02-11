//
//  PPServerAppDelegate.m
//  PPServer
//
//  Created by Robert Höglund on 2/11/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import "PPServerAppDelegate.h"
#import "PPTwitterClient.h"

@implementation PPServerAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    twitterClient_ = [[PPTwitterClient alloc] init];
    [twitterClient_ startListen];
}

@end
