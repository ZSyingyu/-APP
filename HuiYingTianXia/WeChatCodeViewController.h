//
//  WeChatCodeViewController.h
//  HuiYingTianXia
//
//  Created by liguo.chen on 16/9/20.
//  Copyright © 2016年 tsmc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface WeChatCodeViewController : BaseViewController
@property(strong,nonatomic)NSString *codeUrlStr;
@property(strong,nonatomic)NSString *amountStr;
@property(strong,nonatomic)NSString *orderNumberStr;
@property(strong,nonatomic)NSString *feetRate;

@property (nonatomic,strong) NSString *clickButtonStatus;//按钮点击状态
@end
