//
//  PPPlaylistTests.m
//  PPServer
//
//  Created by Robert Höglund on 2/11/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "PPPlaylist.h"
#import "PPPlaylistTrack.h"

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


@end
