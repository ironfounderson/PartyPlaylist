//
//  PPWishlistModel.m
//  PPClient
//
//  Created by Robert Höglund on 2/11/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import "PPWishlistModel.h"
#import "PPTrack.h"

NSString * const PPWishlistTrackAddedNotification = @"PPWishlistTrackAddedNotification";
NSString * const PPWishlistTrackRemovedNotification = @"PPWishlistTrackRemovedNotification";
NSString * const PPWishlistTrackKeyName = @"track";


@interface PPWishlistModel()
@property (nonatomic, readonly) NSMutableArray *favoriteTracks;
- (NSUInteger)indexOfTrack:(PPTrack *)track;
@end

@implementation PPWishlistModel

- (void)dealloc {
    [favoriteTracks_ release];
    [super dealloc];
}

- (BOOL)isFavoriteTrack:(PPTrack *)track {
    return [self indexOfTrack:track] != NSNotFound;    
}

- (void)toggleFavoriteTrack:(PPTrack *)track {
    NSUInteger index = [self indexOfTrack:track];    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:track 
                                                         forKey:PPWishlistTrackKeyName];
    NSString *notificationName;
    if (index == NSNotFound) {
        [self.favoriteTracks addObject:track];
        notificationName = PPWishlistTrackAddedNotification;
    }
    else {
        [self.favoriteTracks removeObjectAtIndex:index];
        notificationName = PPWishlistTrackRemovedNotification;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName 
                                                        object:self 
                                                      userInfo:userInfo];
}

- (NSMutableArray *)favoriteTracks {
    if (!favoriteTracks_) {
        favoriteTracks_ = [[NSMutableArray alloc] init];
    }
    return favoriteTracks_;
}

- (NSUInteger)indexOfTrack:(PPTrack *)track {
    // In the wish list, two tracks are considered equal if they have the same link
    return [self.favoriteTracks indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
        PPTrack *item = (PPTrack *)obj;
        if ([track.link isEqualToString:item.link]) {
            *stop = YES;
            return YES;
        }
        return NO;
    }];
}
@end
