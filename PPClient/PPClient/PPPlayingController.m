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

#define PREVIOUS_SECTION 0
#define CURRENT_SECTION 1
#define NEXT_SECTION 2

@interface PPPlayingController()
@property (getter=isConnected) BOOL connected;
@property (nonatomic, readonly) PPPlaylistRequest *playlistRequest;
@property (retain) PPSpotifyTrack *previousTrack;
@property (retain) PPSpotifyTrack *currentTrack;
@property (retain) PPSpotifyTrack *nextTrack;
- (void)requestCurrentPlayingTracks;
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
@synthesize tableView = tableView_;

- (void)dealloc {
    [connectingView_ release];
    [playlistRequest_ release];
    [previousTrack_ release];
    [currentTrack_ release];
    [nextTrack_ release];
    [tableView_ release];
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

#pragma mark - Table View

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    PPSpotifyTrack *track = nil;
    switch (indexPath.section) {
        case PREVIOUS_SECTION:
            track = self.previousTrack;
            break;
        case CURRENT_SECTION:
            track = self.currentTrack;
            break;
        case NEXT_SECTION:
            track = self.nextTrack;
            break;
    }
    
    cell.textLabel.text = track.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", track.artistName, track.albumName];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case PREVIOUS_SECTION:
            return NSLocalizedString(@"Previous", @"");
        case CURRENT_SECTION:
            return NSLocalizedString(@"Current", @"");
        case NEXT_SECTION:
            return NSLocalizedString(@"Next", @"");

    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == CURRENT_SECTION) {
        return 88.0;
    }
    return tableView.rowHeight;
}

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TrackCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
                                       reuseIdentifier:CellIdentifier] autorelease];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)clearPlayingTracks {
    self.currentTrack = nil;
    self.previousTrack = nil;
    self.nextTrack = nil;  
}

- (void)requestCurrentPlayingTracks {
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
            NSDictionary *nextTrack = [tracks objectForKey:@"next"];
            if (nextTrack) {
                self.nextTrack = [[[PPSpotifyTrack alloc] initWithDictionary:nextTrack] autorelease];
            }
            NSDictionary *currentTrack = [tracks objectForKey:@"current"];
            if (nextTrack) {
                self.currentTrack = [[[PPSpotifyTrack alloc] initWithDictionary:currentTrack] autorelease];
            }
            NSDictionary *previousTrack = [tracks objectForKey:@"previous"];
            if (nextTrack) {
                self.previousTrack = [[[PPSpotifyTrack alloc] initWithDictionary:previousTrack] autorelease];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [blockSelf.tableView reloadData];
        });
    }];
    [request setFailedBlock:^ {
        [blockSelf clearPlayingTracks];
        dispatch_async(dispatch_get_main_queue(), ^{
            [blockSelf.tableView reloadData];
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


@end
