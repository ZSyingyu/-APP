//
//  OrderItem.m
//  HuiYingTianXia
//
//  Created by tsmc on 15/5/5.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import "OrderItem.h"

@implementation OrderItem
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.batchNo forKey:BatchNum];
    [aCoder encodeObject:self.termianlNo forKey:TerminalNo];
    [aCoder encodeObject:self.voucherNo forKey:VoucherNo];
    
    [aCoder encodeObject:self.type forKey:ImageType];
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    _batchNo = [aDecoder decodeObjectForKey:BatchNum];
    _termianlNo = [aDecoder decodeObjectForKey:TerminalNo];
    _voucherNo = [aDecoder decodeObjectForKey:VoucherNo];
    
    _type = [aDecoder decodeObjectForKey:ImageType];
    
    return self;
}
@end
