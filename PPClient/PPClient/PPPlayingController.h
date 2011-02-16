//
//  PPPlayingController.h
//  PPClient
//
//  Created by Robert Höglund on 2/10/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PPPlayingController : UIViewController {
    NSNetServiceBrowser *netServiceBrowser_;
}

@property (nonatomic, retain) IBOutlet UIView *noServerView;


@end
