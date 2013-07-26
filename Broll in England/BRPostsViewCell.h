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
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *commentLabel;
@property (strong, nonatomic) IBOutlet UIImageView *thumbView;
@property (assign, nonatomic) BRPostsViewController *delegate;

- (void)getImage:(NSString *)URL;

@end
