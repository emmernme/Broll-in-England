//
//  BRPostsViewCell.m
//  Broll in England
//
//  Created by Emil Broll on 20.07.13.
//  Copyright (c) 2013 Emil Broll. All rights reserved.
//

#import "BRPostsViewCell.h"
#import "BRPostsViewController.h"

@implementation BRPostsViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [[[NSBundle mainBundle] loadNibNamed:@"BRPostsViewCell" owner:self options:nil] objectAtIndex:0];
	if (self) {
		// Initialization code
		[self.thumbView setContentMode:UIViewContentModeScaleAspectFill];
		[self.thumbView setClipsToBounds:YES];
		UIFont *GFS = [UIFont fontWithName:@"GFS Didot" size:21];
		[self.titleLabel setFont:GFS];
		[self.commentLabel setFont:[GFS fontWithSize:14]];
		[self.dateLabel setFont:[GFS fontWithSize:14]];
	}
	return self;
}

- (void)getImage:(NSString *)URL {
	NSError *error = nil;
	UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:URL] options:NSDataReadingMappedIfSafe error:&error]];
	if (!error){
		[self.delegate.images setObject:image forKey:self.ID];
		[self.thumbView setImage:image];
	} else {
		NSLog(@"Image not found!");
	}
	return;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	[super setSelected:selected animated:animated];
	if (selected){
		[self.titleLabel setTextColor:[UIColor lightGrayColor]];
		[self.commentLabel setTextColor:[UIColor lightGrayColor]];
		[self.dateLabel setTextColor:[UIColor lightGrayColor]];
	} else {
		[self.titleLabel setTextColor:[UIColor whiteColor]];
		[self.commentLabel setTextColor:[UIColor whiteColor]];
		[self.dateLabel setTextColor:[UIColor whiteColor]];
	}
}

@end
