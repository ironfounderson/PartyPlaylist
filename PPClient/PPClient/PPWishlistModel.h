//
//  PPWishlistModel.h
//  PPClient
//
//  Created by Robert Höglund on 2/11/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PPTrack;

extern NSString * const PPWishlistTrackAddedNotification;
extern NSString * const PPWishlistTrackRemovedNotification;
extern NSString * const PPWishlistTrackKeyName;

@interface PPWishlistModel : NSObject {
    NSMutableArray *favoriteTracks_;
}

- (BOOL)isFavoriteTrack:(PPTrack *)track;

- (void)toggleFavoriteTrack:(PPTrack *)track;

@end
