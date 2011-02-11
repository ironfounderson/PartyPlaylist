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
    NSArray *tracks;
}

@end


@implementation PPTrackParserTests

- (NSData *)dataFromFile:(NSString *)filename {
    NSString *path = [[NSBundle bundleForClass:[self class]] 
                      pathForResource:filename 
                      ofType:@"json"];
    return [NSData dataWithContentsOfFile:path];
}

- (void)setUp {
    [super setUp];
    PPTrackParser *trackParser =[[PPTrackParser alloc] init];
    tracks = [trackParser parseData:[self dataFromFile:@"track_backstreet"]];
    [tracks retain];
}

- (void)tearDown {
    [tracks release];
}

- (void)testParseData_TestFile_FindsAllTracks {
    STAssertEquals((NSUInteger)100, tracks.count, nil);
}

- (void)testParseData_TestFile_TrackTitleIsFound {
    PPTrack *track = [tracks objectAtIndex:0];
    STAssertEqualObjects(@"Everybody (Backstreet's Back) - Radio Edit", track.title, @"title should be found");
}

- (void)testParseData_TestFile_TrackLinkIsFound {
    PPTrack *track = [tracks objectAtIndex:0];
    STAssertEqualObjects(@"spotify:track:6hDH3YWFdcUNQjubYztIsG", track.link, @"link should be found");
}

- (void)testParseData_TestFile_AlbumNameIsFound {
    PPTrack *track = [tracks objectAtIndex:0];
    STAssertEqualObjects(@"Backstreet's Back", track.albumName, @"album name should be found");
}

- (void)testParseData_TestFile_ArtistNameIsFound {
    PPTrack *track = [tracks objectAtIndex:0];
    STAssertEqualObjects(@"Backstreet Boys", track.artistName, @"artist name should be found");
}
@end


/*
 {"info": {"num_results": 1542, "limit": 100, "offset": 0, "query": "backstreet", "type": "track", "page": 1},
 
 "tracks":[
 {"album": 
    {"released": "1996", 
    "href": "spotify:album:5oEljuMoe9MXH6tBIPbd5e", 
    "name": "Backstreet's Back", 
    "availability": {"territories": "AD AE AF AG AI AL AM AN AO AQ AR AT AU AZ BA BB BD BE BF BG BH BI BJ BM BN BO BR BS BT BW BY BZ CA CD CF CG CH CI CK CL CM CO CR CU CV CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GH GI GL GM GN GP GQ GR GT GU GW GY HN HR HT HU IE IL IO IQ IR IS IT JM JO KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MZ NA NC NE NG NI NL NO NP NR NU NZ OM PA PE PF PG PK PL PM PN PR PS PT PW PY QA RE RO RU RW SA SB SC SD SE SH SI SK SL SM SN SO SR ST SV SY SZ TC TD TF TG TJ TK TL TM TN TO TR TT TV TW TZ UA UG UY UZ VA VC VE VG VN VU WF WS YE YT ZA ZM ZW"}}, 
"name": "Everybody (Backstreet's Back) - Radio Edit", 
 "popularity": "0.71737", 
 "external-ids": [{"type": "isrc", "id": "USJI19710083"}, {"type": "isrc", "id": "USJI19710083"}], 
 "length": 225.36, 
 "href": "spotify:track:6hDH3YWFdcUNQjubYztIsG", 
 "artists": [{"href": "spotify:artist:5rSXSAkZ67PYJSvpUpkOr7", "name": "Backstreet Boys"}], 
 "track-number": "1"}
*/