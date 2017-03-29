//
//  ACSwingCardViewController.m
//  HuiYingTianXia
//
//  Created by 朱颖宇 on 15/8/14.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import "ACSwingCardViewController.h"
#import "FLAnimatedImage.h"
#import "TTTAttributedLabel.h"
#import "NSString+Util.h"
#import "POSManger.h"
#import "AC_POSManger.h"
#import "MBProgressHUD+Add.h"
#import "CSwiperStateChangedListener.h"
#import "ItronCommunicationManagerBase.h"
#import "vcom.h"

#import "EnterPwdViewController.h"
#import "ConsumeViewController.h"

@interface ACSwingCardViewController ()<AC_POSMangerDelegate>
@property(nonatomic, strong)TTTAttributedLabel *labTip;

@end

NSString * text;
int ctrlFlag;
//bool readOldFileForiTronDevice = TRUE;

@implementation ACSwingCardViewController


@synthesize getKsnBtn = _getKsnBtn;
@synthesize cardInfoView = _cardInfoView;



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"检查刷卡器";
    [self setBackBarButtonItemWithTitle:@"返回"];
    
//    [self performSelector:@selector(delegateAction) withObject:nil afterDelay:3.0f];
    
    [[AC_POSManger shareInstance] setDeleagte:self];
    
    UIView *bView = [[UIView alloc]init];
    bView.backgroundColor = COLOR_THE_WHITE;
    [self.view addSubview:bView];
    [bView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(self.view.frame.origin.y + 150);
    }];
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"温情提示"]];
    imageView1.backgroundColor = [UIColor redColor];
    [self.view addSubview:imageView1];
    [imageView1 makeConstraints:^(MASConstraintMaker *make) {
        if (IPHONE4__4S) {
            make.top.equalTo(self.view).offset(HFixHeightBaseOn568(10));
        }else {
            make.top.equalTo(self.view).offset(HFixHeightBaseOn568(16));
        }
        make.centerX.equalTo(self.view);
        make.width.equalTo(imageView1.frame.size.width * 0.6);
        make.height.equalTo(imageView1.frame.size.height * 0.6);
    }];
    
    self.labTip = [[TTTAttributedLabel alloc] init];
    self.labTip.font = FONT_16;
    self.labTip.numberOfLines = 0;
    [self.labTip setTextAlignment:NSTextAlignmentLeft];
    [self.labTip setTextColor:COLOR_FONT_RED];
    //    [self.labTip setTextColor:COLOR_FONT_BLACK];
    //    self.labTip.text = @"磁条面向自己\n紧贴卡槽底部匀速刷过";
    self.labTip.text = @"   1.芯片卡请进行插卡操作\n\n   2.磁条面向自己紧贴卡槽底部匀速刷过";
    self.labTip.backgroundColor = COLOR_THE_WHITE;
    [self.view addSubview:self.labTip];
    
    CGSize size = [self.labTip.text suggestedSizeWithFont:self.labTip.font  width:SCREEN_WIDTH];
    [self.labTip makeConstraints:^(MASConstraintMaker *make) {
        //        if (IPHONE4__4S) {
        //            make.top.equalTo(self.view).offset(HFixHeightBaseOn568(70));
        //        }else {
        //            make.top.equalTo(self.view).offset(HFixHeightBaseOn568(110));
        //        }
        make.top.equalTo(imageView1.bottom).offset(0);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(size.height + 10);
    }];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"刷卡提示" ofType:@"gif"];
    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfFile:path]];
    FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
    imageView.animatedImage = image;
    [self.view addSubview:imageView];
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(image.size.height / 2);
    }];
}

//-(void)delegateAction {
//    [[AC_POSManger shareInstance] setDeleagte:self];
//}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //    [[POSManger shareInstance] magnCardWithAmount:[[POSManger transformAmountFormatWithStr:self.tadeAmount] integerValue]
    //                                         andBlock:^(BOOL result, NSString *message) {
    //                                             if (result) {
    //                                                 EnterPwdViewController *enterPwdVC =[[EnterPwdViewController alloc] init];
    //                                                 enterPwdVC.tadeType = self.tadeType;
    //                                                 enterPwdVC.tadeAmount = self.tadeAmount;
    //                                                 if (self.item) {
    //                                                     enterPwdVC.item = self.item;
    //                                                 }
    //                                                 [self.navigationController pushViewController:enterPwdVC animated:YES];
    //                                             }else {
    //                                                 NSLog(@"刷卡失败：%@",message);
    //                                                 if(self.tadeType == type_balance){
    //                                                     [self.navigationController.navigationBar setHidden:YES];
    //                                                 }
    //                                                 [self.navigationController popViewControllerAnimated:YES];
    //                                             }
    //                                         }];
    
    //    [[AC_POSManger shareInstance] setDeleagte:self];
}

