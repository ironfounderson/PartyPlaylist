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

/**
 The main controller
 */
@interface PPAppController : NSObject {
}

@property (nonatomic, retain) PPBonjourBrowser *bonjourBrowser;
@property (nonatomic, retain) IBOutlet PPPlayingController *playingController;

- (void)startController:(BOOL)isFreshStart;
- (void)stopController;

@end
