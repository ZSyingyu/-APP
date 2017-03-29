//
//  AC_POSManger.h
//  HuiYingTianXia
//
//  Created by tsmc on 15/5/16.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "vcom.h"
@protocol AC_POSMangerDelegate

@optional
- (void)swingcardCallback:(NSDictionary *)cardInfo;
- (void)getKsnCallback:(BOOL)status;
- (void)waitingForCardSwipe:(BOOL)status;
- (void)errorWithInfo:(NSDictionary *)info;
- (void)EmvOperationWaitiing;
@end


@interface AC_POSManger : NSObject<CSwiperStateChangedListener>
{
    vcom* m_vcom;
}
@property(nonatomic, weak)NSObject <AC_POSMangerDelegate> *deleagte;

@property(strong,nonatomic)NSString *vouchNo;
@property(strong,nonatomic)NSString *amount;
@property(nonatomic, assign)TRADE_YTPE tadeType;

+ (instancetype)shareInstance;
- (void)openAndBanding;//余额
//- (void)openAndBandingSale;//消费
@end
