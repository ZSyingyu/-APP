//
//  ACSwingCardViewController.h
//  HuiYingTianXia
//
//  Created by 朱颖宇 on 15/8/14.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "vcom.h"
#import <Foundation/Foundation.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MessageUI.h>
#import "CSwiperStateChangedListener.h"

@interface ACSwingCardViewController : BaseViewController<CSwiperStateChangedListener,UITextViewDelegate,MFMailComposeViewControllerDelegate>



{
    vcom* m_vcom;
    UITextView *_cardInfoView;
    id timer;
    id timerForAishua;
}
@property (nonatomic,retain) UITextView *cardInfoView;
@property (nonatomic,retain) UIButton *getKsnBtn;
@property (nonatomic,retain) UIButton *swipeCardBtn;
@property (nonatomic,retain) UIButton *stopBtn;

-(void)refreshSwipeDisplay:(NSString *)displayData;

//-(void) stat_EmvSwiper:(int)mode
//           PINKeyIndex:(int)_PINKeyIndex
//            DESKeyInex:(int)_DESKeyIndex
//           MACKeyIndex:(int)_MACKeyIndex
//              CtrlMode:(char*)_CtrlMode
//       ParameterRandom:(char*)_ParameterRandom
//    ParameterRandomLen:(int)_ParameterRandomLen
//                  cash:(char*)_cash
//               cashLen:(int)_cashLen
//            appendData:(char*)_appendData
//         appendDataLen:(int)_appendDataLen
//                  time:(int)_time
//       Transactioninfo:(Transactioninfo *) transactioninfo;

//启动录音，启动数据接收
-(void) StartRec;

//停止录音，停止数据接收
-(void)StopRec;

@end
