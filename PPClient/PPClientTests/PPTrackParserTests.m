//
//  PPTrackParserTests.m
//  PPClient
//
//  Created by Robert Höglund on 2/10/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "PPTrackParser.h"
#import "PPTrack.h"

@interface PPTrackParserTests : SenTestCase {
    
}

@end


@implementation PPTrackParserTests

- (NSData *)dataFromFile:(NSString *)filename {
    NSString *path = [[NSBundle bundleForClass:[self class]] 
                      pathForResource:filename 
                      ofType:@"json"];
    return [NSData dataWithContentsOfFile:path];
}

- (void)testParseData_TestFile_FindsAllTracks {
    PPTrackParser *trackParser =[[PPTrackParser alloc] init];
    NSArray *tracks = [trackParser parseData:[self dataFromFile:@"track_backstreet"]];
    STAssertEquals((NSUInteger)100, tracks.count, nil);
}
@end
