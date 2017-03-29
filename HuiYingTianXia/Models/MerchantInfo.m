//
//  MerchantInfo.m
//  HuiYingTianXia
//
//  Created by 朱颖宇 on 15/6/30.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import "MerchantInfo.h"

@implementation MerchantInfo

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.merchantNumber forKey:MerchantNo];
    [aCoder encodeObject:self.personID forKey:CardID];
    [aCoder encodeObject:self.bankCardNO forKey:CardNumber];
    [aCoder encodeObject:self.bankName forKey:BankName];
    
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    _merchantNumber = [aDecoder decodeObjectForKey:MerchantNo];
    _personID = [aDecoder decodeObjectForKey:CardID];
    _bankCardNO = [aDecoder decodeObjectForKey:CardNumber];
    _bankName = [aDecoder decodeObjectForKey:BankName];
    
    return self;
}

@end
