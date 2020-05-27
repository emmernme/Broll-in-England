//
//  BRMenuViewController.h
//  Broll in England
//
//  Created by Emil Broll on 28.07.13.
//  Copyright (c) 2013 Emil Broll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRGetData.h"
#import "BRPostsViewController.h"
#import <StoreKit/StoreKit.h>

@class IIViewDeckController;
@interface BRMenuViewController : UIViewController <BRGetDataDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UIAlertViewDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property (strong, nonatomic) BRGetData *getData;
@property (strong, nonatomic) UISearchDisplayController *searchController;
@property (strong, nonatomic) BRPostsViewController	*postsView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) NSArray *pages;
@property (nonatomic, assign) IIViewDeckController *viewDeckController;
@property (nonatomic) BOOL ready;

@property (strong, nonatomic) SKProduct *kaffe1;
@property (strong, nonatomic) SKProduct *kaffe2;
@property (strong, nonatomic) SKProductsRequest *productsRequest;

-(id)init;

-(void)toggleRainbow;

@end
