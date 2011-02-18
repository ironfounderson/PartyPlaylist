//
//  PPPlayingController.h
//  PPClient
//
//  Created by Robert Höglund on 2/10/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPPlaylistRequest.h"

@class PPBonjourBrowser;

@interface PPPlayingController : UIViewController <PPPlaylistRequestDelegate> {
@private
    BOOL isActive_;
}

@property (nonatomic, retain) IBOutlet UILabel *connectingMessage;
@property (nonatomic, retain) IBOutlet UIView *connectingView;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, assign) PPBonjourBrowser *bonjourBrowser;

- (void)refreshView;
- (void)stop;

- (IBAction)handleChoosePlaylist:(id)sender;

@end
