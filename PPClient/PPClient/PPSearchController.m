//
//  PPSearchController.m
//  PPClient
//
//  Created by Robert Höglund on 2/10/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import "PPSearchController.h"

@implementation PPSearchController

@synthesize tableView = tableView_;
@synthesize searchModel = searchModel_;

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

#pragma mark - UISearchbar Delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchModel searchTrack:searchBar.text];
    [searchBar resignFirstResponder];
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
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

#pragma mark - PPSearchModelDelegate

- (void)searchModel:(PPSearchModel *)model 
   receivedResponse:(NSData *)response 
         withStatus:(int)statusCode {
    NSLog(@"%d: %@", statusCode, response);
}

@end