- (void)backAction:(id)sender
{
    if(self.tadeType == type_balance){
        [self.navigationController.navigationBar setHidden:YES];
    }
    [super backAction:sender];
}



- (void)swipeICCardAction
{
    
    [m_vcom StopRec];
    
    //icBtn.userInteractionEnabled = NO;
    
    self.cardInfoView.text = @"ic卡刷";
    //ic卡刷卡命令
    
    //    NSString *str = @"123456";
    //    char *temp = HexToBin((char *)[str UTF8String]);
    //    char rom[100];
    //    memcpy(rom, temp, [str length]/2);//一定要拷贝否则会占用通一块内存
    
    
    //    NSString *appendData = @"49900003200015141399";
    //    char *temp1 = HexToBin((char*)[appendData UTF8String]);
    //    char appendDataChar[100];
    //    memcpy(appendDataChar, temp1, [appendData length]/2);//一定要拷贝否则会占用通一块内存
    //    int appendlen =[appendData length]/2;
    
    //    NSString *cash = @"100";//金额  单位为分
    NSString *cash = self.tadeAmount;
    NSLog(@"amount:%@",self.tadeAmount);
    int cashLen = [cash length];
    char cData[100];
    cData[0] = 0;
    strcpy(cData,((char*)[cash UTF8String]));
    //    NSLog(@"cash:%s",[cash UTF8String]);
    
    Transactioninfo *tranInfo = [[Transactioninfo alloc] init];
    
    //    it6=0/1 55域数据是否加密1011
    NSString *ctrm = @"8E000000";
    //    8E000000
    //    NSString *ctrm = @"25000000";
    //    NSString *ctrm = @"5b600000";
    char *temp2 = HexToBin((char*)[ctrm UTF8String]);
    char ctr[4];
    memcpy(ctr, temp2, [ctrm length]/2);
    
    [m_vcom stat_EmvSwiper:0 PINKeyIndex:1 DESKeyInex:1 MACKeyIndex:1 CtrlMode:ctr ParameterRandom:nil ParameterRandomLen:0 cash:cData cashLen:cashLen appendData:nil appendDataLen:0 time:30 Transactioninfo:tranInfo];
    [m_vcom StartRec];
    
}

#pragma mark AC_POSMangerDelegate

- (void)EmvOperationWaitiing{
    [MBProgressHUD showSuccess:@"正在读取银行卡,请勿拔卡!" toView:self.view];
    NSLog(@"-----------");
}


- (void)swingcardCallback:(NSDictionary *)cardInfo
{
    EnterPwdViewController *enterPwdVC =[[EnterPwdViewController alloc] init];
    enterPwdVC.tadeType = self.tadeType;
    enterPwdVC.rate = self.rate;
    enterPwdVC.tadeAmount = self.tadeAmount;
    enterPwdVC.cardInfo = cardInfo;
    //    NSInteger voucherNo = [self.voucherNo integerValue];
    
    
    //    self.voucherNo = [NSString stringWithFormat:@"%06zd",++voucherNo];
    
    //    enterPwdVC.voucherNo = [NSString stringWithFormat:@"%06zd",++voucherNo];
    enterPwdVC.voucherNo = [AC_POSManger shareInstance].vouchNo;
    NSLog(@"voucherNo:%@",enterPwdVC.voucherNo);
    enterPwdVC.originalVoucherNo = self.originalVoucherNo;
    NSLog(@"originalVoucherNo:%@",enterPwdVC.originalVoucherNo);
    
    enterPwdVC.batchNo = self.batchNo;
    if (self.absItem) {
        enterPwdVC.absItem = self.absItem;
    }
    [self.navigationController pushViewController:enterPwdVC animated:YES];
}

- (void)errorWithInfo:(NSDictionary *)info
{
    NSError *error = [NSError errorWithDomain:@"error" code:0 userInfo:@{@"NSLocalizedDescription":@"刷卡器超时"}];
    [self showStatusBarError:error];
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
