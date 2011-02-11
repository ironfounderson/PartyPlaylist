//
//  PPPlaylistViewController.h
//  PPServer
//
//  Created by Robert Höglund on 2/11/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PPPlaylist;

@interface PPPlaylistViewController : NSViewController {
@private    
}

@property (retain) PPPlaylist *playlist;
@property (assign) IBOutlet NSTableView *tableView;

@end
