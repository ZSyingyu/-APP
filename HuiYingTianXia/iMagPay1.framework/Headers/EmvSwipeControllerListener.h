//
//  EmvSwipeControllerListener.h
//  iMagPay
//
//  Created by zheng wei on 15/12/11.
//  Copyright © 2015年 szzcs. All rights reserved.
//
//  用于带按键,LED一体MPOS蓝牙机型IC卡操作接口
#import <Foundation/Foundation.h>

@protocol EmvSwipeControllerListener <NSObject>
//返回2磁道加密数据
@optional
-(void)onReturnEmvCardEncTrack2Data:(NSString *)track2 :(int)len;
@required
//返回55域
-(void)onReturnEmvCardDataResult:(NSString *)ic55field;
//返回主账号
-(void)onReturnEmvCardPAN:(NSString *)pan;
//返回有效期
-(void)onReturnEmvCardExpiryDate:(NSString *)date;
//返回服务代码
-(void)onReturnEmvCardServiceCode:(NSString *)code;
//返回2磁道数据
-(void)onReturnEmvCardTrack2Data:(NSString *)track2 :(int)len;
//返回IC序列号(5F34)
-(void)onReturnEmvCardSeqNumber:(NSString *)seq;
//EMV流程结束
-(void)onEmvProcessFinished;
//EMV流程失败
-(void)onEmvProcessFailed;
@end
