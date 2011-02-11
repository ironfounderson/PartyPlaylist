//
//  PPPlaylistViewController.m
//  PPServer
//
//  Created by Robert Höglund on 2/11/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import "PPPlaylistViewController.h"
#import "PPPlaylist.h"

@interface PPPlaylistViewController()
@property (copy) NSArray *tracks;
@end

@implementation PPPlaylistViewController

@synthesize playlist;
@synthesize tableView;
@synthesize tracks = tracks_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:PPPlaylistChangeNotification 
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:PPPlaylistTrackLoadedNotification 
                                                  object:nil];
    [tracks_ release];
    [super dealloc];
}

- (void)awakeFromNib {
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(handlePlaylistChange:) 
                                                 name:PPPlaylistChangeNotification 
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(handleTrackLoaded:) 
                                                 name:PPPlaylistTrackLoadedNotification 
                                               object:nil];    
}

- (void)handlePlaylistChange:(NSNotification *)notification {
    PPPlaylist *pl= [notification object];
    self.tracks = [pl upcomingItems];
    [self.tableView reloadData];
}

- (void)handleTrackLoaded:(NSNotification *)notification {
    [self.tableView reloadData];
}

#pragma mark - Table View Datasource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
    return self.tracks.count;
}

- (id)tableView:(NSTableView *)aTableView
objectValueForTableColumn:(NSTableColumn *)aTableColumn
            row:(NSInteger)rowIndex {
    PPPlaylistTrack *track = [self.tracks objectAtIndex:rowIndex];
    return [track valueForIdentifier:[aTableColumn identifier]];
}

@end
