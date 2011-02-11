//
//  PPServerAppDelegate.m
//  PPServer
//
//  Created by Robert Höglund on 2/11/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import "PPServerAppDelegate.h"
#import "PPTwitterClient.h"
#import "PPSpotifyController.h"

@implementation PPServerAppDelegate

@synthesize window;
@synthesize username;
@synthesize password;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    twitterClient_ = [[PPTwitterClient alloc] init];
    //[twitterClient_ startListen];
    
    spotifyController_ = [[PPSpotifyController alloc] init];
    [spotifyController_ startSession];
}

- (IBAction)loginToSpotify:(id)sender {
    [spotifyController_ loginUser:self.username.stringValue 
                         password:self.password.stringValue];
}

@end
