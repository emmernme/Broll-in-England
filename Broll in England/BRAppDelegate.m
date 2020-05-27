//
//  BRAppDelegate.m
//  Broll in England
//
//  Created by Emil Broll on 19.07.13.
//  Copyright (c) 2013 Emil Broll. All rights reserved.
//

#import "BRAppDelegate.h"
#import "IISideController.h"
#import "MWPhotoBrowser.h"

@implementation BRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.navController = [[UINavigationController alloc] init];
	self.menuView = [[BRMenuViewController alloc] init];
	IISideController *resizeMenuView = [[IISideController alloc] initWithViewController:self.menuView];

	self.deckController = [[IIViewDeckController alloc] initWithCenterViewController:self.navController leftViewController:resizeMenuView];
	[self.menuView setViewDeckController:self.deckController];
	[self.window setRootViewController:self.deckController];
	[self.window makeKeyAndVisible];
	
	[self.deckController setParallaxAmount:0.85];
	[self.deckController setLeftSize:50];
	[self.deckController setCenterhiddenInteractivity:IIViewDeckCenterHiddenNotUserInteractiveWithTapToClose];

	[self.navController pushViewController:self.menuView.postsView animated:FALSE];

	[self.navController.navigationBar setUserInteractionEnabled:YES];
	[self.navController.navigationBar setTranslucent:NO];

	NSShadow *shadow = [NSShadow new];
	[shadow setShadowColor: [UIColor whiteColor]];
	[shadow setShadowOffset:CGSizeZero];
#ifdef __IPHONE_7_0
	[[UINavigationBar appearance] setBarTintColor:RGBA(245,245,245, 1)];
#else
	[[UINavigationBar appearance] setTintColor:RGBA(245,245,245, 1)];
#endif
	[[UINavigationBar appearance] setTitleTextAttributes:BRTitleTextAttributes];
	[application registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
	[application setApplicationIconBadgeNumber:0];

	[self toggleRainbow];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleRainbow) name:BRRainbowModeChanged object:nil];

	return YES;
}
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
	if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isPushRegistered"] isEqualToString:@"true"])
		return;
	
	NSString *newToken = [deviceToken description];
	newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
	newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
	BRGetData *getData = [[BRGetData alloc] initWithDelegate:self];
	NSLog(@"Got token: %@", newToken);
	[getData registerPushToken:newToken];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
	NSLog(@"Failed to get token, error: %@", error);
}

-(void)recieveData:(id)data fromGetData:(BRGetData *)getData {
	[[NSUserDefaults standardUserDefaults] setObject:@"true" forKey:@"isPushRegistered"];
}
-(void)recieveError:(NSString *)error fromGetData:(BRGetData *)getData {
	[[NSUserDefaults standardUserDefaults] setObject:@"false" forKey:@"isPushRegistered"];
	NSLog(@"Did not register push notification. Server error %@", error);
	[BRQuickAlertView alertViewWithTitle:@"Oops..." message:[NSString stringWithFormat:@"Kunne ikke registrere push-notifications. %@", error] cancel:@"Ålreit, jeg prøver senere." buttons:nil];
}

- (void)toggleRainbow {/*
	NSShadow *shadow = [NSShadow new];
	[shadow setShadowColor: [UIColor clearColor]];
	[shadow setShadowOffset: CGSizeMake(0.0f, 0.0f)];
	if (BRIsRainbow){
		struct CGImage *image = CGImageCreateWithImageInRect([[UIImage imageNamed:@"rainbow2"] CGImage], CGRectMake(0, 120, 320, 42));
		[[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithCGImage:image] forBarMetrics:UIBarMetricsDefault];
		[(UINavigationBar *)[self.navController.navigationBar.superview viewWithTag:1234] setBackgroundImage:[UIImage imageWithCGImage:image] forBarMetrics:UIBarMetricsDefault];
		CGImageRelease(image);

		NSDictionary *textAttributes = @{ NSForegroundColorAttributeName: [UIColor blackColor], NSShadowAttributeName: shadow,
										  NSFontAttributeName: [UIFont fontWithName:@"UnifrakturMaguntia" size:23], };
		[[UINavigationBar appearance] setTitleTextAttributes:textAttributes];
		[self.navController.navigationBar setTitleTextAttributes:textAttributes];
	} else {
		self.thing = [self.navController.navigationBar viewWithTag:1234];
		[(UINavigationBar *)[self.navController.navigationBar viewWithTag:1234] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
		[[UINavigationBar appearance] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
#ifdef __IPHONE_7_0
		[[UINavigationBar appearance] setBarTintColor:RGBA(245,245,245, 1)];
#else
		[[UINavigationBar appearance] setTintColor:RGBA(245,245,245, 1)];
#endif
		NSDictionary *textAttributes = @{ NSForegroundColorAttributeName: [UIColor blackColor], NSShadowAttributeName: shadow,
										  NSFontAttributeName: [UIFont fontWithName:@"UnifrakturMaguntia" size:23], };
		[[UINavigationBar appearance] setTitleTextAttributes:textAttributes];
		[self.navController.navigationBar setTitleTextAttributes:textAttributes];
	}*/
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
