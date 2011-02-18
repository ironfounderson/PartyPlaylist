//
//  PPWishlistModel.h
//  PPClient
//
//  Created by Robert Höglund on 2/11/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PPSpotifyTrack;
@class PPCoreDataStack;
@class NSManagedObjectContext;
@class NSFetchRequest;

extern NSString * const PPWishlistTrackAddedNotification;
extern NSString * const PPWishlistTrackRemovedNotification;
extern NSString * const PPWishlistTrackKeyName;

@interface PPWishlistModel : NSObject {
}

@property (nonatomic, retain) PPCoreDataStack *coreDataStack;
@property (nonatomic, readonly) NSManagedObjectContext *moc;
- (BOOL)isFavoriteTrack:(PPSpotifyTrack *)track;

- (void)toggleFavoriteTrack:(PPSpotifyTrack *)track;
- (NSFetchRequest *)favoritesFetchRequest;

@end
