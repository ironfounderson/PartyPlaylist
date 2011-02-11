//
//  PPServerAppDelegate.h
//  PPServer
//
//  Created by Robert Höglund on 2/11/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PPTwitterClient;
@class PPSpotifyController;

@interface PPServerAppDelegate : NSObject <NSApplicationDelegate> {
@private
    PPTwitterClient *twitterClient_;
    PPSpotifyController *spotifyController_;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSTextField *username;
@property (assign) IBOutlet NSTextField *password;

- (IBAction)loginToSpotify:(id)sender;

@end
