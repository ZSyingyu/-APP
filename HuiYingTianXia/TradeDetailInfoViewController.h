//
//  TradeDetailInfoViewController.h
//  HuiYingTianXia
//
//  Created by 朱颖宇 on 15/9/29.
//  Copyright © 2015年 tsmc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface TradeDetailInfoViewController : BaseViewController

@property(strong,nonatomic)NSString *name;//商户名称
@property(strong,nonatomic)NSString *type;//交易类型
@property(strong,nonatomic)NSString *strRate;//交易费率
@property(strong,nonatomic)NSString *time;//交易时间
@property(strong,nonatomic)NSString *status;//交易状态
@property(strong,nonatomic)NSString *amount;//交易金额
@property(strong,nonatomic)NSString *maxFee;//封顶金额
@property(strong,nonatomic)NSString *cardNum;//交易卡号
@property(strong,nonatomic)NSString *tradeNum;//交易编号
@property(strong,nonatomic)NSString *authorizeNum;//授权码
@property(strong,nonatomic)NSString *imageUrl;//签名url

@end
