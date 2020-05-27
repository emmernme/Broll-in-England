//
//  BRMenuViewController.m
//  Broll in England
//
//  Created by Emil Broll on 28.07.13.
//  Copyright (c) 2013 Emil Broll. All rights reserved.
//

#import "BRMenuViewController.h"
#import "IIViewDeckController.h"
#import "BRSinglePostViewController.h"
#import "BRAboutViewController.h"
#import "BRQuickAlertView.h"

@implementation BRMenuViewController

- (id)init {
    self = [super init];
    if (self) {
        // Custom initialization
		self.postsView = [[BRPostsViewController alloc] initWithQuery:[NSDictionary dictionaryWithObject:@"posts" forKey:@"action"]];
		[self.postsView setMode:BRPostsViewModeHome];
		[self.postsView setTitle:@"Broll in England"];
				
		UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 39, 25)];
		[button setImageEdgeInsets:UIEdgeInsetsMake(0, 7, 0, 7)];
		[button setShowsTouchWhenHighlighted:YES];
		[button setImage:[UIImage imageNamed:@"archive"] forState:UIControlStateNormal];
		[button addTarget:self.viewDeckController action:@selector(toggleLeftView) forControlEvents:UIControlEventTouchUpInside];
		UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
		[[self.postsView navigationItem] setLeftBarButtonItem:barButton];
		
		button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 39, 25)];
		[button setImageEdgeInsets:UIEdgeInsetsMake(0, 7, 0, 7)];
		[button setShowsTouchWhenHighlighted:YES];
		[button setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
		[button addTarget:self.postsView action:@selector(toggleSearch) forControlEvents:UIControlEventTouchUpInside];
		barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
		[[self.postsView navigationItem] setRightBarButtonItem:barButton];
		
		int menuStored = [[[NSUserDefaults standardUserDefaults] objectForKey:@"menuStored"] intValue];
		if (menuStored && ([[NSDate date] timeIntervalSince1970] - menuStored) < 604800){
			self.categories = [[NSUserDefaults standardUserDefaults] objectForKey:@"menuCategories"];
			self.pages = [[NSUserDefaults standardUserDefaults] objectForKey:@"menuPages"];
			self.ready = YES;
		} else {
			self.getData = [[BRGetData alloc] initWithDelegate:self];
			[self.getData getMenu];
			self.ready = NO;
		}
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleRainbow) name:BRRainbowModeChanged object:nil];
	}
    return self;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	// This will create a "invisible" footer
	return 0.001f;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
	[self toggleRainbow];
	[[UITableViewHeaderFooterView appearance] setTintColor:[UIColor whiteColor]];
	[self.tableView setSeparatorColor:[UIColor whiteColor]];
	[self.tableView setBackgroundColor:RGBA(0, 0, 0, 0.85)];
}
-(void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)toggleRainbow {/*
	if (BRIsRainbow){
		UIImageView *background = [[UIImageView alloc] initWithFrame:self.tableView.frame];
		[background setImage:[UIImage imageNamed:@"rainbow2"]];
		[background setClipsToBounds:YES];
		[self.tableView setBackgroundView:background];
	} else {
		UIView *background = [[UIView alloc] initWithFrame:self.tableView.frame];
		[background setBackgroundColor:RGBA(0,0,0,0.85)];
		[self.tableView setBackgroundView:background];
	}*/
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.ready){
		switch (section) {
			case 0:
				return 1;
				break;
			case 1:
				return [self.categories count];
				break;
			case 2:
				return [self.pages count];
				break;
			case 3:
				return 2;// ([[[NSUserDefaults standardUserDefaults] objectForKey:BRDonated] isEqualToString:@"true"])?3:2;
				break;
		}
	}
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
	
	[cell.textLabel setTextColor:[UIColor whiteColor]];
	[[cell textLabel] setFont:[UIFont fontWithName:@"GFS Didot" size:16]];
	[cell setBackgroundColor:[UIColor clearColor]];
	[cell setSelectionStyle:UITableViewCellSelectionStyleGray];
	
	if (indexPath.section == 0){
		cell.textLabel.text = @"Hjem";
	} else if (indexPath.section == 1){
		cell.textLabel.text = [[self.categories objectAtIndex:indexPath.row] objectForKey:@"title"];
	} else if (indexPath.section == 2){
		cell.textLabel.text = [[self.pages objectAtIndex:indexPath.row] objectForKey:@"title"];
	} else if (indexPath.section == 3){
		if (indexPath.row == 0) {
			cell.textLabel.text = @"Om appen";
		} else if (indexPath.row == 1) {
			cell.textLabel.text = @"Kjøp en kopp kaffe til meg!";
		} else {
			if (BRIsRainbow){
				cell.textLabel.text = @"Skru av regnbuene, vær så snill!";
			} else {
				cell.textLabel.text = @"Regnbuer, takk.";
				UIImageView *background = [[UIImageView alloc] initWithFrame:cell.frame];
				[background setImage:[UIImage imageNamed:@"rainbow2"]];
				[background setContentMode:UIViewContentModeCenter];
				[background setClipsToBounds:YES];
				[cell setBackgroundView:background];
			}
		}
	}
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if (section == 0){
		return 0;
	}
	return 25;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	// Create label with section title
	if (section == 0) return [[UIView alloc] initWithFrame:CGRectNull];
	
	CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
	UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, 25)];
	headerView.contentMode = UIViewContentModeScaleToFill;
	
	// Add the label
	UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 0, 300.0, 24)];
	headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.textColor = [UIColor whiteColor];
	headerLabel.highlightedTextColor = [UIColor whiteColor];
	headerLabel.font = [UIFont fontWithName:@"GFS Didot" size:15];
	
	headerLabel.shadowColor = [UIColor clearColor];
	headerLabel.shadowOffset = CGSizeMake(0.0, 1.0);
	headerLabel.numberOfLines = 0;
	
	switch (section) {
		case 1:
			headerLabel.text = @"Kategorier";
			break;
		case 2:
			headerLabel.text = @"Sider";
			break;
		case 3:
			headerLabel.text = @"Annet";
			break;
	}
	[headerView addSubview: headerLabel];
	headerView.backgroundColor = RGBA(0, 0, 0, 0.6);
	return headerView;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	[self.postsView.navigationController popToRootViewControllerAnimated:NO];

	if (indexPath.section == 0){
		if (self.postsView.mode == BRPostsViewModeHome){
			[self.viewDeckController toggleLeftView];
			return;
		}
		if ([self.postsView mode] == BRPostsViewModeSearch)
			[self.postsView toggleSearch];
		[self.postsView getDataFromQuery:@{@"action": @"posts"} new:YES];
		[self.postsView setMode:BRPostsViewModeHome];
		[self.postsView setTitle:@"Broll in England"];
		[self.viewDeckController toggleLeftView];
	} else if (indexPath.section == 1){
		if ([self.postsView mode] == BRPostsViewModeSearch)
			[self.postsView toggleSearch];
		[self.postsView getDataFromQuery:@{@"action": @"posts", @"category": [[self.categories objectAtIndex:indexPath.row] objectForKey:@"ID"]} new:YES];
		[self.postsView setMode:BRPostsViewModeCategory];
		[self.postsView setTitle:[[self.categories objectAtIndex:indexPath.row] objectForKey:@"title"]];
		[self.viewDeckController toggleLeftView];
	} else if (indexPath.section == 2){
		BRSinglePostViewController *single = [[BRSinglePostViewController alloc] initWithID:[[[self.pages objectAtIndex:indexPath.row] objectForKey:@"ID"] intValue] andPostData:[self.pages objectAtIndex:indexPath.row] andImage:nil];
		[single setTitle:[[self.pages objectAtIndex:indexPath.row] objectForKey:@"title"]];
		[self.viewDeckController toggleLeftView];
		[self.postsView.navigationController pushViewController:single animated:YES];
	} else if (indexPath.section == 3){
		if (indexPath.row == 0) {
			BRAboutViewController *about = [[BRAboutViewController alloc] init];
			[self.viewDeckController toggleLeftView];
			[self.postsView.navigationController pushViewController:about animated:YES];
		} else if (indexPath.row == 1) {
			self.productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObjects:@"Kaffe1", @"Kaffe2", nil]];
			self.productsRequest.delegate = self;
			[self.productsRequest start];
			UIAlertView *coffeAlert = [[UIAlertView alloc] initWithTitle:@"Kjøp en kopp kaffe til meg!" message:@"Ja, det tok faktisk litt tid å lage appen, så jeg blir veldig glad om du vil kjøpe en kopp kaffe til meg." delegate:self cancelButtonTitle:@"Pff, pengene mine får du aldri!" otherButtonTitles:@"Tja, hvis en kaffe koster 7 kr så.", @"Selvsagt, ta en kopp til 21 kr du!", nil];
			[coffeAlert setTag:1];
			[coffeAlert show];
		}/* else {
			if (BRIsRainbow){
				[[NSUserDefaults standardUserDefaults] setValue:@"false" forKey:BRRainbowMode];
				[[NSNotificationCenter defaultCenter] postNotificationName:BRRainbowModeChanged object:nil];
			} else {
				[[NSUserDefaults standardUserDefaults] setValue:@"true" forKey:BRRainbowMode];
				[[NSNotificationCenter defaultCenter] postNotificationName:BRRainbowModeChanged object:nil];
			}
			[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationFade];
		}*/
	}
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) return;
	if (alertView.tag != 1){
		NSString *email = @"mailto:embroll@me.com?subject=Jeg vil ha postkort!&body=Hey, jeg kjøpte en kaffe til deg, kan jeg få et postkort av deg?\nNavn:\nAdresse:\nPostnummer:\nBy:\nLand:";
		email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
		return;
	}

	NSLog(@"Huh");
	if (![SKPaymentQueue canMakePayments] || !self.kaffe1 || !self.kaffe2){
		static int attempts;
		if (attempts < 5){
			double delayInSeconds = 2.0;
			dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
			dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
				[self alertView:alertView clickedButtonAtIndex:buttonIndex];
			});
			attempts++;
		} else {
			[BRQuickAlertView alertViewWithTitle:@"Oops..." message:@"Dette er pinlig, prøv igjen senere." cancel:@"Javel..." buttons:@"Særlig.", nil];
		}
		return;
	}
	if (buttonIndex == 1){
		SKPayment *payment = [SKPayment paymentWithProduct:self.kaffe1];
		[[SKPaymentQueue defaultQueue] addPayment:payment];
	}
	if (buttonIndex == 2){
		SKPayment *payment = [SKPayment paymentWithProduct:self.kaffe2];
		[[SKPaymentQueue defaultQueue] addPayment:payment];
	}
	[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions){
        if (transaction.transactionState == SKPaymentTransactionStatePurchased || transaction.transactionState == SKPaymentTransactionStateRestored){
			[[NSUserDefaults standardUserDefaults] setObject:@"true" forKey:BRDonated];
			[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Woho" message:@"Tusen takk for kaffen! Hvis du sender meg adressen din, får du et lite takkekort i posten :)" delegate:self cancelButtonTitle:@"Ellers takk" otherButtonTitles:@"Joa, jeg vil gjerne ha postkort!", nil];
			[alert show];
			[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationFade];
		} else if (transaction.transactionState == SKPaymentTransactionStateFailed) {
			NSLog(@"%@", transaction.debugDescription);
			if (transaction.error.code != SKErrorPaymentCancelled) {
				[BRQuickAlertView alertViewWithTitle:@"Oops..." message:@"Dette er pinlig, betalingen feilet, prøv igjen senere." cancel:@"Javel..." buttons:@"Særlig.", nil];
				[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
			} else {
				[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
			}
		}

    }
}



#pragma mark -
#pragma mark SKProductsRequestDelegate methods

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *products = response.products;
	if (products.count > 0){
		self.kaffe1 = [products objectAtIndex:0];
		self.kaffe2 = [products objectAtIndex:1];
    }
	if (self.kaffe1 && self.kaffe2){
        NSLog(@"Product title: %@" , self.kaffe1.localizedTitle);
        NSLog(@"Product description: %@" , self.kaffe1.localizedDescription);
        NSLog(@"Product price: %@" , self.kaffe1.price);
        NSLog(@"Product id: %@" , self.kaffe1.productIdentifier);
        NSLog(@"Product title: %@" , self.kaffe2.localizedTitle);
        NSLog(@"Product description: %@" , self.kaffe2.localizedDescription);
        NSLog(@"Product price: %@" , self.kaffe2.price);
        NSLog(@"Product id: %@" , self.kaffe2.productIdentifier);
    }
    
    for (NSString *invalidProductId in response.invalidProductIdentifiers){
        NSLog(@"Invalid product id: %@" , invalidProductId);
    }
}

