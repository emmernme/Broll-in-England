//
//  BRViewSinglePostController.h
//  Broll in England
//
//  Created by Emil Broll on 21.07.13.
//  Copyright (c) 2013 Emil Broll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRGetData.h"
#import "Base64.h"

@interface BRSinglePostViewController : UIViewController <BRGetDataDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (strong, nonatomic) BRGetData *getData;
@property (nonatomic) int ID;
@property (strong, nonatomic) NSString *html;

- (id)initWithID:(int)ID andPostData:(NSDictionary *)post andImage:(UIImage *)image;

@end
