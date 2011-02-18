//
//  PPClientAppDelegate.m
//  PPClient
//
//  Created by Robert Höglund on 2/10/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import "PPClientAppDelegate.h"
#import "PPSearchController.h"
#import "PPAppController.h"


@implementation PPClientAppDelegate


@synthesize window=window_;
@synthesize tabBarController=tabBarController_;
@synthesize searchController = searchController_;
@synthesize wishlistController = wishlistController_;
@synthesize appController = appController_;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    freshStart_ = YES;
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [self.appController stopController];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    NSLog(@"%s", __FUNCTION__);
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
    NSLog(@"%s", __FUNCTION__);
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self.appController startController:freshStart_];
    freshStart_ = NO;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    NSLog(@"%s", __FUNCTION__);
}

- (void)dealloc {
    [window_ release];
    [tabBarController_ release];
    [wishlistController_ release];
    [searchController_ release];
    [appController_ release];
    [super dealloc];
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
