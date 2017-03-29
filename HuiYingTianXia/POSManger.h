//
//  POSManger.h
//  HuiYingTianXia
//
//  Created by tsmc on 15-4-15.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommunicationCallBack.h"

typedef void (^OpenDevBlock )(BOOL result, NSString *message);
typedef void (^CallBackBlock )(BOOL result, NSString *message);
typedef void (^NumberB )(BOOL result, NSString *message);

@interface POSManger : NSObject
@property(nonatomic, copy)OpenDevBlock openDevBlock;
@property(nonatomic, copy)void(^readNumberBlock)(BOOL result, NSString *message) ;
@property(nonatomic, copy)void(^readSNBlock)(BOOL result, NSString *message) ;
@property(nonatomic, copy)void(^writeTernumberBlock)(BOOL result, NSString *message) ;
@property(nonatomic, copy)void(^writeWorkKeyBlock)(BOOL result, NSString *message) ;
@property(nonatomic, copy)void(^writeMainKeyBlock)(BOOL result, NSString *message) ;
@property(nonatomic, copy)void(^magnCardBlock)(BOOL result, NSString *message) ;
@property(nonatomic, copy)void(^tranceBlock)(BOOL result, FieldTrackData data) ;
@property(nonatomic, copy)void(^getMacBlock)(BOOL result, NSString *message) ;
@property(nonatomic, assign)long amount;

+ (instancetype)shareInstance;
-(void)openDeviceWithBlock:(OpenDevBlock)block;
- (void)closeDevice;
- (void)closeResource;
- (void)exchangeData;

//打开终端 如未绑定进行绑定
- (void)openAndBandingWithBolck:(void (^)(BOOL result, NSString *message))block;
//功能描述：读取SN号版本号
-(int)readSnVersionWithSNBlock:(void (^)(BOOL result, NSString *message))block;
//功能描述：读取终端号商户号
-(int)readTernumberWithNumberBlock:(void (^)(BOOL result, NSString *message))block;
//功能描述：写入终端号商户号
-(int)writeTernumber:(NSString*)dataTernumber andBlock:(void(^)(BOOL result, NSString *message))block;
//功能描述：写入工作密钥
-(int)WriteWorkKeyLength:(NSInteger)len andWorkkey:(NSString*)workkey andWriteKeyBlock:(void (^)(BOOL result, NSString *message))block;
//功能描述：写入主密钥
-(int)WriteMainKeyWithLenth:(int)lenth andDatakey:(NSString*)Datakey withBlock:(void(^)(BOOL result, NSString *message))block;
//功能描述：刷卡
-(void)magnCardWithAmount:(long)amount andBlock:(void (^)(BOOL result, NSString *message))block;
//功能描述：消费,返回消费需要上送数据22域+35+36+IC磁道数据+PINBLOCK+磁道加密随机数
-(int)TRANS_SaleTimeOut:(long)timeout andAmount:(long)nAmount andPWDLength:(int)pwdLength andPWD:(NSString*)pwd andBlock:(void (^)(BOOL result, FieldTrackData data))block;
//获取MAC值
-(int)GetMacWithLength:(NSInteger)length andMackey:(NSString*)mackey andBlock:(void (^)(BOOL result, NSString *message))block;

//普通字符串转换为十六进制的
-(NSString *)hexBytToString:(unsigned char *)byteData:(int)Datalen;

//转化 金额格式
+ (NSString *)transformAmountFormatWithStr:(NSString *)amount;
+ (NSString *)transformAmountWithPoint:(NSString *)amount;
+ (NSString *)getTadeTypeStr:(TRADE_YTPE)tadeType;
@end
