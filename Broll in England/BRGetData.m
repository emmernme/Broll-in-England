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
	NSMutableString *postData = [[NSMutableString alloc] init];
	[query enumerateKeysAndObjectsUsingBlock:^(NSString* key, NSString* obj, BOOL *stop) {
		[postData appendFormat:@"%@=%@&", [key urlEncodeUsingEncoding:NSUTF8StringEncoding], [obj urlEncodeUsingEncoding:NSUTF8StringEncoding]];
	}];
	NSLog(@"postData: %@", postData);
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:AJAXURL]];
	[request setHTTPMethod:@"POST"];
	[request setValue:@"text/plain; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
	self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}
- (void)getPostWithID:(int)ID {
	
}
- (void)getCategories {
	
}
-(void)sendData:(NSDictionary *)data {
	if (self.delegate && [self.delegate respondsToSelector:@selector(recieveData:)]){
		[self.delegate recieveData:data];
	} else if ([self.delegate respondsToSelector:@selector(recieveError:)]){
		[self.delegate recieveError:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:BRGetDataErrorIncompleteDelegate] forKey:@"code"]];
	}
}
-(BOOL)validateData:(NSDictionary *)data {
	// TODO: Validate data
	return YES;
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
    NSLog(@"Got data: %@", [[NSString alloc] initWithData:self.responseData encoding:NSStringEncodingConversionAllowLossy]);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
}
@end
