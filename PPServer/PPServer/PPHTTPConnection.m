//
//  PPHTTPConnection.m
//  PPServer
//
//  Created by Robert Höglund on 2/13/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import "PPHTTPConnection.h"
#import "HTTPLogging.h"
#import "PPPlaylist.h"
#import "PPPlaylistTrack.h"
#import "PPSpotifyTrack.h"
#import "PPHTTPResponse.h"
#import "PPHTTPURLHandler.h"
#import "PPSpotifyAlbumImage.h"

const int httpLogLevel = HTTP_LOG_LEVEL_VERBOSE;

static PPPlaylist *sPlaylist;

@implementation PPHTTPConnection


+ (void)setPlaylist:(PPPlaylist *)playlist {
    sPlaylist = playlist;
}

- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method 
                                              URI:(NSString *)path {
    HTTPLogInfo(@"I got a %@ request %@", method, path);
    
    PPHTTPURLHandler *urlHandler = [[[PPHTTPURLHandler alloc] initWithMethod:method 
                                                                         URI:[path lowercaseString]] 
                                    autorelease];
    if ([self respondsToSelector:urlHandler.methodSelector]) {
        return [self performSelector:urlHandler.methodSelector withObject:urlHandler.parameters];
    }
    else {
        NSString *errorMessage = [NSString stringWithFormat:@"Did not find handler for %@", urlHandler.pathString];
        return [PPHTTPResponse errorResponseWithMessage:errorMessage];
    }
}

- (NSObject<HTTPResponse> *)GET_currentplaying:(NSDictionary *)parameters {
    NSDictionary *nextTrack = [sPlaylist.nextTrack.spotifyTrack dictionary];
    NSDictionary *currentTrack = [sPlaylist.currentTrack.spotifyTrack dictionary];
    NSDictionary *previousTrack = [sPlaylist.previousTrack.spotifyTrack dictionary];

    NSMutableDictionary *response = [NSMutableDictionary dictionary];
    if (nextTrack) {
        [response setObject:nextTrack forKey:@"next"];
    }
    if (currentTrack) {
        [response setObject:currentTrack forKey:@"current"];
    }
    if (previousTrack) {
        [response setObject:previousTrack forKey:@"previous"];
    }    
    return [PPHTTPResponse jsonResponseWithDictionary:response];
}

- (NSObject<HTTPResponse> *)GET_albumimage:(NSDictionary *)parameters {
    NSString *link = 
    [[parameters objectForKey:@"link"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (!link) {
        return [PPHTTPResponse errorResponseWithMessage:@"Did not find query parameter"];
    }
    
    PPSpotifyAlbumImage *albumImages = [PPSpotifyAlbumImage sharedInstance];
    NSString *imagePath = [albumImages imagePathForLink:link];
    NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
    if (!imageData) {
        return [PPHTTPResponse errorResponseWithMessage:@"Did not find image"];
    }
    
    return [PPHTTPResponse responseWithData:imageData];
}

@end
