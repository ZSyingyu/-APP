//
//  AbstractItems.m
//  HuiYingTianXia
//
//  Created by tsmc on 15-4-9.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import "AbstractItems.h"
@implementation AbstractItems

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.n0 = @"0700";
        self.n59 = @"LMD-1.0.1";
//        self.n59 = @"JSZF-1.0.0";
    }
    return self;
}
@end
