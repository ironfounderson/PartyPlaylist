//
//  PPTrackParser.m
//  PPClient
//
//  Created by Robert Höglund on 2/10/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import "PPTrackParser.h"
#import "CJSONDeserializer.h"
#import "PPTrack.h"

@implementation PPTrackParser

- (NSArray *)parseData:(NSData *)data {
    NSDictionary *trackDict = [[CJSONDeserializer deserializer] deserializeAsDictionary:data 
                                                                                  error:nil];
    NSArray *tracks = [trackDict objectForKey:@"tracks"];
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:tracks.count];
    for (NSDictionary *trackDict in tracks) {
        PPTrack *track = [[PPTrack alloc] initWithDictionary:trackDict];
        [result addObject:track];
        [track release];
    }
    return result;
}

@end
