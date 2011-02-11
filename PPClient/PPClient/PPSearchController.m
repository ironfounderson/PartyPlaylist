//
//  PPSearchController.m
//  PPClient
//
//  Created by Robert Höglund on 2/10/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import "PPSearchController.h"
#import "PPTrackParser.h"
#import "PPTrack.h"

@interface PPSearchController()
@property (nonatomic, retain) NSArray *tracks;
@end

@implementation PPSearchController

@synthesize tableView = tableView_;
@synthesize searchModel = searchModel_;
@synthesize tracks = tracks_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

#pragma mark - Memory management

- (void)dealloc {
    [tableView_ release];
    [searchModel_ release];
    [tracks_ release];
    dispatch_release(parseQueue_);
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    self.tableView = nil;
    [super viewDidUnload];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    PPTrack *track = [self.tracks objectAtIndex:indexPath.row];
    cell.textLabel.text = track.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", track.artistName, track.albumName];
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section {
    return self.tracks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TrackCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
                                       reuseIdentifier:CellIdentifier] autorelease];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (PPSearchModel *)searchModel {
    if (!searchModel_) {
        searchModel_ = [[PPSearchModel alloc] init];
        searchModel_.delegate = self;
    }
    return searchModel_;
}

#pragma mark - UISearchbar Delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchModel searchTrack:searchBar.text];
    [searchBar resignFirstResponder];
}

#pragma mark - PPSearchModelDelegate

- (void)searchModel:(PPSearchModel *)model 
   receivedResponse:(NSData *)response 
         withStatus:(int)statusCode {
    if (!parseQueue_) {
        parseQueue_ = dispatch_queue_create("com.roberthoglund.partyplaylist.parsequeue", NULL);
    }
    
    self.tracks = nil;
    [self.tableView reloadData];
    
    __block __typeof__(self)_self = self;    
    dispatch_async(parseQueue_, ^{
        PPTrackParser *trackParser = [[PPTrackParser alloc] init];
        _self.tracks = [trackParser parseData:response];
        [trackParser release];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_self.tableView reloadData];
        });
    });
}

@end
