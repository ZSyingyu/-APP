//
//  SZBlueSwingCardViewController.h
//  HuiYingTianXia
//
//  Created by liguo.chen on 16/9/8.
//  Copyright © 2016年 tsmc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <Foundation/Foundation.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MessageUI.h>

#import "AnFSwiperController.h"
#import "MBProgressHUD.h"
#import "DeviceParams.h"

@interface SZBlueSwingCardViewController : BaseViewController<UITextViewDelegate,MFMailComposeViewControllerDelegate,UITableViewDelegate,UITableViewDataSource,AnFSwiperControllerDelegate, UIActionSheetDelegate,MBProgressHUDDelegate>

{
    NSMutableArray *arrayTable;
    
    AnFSwiperController *blue;
    MBProgressHUD *waitView;
    
    NSArray *arrayTitle;
    
    NSDictionary *dicInfo;
    NSMutableDictionary *dicCurrect;
    NSMutableArray *deviceArrayList;//设备列表
    
    DeviceParams *deviceParams;
    
    int count;
    NSTimer *timer;
}

@property (nonatomic,retain) UITextView *cardInfoView;
@property (nonatomic,retain) UIButton *getKsnBtn;
@property (nonatomic,retain) UIButton *swipeCardBtn;
@property (nonatomic,retain) UIButton *stopBtn;
@property(strong,nonatomic)NSString *vouchNo;


-(void)refreshSwipeDisplay:(NSString *)displayData;


@property (nonatomic, retain) NSString *stringIsICCard;//卡类型

@property (nonatomic, retain) NSString *stringExpired;//失效日期
@property (nonatomic, retain) NSString *stringRandom;//随机数
@property (nonatomic, retain) NSString *stringCardNo;//卡号
@property (nonatomic, retain) NSString *stringTrackTwoData;//track2
@property (nonatomic, retain) NSString *stringTrackTwoThreadData;//track2+track3
@property (nonatomic, retain) NSString *stringCardSN;//序号
@property(nonatomic, retain) NSString *stringICData; //55域

@end
