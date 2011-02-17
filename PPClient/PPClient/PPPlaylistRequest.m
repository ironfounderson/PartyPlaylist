//
//  PPServerRequest.m
//  PPClient
//
//  Created by Robert Höglund on 2/17/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import "PPPlaylistRequest.h"
#import "ASIHTTPRequest.h"

@interface PPPlaylistRequest()
@property (nonatomic, retain) ASIHTTPRequest *request;
- (void)cancelRequest;
@end

@implementation PPPlaylistRequest

@synthesize delegate;
@synthesize request = request_;

- (void)dealloc {
    [request_ release];
    [super dealloc];
}

- (void)cancelRequest {
    if (self.request) {
        [self.request clearDelegatesAndCancel];
    }
    self.request = nil;
}

- (void)twitterNameAtHost:(NSString *)hostAddress {
    [self cancelRequest];
    
    NSString *urlString = [NSString stringWithFormat:@"http://%@", hostAddress];
    NSLog(@"Did request %@", hostAddress);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setDelegate:self];
    self.request = request;
    
    [request startAsynchronous];  
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    // NSData *response = [request responseData];
    self.request = nil;
    NSLog(@"request succeded");
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    NSError *error = [request error];
    self.request = nil;
    NSLog(@"Request failed with error %@", error); 
}
@end
