//
//  BRViewSinglePostController.m
//  Broll in England
//
//  Created by Emil Broll on 21.07.13.
//  Copyright (c) 2013 Emil Broll. All rights reserved.
//

#import "BRSinglePostViewController.h"
#import "BRRefreshControl.h"
#import "BRQuickAlertView.h"

@implementation BRSinglePostViewController

- (id)initWithID:(int)ID andPostData:(NSDictionary *)post andImage:(UIImage *)image {
    self = [super init];
    if (self) {
        // Custom initialization
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
		self.getData = [[BRGetData alloc] initWithDelegate:self];
		self.ID = ID;
		[self.getData getPostWithID:ID];
		self.loading = YES;
		self.first = YES;
		[self setTitle:[post objectForKey:@"title"]];
		self.images = [[NSMutableArray alloc] init];
		self.imagesURL = [[NSMutableArray alloc] init];

		NSString *html = [NSMutableString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"single" ofType:@"html"] encoding:NSUTF8StringEncoding error:nil];
		html = [html stringByReplacingOccurrencesOfString:@"%ID%" withString:[NSString stringWithFormat:@"%i", ID]];
		html = [html stringByReplacingOccurrencesOfString:@"%link%" withString:[post objectForKey:@"link"]];
		html = [html stringByReplacingOccurrencesOfString:@"%title%" withString:[post objectForKey:@"title"]];
		NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[post objectForKey:@"date"] intValue]];
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setLocale:[NSLocale currentLocale]];
		[formatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"EEEEdMMMM" options:0 locale:[NSLocale currentLocale]]];
		html = [html stringByReplacingOccurrencesOfString:@"%date%" withString:[formatter stringFromDate:date]];
		int comments = [[post objectForKey:@"comments"] intValue];
		NSString *commentText;
		if (comments == 0){
			commentText = @"Ingen kommentarer";
		} else if (comments == 1){
			commentText = @"Én kommentar";
		} else {
			commentText = [NSString stringWithFormat:@"%d kommentarer", comments];
		}
		html = [html stringByReplacingOccurrencesOfString:@"%comments%" withString:commentText];
		if (image){
			html = [html stringByReplacingOccurrencesOfString:@"%thumb%" withString:[NSString stringWithFormat:@"data:img/jpeg;base64,%@", [UIImageJPEGRepresentation(image, 1.0) base64EncodedString]]];
			html = [html stringByReplacingOccurrencesOfString:@"%thumbURL%" withString:[post objectForKey:@"thumb"]];
		} else if ([[post objectForKey:@"thumb"] isKindOfClass:[NSString class]]) {
			html = [html stringByReplacingOccurrencesOfString:@"%thumb%" withString:[post objectForKey:@"thumb"]];
			html = [html stringByReplacingOccurrencesOfString:@"%thumbURL%" withString:[post objectForKey:@"thumb"]];
		} else {
			html = [html stringByReplacingOccurrencesOfString:@"id=\"photo\"" withString:@"id=\"photo\" style='display:none'"];
		}
		self.html = html;
		self.postData = post;
	}
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self.webView loadHTMLString:self.html baseURL:[NSURL URLWithString:@"http://app.brollinengland.com/"]];//[[NSBundle mainBundle] bundleURL]];
#ifdef __IPHONE_7_0
	[[self.webView scrollView] setContentInset:UIEdgeInsetsMake(0, 0, 42, 0)];
	[[self.webView scrollView] setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, 42, 0)];
#else
	[[self.webView scrollView] setContentInset:UIEdgeInsetsMake(42, 0, 42, 0)];
	[[self.webView scrollView] setScrollIndicatorInsets:UIEdgeInsetsMake(42, 0, 42, 0)];
