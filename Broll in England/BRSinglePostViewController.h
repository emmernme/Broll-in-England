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
#import "MWPhotoBrowser.h"

@class BRRefreshControl;
@interface BRSinglePostViewController : UIViewController <BRGetDataDelegate, UIScrollViewDelegate, UIWebViewDelegate, MWPhotoBrowserDelegate>

@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) IBOutlet UIToolbar *toolBar;
@property (nonatomic, strong) UIBarButtonItem *backItem;
@property (nonatomic, strong) UIBarButtonItem *reloadItem;
@property (nonatomic, strong) UIBarButtonItem *forwardItem;
@property (strong, nonatomic) BRGetData *getData;
@property (strong, nonatomic) BRRefreshControl *refreshControl;
@property (nonatomic) int ID;
@property (strong, nonatomic) NSString *html;
@property (strong, nonatomic) NSString *JS;
@property (strong, nonatomic) NSDictionary *postData;
@property (strong, nonatomic) NSMutableArray *images;
@property (strong, nonatomic) NSMutableArray *imagesURL;
@property (nonatomic) BOOL loading;
@property (nonatomic) BOOL doJS;
@property (nonatomic) BOOL first;
@property (strong, nonatomic) NSString *commentText;


- (id)initWithID:(int)ID andPostData:(NSDictionary *)post andImage:(UIImage *)image;

- (void)share:(id)sender;
- (void)showToolbar:(BOOL)huh;
- (void)goBack;
-(void)setContent:(NSString *)content;

- (void)toggleRainbow;

@end