#pragma mark - BRGetDataDelegate

- (void)recieveData:(id)data fromGetData:(BRGetData *)getData {
	NSMutableArray *categories = [[NSMutableArray alloc] init];
	NSMutableArray *pages = [[NSMutableArray alloc] init];
	
	for (id category in [data objectForKey:@"categories"]){
		[categories addObject:category];
	}
	for (id page in [data objectForKey:@"pages"]){
		[pages addObject:page];
	}
	self.categories = [NSArray arrayWithArray:categories];
	self.pages = [NSArray arrayWithArray:pages];
	[[NSUserDefaults standardUserDefaults] setObject:categories forKey:@"menuCategories"];
	[[NSUserDefaults standardUserDefaults] setObject:pages forKey:@"menuPages"];
	[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] forKey:@"menuStored"];
	self.ready = YES;
	[self.tableView reloadData];
	NSLog(@"Menu data set. %@ %@", self.categories, self.pages);
}

- (void)recieveError:(NSString *)error fromGetData:(BRGetData *)getData {
	self.ready = YES;
	[self.tableView setUserInteractionEnabled:YES];
	[self.tableView reloadData];
	NSLog(@"error: %@", error);
	[BRQuickAlertView alertViewWithTitle:@"Oops..." message:error cancel:@"Ok..." buttons: nil];
}

@end
