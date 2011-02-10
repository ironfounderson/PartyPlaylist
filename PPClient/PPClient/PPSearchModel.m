//
//  PPSearchModel.m
//  PPClient
//
//  Created by Robert Höglund on 2/10/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import "PPSearchModel.h"


@implementation PPSearchModel

@synthesize delegate;

- (void)searchTrack:(NSString *)query {
    NSLog(@"Should search for: %@", query);
}

@end
