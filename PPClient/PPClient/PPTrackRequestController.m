//
//  PPTrackRequestController.m
//  PPClient
//
//  Created by Robert Höglund on 2/17/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import "PPTrackRequestController.h"
#import "PPTrack.h"

@implementation PPTrackRequestController

@synthesize artistLabel;
@synthesize trackLabel;
@synthesize albumLabel;

@synthesize track = track_;
@synthesize requestBlock;

- (void)dealloc {
    [track_ release];
    [artistLabel release];
    [trackLabel release];
    [albumLabel release];
    [requestBlock release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [self setArtistLabel:nil];
    [self setTrackLabel:nil];
    [self setAlbumLabel:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.artistLabel.text = self.track.artistName;
    self.trackLabel.text = self.track.title;
    self.albumLabel.text = self.track.albumName;
}

- (NSString *)message {
    return [[NSString stringWithFormat:@"@janesplaylist add %@", self.track.link]
            stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (IBAction)requestWithTwitterrific:(id)sender {
    if (self.requestBlock) {
        NSString *url = [NSString stringWithFormat:@"twitterrific://current/post?message=%@", [self message]];
        self.requestBlock(url);
    }
}

- (IBAction)requestWithTwitter:(id)sender {
    if (self.requestBlock) {
        NSString *url = [NSString stringWithFormat:@"tweetie:///post?message=%@", [self message]];
        self.requestBlock(url);

    }
}

- (IBAction)cancel:(id)sender {
    if (self.requestBlock) {
        self.requestBlock(nil);
    }
}
@end
