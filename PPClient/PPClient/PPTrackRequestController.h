//
//  PPTrackRequestController.h
//  PPClient
//
//  Created by Robert Höglund on 2/17/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PPTrack;

typedef void(^PPTrackRequestResponse)(NSString *url);

@interface PPTrackRequestController : UIViewController {
    
}

@property (nonatomic, retain) IBOutlet UILabel *artistLabel;
@property (nonatomic, retain) IBOutlet UILabel *trackLabel;
@property (nonatomic, retain) IBOutlet UILabel *albumLabel;

@property (nonatomic, retain) PPTrack *track;
@property (nonatomic, copy) PPTrackRequestResponse requestBlock;

- (IBAction)requestWithTwitterrific:(id)sender;
- (IBAction)requestWithTwitter:(id)sender;
- (IBAction)cancel:(id)sender;

@end
