//
//  BRAboutViewController.m
//  Broll in England
//
//  Created by Emil Broll on 05.08.13.
//  Copyright (c) 2013 Emil Broll. All rights reserved.
//

#import "BRAboutViewController.h"

@interface BRAboutViewController ()

@end

@implementation BRAboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[[NSBundle mainBundle] URLForResource:@"about" withExtension:@"html"]];
	[self.webView loadRequest:request];
#ifndef __IPHONE_7_0
	[[self.webView scrollView] setContentInset:UIEdgeInsetsMake(42, 0, 0, 0)];
	[[self.webView scrollView] setScrollIndicatorInsets:UIEdgeInsetsMake(42, 0, 0, 0)];
#endif
	[self.webView setDelegate:self];
	[self setTitle:@"Om appen"];
	
	UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 39, 25)];
	[button setImageEdgeInsets:UIEdgeInsetsMake(0, 7, 0, 7)];
	[button setShowsTouchWhenHighlighted:YES];
	[button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
	[button addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:button];
	[[self navigationItem] setLeftBarButtonItem:backButton];
	[self.navigationItem setHidesBackButton:YES];
	
	button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 39, 25)];
	[button setImageEdgeInsets:UIEdgeInsetsMake(0, 7, 0, 7)];
	[button setShowsTouchWhenHighlighted:YES];
	[button setImage:[UIImage imageNamed:@"upload"] forState:UIControlStateNormal];
	[button addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithCustomView:button];
	[[self navigationItem] setRightBarButtonItem:shareButton];

	[self.webView setOpaque:NO];
	[self toggleRainbow];
	
/*	UITapGestureRecognizer *rainbowMode = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(secret)];
	[rainbowMode setNumberOfTapsRequired:3];
	[rainbowMode setNumberOfTouchesRequired:2];
	[self.view addGestureRecognizer:rainbowMode];
*/	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleRainbow) name:BRRainbowModeChanged object:nil];
}

-(void)toggleRainbow {/*
	if (BRIsRainbow){
		UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
		[background setImage:[UIImage imageNamed:@"rainbow2"]];
		[background setClipsToBounds:YES];
		[self.view insertSubview:background atIndex:0];
		[self.webView.scrollView setBackgroundColor:[UIColor clearColor]];
		[self.webView setBackgroundColor:[UIColor clearColor]];
	} else {
		[self.webView.scrollView setBackgroundColor:RGBA(245,245,245, 1)];
		[self.webView setBackgroundColor:RGBA(245,245,245, 1)];
	}*/
}

-(void)secret {/*
	NSLog(@"Toggeling rainbow mode");
	if (BRIsRainbow){
		[[NSUserDefaults standardUserDefaults] setValue:@"false" forKey:BRRainbowMode];
		[[NSUserDefaults standardUserDefaults] synchronize];
		[[NSNotificationCenter defaultCenter] postNotificationName:BRRainbowModeChanged object:self];
	} else {
		[[NSUserDefaults standardUserDefaults] setValue:@"true" forKey:BRRainbowMode];
		[[NSUserDefaults standardUserDefaults] synchronize];
		[[NSNotificationCenter defaultCenter] postNotificationName:BRRainbowModeChanged object:self];
	}*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	if (navigationType != UIWebViewNavigationTypeOther){
		[[UIApplication sharedApplication] openURL:request.URL];
		return NO;
	}
	return YES;
}


-(void)share {
	UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[@"Broll in England - the app! https://itunes.apple.com/us/app/broll-in-england/id685960325?l=nb&ls=1&mt=8 @EmilBroll"] applicationActivities:nil];
	activityController.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll, UIActivityTypePostToWeibo];
    [self presentViewController:activityController animated:YES completion:nil];
}

@end
