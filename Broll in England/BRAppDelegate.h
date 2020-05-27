//
//  BRAppDelegate.h
//  Broll in England
//
//  Created by Emil Broll on 19.07.13.
//  Copyright (c) 2013 Emil Broll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRMenuViewController.h"
#import "IIViewDeckController.h"
#import "BRQuickAlertView.h"

@interface BRAppDelegate : UIResponder <UIApplicationDelegate, BRGetDataDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navController;
@property (strong, nonatomic) BRMenuViewController *menuView;
@property (strong, nonatomic) IIViewDeckController *deckController;
@property (strong, nonatomic) id thing;

-(void)toggleRainbow;

@end
