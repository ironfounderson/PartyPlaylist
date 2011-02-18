//
//  PPWishlistModel.m
//  PPClient
//
//  Created by Robert Höglund on 2/11/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import "PPWishlistModel.h"
#import "PPSpotifyTrack.h"
#import "PPCoreDataStack.h"
#import "Track.h"

NSString * const PPWishlistTrackAddedNotification = @"PPWishlistTrackAddedNotification";
NSString * const PPWishlistTrackRemovedNotification = @"PPWishlistTrackRemovedNotification";
NSString * const PPWishlistTrackKeyName = @"track";

@interface PPWishlistModel() 
- (Track *)findTrack:(PPSpotifyTrack *)spotifyTrack;
@end

@implementation PPWishlistModel

@synthesize coreDataStack = coreDataStack_;

- (void)dealloc {
    [coreDataStack_ release];
    [super dealloc];
}

- (NSManagedObjectContext *)moc {
    return self.coreDataStack.managedObjectContext;
}

- (BOOL)isFavoriteTrack:(PPSpotifyTrack *)spotifyTrack {
    Track *track = [self findTrack:spotifyTrack];
    return track ? track.favoriteValue : NO;
}

- (void)toggleFavoriteTrack:(PPSpotifyTrack *)spotifyTrack {
    Track *cdTrack = [self findTrack:spotifyTrack];
    if (cdTrack) {
        cdTrack.favoriteValue = !cdTrack.favoriteValue;
    }
    else {
        cdTrack = [Track insertInManagedObjectContext:self.coreDataStack.managedObjectContext];
        cdTrack.favoriteValue = YES;
        cdTrack.link = spotifyTrack.link;
        cdTrack.title = spotifyTrack.title;
        cdTrack.albumName = spotifyTrack.albumName;
        cdTrack.artistName = spotifyTrack.artistName;
    }
    [self.coreDataStack saveContext];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:spotifyTrack 
                                                         forKey:PPWishlistTrackKeyName];
    NSString *notificationName;
    if (cdTrack.favoriteValue) {
        notificationName = PPWishlistTrackAddedNotification;
    }
    else {
        notificationName = PPWishlistTrackRemovedNotification;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName 
                                                        object:self 
                                                      userInfo:userInfo];
}

- (NSFetchRequest *)favoritesFetchRequest {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[Track entityInManagedObjectContext:self.coreDataStack.managedObjectContext]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"favorite == YES"];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];

    return [fetchRequest autorelease];
}

- (Track *)findTrack:(PPSpotifyTrack *)spotifyTrack {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[Track entityInManagedObjectContext:self.coreDataStack.managedObjectContext]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"link == %@", spotifyTrack.link];
    [fetchRequest setPredicate:predicate];
    
    NSArray *results = [self.coreDataStack.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    [fetchRequest release];
    return results.count > 0 ? [results objectAtIndex:0] : nil;
}

@end
