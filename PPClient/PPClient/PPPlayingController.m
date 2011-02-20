//
//  PPPlayingController.m
//  PPClient
//
//  Created by Robert Höglund on 2/10/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import "PPPlayingController.h"
#import "PPChoosePlaylistController.h"
#import "UIViewController+PPModal.h"
#import "PPBonjourBrowser.h"
#import "PPSpotifyTrack.h"
#import "ASIHTTPRequest.h"
#import "CJSONDeserializer.h"
#import "PPPlayingTrackView.h"
#import "PPPlayingCurrentTrackView.h"
#import "PPPlayingTrack.h"
#import "PPAlbumCoverManager.h"

#define PREVIOUS_SECTION 0
#define CURRENT_SECTION 1
#define NEXT_SECTION 2

@interface PPPlayingController()
@property (getter=isConnected) BOOL connected;
@property (nonatomic, readonly) PPPlaylistRequest *playlistRequest;
@property (readonly) PPPlayingTrack *previousTrack;
@property (readonly) PPPlayingTrack *currentTrack;
@property (readonly) PPPlayingTrack *nextTrack;
@property (readonly) PPPlayingTrackView *previousView;
@property (readonly) PPPlayingTrackView *currentView;
@property (readonly) PPPlayingTrackView *nextView;

- (void)requestCurrentPlayingTracks;
- (void)updateTrackViews;
@end

@implementation PPPlayingController
@synthesize connectingMessage;
@synthesize connectingView = connectingView_;
@synthesize bonjourBrowser;
@synthesize connected;
@synthesize playlistRequest = playlistRequest_;
@synthesize previousTrack = previousTrack_;
@synthesize currentTrack = currentTrack_;
@synthesize nextTrack = nextTrack_;
@synthesize previousView = previousView_;
@synthesize nextView = nextView_;
@synthesize currentView = currentView_;
@synthesize albumCoverManager = albumCoverManager_;

- (void)dealloc {
    [connectingView_ release];
    [playlistRequest_ release];
    [previousTrack_ release];
    [currentTrack_ release];
    [nextTrack_ release];
    [previousView_ release];
    [currentView_ release];
    [previousView_ release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.connected = NO;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.connectingView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)showNoServerView {
    self.connectingView.frame = self.view.frame;
    self.connectingMessage.text = NSLocalizedString(@"No playlist selected", 
                                                    @"No playlist selected");
    [self.view addSubview:self.connectingView];
    
}

- (void)showConnectingView {
    self.connectingView.frame = self.view.frame;
    self.connectingMessage.text = 
    [NSString stringWithFormat: NSLocalizedString(@"Connecting to '%@'", 
                                                  @"Connecting to playlist"), 
     self.bonjourBrowser.playlistName];
    [self.view addSubview:self.connectingView];
}

- (void)showPlayingView {
    if (self.connectingView.superview) {
        [self.connectingView removeFromSuperview];
    }
    CGFloat top = 0;
    if (!self.previousView.superview) {
        CGRect frame = self.previousView.frame;
        frame.origin.y = top;
        self.previousView.frame = frame;
        top += frame.size.height;
        [self.view addSubview:self.previousView];
        
        frame = self.currentView.frame;
        frame.origin.y = top;
        self.currentView.frame = frame;
        top += frame.size.height;
        [self.view addSubview:self.currentView];
        
        frame = self.nextView.frame;
        frame.origin.y = top;
        self.nextView.frame = frame;
        top += frame.size.height;
        [self.view addSubview:self.nextView];
    }
    
    isActive_ = YES;
    [self requestCurrentPlayingTracks];
}

- (void)playlistAvailabilityChange:(NSNotification *)notification {
    [self refreshView];
}

- (void)refreshView {
    if (self.bonjourBrowser.isPlaylistAvailable) {
        [self showPlayingView];
    }
    else {
        if (self.bonjourBrowser.playlistAddress) {
            [self showConnectingView];        
        }
        else {
            [self showNoServerView];
        }
    }
}

- (void)stop {
    isActive_ = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshView];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(playlistAvailabilityChange:) 
                                                 name:PPBonjourBrowserPlaylistAvailableNotification 
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    isActive_ = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:PPBonjourBrowserPlaylistAvailableNotification 
                                                  object:nil];
}

- (UIView *)connectingView {
    if (!connectingView_)  {
        [[NSBundle mainBundle] loadNibNamed:@"PPConnectingView" owner:self options:nil];
    }
    return connectingView_;
}

- (PPPlaylistRequest *)playlistRequest {
    if (!playlistRequest_) {
        playlistRequest_ = [[PPPlaylistRequest alloc] init];
        playlistRequest_.delegate = self;
    }
    return playlistRequest_;
}

- (IBAction)handleChoosePlaylist:(id)sender {
    PPChoosePlaylistController *playlistController = [[PPChoosePlaylistController alloc] init];
    __block __typeof__(self) blockSelf = self;
    [playlistController setSelectServiceBlock:^(NSNetService *service) {
        if (service) {
            [blockSelf.bonjourBrowser setServiceAsSelectedPlaylist:service];
        }
        [blockSelf dismissModalViewControllerAnimated:YES];
    }];
    playlistController.bonjourBrowser = self.bonjourBrowser;
    [self presentModalViewController:playlistController animated:YES];
    [playlistController release];
}

