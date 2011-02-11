//
//  PPClientAppDelegate.h
//  PPClient
//
//  Created by Robert Höglund on 2/10/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PPWishlistModel;
@class PPSearchController;
@class PPWishlistController;

@interface PPClientAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@property (nonatomic, retain) IBOutlet PPWishlistModel *wishlist;

@property (nonatomic, retain) IBOutlet PPSearchController *searchController;

@property (nonatomic, retain) IBOutlet PPWishlistController *wishlistController;

@end
