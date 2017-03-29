//
//  NetAPIClient.h
//  HuiYingTianXia
//
//  Created by tsmc on 15-4-9.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface NetAPIClient : AFHTTPRequestOperationManager

typedef enum {
    Get = 0,
    Post,
    Put,
    Delete
} NetworkMethod;

+ (instancetype)sharedClient;

- (void)requestWithPath:(NSString *)aPath
             withParams:(NSDictionary*)params
         withMethodType:(int)NetworkMethod
               andBlock:(void (^)(id data, NSError *error))block;

- (void)uploadImage:(UIImage *)image
               path:(NSString *)path
               name:(NSString *)name
         parameters:(NSDictionary *)parameters
       successBlock:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
       failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
      progerssBlock:(void (^)(CGFloat progressValue))progress;

@end
