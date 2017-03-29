//
//  NetAPIManger.h
//  HuiYingTianXia
//
//  Created by tsmc on 15-4-9.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetAPIClient.h"

@interface NetAPIManger : NSObject

+ (instancetype)sharedManger;
#pragma mark Login  登录
- (void)request_LoginWithParams:(NSDictionary *)params andBlock:(void (^)(id data, NSError *error))block;
#pragma mark Register  注册
- (void)request_RegisterWithParams:(NSDictionary *)params andBlock:(void (^)(id data, NSError *error))block;
#pragma mark BindingPos 绑定
- (void)request_BindingPosWithParams:(NSDictionary *)params andBlock:(void (^)(id data, NSError *error))block;
#pragma mark Trance
- (void)request_TranceWithParams:(NSDictionary *)params andBlock:(void (^)(id data, NSError *error))block;
#pragma mark Balance 余额
- (void)request_BalanceWithParams:(NSDictionary *)params andBlock:(void (^)(id data, NSError *error))block;
#pragma mark revoke 撤销
- (void)request_RevokeWithParams:(NSDictionary *)params andBlock:(void (^)(id data, NSError *error))block;
#pragma mark upLoad image  上传照片
- (void)request_UploadImageWithParrams:(NSDictionary *)params
                          andImageInfo:(NSDictionary *)imageInfo
                              andBlock:(void (^)(id data, NSError *error))block;
#pragma mark record  记录
- (void)request_RecordWithParams:(NSDictionary *)params andBlock:(void (^)(id data, NSError *error))block;

#pragma mark change pwd
- (void)request_changePwdWithParams:(NSDictionary *)params andBlock:(void (^)(id data, NSError *error))block;
#pragma mark Detail
- (void)request_DetailsWithParams:(NSDictionary *)params andBlock:(void (^)(id data, NSError *error))block;
#pragma mark Message
- (void)request_MessageWithParams:(NSDictionary *)params andBlock:(void (^)(id data, NSError *error))block;
#pragma mark Cash
- (void)request_CashWithParams:(NSDictionary *)params andBlock:(void (^)(id data, NSError *error))block;
#pragma mark ReplacePwd
- (void)request_ReplacePwdWithParams:(NSDictionary *)params andBlock:(void (^)(id data, NSError *error))block;
#pragma mark RaiseQuota
- (void)request_RaiseQuotaWithParams:(NSDictionary *)params andBlock:(void (^)(id data, NSError *error))block;
#pragma mark RaiseQuotaList
- (void)request_RaiseQuotaListWithParams:(NSDictionary *)params andBlock:(void (^)(id data, NSError *error))block;
#pragma mark NoticeList
- (void)request_NoticeListWithParams:(NSDictionary *)params andBlock:(void (^)(id data, NSError *error))block;
#pragma mark QuotaBack
- (void)request_QuotaBackWithParams:(NSDictionary *)params andBlock:(void (^)(id data, NSError *error))block;
#pragma mark CheckQuota
- (void)request_CheckQuotaWithParams:(NSDictionary *)params andBlock:(void (^)(id data, NSError *error))block;

@end
