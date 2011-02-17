//
//  PPDomainBrowser.m
//  PPClient
//
//  Created by Robert Höglund on 2/16/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import "PPBonjourBrowser.h"

NSString * const PPBonjourBrowserServicesUpdatedNotification = @"PPBonjourBrowserServicesUpdatedNotification";
NSString * const PPBonjourBrowserPlaylistAvailableNotification = @"PPBonjourBrowserPlaylistAvailableNotification";

#define kWebServiceType @"_spp._tcp"
#define kInitialDomain  @"local"

@interface PPBonjourBrowser() 
@property (nonatomic, retain) NSNetServiceBrowser *netServiceBrowser;
@property (readonly) NSMutableArray *services;
- (BOOL)searchForServicesOfType:(NSString *)type inDomain:(NSString *)domain;
- (void)notifyPlaylistAvailabilityChange;
@end

@implementation PPBonjourBrowser

@synthesize netServiceBrowser = netServiceBrowser_;
@synthesize services = services_;
@synthesize isPlaylistAvailable = playlistAvailable_;

- (id)init {
    self = [super init];
    if (self) {
        services_ = [[NSMutableArray alloc] init];
        playlistAvailable_ = NO;
    }
    return self;
}

- (void)dealloc {
    [services_ release];
    [netServiceBrowser_ release];
    [super dealloc];
}

- (void)start {
    [self searchForServicesOfType:@"_spp._tcp" inDomain:@"local."];
}

- (void)stop {
    [self.netServiceBrowser stop];
}

- (BOOL)searchForServicesOfType:(NSString *)type inDomain:(NSString *)domain {
	
	// [self stopCurrentResolve];
	[self.netServiceBrowser stop];
	[self.services removeAllObjects];
    playlistAvailable_ = NO;
    
	NSNetServiceBrowser *aNetServiceBrowser = [[NSNetServiceBrowser alloc] init];
	if(!aNetServiceBrowser) {
        // The NSNetServiceBrowser couldn't be allocated and initialized.
		return NO;
	}
    
	aNetServiceBrowser.delegate = self;
	self.netServiceBrowser = aNetServiceBrowser;
	[aNetServiceBrowser release];
	[self.netServiceBrowser searchForServicesOfType:type inDomain:domain];
    
	return YES;
}

- (void)netServiceBrowser:(NSNetServiceBrowser*)netServiceBrowser 
         didRemoveService:(NSNetService*)service 
               moreComing:(BOOL)moreComing {
    [self.services removeObject:service];
    if (!moreComing) {
        [self notifyPlaylistAvailabilityChange];
        [[NSNotificationCenter defaultCenter] 
         postNotificationName:PPBonjourBrowserServicesUpdatedNotification object:self];
    }
}	

- (void)netServiceBrowser:(NSNetServiceBrowser*)netServiceBrowser 
           didFindService:(NSNetService*)service 
               moreComing:(BOOL)moreComing {
    [self.services addObject:service];
    if (!moreComing) {
        [self notifyPlaylistAvailabilityChange];
        [[NSNotificationCenter defaultCenter] 
         postNotificationName:PPBonjourBrowserServicesUpdatedNotification object:self];
    }
}	

- (NSArray *)availableServices {
    return [NSArray arrayWithArray:self.services];
}

- (void)setServiceAsSelectedPlaylist:(NSNetService *)service {
    NSString *completeAddress = [NSString stringWithFormat:@"%@:%d", 
                                 service.hostName, service.port];
    self.playlistAddress = completeAddress;
    self.playlistName = service.name;
    [self notifyPlaylistAvailabilityChange];
}

- (void)notifyPlaylistAvailabilityChange {
    BOOL available = NO;
    for (NSNetService *service in self.services) {
        if ([service.name isEqualToString:self.playlistName]) {
            available = YES;
            break;
        }
    }
    
    // TODO: Need to think on how to better handle this notification so it properly handles the case when the
    // app goes into background and back
    playlistAvailable_ = available;
    [[NSNotificationCenter defaultCenter] 
     postNotificationName:PPBonjourBrowserPlaylistAvailableNotification object:self];
}

- (NSString *)playlistName {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"PLAYLIST_NAME"];
}

- (void)setPlaylistName:(NSString *)newServerName {
    [[NSUserDefaults standardUserDefaults] setObject:newServerName forKey:@"PLAYLIST_NAME"];
}

- (NSString *)playlistAddress {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"PLAYLIST_ADDRESS"];
}

- (void)setPlaylistAddress:(NSString *)newServerAddress {
    [[NSUserDefaults standardUserDefaults] setObject:newServerAddress forKey:@"PLAYLIST_ADDRESS"];
}

- (NSString *)playlistTwitterName {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"PLAYLIST_TWITTERNAME"];
}

- (void)setPlaylistTwitterName:(NSString *)newServerAddress {
    [[NSUserDefaults standardUserDefaults] setObject:newServerAddress forKey:@"PLAYLIST_TWITTERNAME"];
}

@end
