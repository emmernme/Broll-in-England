//
//  BRPostsViewController.m
//  Broll in England
//
//  Created by Emil Broll on 19.07.13.
//  Copyright (c) 2013 Emil Broll. All rights reserved.
//

#import "BRPostsViewController.h"
#import "BRQuickAlertView.h"
#import <QuartzCore/QuartzCore.h>
#import "AFNetworking.h"

@implementation BRPostsViewController

- (id)initWithQuery:(NSDictionary *)query {
	self = [super init];
	if (self) {
		// Custom initialization
		self.getData = [[BRGetData alloc] initWithDelegate:self];
		self.query = query;
		self.data = [[NSMutableArray alloc] init];
		self.IDs = [[NSMutableArray alloc] init];
		self.qGetData = [[BRGetData alloc] initWithDelegate:self];
		self.qQuery = query;
		self.qData = [[NSMutableArray alloc] init];
		self.qIDs = [[NSMutableArray alloc] init];
		[self getDataFromQuery:query new:YES];
		
		self.tableView.dataSource = self;
		self.tableView.delegate = self;

		self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
		[self.searchBar setDelegate:self];
		[self toggleRainbow];

		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleRainbow) name:BRRainbowModeChanged object:nil];
	}
	return self;
}
-(void)viewDidLoad {
	[self.tableView setUserInteractionEnabled:NO];
	[self.tableView setRowHeight:180];
	[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
	[self.tableView setSeparatorColor:[UIColor whiteColor]];
	[self.tableView setBackgroundColor:RGBA(245,245,245, 1)];
	[self.searchBar setTintColor:[UIColor whiteColor]];

	self.refreshController = [[BRRefreshControl alloc] initInScrollView:self.tableView];
	[self.refreshController setTintColor:[UIColor blackColor]];
	[self.refreshController setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
	[self.refreshController setActivityIndicatorViewColor:[UIColor blackColor]];
	[self.refreshController addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
}
-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	NSString *title = self.title;
	self.title = @"";
	self.title = title;
}

-(void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)dismissKeyboard {
	[self.searchBar resignFirstResponder];
}

-(void)toggleRainbow {/*
	if (BRIsRainbow){
		UIImageView *background = [[UIImageView alloc] initWithFrame:self.tableView.frame];
		[background setImage:[UIImage imageNamed:@"rainbow2"]];
		[background setClipsToBounds:YES];
		[self.tableView setBackgroundView:background];
		
		struct CGImage *image = CGImageCreateWithImageInRect([[UIImage imageNamed:@"rainbow2"] CGImage], CGRectMake(0, 120, 320, 42));
		[self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithCGImage:image] forBarMetrics:UIBarMetricsDefault];
		[self.searchBar setBackgroundImage:[UIImage imageWithCGImage:image]];
		CGImageRelease(image);
		NSString *title = self.title;
		self.title = @"";
		self.title = title;
		[self.navigationController.navigationBar setNeedsLayout];


	} else {
		[self.tableView setBackgroundView:nil];
		[self.tableView setBackgroundColor:RGBA(245,245,245, 1)];
		[self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
		[self.searchBar setBackgroundImage:nil];
		[self.searchBar setTintColor:[UIColor whiteColor]];

#ifdef __IPHONE_7_0
		[self.navigationController.navigationBar setBarTintColor:RGBA(245,245,245, 1)];
#else
		[self.navigationController.navigationBar setTintColor:RGBA(245,245,245, 1)];
#endif
		NSString *title = self.title;
		self.title = @"";
		self.title = title;
		[self.navigationController.navigationBar setNeedsLayout];
	}*/
}

-(void)refresh {
	NSMutableDictionary *query = [[NSMutableDictionary alloc] initWithDictionary:(self.mode != BRPostsViewModeSearch)?self.query:self.qQuery];
	[query setValue:@"0" forKey:@"offset"];
	[self getDataFromQuery:query new:YES];
	[self.tableView setUserInteractionEnabled:NO];
}
- (void)getDataFromQuery:(NSDictionary *)query new:(BOOL)new {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

	if (self.mode != BRPostsViewModeSearch){
		if (new)
			self.query = query;
		[self.getData getPostsWithQuery:query];
		self.shouldOverWriteData = YES;
		self.loading = YES;
		self.infinity = YES;
	} else {
		if (new)
			self.qQuery = query;
		[self.qGetData getPostsWithQuery:query];
		self.qShouldOverWriteData = YES;
		self.qLoading = YES;
		self.qInfinity = YES;
	}
}

-(void)toggleSearch {
	if (self.tableView.tableHeaderView){
		self.tableView.tableHeaderView = nil;
		[self setMode:BRPostsViewModeHome];
		[self setTitle:@"Broll in England"];
		self.loading = NO;
		if ([self.refreshController refreshing]){
			[self.refreshController endRefreshing];
		}
		[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
		[UIView animateWithDuration:0.4 delay: 0.0 options: UIViewAnimationOptionCurveEaseIn animations:^{
			[(UIButton *)self.navigationItem.rightBarButtonItem.customView setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
			[self.tableView.tableHeaderView setAlpha:0];
		} completion:nil];

	} else {
		[self.searchBar setAlpha:0];
		[self setMode:BRPostsViewModeSearch];
		[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
		self.tableView.tableHeaderView = self.searchBar;
		if ([self.refreshController refreshing]){
			[self.refreshController endRefreshing];
		}
		[self.searchBar becomeFirstResponder];
		[UIView animateWithDuration:0.4 delay: 0.0 options: UIViewAnimationOptionCurveEaseIn animations:^{
			[(UIButton *)self.navigationItem.rightBarButtonItem.customView setImage:[UIImage imageNamed:@"left2"] forState:UIControlStateNormal];
			[self.tableView.tableHeaderView setAlpha:1];
			self.qLoading = YES;
		} completion:nil];
	}
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[self getDataFromQuery:@{@"action": @"posts", @"q": searchBar.text} new:YES];
	[self setTitle:searchBar.text];
	[searchBar resignFirstResponder];
	[self.tableView setUserInteractionEnabled:NO];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// Return the number of sections.
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// Return the number of rows in the section.
	NSArray *IDs = (self.mode != BRPostsViewModeSearch)? self.IDs : self.qIDs;

	if ((self.mode != BRPostsViewModeSearch)?self.loading:self.qLoading)
		return 0;
	else if ([IDs count] == 0)
		return 0;
	return ([IDs count] + ((self.infinity && [IDs count] % 5 == 0)?1:0));
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSInteger row = indexPath.row;
	
	NSArray *data = (self.mode != BRPostsViewModeSearch)? self.data : self.qData;
	NSArray *IDs = (self.mode != BRPostsViewModeSearch)? self.IDs : self.qIDs;
	BRGetData *getData = (self.mode != BRPostsViewModeSearch)? self.getData : self.qGetData;
	NSDictionary *query = (self.mode != BRPostsViewModeSearch)? self.query : self.qQuery;
	
	if (row > [IDs count] - 1){
		static NSString *loadingIdentifier = @"LoadingCell";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:loadingIdentifier];
		if (cell == nil){
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:loadingIdentifier];
		}
		cell.tag = BRCellTypeInfinityLoader;
		UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		loading.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
		[loading setColor:[UIColor grayColor]];
		[loading startAnimating];
		[cell addSubview:loading];
		[loading setCenter:CGPointMake(cell.contentView.bounds.size.width/2,cell.contentView.bounds.size.height/2)];
		[cell setUserInteractionEnabled:NO];
		
		NSMutableDictionary *infinity = [[NSMutableDictionary alloc] initWithDictionary:query];
		[infinity setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[IDs count]] forKey:@"offset"];
		[getData getPostsWithQuery:infinity];
		self.shouldOverWriteData = NO;
		self.loading = YES;
		NSLog(@"Whaaat");
		return cell;
	}
	
	NSDictionary *post = [data objectAtIndex:row];
	static NSString *CellIdentifier = @"PostsCell";
	BRPostsViewCell *cell = [[BRPostsViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	cell.delegate = self;
	cell.ID = (NSNumber *)[IDs objectAtIndex:row];

	if ([[post objectForKey:@"thumb"] isKindOfClass:[NSString class]]){
		NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[post objectForKey:@"thumb"]]];
		[request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
		[[cell imageIndicator] startAnimating];
		__weak typeof(cell) weakCell = cell;
		NSDate *start = [NSDate date];
		[cell.thumbView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"iTunesArtwork"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
			[[weakCell imageIndicator] stopAnimating];
			NSTimeInterval timeInterval = [start timeIntervalSinceNow];
			if (timeInterval <= 0.3){
				[[weakCell thumbView] setImage:image];
			} else
				[UIView transitionWithView:weakCell.thumbView duration:0.7f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{ [weakCell.thumbView setImage:image];} completion:NULL];
			if (weakCell.informer && [weakCell.informer respondsToSelector:@selector(getImage:)])
				[weakCell.informer performSelector:@selector(getImage:) withObject:image];
		} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
		}];
	} else {
		[cell.thumbView setImage:[UIImage imageNamed:@"iTunesArtwork"]];
	}
	[cell.titleLabel setText:[post objectForKey:@"title"]];
	int comments = [[post objectForKey:@"comments"] intValue];
	NSString *commentText;
	if (comments == 0){
		commentText = @"Ingen kommentarer";
	} else if (comments == 1){
		commentText = @"Én kommentar";
	} else {
		commentText = [NSString stringWithFormat:@"%d kommentarer", comments];
	}
	[cell.commentLabel setText:commentText];
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[post objectForKey:@"date"] integerValue]];
	[cell.dateLabel setText:[[SORelativeDateTransformer registeredTransformer] transformedValue:date]];
	cell.date = date;
	
	// Configure the cell...
	cell.loading = false;
	return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSArray *IDs = (self.mode != BRPostsViewModeSearch)? self.IDs : self.qIDs;

	if (indexPath.row > [IDs count] - 1){
		return 56;
	} else
		return 180;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	// This will create a "invisible" footer
	return 0.001f;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 1)];
	lineView.backgroundColor = RGBA(245,245,245, 1);
	return lineView;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Navigation logic may go here. Create and push another view controller.
	NSArray *data = (self.mode != BRPostsViewModeSearch)? self.data : self.qData;
	NSArray *IDs = (self.mode != BRPostsViewModeSearch)? self.IDs : self.qIDs;

	NSNumber *ID = [IDs objectAtIndex:indexPath.row];
	
	BRPostsViewCell *cell = (BRPostsViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
	UIImage *image = nil;
	if ([cell hasImageYet]){
		image = [cell.thumbView image];
	} else {
		[cell setInformer:self.single];
	}
	self.single = [[BRSinglePostViewController alloc] initWithID:[ID intValue] andPostData:[data objectAtIndex:indexPath.row] andImage:image];
	[self.navigationController pushViewController:self.single animated:YES];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}
