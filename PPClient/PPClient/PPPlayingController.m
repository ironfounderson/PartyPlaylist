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

@interface PPPlayingController()
@property (getter=isConnected) BOOL connected;
@property (nonatomic, readonly) PPPlaylistRequest *playlistRequest;
@end

@implementation PPPlayingController
@synthesize connectingMessage;
@synthesize connectingView = connectingView_;
@synthesize bonjourBrowser;
@synthesize connected;
@synthesize playlistRequest = playlistRequest_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [connectingView_ release];
    [playlistRequest_ release];
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

@end
