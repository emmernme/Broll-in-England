//
//  BRAppDelegate.h
//  Broll in England
//
//  Created by Emil Broll on 19.07.13.
//  Copyright (c) 2013 Emil Broll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRPostsViewController.h"

@interface BRAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navController;
@property (strong, nonatomic) BRPostsViewController *postsView;


@end