- (void)clearPlayingTracks {
    self.currentTrack.track = nil;
    self.currentTrack.albumCover = nil;
    self.previousTrack.track = nil;
    self.previousTrack.albumCover = nil;
    self.nextTrack.track = nil;  
    self.nextTrack.albumCover = nil;  
}

- (void)updateTrackViews {
    [self.previousView displaySpotifyTrack:self.previousTrack];
    [self.currentView displaySpotifyTrack:self.currentTrack];
    [self.nextView displaySpotifyTrack:self.nextTrack];
}

- (void)assignPlayingTrack:(PPPlayingTrack *)track fromDictionary:(NSDictionary *)trackDict {
    if (trackDict) {
        track.track = [[[PPSpotifyTrack alloc] initWithDictionary:trackDict] autorelease];
        [self.albumCoverManager findAlbumCoverForTrack:track];
    }

}
- (void)requestCurrentPlayingTracks {
    
    //TODO: Smarter update of playing tracks so we don't update if we get the same tracks as we already are playing
    
    NSLog(@"Requesting current playing tracks");
    if (!self.bonjourBrowser.isPlaylistAvailable) {
        return;
    }
    
    NSString *hostAddress = self.bonjourBrowser.playlistAddress;
    NSString *urlString = [NSString stringWithFormat:@"http://%@/currentplaying", hostAddress];
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    __block __typeof__(self) blockSelf = self;
    [request setCompletionBlock:^ {
        [blockSelf clearPlayingTracks];
        if (request.responseStatusCode == 200) {
            NSDictionary *tracks = 
            [[CJSONDeserializer deserializer] deserializeAsDictionary:request.responseData 
                                                                error:nil];
            [blockSelf assignPlayingTrack:self.nextTrack 
                           fromDictionary:[tracks objectForKey:@"next"]];
            [blockSelf assignPlayingTrack:self.currentTrack 
                           fromDictionary:[tracks objectForKey:@"current"]];
            [blockSelf assignPlayingTrack:self.previousTrack 
                           fromDictionary:[tracks objectForKey:@"previous"]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [blockSelf updateTrackViews];
        });
    }];
    [request setFailedBlock:^ {
        [blockSelf clearPlayingTracks];
        dispatch_async(dispatch_get_main_queue(), ^{
            [blockSelf updateTrackViews];
        });

    }];
    [request startAsynchronous];
    
    if (isActive_) {
        // What should this rate be??
        NSTimeInterval refreshRate = 30.0;
        [NSTimer scheduledTimerWithTimeInterval:refreshRate 
                                         target:self 
                                       selector:@selector(requestCurrentPlayingTracks) 
                                       userInfo:nil 
                                        repeats:NO];
    }
}

- (PPPlayingTrack *)currentTrack {
    if (!currentTrack_) {
        currentTrack_ = [[PPPlayingTrack alloc] init];
    }
    return currentTrack_;
}

- (PPPlayingTrack *)nextTrack {
    if (!nextTrack_) {
        nextTrack_ = [[PPPlayingTrack alloc] init];
    }
    return nextTrack_;
}

- (PPPlayingTrack *)previousTrack {
    if (!previousTrack_) {
        previousTrack_ = [[PPPlayingTrack alloc] init];
    }
    return previousTrack_;
}

#define TRACK_VIEW_SIZE 120

- (PPPlayingTrackView *)previousView {
    if (!previousView_) {
        previousView_ = [[PPPlayingTrackView alloc] initWithFrame:CGRectMake(0, 0, 320, TRACK_VIEW_SIZE)];
        previousView_.title = NSLocalizedString(@"Just played", @"Just played");
        previousView_.arrowSize = 0;
        previousView_.imageMargin = 10;
    }
    return previousView_;
}

- (PPPlayingTrackView *)currentView {
    if (!currentView_) {
        currentView_ = [[PPPlayingTrackView alloc] initWithFrame:CGRectMake(0, 0, 320, TRACK_VIEW_SIZE)];
        currentView_.title = NSLocalizedString(@"Currently grooving", @"Currently grooving");
        currentView_.arrowSize = 8.0f;
        currentView_.imageMargin = 0;
    }
    return currentView_;
}

- (PPPlayingTrackView *)nextView {
    if (!nextView_) {
        nextView_ = [[PPPlayingTrackView alloc] initWithFrame:CGRectMake(0, 0, 320, TRACK_VIEW_SIZE)];
        nextView_.arrowSize = 0.0f;
        nextView_.title = NSLocalizedString(@"Upcoming track", @"Upcoming track");
        nextView_.imageMargin = 10;
    }
    return nextView_;
}

- (PPAlbumCoverManager *)albumCoverManager {
    if (!albumCoverManager_) {
        albumCoverManager_ = [[PPAlbumCoverManager alloc] init];
        albumCoverManager_.bonjourBrowser = self.bonjourBrowser;
    }
    return albumCoverManager_;
}

@end
