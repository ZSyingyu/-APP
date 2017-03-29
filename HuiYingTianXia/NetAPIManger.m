//
//  NetAPIManger.m
//  HuiYingTianXia
//
//  Created by tsmc on 15-4-9.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import "NetAPIManger.h"
#import "NSObject+Common.h"
#import "MJExtension.h"
#import "AbstractItems.h"

@implementation NetAPIManger
+ (instancetype)sharedManger
{
    static NetAPIManger *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[NetAPIManger alloc] init];
    });
    return instance;
}

#pragma mark Register
- (void)request_RegisterWithParams:(NSDictionary *)params andBlock:(void (^)(id data, NSError *error))block
{
    NSLog(@"%@",params);
    [[NetAPIClient sharedClient] requestWithPath:@"request.app" withParams:params withMethodType:Get andBlock:^(id data, NSError *error) {
        if (data) {
            AbstractItems *items = [AbstractItems objectWithKeyValues:data];
            block(items, nil);
        }else{
            [self showStatusBarError:error];
            block(nil, error);
        }
    }];
}

#pragma mark Login
- (void)request_LoginWithParams:(NSDictionary *)params andBlock:(void (^)(id data, NSError *error))block
{
    [[NetAPIClient sharedClient] requestWithPath:@"request.app" withParams:params withMethodType:Get andBlock:^(id data, NSError *error) {
        if (data) {
            AbstractItems *items = [AbstractItems objectWithKeyValues:data];
            block(items, nil);
        }else{
            [self showStatusBarError:error];
            block(nil, error);
        }
    }];
}

#pragma mark BindingPos
- (void)request_BindingPosWithParams:(NSDictionary *)params andBlock:(void (^)(id data, NSError *error))block
{
    [[NetAPIClient sharedClient] requestWithPath:@"request.app" withParams:params withMethodType:Get andBlock:^(id data, NSError *error) {
        if (data) {
            AbstractItems *items = [AbstractItems objectWithKeyValues:data];
            block(items, nil);
        }else{
            [self showStatusBarError:error];
            block(nil, error);
        }
    }];
}

#pragma mark Trance
- (void)request_TranceWithParams:(NSDictionary *)params andBlock:(void (^)(id data, NSError *error))block
{
    [[NetAPIClient sharedClient] requestWithPath:@"request.app" withParams:params withMethodType:Get andBlock:^(id data, NSError *error) {
        if (data) {
            AbstractItems *items = [AbstractItems objectWithKeyValues:data];
            block(items, nil);
        }else{
            [self showStatusBarError:error];
            block(nil, error);
        }
    }];
}

#pragma mark Balance
- (void)request_BalanceWithParams:(NSDictionary *)params andBlock:(void (^)(id data, NSError *error))block
{
    [[NetAPIClient sharedClient] requestWithPath:@"request.app" withParams:params withMethodType:Get andBlock:^(id data, NSError *error) {
        if (data) {
            AbstractItems *items = [AbstractItems objectWithKeyValues:data];
            block(items, nil);
        }else{
            [self showStatusBarError:error];
            block(nil, error);
        }
    }];
}

#pragma mark upLoad image
- (void)request_UploadImageWithParrams:(NSDictionary *)params
                          andImageInfo:(NSDictionary *)imageInfo
                              andBlock:(void (^)(id data, NSError *error))block
{
    [[NetAPIClient sharedClient] uploadImage:[imageInfo objectForKey:@"image"]
                                        path:@"uploadImage.app"
                                        name:[imageInfo objectForKey:@"name"]
                                  parameters:params
                                successBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    block(responseObject ,nil);
                                } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    block(nil ,error);
                                } progerssBlock:^(CGFloat progressValue) {
                                    
                                }];
}

#pragma mark record
- (void)request_RecordWithParams:(NSDictionary *)params andBlock:(void (^)(id data, NSError *error))block
{
    [[NetAPIClient sharedClient] requestWithPath:@"request.app" withParams:params withMethodType:Get andBlock:^(id data, NSError *error) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            AbstractItems *items = [AbstractItems objectWithKeyValues:data];
            block(items, nil);
        }else{
            [self showStatusBarError:error];
            block(nil, error);
        }
    }];
}

#pragma mark revoke 撤销
- (void)request_RevokeWithParams:(NSDictionary *)params andBlock:(void (^)(id data, NSError *error))block
{
    [[NetAPIClient sharedClient] requestWithPath:@"request.app" withParams:params withMethodType:Get andBlock:^(id data, NSError *error) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            AbstractItems *items = [AbstractItems objectWithKeyValues:data];
            block(items, nil);
        }else{
            [self showStatusBarError:error];
            block(nil, error);
        }
    }];
}


