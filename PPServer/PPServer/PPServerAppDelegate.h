//
//  PPServerAppDelegate.h
//  PPServer
//
//  Created by Robert Höglund on 2/11/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PPTwitterClient;

@interface PPServerAppDelegate : NSObject <NSApplicationDelegate> {
@private
    NSWindow *window;
    PPTwitterClient *twitterClient_;
}

@property (assign) IBOutlet NSWindow *window;
@end
