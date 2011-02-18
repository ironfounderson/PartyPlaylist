//
//  PPTrackParser.m
//  PPClient
//
//  Created by Robert Höglund on 2/10/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import "PPSpotifyTrackJSONParser.h"
#import "CJSONDeserializer.h"
#import "PPSpotifyTrack.h"

@implementation PPSpotifyTrackJSONParser

- (NSArray *)parseData:(NSData *)data {
    NSDictionary *trackDict = [[CJSONDeserializer deserializer] deserializeAsDictionary:data 
                                                                                  error:nil];
    NSArray *tracks = [trackDict objectForKey:@"tracks"];
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:tracks.count];
    for (NSDictionary *trackDict in tracks) {
        PPSpotifyTrack *track = [[PPSpotifyTrack alloc] initWithDictionary:trackDict];
        [result addObject:track];
        [track release];
    }
    return result;
}

- (NSDictionary *)dictionaryFromSpotifyTrack:(PPSpotifyTrack *)spotifyTrack {    
    return [spotifyTrack dictionary];
}

- (NSString *)jsonFromSpotifyTrack:(PPSpotifyTrack *)spotifyTrack {
    return nil;
}

/*
 {
 album =     {
 availability =         {
 territories = "AD AE AF AL AN AO AZ BA BB BD BG BH BI BJ BS BW BY BZ CD CF CG CI CM CN CU CV CY CZ DJ DK DO DZ EE EG ER ES ET FI FJ FM GA GB GD GE GH GI GM GN GP GQ GR GT GW HK HN HR HT HU ID IE IL IN IQ IR IS JO KE KG KH KM KR KW KZ LA LB LC LI LK LR LS LT LV LY MA MC MD MG MH MK ML MM MN MQ MR MT MU MW MX MY MZ NA NC NE NG NI NO NR OM PA PF PG PH PK PL PM PS PT PW QA RE RO RU RW SA SB SC SD SE SG SI SK SL SM SN SO ST SV SY SZ TD TG TH TM TN TR TT TW TZ UA UG UZ VN WF WS YT ZA ZM ZW";
 };
 href = "spotify:album:1suw2wSUQSR9ZJxL2xkh3e";
 name = "Essential - The 90s";
 released = 2010;
 };
 artists =     (
 {
 href = "spotify:artist:5rSXSAkZ67PYJSvpUpkOr7";
 name = "Backstreet Boys";
 }
 );
 "external-ids" =     (
 {
 id = USJI19710149;
 type = isrc;
 }
 );
 href = "spotify:track:2xXdMXNubG5gvzhfNm2dWR";
 length = "212.28";
 name = "As Long As You Love Me";
 popularity = "0.46598";
 "track-number" = 2;
 }
*/

@end
