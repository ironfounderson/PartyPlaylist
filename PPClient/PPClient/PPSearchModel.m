//
//  PPSearchModel.m
//  PPClient
//
//  Created by Robert Höglund on 2/10/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import "PPSearchModel.h"
#import "ASIHTTPRequest.h"
#import "PPSearchURL.h"

@interface PPSearchModel()
@property (nonatomic, retain) ASIHTTPRequest *request;
- (void)cancelRequest;
@end

@implementation PPSearchModel

@synthesize delegate;
@synthesize request = request_;

- (void)dealloc {
    [request_ release];
    [super dealloc];
}

- (void)searchTrack:(NSString *)query {
    PPSearchURL *searchURL = [PPSearchURL trackURLWithQuery:query];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:searchURL.URL];
    [request setDelegate:self];
    self.request = request;
    
    [request startAsynchronous];    
}

- (void)cancelRequest {
    if (request_) {
        [request_ clearDelegatesAndCancel];
    }
    self.request = nil;
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    NSData *response = [request responseData];
    [self.delegate searchModel:self 
              receivedResponse:response
                    withStatus:request.responseStatusCode];
    self.request = nil;
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    self.request = nil;
}

@end
