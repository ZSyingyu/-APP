//
//  MerchantInfo.h
//  HuiYingTianXia
//
//  Created by 朱颖宇 on 15/6/30.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MerchantInfo : NSObject <NSCoding>

@property(strong,nonatomic)NSString *merchantNumber;//商户号
@property(strong,nonatomic)NSString *personID;//身份证号
@property(strong,nonatomic)NSString *bankCardNO;//银行卡号
//@property(strong,nonatomic)NSString *phoneNO;//手机号码
@property(strong,nonatomic)NSString *bankName;//银行名称



@end
