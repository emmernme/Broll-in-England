//
//  BRPostsViewController.h
//  Broll in England
//
//  Created by Emil Broll on 19.07.13.
//  Copyright (c) 2013 Emil Broll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRPostsViewCell.h"
#import "BRGetData.h"
#import "BRSinglePostViewController.h"
#import "SORelativeDateTransformer.h"
#import "UIImageView+AFNetworking.h"
#import "BRRefreshControl.h"

@interface BRPostsViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, BRGetDataDelegate, UISearchBarDelegate, UIScrollViewDelegate>

typedef enum {
	BRCellTypeInfinityLoader,
	BRCellTypePost
} BRCellType;

typedef enum {
	BRPostsViewModeHome,
	BRPostsViewModeCategory,
	BRPostsViewModeSearch
} BRPostsViewMode;

@property (strong, nonatomic) BRSinglePostViewController *single;
@property (strong, nonatomic) BRRefreshControl *refreshController;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (nonatomic) BRPostsViewMode mode;

@property (strong, nonatomic) NSDictionary *query;
@property (strong, nonatomic) BRGetData *getData;
@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) NSMutableArray *IDs;
@property (nonatomic) BOOL loading;
@property (nonatomic) BOOL infinity;
@property (nonatomic) BOOL shouldOverWriteData;

@property (strong, nonatomic) NSDictionary *qQuery;
@property (strong, nonatomic) BRGetData *qGetData;
@property (strong, nonatomic) NSMutableArray *qData;
@property (strong, nonatomic) NSMutableArray *qIDs;
@property (nonatomic) BOOL qLoading;
@property (nonatomic) BOOL qInfinity;
@property (nonatomic) BOOL qShouldOverWriteData;

- (id)initWithQuery:(NSDictionary *)query;
- (void)getDataFromQuery:(NSDictionary *)query new:(BOOL)new;
- (void)refresh;
- (void)toggleSearch;
- (void)dismissKeyboard;

-(void)toggleRainbow;

@end
