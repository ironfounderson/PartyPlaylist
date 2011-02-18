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
#import "PPCoreDataStack.h"
#import "PPWishlistModel.h"

@interface PPAppController()
@property (readonly) PPCoreDataStack *coreDataStack;
@end

@implementation PPAppController

@synthesize bonjourBrowser = bonjourBrowser_;
@synthesize playingController = playingController_;
@synthesize tabBarController = tabBarController_;
@synthesize wishlist = wishlist_;

- (void)dealloc {
    [bonjourBrowser_ release];
    [playingController_ release];
    [tabBarController_ release];
    [wishlist_ release];
    [super dealloc];
}

- (void)startController:(BOOL)isFreshStart {
    self.wishlist.coreDataStack = self.coreDataStack;
    self.playingController.bonjourBrowser = self.bonjourBrowser;
    [self.bonjourBrowser start];
    // We need to update the playing UI when the program resumes. 
    if (!isFreshStart && self.tabBarController.selectedViewController == self.playingController) {
        [self.playingController refreshView];
    }
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

- (PPCoreDataStack *)coreDataStack {
    if (!coreDataStack_) {
        coreDataStack_ = [[PPCoreDataStack alloc] init];
    }
    return coreDataStack_;
}
@end
