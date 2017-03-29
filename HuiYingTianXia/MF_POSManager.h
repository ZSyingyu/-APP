//
//  MF_POSManager.h
//  HuiYingTianXia
//
//  Created by 朱颖宇 on 15/7/31.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "SDK/MPosController.h"
//#import "SDK/MPosDefine.h"

#import "SDK2/MPosController.h"
#import "SDK2/MPosDefine.h"
#import "MLTableAlert/MLTableAlert.h"

@protocol MF_POSMangerDelegate

@optional
- (void)swingcardCallback:(NSDictionary *)cardInfo;
- (void)getKsnCallback:(BOOL)status;
- (void)waitingForCardSwipe:(BOOL)status;
- (void)errorWithInfo:(NSDictionary *)info;
- (void)EmvOperationWaitiing;
- (void)getKsn;


@end

typedef enum {
    USE_UNKNOWN = 0,    // 未知
    USE_MARCARD,        // 使用磁条卡
    USE_IC,             // 使用IC卡
} EU_POS_CARDTYPE;

@interface MF_POSManager : NSObject<MPosDelegate>

@property(nonatomic, weak)NSObject <MF_POSMangerDelegate> *deleagte;

@property(strong,nonatomic)NSString *vouchNo;


@property (strong, nonatomic) NSData *resultData;

@property (strong, nonatomic) MPosController *posCtrl;
@property (assign, nonatomic) EU_POS_CARDTYPE cardType;
@property (assign, nonatomic) MFEU_MSR_EMV_PIN emvPinReq;
@property (strong, nonatomic) MLTableAlert *alert;

+ (NSString *)getTadeTypeStr:(TRADE_YTPE)tadeType;

+ (instancetype)shareInstance;
- (void)connectPos;
@end
