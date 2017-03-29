//
//  MFBTADSwingCardViewController.h
//  HuiYingTianXia
//
//  Created by liguo.chen on 15/11/9.
//  Copyright © 2015年 tsmc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "vcom.h"
#import <Foundation/Foundation.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MessageUI.h>
#import "CSwiperStateChangedListener.h"

@interface MFBTADSwingCardViewController : BaseViewController<CSwiperStateChangedListener,UITextViewDelegate,MFMailComposeViewControllerDelegate>



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
@property(strong,nonatomic)NSString *vouchNo;


-(void)refreshSwipeDisplay:(NSString *)displayData;



//启动录音，启动数据接收
-(void) StartRec;

//停止录音，停止数据接收
-(void)StopRec;


@end