#pragma mark change pwd
- (void)request_changePwdWithParams:(NSDictionary *)params andBlock:(void (^)(id data, NSError *error))block
{
    [[NetAPIClient sharedClient] requestWithPath:@"request.app" withParams:params withMethodType:Get andBlock:^(id data, NSError *error) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            AbstractItems *items = [AbstractItems objectWithKeyValues:data];
            block(items, nil);
        }else{
            [self showStatusBarError:error];
            block(nil, error);
        }
    }];
}

#pragma mark Detail
- (void)request_DetailsWithParams:(NSDictionary *)params andBlock:(void (^)(id data, NSError *error))block
{
    [[NetAPIClient sharedClient] requestWithPath:@"request.app" withParams:params withMethodType:Get andBlock:^(id data, NSError *error) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            AbstractItems *items = [AbstractItems objectWithKeyValues:data];
            block(items, nil);
        }else{
            [self showStatusBarError:error];
            block(nil, error);
        }
    }];
}

#pragma mark Message
- (void)request_MessageWithParams:(NSDictionary *)params andBlock:(void (^)(id data, NSError *error))block
{
    [[NetAPIClient sharedClient] requestWithPath:@"request.app" withParams:params withMethodType:Get andBlock:^(id data, NSError *error) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            AbstractItems *items = [AbstractItems objectWithKeyValues:data];
            block(items, nil);
        }else{
            [self showStatusBarError:error];
            block(nil, error);
        }
    }];
}

#pragma mark Cash
- (void)request_CashWithParams:(NSDictionary *)params andBlock:(void (^)(id data, NSError *error))block
{
    [[NetAPIClient sharedClient] requestWithPath:@"request.app" withParams:params withMethodType:Get andBlock:^(id data, NSError *error) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            AbstractItems *items = [AbstractItems objectWithKeyValues:data];
            block(items, nil);
        }else{
            [self showStatusBarError:error];
            block(nil, error);
        }
    }];
}

#pragma mark ReplacePwd
- (void)request_ReplacePwdWithParams:(NSDictionary *)params andBlock:(void (^)(id data, NSError *error))block
{
    [[NetAPIClient sharedClient] requestWithPath:@"request.app" withParams:params withMethodType:Get andBlock:^(id data, NSError *error) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            AbstractItems *items = [AbstractItems objectWithKeyValues:data];
            block(items, nil);
        }else{
            [self showStatusBarError:error];
            block(nil, error);
        }
    }];
}

#pragma mark RaiseQuota
- (void)request_RaiseQuotaWithParams:(NSDictionary *)params andBlock:(void (^)(id data, NSError *error))block
{
    [[NetAPIClient sharedClient] requestWithPath:@"request.app" withParams:params withMethodType:Get andBlock:^(id data, NSError *error) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            AbstractItems *items = [AbstractItems objectWithKeyValues:data];
            block(items, nil);
        }else{
            [self showStatusBarError:error];
            block(nil, error);
        }
    }];
}

#pragma mark RaiseQuotaList
- (void)request_RaiseQuotaListWithParams:(NSDictionary *)params andBlock:(void (^)(id data, NSError *error))block
{
    [[NetAPIClient sharedClient] requestWithPath:@"request.app" withParams:params withMethodType:Get andBlock:^(id data, NSError *error) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            AbstractItems *items = [AbstractItems objectWithKeyValues:data];
            block(items, nil);
        }else{
            [self showStatusBarError:error];
            block(nil, error);
        }
    }];
}

#pragma mark NoticeList
- (void)request_NoticeListWithParams:(NSDictionary *)params andBlock:(void (^)(id data, NSError *error))block
{
    [[NetAPIClient sharedClient] requestWithPath:@"request.app" withParams:params withMethodType:Get andBlock:^(id data, NSError *error) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            AbstractItems *items = [AbstractItems objectWithKeyValues:data];
            block(items, nil);
        }else{
            [self showStatusBarError:error];
            block(nil, error);
        }
    }];
}

#pragma mark QuotaBack
- (void)request_QuotaBackWithParams:(NSDictionary *)params andBlock:(void (^)(id data, NSError *error))block
{
    [[NetAPIClient sharedClient] requestWithPath:@"request.app" withParams:params withMethodType:Get andBlock:^(id data, NSError *error) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            AbstractItems *items = [AbstractItems objectWithKeyValues:data];
            block(items, nil);
        }else{
            [self showStatusBarError:error];
            block(nil, error);
        }
    }];
}

#pragma mark CheckQuota
- (void)request_CheckQuotaWithParams:(NSDictionary *)params andBlock:(void (^)(id data, NSError *error))block
{
    [[NetAPIClient sharedClient] requestWithPath:@"request.app" withParams:params withMethodType:Get andBlock:^(id data, NSError *error) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            AbstractItems *items = [AbstractItems objectWithKeyValues:data];
            block(items, nil);
        }else{
            [self showStatusBarError:error];
            block(nil, error);
        }
    }];
}

@end
