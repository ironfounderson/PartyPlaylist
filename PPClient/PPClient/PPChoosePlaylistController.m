//
//  PPChoosePlaylistController.m
//  PPClient
//
//  Created by Robert Höglund on 2/16/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import "PPChoosePlaylistController.h"
#import "PPBonjourBrowser.h"

@interface PPChoosePlaylistController() 
@property (nonatomic, retain) NSNetService *currentResolve;
- (void)stopCurrentResolve;
- (void)updateServiceList:(NSNotification *)notification;
@end

@implementation PPChoosePlaylistController

@synthesize tableView = tableView_;
@synthesize selectServiceBlock = selectServiceBlock_;
@synthesize currentResolve = currentResolve_;
@synthesize services = services_;
@synthesize bonjourBrowser;

- (id)init {
    self = [super init];
    if (self) {
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self 
                                       selector:@selector(initialWaitOver:) 
                                       userInfo:nil 
                                        repeats:NO];
    }
    return self;
}

- (void)dealloc {
    [selectServiceBlock_ release];
    [tableView_ release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(updateServiceList:) 
                                                 name:PPBonjourBrowserServicesUpdatedNotification 
                                               object:nil];
    [self updateServiceList:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:PPBonjourBrowserServicesUpdatedNotification 
                                                  object:nil];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction)handleCancel:(id)sender {
	if (self.selectServiceBlock) {
		self.selectServiceBlock(nil);
	}
}

- (void)updateServiceList:(NSNotification *)notification {
    self.services = [self.bonjourBrowser availableServices];
    [self.tableView reloadData];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return services_.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSNetService *service = [services_ objectAtIndex:indexPath.row];

	cell.textLabel.text = [service name];
	cell.textLabel.textColor = [UIColor blackColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.currentResolve) {
		NSIndexPath* indexPath = 
        [NSIndexPath indexPathForRow:[services_ indexOfObject:self.currentResolve] inSection:0];
		[self stopCurrentResolve];
		if (indexPath.row != NSNotFound) {
			[self.tableView reloadRowsAtIndexPaths:[NSArray	arrayWithObject:indexPath] 
                                  withRowAnimation:UITableViewRowAnimationNone];
        }
	}
	
	self.currentResolve = [services_ objectAtIndex:indexPath.row];
	[self.currentResolve setDelegate:self];	
	[self.currentResolve resolveWithTimeout:0.0];
	
	// Make sure we give the user some feedback that the resolve is happening.
	// We will be called back asynchronously, so we don't want the user to think we're just stuck.
	// We delay showing this activity indicator in case the service is resolved quickly.
	//self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showWaiting:) userInfo:self.currentResolve repeats:NO];
}

- (void)initialWaitOver:(NSTimer*)timer {
    NSLog(@"Initial wait time is over");
}

#pragma mark - NSNetService

- (void)stopCurrentResolve {
	//self.needsActivityIndicator = NO;
	//self.timer = nil;
    
	[self.currentResolve stop];
	self.currentResolve = nil;
}

- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict {
	[self stopCurrentResolve];
	[self.tableView reloadData];
}


- (void)netServiceDidResolveAddress:(NSNetService *)service {
	assert(service == self.currentResolve);
	
	[service retain];
	[self stopCurrentResolve];
	
    if (self.selectServiceBlock) {
        self.selectServiceBlock(service);
    }
	[service release];
}



@end
