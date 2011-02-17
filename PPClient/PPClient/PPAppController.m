//
//  PPAppController.m
//  PPClient
//
//  Created by Robert Höglund on 2/16/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import "PPAppController.h"
#import "PPPlayingController.h"
#import "PPBonjourBrowser.h"

@implementation PPAppController

@synthesize bonjourBrowser = bonjourBrowser_;
@synthesize playingController = playingController_;

- (void)dealloc {
    [bonjourBrowser_ release];
    [playingController_ release];
    [super dealloc];
}

- (void)startController:(BOOL)isFreshStart {
    self.playingController.bonjourBrowser = self.bonjourBrowser;
    [self.bonjourBrowser start];
}

- (void)stopController {
    [self.bonjourBrowser stop];
}

- (void)tabBarController:(UITabBarController *)tabBarController 
 didSelectViewController:(UIViewController *)viewController {
    NSLog(@"%@", viewController);
}

- (PPBonjourBrowser *)bonjourBrowser {
    if (!bonjourBrowser_) {
        bonjourBrowser_ = [[PPBonjourBrowser alloc] init];
    }
    return bonjourBrowser_;
}
@end
