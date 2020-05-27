//
//  BRQuickAlertView.h
//  Broll in England
//
//  Created by Emil Broll on 06.08.13.
//  Copyright (c) 2013 Emil Broll. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BRQuickAlertView : NSObject

+(void)alertViewWithTitle:(NSString *)title message:(NSString *) message cancel:(NSString *)cancel buttons:(NSString *)buttons, ... NS_REQUIRES_NIL_TERMINATION;

@end
