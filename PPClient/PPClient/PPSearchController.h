//
//  PPSearchController.h
//  PPClient
//
//  Created by Robert Höglund on 2/10/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPSearchModel.h"

@interface PPSearchController : UIViewController <PPSearchModelDelegate> {
    
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) PPSearchModel *searchModel;

@end
