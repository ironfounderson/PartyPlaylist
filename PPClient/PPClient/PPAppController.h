//
//  PPAppController.h
//  PPClient
//
//  Created by Robert Höglund on 2/16/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PPBonjourBrowser;
@class PPPlayingController;
@class PPWishlistController;
@class PPCoreDataStack;
/**
 The main controller
 */
@interface PPAppController : NSObject {
@private
    PPCoreDataStack *coreDataStack_;
}

@property (nonatomic, retain) PPBonjourBrowser *bonjourBrowser;
@property (nonatomic, retain) IBOutlet PPPlayingController *playingController;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
- (void)startController:(BOOL)isFreshStart;
- (void)stopController;

@end
