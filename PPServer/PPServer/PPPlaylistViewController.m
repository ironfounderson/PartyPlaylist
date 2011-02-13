//
//  PPPlaylistViewController.m
//  PPServer
//
//  Created by Robert Höglund on 2/11/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import "PPPlaylistViewController.h"
#import "PPPlaylist.h"
#import "PPSpotifyController.h"

@interface PPPlaylistViewController()
@property (copy) NSArray *tracks;
@end

@implementation PPPlaylistViewController

@synthesize webView;
@synthesize playlist;
@synthesize tracks = tracks_;
@synthesize spotifyController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:PPPlaylistChangeNotification 
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:PPPlaylistTrackLoadedNotification 
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:PPSpotifyTrackEndedPlayingNotification 
                                                  object:nil];

    [tracks_ release];
    [super dealloc];
}

- (void)awakeFromNib {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:path];
    [[self.webView mainFrame] loadRequest:[NSURLRequest requestWithURL:url]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(handlePlaylistChange:) 
                                                 name:PPPlaylistChangeNotification 
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(handleTrackLoaded:) 
                                                 name:PPPlaylistTrackLoadedNotification 
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(handleTrackEndedPlaying:) 
                                                 name:PPSpotifyTrackEndedPlayingNotification 
                                               object:nil];

}

- (void)handlePlaylistChange:(NSNotification *)notification {
    PPPlaylist *pl= [notification object];
    self.tracks = [pl upcomingItems];
}

- (void)handleTrackLoaded:(NSNotification *)notification {
}

- (void)handleTrackEndedPlaying:(NSNotification *)notification {
    NSLog(@"should move to next track");
}

#pragma mark -
#pragma mark web view stuff

- (void)webView:(WebView *)webView windowScriptObjectAvailable:(WebScriptObject *)windowScriptObject {
	NSLog(@"%@ received %@", self, NSStringFromSelector(_cmd));    
    [windowScriptObject setValue:self forKey:@"AppController"];
}


+ (BOOL)isSelectorExcludedFromWebScript:(SEL)aSelector {
    NSLog(@"Selector %s - %@", __FUNCTION__, NSStringFromSelector(aSelector));
    return NO;
}

+ (BOOL)isKeyExcludedFromWebScript:(const char *)name {
    NSLog(@"Key %s - %s", __FUNCTION__, name);
    return NO;
}

- (void)showMessage:(NSString *)message {
    NSRunAlertPanel(@"From WEBVIEW", message, nil, nil, nil);
}


@end
