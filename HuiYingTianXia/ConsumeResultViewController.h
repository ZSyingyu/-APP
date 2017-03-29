//
//  ConsumeResultViewController.h
//  HuiYingTianXia
//
//  Created by tsmc on 15-3-19.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface ConsumeResultViewController : BaseViewController
@property(nonatomic, assign)RESULT_STATUS resultStatus;
@property(nonatomic, strong)NSString *imagUrl;
@property(nonatomic, strong)UIImage *signImage;
@property(nonatomic, strong)NSDictionary *cardInfo;
@end
