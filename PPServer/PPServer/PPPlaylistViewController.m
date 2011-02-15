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
#import "PPSpotifyTrack.h"
#import "PPPlaylistTrack.h"
#import "PPPlaylistUser.h"
#import "PPTrackRequest.h"
#import "PPWebViewController.h"
#import "DDLog.h"

static int ddLogLevel = LOG_LEVEL_INFO;

@interface PPPlaylistViewController()
@property (copy) NSArray *tracks;
@end

@implementation PPPlaylistViewController

@synthesize webView;
@synthesize playlist;
@synthesize tracks = tracks_;
@synthesize spotifyController;
@synthesize webViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    
    return self;
}

- (void)dealloc {
    for (NSString *name in notifications_) {
        [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                        name:name 
                                                      object:nil];
    }
    [notifications_ release];
    [trackRequests_ release];
    dispatch_release(webUpdateQueue_);
    [tracks_ release];
    [super dealloc];
}

- (void)addObserverSelector:(SEL)selector name:(NSString *)name {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:selector name:name object:nil];
    if (!notifications_) {
        notifications_ = [[NSMutableArray alloc] init];
    }
    [notifications_ addObject:name];

}
- (void)awakeFromNib {
    [self.webView setUIDelegate:self];
    [self.webView setFrameLoadDelegate:self];
    
    trackRequests_ = [[NSMutableArray alloc] init];
    webUpdateQueue_ = dispatch_queue_create("com.roberthoglund.ppserver.webupdatequeue", NULL);
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:path];
    [[self.webView mainFrame] loadRequest:[NSURLRequest requestWithURL:url]];
    
    [self addObserverSelector:@selector(handleTrackLoaded:) 
                         name:PPPlaylistTrackLoadedNotification];
    [self addObserverSelector:@selector(handleTrackEndedPlaying:) 
                         name:PPSpotifyTrackEndedPlayingNotification];
    [self addObserverSelector:@selector(handleStep:) 
                         name:PPPlaylistStepNotification];
    [self addObserverSelector:@selector(handleTrackRequested:) 
                         name:PPPlaylistTrackRequestedNotification];
}


- (void)updateTrackRequests {
    NSMutableIndexSet *discardedItems = [NSMutableIndexSet indexSet];
    [trackRequests_ enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PPTrackRequest *trackRequest = obj;
        if (trackRequest.isLoaded) {
            [self.webViewController showTrackRequest:trackRequest];
            [discardedItems addIndex:idx];                
        }
    }];
    [trackRequests_ removeObjectsAtIndexes:discardedItems];
}

- (void)handleTrackLoaded:(NSNotification *)notification {
    if (trackRequests_.count > 0) {
        [self updateTrackRequests];
    }
}

- (void)handleTrackEndedPlaying:(NSNotification *)notification {
    [self.playlist step];
}

- (void)handleStep:(NSNotification *)notification {
    // Calling these with null will result in the album cover being removed
    [self.webViewController showNextAlbumCoverForTrack:self.playlist.nextTrack];
    [self.webViewController showCurrentAlbumCoverForTrack:self.playlist.currentTrack];
    [self.webViewController showPreviousAlbumCoverForTrack:self.playlist.previousTrack];
    
    // If currentTrack is null the list of requesters will be removed
    NSArray *requestingUsers = self.playlist.currentTrack.users;
    [self.webViewController showRequestingUsers:requestingUsers];

    
    PPPlaylistTrack *track = self.playlist.currentTrack;
    if (!track) {
        DDLogInfo(@"Playlist has stepped but no track is available.");
        return;
    }
        
    DDLogInfo(@"Playlist has stepped. Should groove to %@", track.spotifyTrack.title);
    [self.spotifyController playTrack:track.spotifyTrack];
}

- (void)handleTrackRequested:(NSNotification *)notification {
    PPTrackRequest *trackRequest = [notification object];
    if (trackRequest.isLoaded) {
        [self.webViewController showTrackRequest:trackRequest];
    }
    else {
        [trackRequests_ addObject:trackRequest];
    }
}

#pragma mark -
#pragma mark web view stuff

- (void)webView:(WebView *)webView windowScriptObjectAvailable:(WebScriptObject *)windowScriptObject {
	NSLog(@"%@ received %@", self, NSStringFromSelector(_cmd));    
    [windowScriptObject setValue:self forKey:@"AppController"];
}


- (NSArray *)webView:(WebView *)sender contextMenuItemsForElement:(NSDictionary *)element 
    defaultMenuItems:(NSArray *)defaultMenuItems {
    return nil; // disable contextual menu for the webView
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
    DOMDocument *myDOMDocument = [[self.webView mainFrame] DOMDocument];
    NSLog(@"%@", [[myDOMDocument body] outerHTML]);
    
}

#pragma mark - Dynamic Logging

+ (int)ddLogLevel {
    return ddLogLevel;
}

+ (void)ddSetLogLevel:(int)logLevel {
    ddLogLevel = logLevel;
}

@end
