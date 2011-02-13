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

- (void)test_addTrackFromLink {
    NSString *link = @"link it baby";
    [playlist addTrackFromLink:link byUser:[self sampleUserWithId:@"userid"]];
}

- (PPPlaylistUser *)sampleUserWithId:(NSString *)userId {
    PPPlaylistUser *user = [[PPPlaylistUser alloc] init];
    user.userId = userId;
    return [user autorelease];
}
@end
