//
//  XNBTADSwingCardViewController.h
//  HuiYingTianXia
//
//  Created by liguo.chen on 15/11/18.
//  Copyright © 2015年 tsmc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"
#import <Foundation/Foundation.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MessageUI.h>

#import "vcom.h"
#import <Foundation/Foundation.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MessageUI.h>
#import "CSwiperStateChangedListener.h"

#import <iMagPay/EMVConfigure.h>
#import <iMagPay/BluetoothHandler.h>

@interface XNBTADSwingCardViewController : BaseViewController<UITextViewDelegate,MFMailComposeViewControllerDelegate,UITableViewDelegate,UITableViewDataSource>

{
    vcom* m_vcom;
    UITextView *_cardInfoView;
    id timer;
    id timerForAishua;
    UILabel *tip;
    UITextView *resShow;
}

@property (strong, nonatomic)  UITableView *tableView;
@property (strong, nonatomic) NSMutableArray* myPeripherals;
@property (strong, nonatomic) CBPeripheral* myPeripheral;
- (void)connect:(id)sender;
- (void)cancel:(id)sender;
- (void)sn;
- (void)ver:(id)sender;
- (void)tmk:(id)sender;
- (void)twk:(id)sender;
- (void)mac:(id)sender;
- (void)pin:(id)sender;
- (void)plain:(id)sender;

@property (nonatomic,retain) UITextView *cardInfoView;
@property (nonatomic,retain) UIButton *getKsnBtn;
@property (nonatomic,retain) UIButton *swipeCardBtn;
@property (nonatomic,retain) UIButton *stopBtn;
@property(strong,nonatomic)NSString *vouchNo;


-(void)refreshSwipeDisplay:(NSString *)displayData;



//启动录音，启动数据接收
-(void) StartRec;

//停止录音，停止数据接收
-(void)StopRec;

@end
