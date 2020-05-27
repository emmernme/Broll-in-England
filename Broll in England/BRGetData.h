//
//  BRGetData.h
//  Broll in England
//
//  Created by Emil Broll on 20.07.13.
//  Copyright (c) 2013 Emil Broll. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BRGetData;
@protocol BRGetDataDelegate <NSObject, NSURLConnectionDelegate, NSURLConnectionDataDelegate>
@required
- (void)recieveData:(id)data fromGetData:(BRGetData *)getData;
- (void)recieveError:(NSString *)error fromGetData:(BRGetData *)getData;
@end
@protocol BRGetDataTokenDelegate <NSObject, BRGetDataDelegate>
@required
- (void)tokenSuccess;
- (void)tokenError:(NSString *)error;
@end
typedef enum {
	BRGetDataModePosts,
	BRGetDataModePost,
	BRGetDataModeMenu,
	BRGetDataModeToken
} BRGetDataMode;

@interface BRGetData : NSObject
@property (nonatomic, weak) id <BRGetDataDelegate> delegate;
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData	*responseData;
@property (nonatomic) BRGetDataMode mode;

- (id)initWithDelegate:(id <BRGetDataDelegate>)delegate;
- (void)getPostsWithQuery:(NSDictionary *)query;
- (void)getPostWithID:(int)ID;
- (void)getMenu;
- (id)validateData:(NSData *)data;

-(void)registerPushToken:(NSString *)token;



@end