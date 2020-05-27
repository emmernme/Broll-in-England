//
//  BRAboutViewController.h
//  Broll in England
//
//  Created by Emil Broll on 05.08.13.
//  Copyright (c) 2013 Emil Broll. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BRRefreshControl;
@interface BRAboutViewController : UIViewController <UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;

-(void)share;

-(void)secret;
-(void)toggleRainbow;

@end
