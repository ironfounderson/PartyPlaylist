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
    webUpdateQueue_ = dispatch_queue_create("com.roberthoglund.ppserver.webupdatequeue", NULL);
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:path];
    [[self.webView mainFrame] loadRequest:[NSURLRequest requestWithURL:url]];
    
    [self addObserverSelector:@selector(handlePlaylistItemAdded:) 
                         name:PPPlaylistItemAddedNotification];
    [self addObserverSelector:@selector(handlePlaylistItemUpdated:) 
                         name:PPPlaylistItemUpdatedNotification];
    [self addObserverSelector:@selector(handleTrackLoaded:) 
                         name:PPPlaylistTrackLoadedNotification];
    [self addObserverSelector:@selector(handleTrackEndedPlaying:) 
                         name:PPSpotifyTrackEndedPlayingNotification];

}

- (NSString *)playlistHTMLFromTrack:(PPPlaylistTrack *)track {
    PPSpotifyTrack *spTrack = track.spotifyTrack;
    if (!spTrack.isLoaded) {
        return @"Track waiting to be loaded";
    }
    
    /*
    NSString *text = [NSString stringWithFormat:@"<b>%@</b> %@ -- %d", 
                      [spTrack.title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], 
                      [spTrack.title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], 
                      track.wishCount];
     */
    NSString *text = [NSString stringWithFormat:@"<b>%@</b> %@ -- %d", 
                      [spTrack.title stringByReplacingOccurrencesOfString:@"'" withString:@""],
                      [spTrack.title stringByReplacingOccurrencesOfString:@"'" withString:@""],
                      track.wishCount];

    return text;
}

- (NSString *)htmlLink:(NSString *)link {
    return [[link componentsSeparatedByString:@":"] objectAtIndex:2];
}

- (void)updateWebView:(NSString *)function {
    dispatch_async(dispatch_get_main_queue(), ^ {
        [[self.webView windowScriptObject] evaluateWebScript:function];
    });
}
- (void)handlePlaylistItemAdded:(NSNotification *)notification {
    PPPlaylistTrack *plTrack = [notification object];
    NSString *text = [self playlistHTMLFromTrack:plTrack];
    NSString *jquery = [NSString stringWithFormat:@"addTweet('%@', '%@');", 
                        [self htmlLink:plTrack.link], text];
    [self updateWebView:jquery];
}

- (void)handlePlaylistItemUpdated:(NSNotification *)notification {
    PPPlaylistTrack *plTrack = [notification object];
    NSString *text = [self playlistHTMLFromTrack:plTrack];
    NSString *jquery = [NSString stringWithFormat:@"updateTweet('%@', '%@');", 
                        [self htmlLink:plTrack.link], text];
    [self updateWebView:jquery];
}

- (void)handleTrackLoaded:(NSNotification *)notification {
    PPPlaylistTrack *plTrack = [notification object];
    NSString *text = [self playlistHTMLFromTrack:plTrack];
    NSString *jquery = [NSString stringWithFormat:@"updateTweet('%@', '%@');", 
                        [self htmlLink:plTrack.link], text];
    [self updateWebView:jquery];
}

- (void)handlePlaylistChange:(NSNotification *)notification {
    PPPlaylist *pl= [notification object];
    self.tracks = [pl upcomingItems];
    
    NSString *jquery = @"addTweet();";
    [[self.webView windowScriptObject] evaluateWebScript:jquery];
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

#pragma mark - Dynamic Logging

+ (int)ddLogLevel {
    return ddLogLevel;
}

+ (void)ddSetLogLevel:(int)logLevel {
    ddLogLevel = logLevel;
}

@end
