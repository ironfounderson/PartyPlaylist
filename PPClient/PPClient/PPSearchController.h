//
//  PPSearchController.h
//  PPClient
//
//  Created by Robert Höglund on 2/10/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPSearchModel.h"

@class PPWishlistModel;

@interface PPSearchController : UIViewController <PPSearchModelDelegate> {
@private
    dispatch_queue_t parseQueue_;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) PPSearchModel *searchModel;
@property (nonatomic, retain) IBOutlet PPWishlistModel *wishlist;

@end
