//
//  BRPostsViewController.m
//  Broll in England
//
//  Created by Emil Broll on 19.07.13.
//  Copyright (c) 2013 Emil Broll. All rights reserved.
//

#import "BRPostsViewController.h"

@interface BRPostsViewController ()

@end

@implementation BRPostsViewController

- (id)initWithQuery:(NSDictionary *)query {
	self = [super init];
	if (self) {
		// Custom initialization
		self.getData = [[BRGetData alloc] initWithDelegate:self];
		[self.getData getPostsWithQuery:query];

		self.tableView.dataSource = self;
		self.tableView.delegate = self;

		UIView *background = [[UIView alloc] initWithFrame:self.tableView.frame];
		[background setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
		[self.tableView setBackgroundView:background];
		[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
		[self.tableView setSeparatorColor:RGB(244, 244, 244)];
	}
	return self;
}


- (void)viewDidLoad
{
	[super viewDidLoad];
	
	// Uncomment the following line to preserve selection between presentations.
	// self.clearsSelectionOnViewWillAppear = NO;
 
	// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
	// self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
	// Return the number of sections.
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
	// Return the number of rows in the section.
	return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	int row = indexPath.row;
	static NSString *CellIdentifier = @"PostsCell";
	BRPostsViewCell *cell = (BRPostsViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[BRPostsViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.delegate = self;
	}
	cell.ID = (NSNumber *)[self.IDs objectAtIndex:row];
	[cell.titleLabel setText:@"Heihei!"];
	NSLog(@"%d", cell.thumbView.contentMode);
	[cell.thumbView setImage:[UIImage imageNamed:@"bilde.jpg"]];
	
	
	
	// Configure the cell...
	
	return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 180;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Navigation logic may go here. Create and push another view controller.
	NSNumber *ID = [self.IDs objectAtIndex:indexPath.row];

	if (!self.single){
		self.single = [[BRSinglePostViewController alloc] initWithID:[ID intValue] andPostData:[self.data objectForKey:ID] andImage:[self.images objectForKey:ID]];
	}
	[self.navigationController pushViewController:self.single animated:YES];
}

#pragma mark - BRGetDataDelegate

- (void) recieveData:(NSDictionary *)data {
	self.data = [NSMutableDictionary dictionaryWithDictionary:data];
	for (NSDictionary *item in self.data) {
		NSNumber *ID = [item objectForKey:@"ID"];
		[self.IDs addObject:ID];
	}
}
- (void)recieveError:(NSDictionary *)error {
	
}

@end
