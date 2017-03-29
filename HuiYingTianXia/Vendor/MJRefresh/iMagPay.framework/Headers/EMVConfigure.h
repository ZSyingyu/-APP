//
//  EMVConfigure.h
//  iMagPay
//
//  Created by zheng wei on 15/7/17.
//  Copyright (c) 2015年 szzcs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMVApp.h"
#import "EMVCapk.h"
#import "EMVParam.h"

@interface EMVConfigure : NSObject{
    
}
-(void)setSlot:(Byte)slot;

-(void)setReadOnly:(BOOL)isReadOnly;

-(void)setMerchName:(NSString *)merchName;

-(void)setMerchCateCode:(NSString *)merchCateCode;

-(void)setMerchId:(NSString *)merchId;

-(void)setTermId:(NSString *)termId;

-(void)setTerminalType:(Byte)terminalType;

-(void)setCapability:(NSString *)capability;

-(void)setExCapability:(NSString *)exCapability;

-(void)setTransCurrExp:(Byte)transCurrExp;

-(void)setCountryCode:(NSString *)countryCode;

-(void)setTransCurrCode:(NSString *)transCurrCode;

-(void)setTransType:(TRANS_TYPE)transType;

-(void)setTermIFDSn:(NSString *)termIFDSn;

-(void)setAuthAmnt:(long)authAmnt;

-(void)setOtherAmnt:(long)otherAmnt;

-(void)setTransDate:(NSString *)transDate;

-(void)setTransTime:(NSString *)transTime;

-(void)addAID:(EMVApp *)aid;

-(void)addCAPK:(EMVCapk *)capk;

-(void)loadAIDs;

-(void)loadCAPKs;

-(EMVParam *)getEmvConfig;

@end
