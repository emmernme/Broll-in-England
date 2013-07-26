//
//  BRAppDelegate.m
//  Broll in England
//
//  Created by Emil Broll on 19.07.13.
//  Copyright (c) 2013 Emil Broll. All rights reserved.
//

#import "BRAppDelegate.h"

@implementation BRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.navController = [[UINavigationController alloc] init];
	self.postsView = [[BRPostsViewController alloc] initWithQuery:nil];
	// Override point for customization after application launch.
	[self.window setRootViewController:self.navController];
	[self.window makeKeyAndVisible];
	[self.navController pushViewController:self.postsView animated:FALSE];
	

	
	UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
	[title setFont:[UIFont fontWithName:@"GFS Didot" size:22]];
	[title setTextColor:[UIColor colorWithRed:85.0f/255.0f green:85.0f/255.0f blue:85.0f/255.0f alpha:1]];
	[title setText:@"Broll in England"];
	[title setTextAlignment:NSTextAlignmentCenter];
	[title setBackgroundColor:[UIColor clearColor]];
	[title setCenter:CGPointMake(160, 22)];
	[self.navController.navigationBar addSubview:title];
	[self.navController.navigationBar setTintColor:[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:0.3]];
	[self.navController.navigationBar setTranslucent:YES];
	
	UIBarButtonItem *info = [[UIBarButtonItem alloc] initWithCustomView:[UIButton buttonWithType:UIButtonTypeInfoDark]];
	[info.customView setFrame:CGRectMake(info.customView.frame.origin.x, info.customView.frame.origin.x, info.customView.frame.size.width + 20, info.customView.frame.size.height)];
	UIBarButtonItem *cats = [[UIBarButtonItem alloc] initWithCustomView:[UIButton buttonWithType:UIButtonTypeInfoDark]];
	[cats.customView setFrame:info.customView.frame];
	[self.postsView.navigationItem setRightBarButtonItem:info];
	[self.postsView.navigationItem setLeftBarButtonItem:cats];
	
	return YES;
}

- (void)showInfoView {
	
	return;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
