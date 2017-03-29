//
//  BaseViewController.h
//  HuiYingTianXia
//
//  Created by tsmc on 15-3-18.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderItem.h"
#import "AbstractItems.h"

@interface BaseViewController : UIViewController
@property(nonatomic, assign)TRADE_YTPE tadeType;
@property(nonatomic, strong)NSString *tadeAmount;
@property(nonatomic, strong)OrderItem *orderItem;
@property(nonatomic, strong)AbstractItems *absItem;
@property(strong,nonatomic)NSString *rate;//费率
//@property(strong,nonatomic)NSString *strRate;//输入密码界面展示的费率

@property(strong,nonatomic)NSString *voucherNo;


@property(strong,nonatomic)NSString *originalVoucherNo;//原终端号

@property(strong,nonatomic)NSString *batchNo;
@property(strong,nonatomic)NSString *cardNumber;//交易卡号
@property(strong,nonatomic)NSString *orderNo;//订单号

@property(strong,nonatomic)NSString *merchantNumber;//商户号

@property(strong,nonatomic)NSString *flag;//区分刷卡头的标识

@property(strong,nonatomic)NSMutableDictionary *noticeDic;//公告字典


- (void)setBackBarButtonItemWithTitle:(NSString *)title;
- (void)setRightBarButtonItemWithTitle:(NSString *)title;
- (void)setNavTitle:(NSString *)title;
- (void)setHomeBackBarButtonItemWithTitle:(NSString *)title;
- (void)setBackBarButtonItemWithRealTitle:(NSString *)title;

- (void)setPOSBackBarButtonItemWithTitle:(NSString *)title;

- (void)backAction:(id)sender;


#pragma mark UIKeyboardNotification
- (void)addKeyboardNotification;
- (void)removeKeyboardNotification;
- (void)inputKeyboardWillShow:(NSNotification *)notification;
- (void)inputKeyboardWillHide:(NSNotification *)notification;


#pragma mark UIAlertView
- (void)showAlterViewWithTitle:(NSString *)title message:(NSString *)message btnTitles:(NSArray *)btnTitles;
- (void)alterBtnAction:(UIButton *)btn;


//去掉导航栏下面的黑线
-(void)dismissLine;
@end
