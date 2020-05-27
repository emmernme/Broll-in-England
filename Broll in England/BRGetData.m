//
//  BRGetData.m
//  Broll in England
//
//  Created by Emil Broll on 20.07.13.
//  Copyright (c) 2013 Emil Broll. All rights reserved.
//

#import "BRGetData.h"
	
@implementation BRGetData

-(id)initWithDelegate:(id<BRGetDataDelegate>)delegate {
	self = [super init];
	if (self){
		[self setDelegate:delegate];
	}
	return self;
}

- (void)getPostsWithQuery:(NSDictionary *)query {
	[self setMode:BRGetDataModePosts];
	NSMutableString *postData = [[NSMutableString alloc] init];
	[query enumerateKeysAndObjectsUsingBlock:^(NSString* key, NSString* obj, BOOL *stop) {
		[postData appendFormat:@"%@=%@&", [key urlEncodeUsingEncoding:NSUTF8StringEncoding], [obj urlEncodeUsingEncoding:NSUTF8StringEncoding]];
	}];
	NSLog(@"postData: %@", postData);
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:AJAXURL]];
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
	self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}
- (void)getPostWithID:(int)ID {
	[self setMode:BRGetDataModePost];
	NSLog(@"Getting post with ID %d", ID);
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:AJAXURL]];
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[[NSString stringWithFormat:@"action=post&id=%d&", ID] dataUsingEncoding:NSUTF8StringEncoding]];
	self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}
- (void)getMenu {
	[self setMode:BRGetDataModeMenu];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:AJAXURL]];
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[@"action=menu" dataUsingEncoding:NSUTF8StringEncoding]];
	self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

-(id)validateData:(NSData *)data {
	NSError *error = nil;
	NSString *string = [[NSString alloc] initWithData:data encoding:NSStringEncodingConversionAllowLossy];
	NSLog(@"Data: %@", string);
	if ([string isEqualToString:@"-1"]){
		if (self.delegate)
			[self.delegate recieveError:@"Nettverksfeil" fromGetData:self];
		return nil;
	}
	id JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
	if ([JSON isKindOfClass:[NSDictionary class]] && [JSON objectForKey:@"error"]){
		if (self.delegate)
			[self.delegate recieveError:[JSON objectForKey:@"error"] fromGetData:self];
		return nil;
	} else if (error){
		if (self.delegate)
			[self.delegate recieveError:@"Nettverksfeil" fromGetData:self];
		return nil;
	}
	if (self.mode == BRGetDataModePost){
		string = [string substringWithRange:NSMakeRange(2, string.length - 4)];
		return string;
	}
	if (self.mode == BRGetDataModePosts || self.mode == BRGetDataModeMenu)
		return JSON;
	if (self.mode == BRGetDataModeToken)
		return [JSON objectForKey:@"result"];
	return nil;
}

-(void)registerPushToken:(NSString *)token {
	[self setMode:BRGetDataModeToken];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:AJAXURL]];
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	
	NSString *body = [NSString stringWithFormat:@"action=register_push&name=%@&token=%@&", [[UIDevice currentDevice] name], token];
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
	self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [self.responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
	id data = [self validateData:self.responseData];
	if (self.mode == BRGetDataModeToken){
		if (data){
			[self.delegate recieveData:@"true" fromGetData:self];
		} else {
			[self.delegate recieveError:@"false" fromGetData:self];
		}
	}
	if (data && self.delegate)
		[self.delegate recieveData:data fromGetData:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
	if (self.delegate) {
		[self.delegate recieveError:[error description] fromGetData:self];
	}
}
@end