#endif
	[[self.webView scrollView] setDelegate:self];
	[self.webView setDelegate:self];

	UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 39, 25)];
	[button setImageEdgeInsets:UIEdgeInsetsMake(0, 7, 0, 7)];
	[button setShowsTouchWhenHighlighted:YES];
	[button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
	[button addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:button];
	[[self navigationItem] setLeftBarButtonItem:backButton];
	[self.navigationItem setHidesBackButton:YES];
	
	button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 39, 25)];
	[button setImageEdgeInsets:UIEdgeInsetsMake(0, 7, 0, 7)];
	[button setShowsTouchWhenHighlighted:YES];
	[button setImage:[UIImage imageNamed:@"upload"] forState:UIControlStateNormal];
	[button addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithCustomView:button];
	[[self navigationItem] setRightBarButtonItem:shareButton];
	
	button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 39, 25)];
	[button setImageEdgeInsets:UIEdgeInsetsMake(0, 7, 0, 7)];
	[button setShowsTouchWhenHighlighted:YES];
	[button setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
	[button addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
	self.backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
	
	button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 39, 25)];
	[button setImageEdgeInsets:UIEdgeInsetsMake(0, 7, 0, 7)];
	[button setShowsTouchWhenHighlighted:YES];
	[button setImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
	[button addTarget:self.webView action:@selector(goForward) forControlEvents:UIControlEventTouchUpInside];
	self.forwardItem = [[UIBarButtonItem alloc] initWithCustomView:button];
	
	button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 39, 25)];
	[button setImageEdgeInsets:UIEdgeInsetsMake(0, 7, 0, 7)];
	[button setShowsTouchWhenHighlighted:YES];
	[button setImage:[UIImage imageNamed:@"reload"] forState:UIControlStateNormal];
	[button addTarget:self.webView action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
	self.reloadItem = [[UIBarButtonItem alloc] initWithCustomView:button];
	
	[self.toolBar setItems:@[self.backItem, [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], self.reloadItem, [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], self.forwardItem]];
	
	[self.toolBar setTranslucent:YES];
	
	[self.backItem setEnabled:NO];
	[self.forwardItem setEnabled:NO];

	[self.webView setOpaque:NO];

	[self toggleRainbow];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleRainbow) name:BRRainbowModeChanged object:nil];
	[self.webView.scrollView setBackgroundColor:RGBA(245,245,245, 1)];
	[self.webView setBackgroundColor:RGBA(245,245,245, 1)];
	if ([self.toolBar respondsToSelector:@selector(setBarTintColor:)])
		[self.toolBar setBarTintColor:RGBA(245,245,245, 1)];
	else
		[self.toolBar setTintColor:RGBA(245,245,245, 1)];
}

