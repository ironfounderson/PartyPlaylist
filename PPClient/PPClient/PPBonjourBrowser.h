//
//  PPDomainBrowser.h
//  PPClient
//
//  Created by Robert Höglund on 2/16/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const PPBonjourBrowserServicesUpdatedNotification;
extern NSString * const PPBonjourBrowserPlaylistAvailableNotification;

/**
 Keeps track of the available playlist servers. 
 */
@interface PPBonjourBrowser : NSObject <NSNetServiceBrowserDelegate> {
@private
}

@property (nonatomic, assign) NSString *playlistName;
@property (nonatomic, assign) NSString *playlistAddress;
@property (nonatomic, assign) NSString *playlistTwitterName;
@property (readonly) BOOL isPlaylistAvailable;

- (void)start;
- (void)stop;
- (NSArray *)availableServices;
- (void)setServiceAsSelectedPlaylist:(NSNetService *)service;
@end
