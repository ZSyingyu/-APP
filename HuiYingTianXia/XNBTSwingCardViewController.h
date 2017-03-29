//
//  XNBTSwingCardViewController.h
//  HuiYingTianXia
//
//  Created by 朱颖宇 on 15/8/19.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <Foundation/Foundation.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MessageUI.h>

@interface XNBTSwingCardViewController : BaseViewController<UITextViewDelegate,MFMailComposeViewControllerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain) UITextView *cardInfoView;
@property (nonatomic,retain) UIButton *getKsnBtn;
@property (nonatomic,retain) UIButton *swipeCardBtn;
@property (nonatomic,retain) UIButton *stopBtn;
@property(strong,nonatomic)NSString *vouchNo;


-(void)refreshSwipeDisplay:(NSString *)displayData;

@end
