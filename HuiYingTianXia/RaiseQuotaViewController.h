//
//  RaiseQuotaViewController.h
//  HuiYingTianXia
//
//  Created by 朱颖宇 on 15/10/21.
//  Copyright © 2015年 tsmc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface RaiseQuotaViewController : BaseViewController
@property(strong,nonatomic)NSString *name;//姓名
@property(strong,nonatomic)NSString *cardid;//身份证号
@property(strong,nonatomic)NSString *bankname;//银行名称
@property(strong,nonatomic)NSString *banknumber;//银行卡号
@property(strong,nonatomic)NSString *status;//审核状态
@property(strong,nonatomic)NSString *quota;//提额额度
@property(strong,nonatomic)NSString *checkview;//审核意见
@property(strong,nonatomic)NSString *cardfronturl;//身份证正面图片url
@property(strong,nonatomic)NSString *cardbackurl;//身份证反面图片url
@property(strong,nonatomic)NSString *bankfronturl;//银行卡正面图片url
@property(strong,nonatomic)NSString *bankbackurl;//银行卡反面图片url
@property(strong,nonatomic)NSString *handcardurl;//手持图片url
@property(strong,nonatomic)NSString *phoneNo;//持卡人手机号

@end
