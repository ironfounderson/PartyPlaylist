//
//  PPDomainBrowser.m
//  PPClient
//
//  Created by Robert Höglund on 2/16/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import "PPBonjourBrowser.h"

#define kWebServiceType @"_spp._tcp"
#define kInitialDomain  @"local"

@interface PPBonjourBrowser() 
@property (nonatomic, retain) NSNetServiceBrowser *netServiceBrowser;
@end

@implementation PPBonjourBrowser

@synthesize netServiceBrowser = netServiceBrowser_;

- (void)start {
    
}

- (void)stop {
    
}

@end