#pragma mark - BRGetDataDelegate

- (void)recieveData:(id)data fromGetData:(BRGetData *)getData {
	NSLog(@"Got some data! %@", data);
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

	if (self.mode != BRPostsViewModeSearch){
		if (getData == self.qGetData){
			return;
		}
		self.loading = NO;

		if (self.shouldOverWriteData){
			[self.data removeAllObjects];
			[self.IDs removeAllObjects];
		}
		[self.data addObjectsFromArray:data];
		for (NSDictionary *item in data) {
			NSNumber *ID = [item objectForKey:@"ID"];
			[self.IDs addObject:ID];
		}
		self.shouldOverWriteData = NO;
	} else {
		self.qLoading = NO;
		if (self.qShouldOverWriteData){
			[self.qData removeAllObjects];
			[self.qIDs removeAllObjects];
		}
		[self.qData addObjectsFromArray:data];
		for (NSDictionary *item in data) {
			NSNumber *ID = [item objectForKey:@"ID"];
			[self.qIDs addObject:ID];
		}
		self.qShouldOverWriteData = NO;
	}
	if ([self.refreshController refreshing]){
		[self.refreshController endRefreshing];
	}
	[self.tableView setUserInteractionEnabled:YES];
	[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];

}
- (void)recieveError:(NSString *)error fromGetData:(BRGetData *)getData {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

	if ([self.refreshController refreshing]){
		[self.refreshController endRefreshing];
	}
	if (self.mode != BRPostsViewModeSearch){
		if (self.shouldOverWriteData){
			[self.data removeAllObjects];
			[self.IDs removeAllObjects];
		}
		self.infinity = NO;
		self.loading = NO;
	} else {
		if (self.qShouldOverWriteData){
			[self.qData removeAllObjects];
			[self.qIDs removeAllObjects];
		}
		self.qLoading = NO;
		self.qInfinity = NO;
		
	}
	[self.tableView setUserInteractionEnabled:YES];
	[self.tableView reloadData];
	NSLog(@"error: %@", error);
	[BRQuickAlertView alertViewWithTitle:@"Ooops..." message:[error description] cancel:@"Ok..." buttons:nil];
}

@end
