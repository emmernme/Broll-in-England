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
		UIFont *GFS = [UIFont fontWithName:@"Poiret One" size:24];
		[self.titleLabel setFont:GFS];
		[self.commentLabel setFont:[GFS fontWithSize:18]];
		[self.dateLabel setFont:[GFS fontWithSize:18]];
		self.hasImageYet = NO;
		[self.thumbView setContentMode:UIViewContentModeScaleAspectFill];
		[self.thumbView setClipsToBounds:YES];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleRainbow) name:BRRainbowModeChanged object:nil];
		[self toggleRainbow];
	}
	return self;
}
- (void)layoutSubviews {
	[super layoutSubviews];
}
-(void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)toggleRainbow {/*
	if (BRIsRainbow){
		UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.topView.frame.size.width, self.topView.frame.size.height)];
		[background setImage:[UIImage imageNamed:@"rainbow2"]];
		[background setContentMode:UIViewContentModeCenter];
		[background setClipsToBounds:YES];
		[background setAlpha:0.4];
		[background setTag:1234];
		[self.topView insertSubview:background atIndex:0];
		NSData *archivedViewData = [NSKeyedArchiver archivedDataWithRootObject:background];
		id bottom = [NSKeyedUnarchiver unarchiveObjectWithData:archivedViewData];

		[self.bottomView insertSubview:bottom atIndex:0];
		[self.topView setBackgroundColor:[UIColor clearColor]];
		[self.bottomView setBackgroundColor:[UIColor clearColor]];
		
	} else {
		[[self.topView viewWithTag:1234] removeFromSuperview];
		[[self.bottomView viewWithTag:1234] removeFromSuperview];
		[self.topView setBackgroundColor:RGBA(245,245,245, 0.5)];
		[self.bottomView setBackgroundColor:RGBA(245,245,245, 0.5)];
	}*/
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	[super setSelected:selected animated:animated];
	if (selected){
		[self.titleLabel setTextColor:[UIColor lightGrayColor]];
		[self.commentLabel setTextColor:[UIColor lightGrayColor]];
		[self.dateLabel setTextColor:[UIColor lightGrayColor]];
	} else {
		[self.titleLabel setTextColor:[UIColor blackColor]];
		[self.commentLabel setTextColor:[UIColor blackColor]];
		[self.dateLabel setTextColor:[UIColor blackColor]];
	}
}
-(void)prepareForReuse {
	self.thumbView = nil;
	self.loading = true;
}

@end
