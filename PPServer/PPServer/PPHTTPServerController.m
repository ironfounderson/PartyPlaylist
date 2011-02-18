//
//  PPHTTPServerController.m
//  PPServer
//
//  Created by Robert Höglund on 2/13/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import "PPHTTPServerController.h"
#import "HTTPServer.h"
#import "DDLog.h"
#import "PPHTTPConnection.h"
#import "PPTwitterClient.h"
static int ddLogLevel = LOG_LEVEL_INFO;

NSString * const PPBonjourType = @"_spp._tcp";

@implementation PPHTTPServerController

- (id)initWithPlaylist:(PPPlaylist *)playlist {
    self = [super init];
    if (self) {
        [PPHTTPConnection setPlaylist:playlist];
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}


- (void)startServer {
    if (httpServer_) {
        return;
    }
    
    httpServer_ = [[HTTPServer alloc] init];
    // Port for testing
    [httpServer_ setPort:12354];
    
    NSString *documentRoot = [[NSBundle mainBundle] resourcePath];
    [httpServer_ setDocumentRoot:documentRoot];
    DDLogInfo(@"Document root = %@", documentRoot);
    
    [httpServer_ setConnectionClass:[PPHTTPConnection class]];    
    [httpServer_ setType:PPBonjourType];
    [httpServer_ setName:PPTwitterUsername];
    [httpServer_ setTXTRecordDictionary:
     [NSDictionary dictionaryWithObjectsAndKeys:
      @"UNIQUE-SERVER-NAME", @"UUID", 
      PPTwitterUsername, @"TWITTERUSER", nil]];
                                             
    NSError *error;
	BOOL success = [httpServer_ start:&error];
    if (!success) {
        DDLogError(@"Could not start HTTP server. Got error: %@", error);
    }
}

#pragma mark - Dynamic Logging

+ (int)ddLogLevel {
    return ddLogLevel;
}

+ (void)ddSetLogLevel:(int)logLevel {
    ddLogLevel = logLevel;
}

@end
