//
//  PPChoosePlaylistController.h
//  PPClient
//
//  Created by Robert Höglund on 2/16/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PPChoosePlaylistResponse)(NSNetService *resolvedService);

@class PPBonjourBrowser;

@interface PPChoosePlaylistController : UIViewController <NSNetServiceDelegate> {
}

@property (nonatomic, copy) PPChoosePlaylistResponse selectServiceBlock;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSArray *services;
@property (nonatomic, assign) PPBonjourBrowser *bonjourBrowser;
- (IBAction)handleCancel:(id)sender;

@end
