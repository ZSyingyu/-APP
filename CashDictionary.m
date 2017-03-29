//
//  CashDictionary.m
//  HuiYingTianXia
//
//  Created by 朱颖宇 on 15/7/27.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import "CashDictionary.h"

@implementation CashDictionary

+(NSDictionary *)cashDic {
    NSDictionary *sharedDic = @{
                                @"10A" : @"提现受理失败",
                                @"10B" : @"提现中",
                                @"10C" : @"提现成功",
                                @"10D" : @"提现失败"
                                };
    return sharedDic;
}

@end
