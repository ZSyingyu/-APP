//
//  TradeRecordViewController.h
//  HuiYingTianXia
//
//  Created by 朱颖宇 on 15/8/24.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface TradeRecordViewController : BaseViewController



- (void)setRightBarButtonItemWithTitle:(NSString *)title;

@property(nonatomic, strong)NSDictionary *cardInfo;


@end
