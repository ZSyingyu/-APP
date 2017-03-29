//
//  BankViewController.h
//  HuiYingTianXia
//
//  Created by 朱颖宇 on 15/6/18.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef void(^selectedBankBlock)(NSString *code, NSString *name);

@interface BankViewController : BaseViewController <UITableViewDelegate,UITableViewDataSource>

- (instancetype)initWithSelectedBankBlock:(selectedBankBlock)block;

@property(strong,nonatomic) NSArray *dataArray;


@end
