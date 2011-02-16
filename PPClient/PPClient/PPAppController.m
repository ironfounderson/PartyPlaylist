//
//  PPAppController.m
//  PPClient
//
//  Created by Robert Höglund on 2/16/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import "PPAppController.h"


@implementation PPAppController

@synthesize bonjourBrowser = bonjourBrowser_;

- (void)dealloc {
    [bonjourBrowser_ release];
    [super dealloc];
}

- (void)startController:(BOOL)isFreshStart {
    
}

- (void)stopController {
    
}

- (void)tabBarController:(UITabBarController *)tabBarController 
 didSelectViewController:(UIViewController *)viewController {
    NSLog(@"%@", viewController);
}

@end
