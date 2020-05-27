//
//  BRPostsViewCell.h
//  Broll in England
//
//  Created by Emil Broll on 20.07.13.
//  Copyright (c) 2013 Emil Broll. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BRPostsViewController;

@interface BRPostsViewCell : UITableViewCell

@property (strong, nonatomic) NSNumber *ID;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *commentLabel;
@property (strong, nonatomic) IBOutlet UIImageView *thumbView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *imageIndicator;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) UIImageView *headerView;
@property (assign, nonatomic) BRPostsViewController *delegate;
@property (assign, nonatomic) id informer;
@property (nonatomic) BOOL hasImageYet;
@property (nonatomic) BOOL loading;

- (void)toggleRainbow;

@end
