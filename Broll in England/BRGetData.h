//
//  BRGetData.h
//  Broll in England
//
//  Created by Emil Broll on 20.07.13.
//  Copyright (c) 2013 Emil Broll. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BRGetDataDelegate <NSObject, NSURLConnectionDelegate, NSURLConnectionDataDelegate>
@required
- (void)recieveData:(NSDictionary *)data;
- (void)recieveError:(NSDictionary *)error;
@end

@interface BRGetData : NSObject
@property (nonatomic, assign) id <BRGetDataDelegate> delegate;
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData	*responseData;

- (id)initWithDelegate:(id <BRGetDataDelegate>)delegate;
- (void)getPostsWithQuery:(NSDictionary *)query;
- (void)getPostWithID:(int)ID;
- (void)getCategories;
- (void)sendData:(NSDictionary *)data;
- (BOOL)validateData:(NSDictionary *)data;


@end

enum BRGetDataError {
	BRGetDataErrorIncompleteDelegate = 1,
	BRGetDataErrorServerDown = 2
};