//
//  PPWishlistModel.m
//  PPClient
//
//  Created by Robert Höglund on 2/11/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import "PPWishlistModel.h"
#import "PPTrack.h"
#import "PPCoreDataStack.h"
#import "Track.h"

NSString * const PPWishlistTrackAddedNotification = @"PPWishlistTrackAddedNotification";
NSString * const PPWishlistTrackRemovedNotification = @"PPWishlistTrackRemovedNotification";
NSString * const PPWishlistTrackKeyName = @"track";

@interface PPWishlistModel() 
- (Track *)findTrack:(PPTrack *)track;
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

- (BOOL)isFavoriteTrack:(PPTrack *)track {
    Track *cdTrack = [self findTrack:track];
    return cdTrack ? cdTrack.favoriteValue : NO;
}

- (void)toggleFavoriteTrack:(PPTrack *)track {
    Track *cdTrack = [self findTrack:track];
    if (cdTrack) {
        cdTrack.favoriteValue = !cdTrack.favoriteValue;
    }
    else {
        cdTrack = [Track insertInManagedObjectContext:self.coreDataStack.managedObjectContext];
        cdTrack.favoriteValue = YES;
        cdTrack.link = track.link;
        cdTrack.title = track.title;
        cdTrack.albumName = track.albumName;
        cdTrack.artistName = track.artistName;
    }
    [self.coreDataStack saveContext];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:track 
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

- (Track *)findTrack:(PPTrack *)track {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[Track entityInManagedObjectContext:self.coreDataStack.managedObjectContext]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"link == %@", track.link];
    [fetchRequest setPredicate:predicate];
    
    NSArray *results = [self.coreDataStack.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    [fetchRequest release];
    return results.count > 0 ? [results objectAtIndex:0] : nil;
}

@end
