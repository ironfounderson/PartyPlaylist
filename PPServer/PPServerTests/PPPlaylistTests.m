//
//  PPPlaylistTests.m
//  PPServer
//
//  Created by Robert Höglund on 2/11/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "PPPlaylist.h"
#import "PPPlaylistItem.h"

@interface PPPlaylistTests : SenTestCase {
@private
    PPPlaylist *playlist;
}

@end


@implementation PPPlaylistTests

- (void)setUp {
    [super setUp];
    playlist = [[PPPlaylist alloc] init];
}

- (void)tearDown {
    [playlist release];
    [super tearDown];
}

- (void)testAddTrack_NewTrack_TrackInListWithWishCountOne {
    // Arrange
    SPPTrack *track = [self createTestTrack];
    // Act
    [playlist addTrack:track forUser:@"user1"];
    // Assert
    SPPPlaylistItem *item = [playlist itemAtIndex:0];
    STAssertEquals((NSInteger)1, item.wishCount, nil);
}

- (void)testAddTrack_NewTrack_ItemIncludesUser {
    // Arrange
    SPPTrack *track = [self createTestTrack];
    // Act
    [playlist addTrack:track forUser:@"user1"];
    // Assert
    SPPPlaylistItem *item = [playlist itemAtIndex:0];
    STAssertTrue([item containsUser:@"user1"], nil);
}

- (void)testAddTrack_PresentTrack_NewUserShouldIncreaseWishcount {
    // Arrange
    SPPTrack *track = [self createTestTrack];
    [playlist addTrack:track forUser:@"user1"];
    // Act
    [playlist addTrack:track forUser:@"user2"];
    // Assert
    SPPPlaylistItem *item = [playlist itemAtIndex:0];
    STAssertEquals((NSInteger)2, item.wishCount, nil);
}

- (void)testRemoveTrack_TrackHasBeenAddedByUser_TrackIsRemoved {
    // Arrange
    SPPTrack *track = [self createTestTrack];
    [playlist addTrack:track forUser:@"user1"];
    // Act
    [playlist removeTrack:track forUser:@"user1"];
    // Assert
    STAssertEquals((NSUInteger)0, playlist.itemCount, nil);
}

- (void)testRemoveTrack_TrackHasNotBeenAddedByUser_TrackIsNotRemoved {
    // Arrange
    SPPTrack *track = [self createTestTrack];
    [playlist addTrack:track forUser:@"user1"];
    // Act
    [playlist removeTrack:track forUser:@"user2"];
    // Assert
    STAssertEquals((NSUInteger)1, playlist.itemCount, nil);
}

- (void)testRemoveTrack_TrackAddedByTwoUsers_WishCountIsDecreased {
    // Arrange
    SPPTrack *track = [self createTestTrack];
    [playlist addTrack:track forUser:@"user1"];
    [playlist addTrack:track forUser:@"user2"];
    // Act
    [playlist removeTrack:track forUser:@"user2"];
    // Assert
    SPPPlaylistItem *item = [playlist itemAtIndex:0];
    STAssertEquals((NSInteger)1, item.wishCount, nil);
}

- (void)testStep_ListHasOneItem_ShouldSetCurrentItem {
    // Arrange
    [playlist addTrack:[self createTestTrack] forUser:@"user1"];
    // Act
    [playlist step];
    // Assert
    STAssertNotNil(playlist.currentItem, nil);
}

- (void)testStep_ListHasTwoItems_ShouldSetCurrentItemAndNextItem {
    // Arrange
    [playlist addTrack:[self createTestTrackWithLink:@"link1"] 
               forUser:@"user1"];
    [playlist addTrack:[self createTestTrackWithLink:@"link2"] 
               forUser:@"user1"];
    
    // Act
    [playlist step];
    // Assert
    STAssertNotNil(playlist.currentItem, nil);
    STAssertNotNil(playlist.nextItem, nil);
}

- (void)testStep_ListHasOneItem_DoubleStepSetsPreviousItem {
    // Arrange
    [playlist addTrack:[self createTestTrack] forUser:@"user1"];
    // Act
    [playlist step];
    [playlist step];
    // Assert
    STAssertNotNil(playlist.previousItem, nil);
    STAssertNil(playlist.currentItem, nil);
}

- (void)testStep_UpdatesPlayCountWhenSettingCurrentItem {
    // Arrange
    [playlist addTrack:[self createTestTrack] forUser:@"user1"];
    // Act
    [playlist step];
    // Assert
    STAssertEquals((NSUInteger)1, playlist.currentItem.playCount, nil);
}


- (SPPTrack *)createTestTrack {
    return [self createTestTrackWithLink:@"spotify:link:1234567890"];
}

- (SPPTrack *)createTestTrackWithLink:(NSString *)link {
    NSDictionary *trackDict = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"I want it that way", SPPTrackName, 
                               @"Backstreet Boys", SPPTrackArtistName, 
                               link, SPPTrackLinkText, nil];
    return [SPPTrack trackWithDictionary:trackDict];    
}

@end