-(void)toggleRainbow {/*
	if (BRIsRainbow){
		UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
		[background setImage:[UIImage imageNamed:@"rainbow2"]];
		[background setClipsToBounds:YES];
		[self.view insertSubview:background atIndex:0];
		[self.webView.scrollView setBackgroundColor:[UIColor clearColor]];
		[self.webView setBackgroundColor:[UIColor clearColor]];
	
		struct CGImage *image = CGImageCreateWithImageInRect([[UIImage imageNamed:@"rainbow2"] CGImage], CGRectMake(0, 120, 320, 42));
		[self.toolBar setBackgroundImage:[UIImage imageWithCGImage:image] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
		CGImageRelease(image);

	} else {
		[self.webView.scrollView setBackgroundColor:RGBA(245,245,245, 1)];
		[self.webView setBackgroundColor:RGBA(245,245,245, 1)];
		[self.toolBar setBackgroundImage:nil forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
#ifdef __IPHONE_7_0
		[self.toolBar setBarTintColor:RGBA(245,245,245, 1)];
#else
		[self.toolBar setTintColor:RGBA(245,245,245, 1)];
#endif

	}*/
}
-(void)viewWillAppear:(BOOL)animated {
	NSShadow *shadow = [NSShadow new];
	[shadow setShadowColor: [UIColor whiteColor]];
	[shadow setShadowOffset:CGSizeZero];
	[self.navigationController.navigationBar setTitleTextAttributes:BRTitleTextAttributes];
	[super viewWillAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)goBack {
	if ([self.webView canGoBack])
		[self.webView goBack];
	else
		[self.webView loadHTMLString:self.html baseURL:[NSURL URLWithString:@"http://app.brollinengland.com/"]];//[[NSBundle mainBundle] bundleURL]];
}

- (void)recieveData:(id)data fromGetData:(BRGetData *)getData {
	self.loading = NO;
	if ([self.refreshControl refreshing]) {
		[self.refreshControl endRefreshing];
	}
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[self setContent:data];
}
-(void)setContent:(NSString *)content {
	content = [content stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"];
	NSString *success = [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('content').innerHTML = '%@';", content]];
	static int attempts;
	NSLog(@"Success: %lu", (unsigned long)[success length]);
	if ([success length] > 0){
		NSString *imagesString = [self.webView stringByEvaluatingJavaScriptFromString:@"getImages()"];
		if (imagesString.length > 0) {
			NSData *jsonData = [imagesString dataUsingEncoding:NSUTF8StringEncoding];
			NSError *error = nil;
			NSArray *tempImages = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
			NSMutableArray *images = [[NSMutableArray alloc] init];
			NSMutableArray *imagesURL = [[NSMutableArray alloc] init];
			for (NSString *image in tempImages) {
				if ([image isEqual:[NSNull null]]) continue;
				[images addObject:[MWPhoto photoWithURL:[NSURL URLWithString:image]]];
				[imagesURL addObject:image];
			}
			self.images = images;
			self.imagesURL = imagesURL;
		}

		attempts = 0;
		return;
	}
	if ([success length] == 0 && [content length] > 0){
		if (attempts > 5){
			[BRQuickAlertView alertViewWithTitle:@"Oops..." message:@"Kunne ikke hente innlegg. Prøv igjen senere." cancel:@"Okei..." buttons:nil];
			attempts = 0;
			return;
		}
		attempts++;
		NSLog(@"Couldn't set content. Trying again in .5 secs.");
		[self performSelector:@selector(setContent:) withObject:content afterDelay:0.5];
	}
}

-(void)recieveError:(NSString *)error fromGetData:(BRGetData *)getData {
	self.loading = NO;
	NSLog(@"Failed to get post %@", error);
	if ([self.refreshControl refreshing]) {
		[self.refreshControl endRefreshing];
	}
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

	[self.navigationController dismissViewControllerAnimated:YES completion:^{
		[BRQuickAlertView alertViewWithTitle:@"Oops.." message:error cancel:@"Ok..." buttons:nil];
	}];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	NSLog(@"%@", request.URL);
	if ([[[request URL] absoluteString] rangeOfString:@"http://app.brollinengland.com/"].location == 0 && ![[[request URL] fragment] length] > 0){
		NSLog(@"Local! %@", [request URL]);
		if (self.first){
			self.first = NO;
			return YES;
		}
		[self.getData getPostWithID:self.ID];
		self.loading = YES;
		self.first = YES;
		[self.webView loadHTMLString:self.html baseURL:[NSURL URLWithString:@"http://app.brollinengland.com/"]];//[[NSBundle mainBundle] bundleURL]];
		return NO;
	}

	if ([[[request URL] absoluteString] rangeOfString:@"https://disqus.com/next/login/?forum="].location != NSNotFound){
		self.commentText = [self.webView stringByEvaluatingJavaScriptFromString:@""];
	}

	for (NSString *a in @[@"disqus.com/next/login-success",@"disqus.com/next/logout", @"disqus.com/_ax/twitter/complete", @"disqus.com/_ax/google/complete", @"disqus.com/_ax/facebook/complete"]){
		if ([[[request URL] absoluteString] rangeOfString:a].location != NSNotFound){
			[self.webView loadHTMLString:self.html baseURL:[NSURL URLWithString:@"http://app.brollinengland.com/"]];//[[NSBundle mainBundle] bundleURL]];
			[self.webView stringByEvaluatingJavaScriptFromString:@"window.location.hash='#disqus_thread'"];
			break;
		}
	}

	NSArray *images = @[@"jpeg", @"jpg", @"png", @"gif", @"tif", @"tiff"];
	if ([images containsObject:[[[request URL] pathExtension] lowercaseString]]){
		NSLog(@"Image! %@", [[request URL] description]);
		NSUInteger index = [self.imagesURL indexOfObject:[[request URL] absoluteString]];
		if (index != NSNotFound){
			MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
			[browser setCurrentPhotoIndex:index];
			browser.enableGrid = YES;
			browser.zoomPhotosToFill = NO;
			[self.navigationController pushViewController:browser animated:YES];
			[browser.navigationController.navigationBar setTitleTextAttributes:@{
																				 NSForegroundColorAttributeName: [UIColor whiteColor],
																				 NSFontAttributeName: [UIFont systemFontOfSize:[UIFont systemFontSize]],
																				 }];
		}
		return NO;
	}

	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

	return YES;
}
-(void)webViewDidFinishLoad:(UIWebView *)webView {
	if ([[[webView.request URL] absoluteString] rangeOfString:@"http://app.brollinengland.com/"].location == 0 && ![[[webView.request URL] fragment] length] > 0){
		[self.backItem setEnabled:NO];
	} else {
		[self.backItem setEnabled:YES];
	}
	if(![[[webView.request URL] absoluteString] rangeOfString:@"http://app.brollinengland.com/"].location == 0){
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	}

	
	[self.forwardItem setEnabled:[webView canGoForward]];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


-(void)share:(id)sender {
	
	NSMutableString *shareText = [[NSMutableString alloc] initWithFormat:@" - %@", [self.postData objectForKey:@"link"]];
	NSString *string = [self.postData objectForKey:@"title"];
	if ([shareText length] + [string length] > 140){
		[shareText insertString:[NSString stringWithFormat:@"%@...", [string substringToIndex:(136 - shareText.length)]] atIndex:0];
	} else {
		[shareText insertString:[self.postData objectForKey:@"title"] atIndex:0];
	}
	UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[shareText] applicationActivities:nil];
	activityController.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll, UIActivityTypePostToWeibo];
    [self presentViewController:activityController animated:YES completion:nil];
}

- (void)showToolbar:(BOOL)huh {
	if (huh){
		float scrollOffset = self.webView.scrollView.contentOffset.y;
		CGRect rect = self.toolBar.frame;
		rect.origin.y = self.view.frame.size.height - self.toolBar.frame.size.height;

		if (scrollOffset < 0){
			[UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut
							 animations:^{
								 [self.toolBar setFrame:rect];
							 } completion:nil];
		} else {
			[UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut
							animations:^{
								[self.toolBar setFrame:rect];
							} completion:^(BOOL finished) {
								[self performSelector:@selector(showToolbar:) withObject:nil afterDelay:3];
							}];
		}
	} else {
		CGRect rect = self.toolBar.frame;
		rect.origin.y = self.view.frame.size.height;
		[UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut
						 animations:^{
							 [self.toolBar setFrame:rect];
						 } completion:nil];
	}
}

-(void)scrollViewDidScroll: (UIScrollView*)scrollView
{
	static BOOL isAtTop;
	static BOOL isAtMiddle;
    float scrollViewHeight = scrollView.frame.size.height;
    float scrollContentSizeHeight = scrollView.contentSize.height;
    float scrollOffset = scrollView.contentOffset.y;
    if (scrollOffset < 0 && !isAtTop){
		isAtTop = YES;
		[self showToolbar:YES];
		isAtMiddle = NO;
    } else if (scrollOffset + scrollViewHeight > scrollContentSizeHeight){
		isAtTop = NO;
		isAtMiddle = NO;
        CGRect rect = self.toolBar.frame;
		if (scrollOffset + scrollViewHeight >= scrollContentSizeHeight + scrollView.contentInset.bottom)
			rect.origin.y = self.view.frame.size.height - self.toolBar.frame.size.height;
		else
			rect.origin.y = self.view.frame.size.height + (scrollContentSizeHeight - (scrollOffset + scrollViewHeight));
		[self.toolBar setFrame:rect];
    } else if (scrollOffset > 1 && scrollOffset < scrollContentSizeHeight){
		isAtTop = NO;
		if (!isAtMiddle){
			[self showToolbar:NO];
			isAtMiddle = YES;;
		}
	}
}
-(NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
	return self.images.count;
}
- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
	if (index < self.images.count)
		return [self.images objectAtIndex:index];
	return nil;
}
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
	if (index < self.images.count)
		return [self.images objectAtIndex:index];
	return nil;
}

@end