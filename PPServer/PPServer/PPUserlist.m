//
//  PPUserlist.m
//  PPServer
//
//  Created by Robert Höglund on 2/12/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import "PPUserlist.h"
#import "PPPlaylistUser.h"

@interface PPUserlist()
- (PPPlaylistUser *)findUserWithId:(NSString *)userId;
@end

@implementation PPUserlist

- (id)init {
    self = [super init];
    if (self) {
        users_ = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)dealloc {
    [users_ release];
    [super dealloc];
}

- (PPPlaylistUser *)userWithTwitterId:(MGTwitterEngineID)userId {
    return [self findUserWithId:[NSString stringWithFormat:@"%llu", userId]];
}

/*
{
    "contributors_enabled" = 0;
    "created_at" = "Wed Mar 28 21:35:47 +0000 2007";
    description = "";
    "favourites_count" = 0;
    "follow_request_sent" = 0;
    "followers_count" = 3;
    following = 0;
    "friends_count" = 1;
    "geo_enabled" = 0;
    id = 2728501;
    "id_str" = 2728501;
    "is_translator" = 0;
    lang = en;
    "listed_count" = 0;
    location = Sweden;
    name = "Robert H\U00f6glund";
    notifications = 0;
    "profile_background_color" = C6E2EE;
    "profile_background_image_url" = "http://a1.twimg.com/a/1297446951/images/themes/theme2/bg.gif";
    "profile_background_tile" = 0;
    "profile_image_url" = "http://a3.twimg.com/sticky/default_profile_images/default_profile_6_normal.png";
    "profile_link_color" = 1F98C7;
    "profile_sidebar_border_color" = C6E2EE;
    "profile_sidebar_fill_color" = DAECF4;
    "profile_text_color" = 663B12;
    "profile_use_background_image" = 1;
    protected = 0;
    "screen_name" = roho9035;
    "show_all_inline_media" = 0;
    "statuses_count" = 38;
    "time_zone" = Stockholm;
    url = "http://www.roberthoglund.com";
    "utc_offset" = 3600;
    verified = 0;
}
*/

- (PPPlaylistUser *)createTwitterUser:(NSDictionary *)userDict {
    NSString *userId = [NSString stringWithFormat:@"%llu", [[userDict objectForKey:@"id"] longLongValue]];
    PPPlaylistUser *user = [self findUserWithId:userId];
    if (user) {
        return user;
    }
    
    user = [[PPPlaylistUser alloc] init];
    user.name = [userDict objectForKey:@"name"];
    user.screenName = [userDict objectForKey:@"screen_name"];
    user.userId = userId;     // TODO: Queue avatar image for downloading
    
    NSLog(@"Adding user: %@", user.screenName);
    [users_ addObject:user];
    return [user autorelease];
}

- (PPPlaylistUser *)findUserWithId:(NSString *)userId {
    NSUInteger index = [users_ indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
        PPPlaylistUser *user = obj;
        if ([user.userId isEqualToString:userId]) {
            *stop = YES;
            return YES;
        }
        return NO;
    }];
    return index != NSNotFound ? [users_ objectAtIndex:index] : nil;

}

@end
