//
//  BRViewSinglePostController.m
//  Broll in England
//
//  Created by Emil Broll on 21.07.13.
//  Copyright (c) 2013 Emil Broll. All rights reserved.
//

#import "BRSinglePostViewController.h"

@implementation BRSinglePostViewController

- (id)initWithID:(int)ID andPostData:(NSDictionary *)post andImage:(UIImage *)image {
    self = [super init];
    if (self) {
        // Custom initialization
		self.getData = [[BRGetData alloc] initWithDelegate:self];
		self.ID = ID;
		[self.getData getPostWithID:ID];

		NSString *html = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"single" ofType:@"html"] encoding:NSStringEncodingConversionAllowLossy error:nil];
		html = [html stringByReplacingOccurrencesOfString:@"%ID%" withString:[NSString stringWithFormat:@"%i", ID]];
		html = [html stringByReplacingOccurrencesOfString:@"%title%" withString:[NSString stringWithFormat:@"%@", [post objectForKey:@"title"]]];
		html = [html stringByReplacingOccurrencesOfString:@"%date%" withString:[NSString stringWithFormat:@"%@", [post objectForKey:@"date"]]];
		html = [html stringByReplacingOccurrencesOfString:@"%comments%" withString:[NSString stringWithFormat:@"%@ kommentarer", [post objectForKey:@"comments"]]];
		html = [html stringByReplacingOccurrencesOfString:@"%thumb%" withString:[NSString stringWithFormat:@"data:img/jpeg;base64,%@", [UIImageJPEGRepresentation(image, 1.0) base64EncodedString]]];
		self.html = html;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self.webView loadHTMLString:self.html baseURL:[[NSBundle mainBundle] bundleURL]];
	[[self.webView scrollView] setContentInset:UIEdgeInsetsMake(42, 0, 0, 0)];
	[[self.webView scrollView] setScrollIndicatorInsets:UIEdgeInsetsMake(42, 0, 0, 0)];
	[[self.webView scrollView] setDelegate:self];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)recieveData:(NSDictionary *)data {
	
}
-(void)recieveError:(NSDictionary *)error {
	
}


@end
