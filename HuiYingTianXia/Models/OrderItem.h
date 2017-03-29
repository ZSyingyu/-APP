//
//  OrderItem.h
//  HuiYingTianXia
//
//  Created by tsmc on 15/5/5.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderItem : NSObject <NSCoding>

@property(nonatomic, strong)NSString *acqAuthNo;//授权码
@property(nonatomic, strong)NSString *bankName; //银行名称
@property(nonatomic, strong)NSString *cardNo;   //银行卡号
@property(nonatomic, strong)NSString *completeTime;//交易完成时间
@property(nonatomic, strong)NSString *imageUrl; //图片路径
@property(nonatomic, strong)NSString *orderNo;  //订单号
@property(nonatomic, strong)NSString *status;   //交易状态
@property(nonatomic, strong)NSString *tradeType;//交易类型
@property(nonatomic, strong)NSString *strAmount;   //交易金额
@property(nonatomic, strong)NSString *termianlVoucherNo; //终端流水号
@property(nonatomic, strong)NSString *terminalBatchNo;   //终端批次号


@property(strong,nonatomic)NSString *bankPhone;//持卡人手机号

@property(strong,nonatomic)NSString *type;//图片类型

@property(nonatomic, strong)NSString *batchNo;   //批次号
@property(nonatomic, strong)NSString *termianlNo;//终端号
@property(nonatomic, strong)NSString *voucherNo; //流水号

@property(strong,nonatomic)NSString *payStatus;//提现状态
@property(strong,nonatomic)NSString *payResMsg;//提现状态描述

@property(nonatomic)int settleCycle;

@property(strong,nonatomic)NSArray *appPayment;//消费列表

@property(strong,nonatomic)NSString *completeTimeString;//交易完成时间
@property(strong,nonatomic)NSString *trxAmt;//交易金额
@property(strong,nonatomic)NSString *tradeTypeName;//交易类型
@property(strong,nonatomic)NSString *statusName;//状态名称

@property(strong,nonatomic)NSString *todayAmount;//今日消费金额
@property(strong,nonatomic)NSString *todayWithDraw;//可提现笔数
@property(strong,nonatomic)NSString *todayWithDrawSurplus;//剩余提现额度
@property(strong,nonatomic)NSString *rate;//交易费率
//@property(strong,nonatomic)NSString *status;//提现状态

@property(strong,nonatomic)NSString *tradeAmount;//七日消费金额
@property(strong,nonatomic)NSString *withDraw;//七日提现交易笔数
@property(strong,nonatomic)NSString *withDrawAmount;//七日提现交易金额

@property(strong,nonatomic)NSString *bankAccount;//提额数据中银行卡号
@property(strong,nonatomic)NSString *bankAccountName;//提额数据中银行卡姓名
@property(strong,nonatomic)NSString *idCardNumber;//提额数据中身份证号
@property(strong,nonatomic)NSArray *images;//提额数据中图片数组
@property(strong,nonatomic)NSString *increaseLimitStatus;//提额数据中审核状态
@property(strong,nonatomic)NSString *singleLimit;//提额数据中的申请额度
@property(strong,nonatomic)NSString *examineResult;//提额数据中的审核意见

//POS商户查询
@property(strong,nonatomic)NSString *strRate;
@property(strong,nonatomic)NSString *strMaxFee;

@end
