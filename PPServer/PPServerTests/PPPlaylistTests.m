//
//  PPPlaylistTests.m
//  PPServer
//
//  Created by Robert Höglund on 2/12/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "PPPlaylist.h"
#import "PPPlaylistUser.h"
#import "PPPlaylistTrack.h"
#import "PPSpotifyTrack.h"

@interface PPPlaylistTests : SenTestCase {
@private
    PPPlaylist *playlist;
}

- (PPPlaylistUser *)sampleUserWithId:(NSString *)userId;

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

- (void)test_addTrackFromLink_notLoadedTrackIsNotAvailable {
    NSString *link = @"spotify:track:randomlinktestdude";
    [playlist addTrackFromLink:link byUser:[self sampleUserWithId:@"userid"]];
    NSArray *tracks = [playlist availableTracks];
    STAssertEquals((NSUInteger)0, tracks.count, nil);
}     

- (void)test_addTrackFromLink_loadedTrackIsAvailable {
    NSString *link = @"spotify:track:randomlinktestdude";
    PPPlaylistTrack *track = [playlist addTrackFromLink:link byUser:[self sampleUserWithId:@"userid"]];
    // When runing the program the only place this should be set is from within PPSpotifyController
    track.spotifyTrack.loaded = YES;
    NSArray *tracks = [playlist availableTracks];
    STAssertEquals((NSUInteger)1, tracks.count, nil);
}     

- (void)test_step_WithOneAvailableTrack_TrackIsSetToNextTrack {
    // Arrange
    PPPlaylistTrack *track1 = [playlist addTrackFromLink:@"link1" byUser:[self sampleUserWithId:@"user1"]];
    track1.spotifyTrack.loaded = YES;
    // Act
    [playlist step];
    // Assert
    STAssertEqualObjects(track1, playlist.nextTrack, nil);
}

- (void)test_step_WithOneAvailableTrack_TrackIsRemovedFromAvailableTracks {
    // Arrange
    PPPlaylistTrack *track1 = [playlist addTrackFromLink:@"link1" byUser:[self sampleUserWithId:@"user1"]];
    track1.spotifyTrack.loaded = YES;
    // Act
    [playlist step];
    // Assert
    NSArray *tracks = [playlist availableTracks];
    STAssertEquals((NSUInteger)0, tracks.count, nil);
}

- (void)test_step_WithTwoAvailableTracks_NextTrackIsSet {
    // Arrange
    PPPlaylistTrack *track1 = [playlist addTrackFromLink:@"link1" byUser:[self sampleUserWithId:@"user1"]];
    track1.spotifyTrack.loaded = YES;
    PPPlaylistTrack *track2 = [playlist addTrackFromLink:@"link2" byUser:[self sampleUserWithId:@"user1"]];
    track2.spotifyTrack.loaded = YES;
    // Act
    [playlist step];
    [playlist step];
    // Assert
    STAssertEqualObjects(track2, playlist.nextTrack, nil);
}

- (PPPlaylistUser *)sampleUserWithId:(NSString *)userId {
    PPPlaylistUser *user = [[PPPlaylistUser alloc] init];
    user.userId = userId;
    return [user autorelease];
}
@end
