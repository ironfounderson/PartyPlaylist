//
//  PPPlaylistTrackTests.m
//  PPServer
//
//  Created by Robert Höglund on 2/13/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "PPPlaylistTrack.h"
#import "PPSpotifyTrack.h"
#import "PPPlaylistUser.h"

@interface PPPlaylistTrackTests : SenTestCase {
@private
    
}

- (PPSpotifyTrack *)sampleSpotifyTrack;
- (PPPlaylistUser *)sampleUserWithId:(NSString *)userId;

@end


@implementation PPPlaylistTrackTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)test_addUser_shouldUpdateWishCount {
    PPPlaylistTrack *plTrack = [PPPlaylistTrack playlistTrackWithSpotifyTrack:[self sampleSpotifyTrack]];
    [plTrack addUser:[self sampleUserWithId:@"userid"]];
    STAssertEquals((NSUInteger)1, plTrack.wishCount, @"wishCount should be updated when adding a user");
}

- (void)test_addUser_addingSameUserTwiceShouldNotUpdateWishCountTwice {
    PPPlaylistTrack *plTrack = [PPPlaylistTrack playlistTrackWithSpotifyTrack:[self sampleSpotifyTrack]];
    [plTrack addUser:[self sampleUserWithId:@"userid"]];
    [plTrack addUser:[self sampleUserWithId:@"userid"]];
    STAssertEquals((NSUInteger)1, plTrack.wishCount, nil);
}

- (void)test_addUser_addingTwoUsersShouldUpdateWishCount {
    PPPlaylistTrack *plTrack = [PPPlaylistTrack playlistTrackWithSpotifyTrack:[self sampleSpotifyTrack]];
    [plTrack addUser:[self sampleUserWithId:@"userid_1"]];
    [plTrack addUser:[self sampleUserWithId:@"userid_2"]];
    STAssertEquals((NSUInteger)2, plTrack.wishCount, nil);
}

- (void)test_valueForIdentifier_artistName {
    // Arrange
    PPSpotifyTrack *track = [self sampleSpotifyTrack];
    track.artistName = @"The artist";
    PPPlaylistTrack *plTrack = [PPPlaylistTrack playlistTrackWithSpotifyTrack:track];
    // Act
    NSString *artistName = [plTrack valueForIdentifier:PPPlaylistTrackArtistNameIdentifier];
    // Assert
    STAssertEqualObjects(@"The artist", artistName, nil);
    
}

- (void)test_valueForIdentifier_title {
    // Arrange
    PPSpotifyTrack *track = [self sampleSpotifyTrack];
    track.title = @"The title";
    PPPlaylistTrack *plTrack = [PPPlaylistTrack playlistTrackWithSpotifyTrack:track];
    // Act
    NSString *title = [plTrack valueForIdentifier:PPPlaylistTrackTitleIdentifier];
    // Assert
    STAssertEqualObjects(@"The title", title, nil);
    
}

- (void)test_valueForIdentifier_wishCount {
    // Arrange
    PPSpotifyTrack *track = [self sampleSpotifyTrack];
    PPPlaylistTrack *plTrack = [PPPlaylistTrack playlistTrackWithSpotifyTrack:track];
    [plTrack addUser:[self sampleUserWithId:@"userid"]];
    // Act
    NSNumber *wishCount = [plTrack valueForIdentifier:PPPlaylistTrackWishCountIdentifier];
    // Assert
    STAssertEquals(1, [wishCount intValue], nil);
    
}

#pragma mark - Helper methods

- (PPSpotifyTrack *)sampleSpotifyTrack {
    PPSpotifyTrack *track = [[PPSpotifyTrack alloc] init];
    return [track autorelease];
}

- (PPPlaylistUser *)sampleUserWithId:(NSString *)userId {
    PPPlaylistUser *user = [[PPPlaylistUser alloc] init];
    user.userId = userId;
    return [user autorelease];
}

@end
