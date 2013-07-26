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

@interface BRPostsViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, BRGetDataDelegate>

@property (strong, nonatomic) NSMutableDictionary *query;
@property (strong, nonatomic) BRGetData *getData;
@property (strong, nonatomic) BRSinglePostViewController *single;
@property (strong, nonatomic) NSMutableDictionary *data;
@property (strong, nonatomic) NSMutableArray *IDs;
@property (strong, nonatomic) NSMutableDictionary *images;

- (id)initWithQuery:(NSDictionary *)query;

@end
