//
//  BRQuickAlertView.m
//  Broll in England
//
//  Created by Emil Broll on 06.08.13.
//  Copyright (c) 2013 Emil Broll. All rights reserved.
//

#import "BRQuickAlertView.h"

@implementation BRQuickAlertView

+(void)alertViewWithTitle:(NSString *)title message:(NSString *)message cancel:(NSString *)cancel buttons:(NSString *)buttons, ... {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancel otherButtonTitles:buttons, nil];
	[alert show];
}

@end
