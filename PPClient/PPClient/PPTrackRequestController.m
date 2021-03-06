//
//  PPTrackRequestController.m
//  PPClient
//
//  Created by Robert Höglund on 2/17/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import "PPTrackRequestController.h"
#import "PPSpotifyTrack.h"
#import "PPWishlistModel.h"

@interface PPTrackRequestController()
- (void)updateFavoriteImage;
@end
@implementation PPTrackRequestController

@synthesize artistLabel;
@synthesize trackLabel;
@synthesize albumLabel;
@synthesize favoriteImage;

@synthesize spotifyTrack = spotifyTrack_;
@synthesize requestBlock;
@synthesize wishlist;

- (void)dealloc {
    [spotifyTrack_ release];
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
    UITapGestureRecognizer *tap = 
    [[UITapGestureRecognizer alloc] initWithTarget:self 
                                            action:@selector(toggleFavoriteTrack)];
    [self.favoriteImage addGestureRecognizer:tap];
    [tap release];
    
}

- (void)viewDidUnload {
    [self setArtistLabel:nil];
    [self setTrackLabel:nil];
    [self setAlbumLabel:nil];
    [self setFavoriteImage:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.artistLabel.text = self.spotifyTrack.artistName;
    self.trackLabel.text = self.spotifyTrack.title;
    self.albumLabel.text = self.spotifyTrack.albumName;
    [self updateFavoriteImage];
}

- (NSString *)message {
    return [[NSString stringWithFormat:@"@janesplaylist add %@", self.spotifyTrack.link]
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
- (void)toggleFavoriteTrack {
    NSLog(@"should toggle");
    [self.wishlist toggleFavoriteTrack:self.spotifyTrack];
    [self updateFavoriteImage];
}

- (void)updateFavoriteImage {
    if ([self.wishlist isFavoriteTrack:self.spotifyTrack]) {
        self.favoriteImage.image = [UIImage imageNamed:@"star-selected.png"];
    }
    else {
        self.favoriteImage.image = [UIImage imageNamed:@"star-unselected.png"];
    }
   
}
@end
