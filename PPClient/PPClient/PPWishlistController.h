//
//  PPWishController.h
//  PPClient
//
//  Created by Robert Höglund on 2/10/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
@class PPWishlistModel;

@interface PPWishlistController : UIViewController <NSFetchedResultsControllerDelegate> {
}

@property (nonatomic, retain) IBOutlet PPWishlistModel *wishlist;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@end
