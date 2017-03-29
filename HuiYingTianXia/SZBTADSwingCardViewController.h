//
//  SZBTADSwingCardViewController.h
//  HuiYingTianXia
//
//  Created by liguo.chen on 16/5/19.
//  Copyright © 2016年 tsmc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "vcom.h"
#import <Foundation/Foundation.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MessageUI.h>
#import "CSwiperStateChangedListener.h"
#import "AnFSwiperController.h"
#import "MBProgressHUD.h"
#import "DeviceParams.h"

@interface SZBTADSwingCardViewController : BaseViewController<CSwiperStateChangedListener,UITextViewDelegate,MFMailComposeViewControllerDelegate,AnFSwiperControllerDelegate, MBProgressHUDDelegate, UIActionSheetDelegate>



{
    vcom* m_vcom;
    UITextView *_cardInfoView;
    id timer;
    id timerForAishua;
    
    //神州安付刷卡头
    NSMutableArray *arrayTable;
    
    AnFSwiperController *blue;
    MBProgressHUD *waitView;
    NSArray *arrayTitle;
    
    NSMutableDictionary *dicInfo;
    NSMutableDictionary *dicCurrect;
    NSMutableArray *deviceArrayList;//设备列表
    
    DeviceParams *deviceParams;
    
    int count;
}
@property (nonatomic,retain) UITextView *cardInfoView;
@property (nonatomic,retain) UIButton *getKsnBtn;
@property (nonatomic,retain) UIButton *swipeCardBtn;
@property (nonatomic,retain) UIButton *stopBtn;
@property(strong,nonatomic)NSString *vouchNo;


//神州安付
@property (nonatomic, retain) NSString *stringIsICCard;//卡类型

@property (nonatomic, retain) NSString *stringExpired;//失效日期
@property (nonatomic, retain) NSString *stringRandom;//随机数
@property (nonatomic, retain) NSString *stringCardNo;//卡号
@property (nonatomic, retain) NSString *stringTrackTwoData;//track2
@property (nonatomic, retain) NSString *stringTrackTwoThreadData;//track2+track3
@property (nonatomic, retain) NSString *stringCardSN;//序号
@property(nonatomic, retain) NSString *stringICData; //55域


-(void)refreshSwipeDisplay:(NSString *)displayData;



//启动录音，启动数据接收
-(void) StartRec;

//停止录音，停止数据接收
-(void)StopRec;

@end
