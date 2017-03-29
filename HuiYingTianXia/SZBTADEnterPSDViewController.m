//
//  SZBTADEnterPSDViewController.m
//  HuiYingTianXia
//
//  Created by liguo.chen on 16/5/20.
//  Copyright © 2016年 tsmc. All rights reserved.
//

#import "SZBTADEnterPSDViewController.h"
#import "ConsumeResultCell.h"
#import "KeyBoardView.h"
#import "SignViewController.h"
#import "ConsumeResultViewController.h"
#import "POSManger.h"
#import "AC_POSManger.h"
#import "NetAPIManger.h"
#import "AbstractItems.h"
#import "MJExtension.h"
#import "NSString+MD5HexDigest.h"
#import "ComMethod.h"
#import "POSManger.h"
#import "ResponseDictionaryTool.h"
#import "MBProgressHUD+Add.h"
#import "HomePageViewController.h"
#import "SwingCardViewController.h"
#import "QueryrRecordViewController.h"
#import "MerchantInfo.h"
#import "ConsumeViewController.h"
#import "MFADConsumeViewController.h"
#import "MFBTConsumeViewController.h"
#import "RateViewController.h"
//#import "NewRateViewController.h"

@interface SZBTADEnterPSDViewController ()<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>

@property(nonatomic, strong)UIScrollView *baseView;
@property(nonatomic, strong)UIButton *btnCancle;
@property(nonatomic, strong)UIButton *btnConfirm;
@property(nonatomic, strong)UIButton *btnMaskLayer;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSArray *btnTitles;
@property(nonatomic, strong)KeyBoardView *keyBoardView;
@property(nonatomic, strong)NSString *merchantName;

@property(strong,nonatomic)UITextField *tfPwd;//输入的密码

@property(strong,nonatomic)UIAlertView *alertView;//弹出框
@property(strong,nonatomic)UILabel *titleLabel;//弹出框标题
@property(strong,nonatomic)UIView *lineView1;//分割线
@property(strong,nonatomic)UILabel *amountLabel;//金额
@property(strong,nonatomic)UIView *lineView2;//分割线
@property(strong,nonatomic)UILabel *numLabel;//银行卡号标签
@property(strong,nonatomic)UILabel *cardNumLabel;//银行卡号显示
@property(strong,nonatomic)UIButton *cancleButton;//弹出框取消按钮
@property(strong,nonatomic)UIButton *confirmButton;//弹出框确定按钮
@property(strong,nonatomic)UIView *coverView;//蒙板
@property(strong,nonatomic)NSMutableArray *nums;//输入框数字数组
@property(strong,nonatomic)NSMutableString *pwd;//密码串

@property(strong,nonatomic)NSString *strRate;//输入密码界面展示的费率

- (void)showKeyboard;
- (void)hideKeyboardAction;

@end


#define CELL__HEIGHT             HFixWidthBaseOn320(34)


static NSString *LableIdenfity = @"Lable";
static NSString *TextFielddenfity = @"TextField";

@implementation SZBTADEnterPSDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"输入密码";
    //[self setBackBarButtonItemWithTitle:@"返回"];
    [self.navigationItem setHidesBackButton:YES];
    
    self.baseView = [[UIScrollView alloc] init];
    [self.baseView setBackgroundColor:[UIColor clearColor]];
    
    //新添加代码
    [self.baseView setFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 240)/2., 40, 240, 40)];
    [self.baseView.layer setBorderColor:[UIColor clearColor].CGColor];
    [self.baseView.layer setBorderWidth:1];
    [self.baseView.layer setMasksToBounds:YES];
    [self.baseView.layer setCornerRadius:5];
    
    [self.view addSubview:self.baseView];
    [self.baseView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.width.equalTo(SCREEN_WIDTH);
    }];
    
    self.merchantName = [[NSUserDefaults standardUserDefaults] objectForKey:MerchantName];
    self.btnTitles = nil;
    if (self.tadeType == type_consument ) {
        if(self.merchantName.length > 0){
            self.btnTitles = @[@"商户名称",
                               @"交易类型",
                               @"交易卡号",
                               @"交易费率",
                               @"金       额",
                               @"密       码"];
        }else {
            self.btnTitles = @[@"交易类型",
                               @"交易卡号",
                               @"交易费率",
                               @"金       额",
                               @"密       码"];
        }
    }else if (self.tadeType == type_balance || self.tadeType == type_revoke){
        if(self.merchantName.length > 0){
            self.btnTitles = @[@"商户名称",
                               @"交易类型",
                               @"交易卡号",
                               @"密       码"];
        }else {
            self.btnTitles = @[@"交易类型",
                               @"交易卡号",
                               @"密       码"];
        }
    }
    //    if(self.merchantName.length > 0){
    //        self.btnTitles = @[@"商户名称",
    //                           @"交易类型",
    //                           @"交易卡号",
    //                           @"金       额",
    //                           @"密       码"];
    //    }else {
    //        self.btnTitles = @[@"交易类型",
    //                           @"交易卡号",
    //                           @"金       额",
    //                           @"密       码"];
    //    }
    
    self.tableView = [[UITableView alloc] init];
    [self.tableView registerClass:[ConsumeResultCell class] forCellReuseIdentifier:LableIdenfity];
    [self.tableView registerClass:[ConsumeResultCell class] forCellReuseIdentifier:TextFielddenfity];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.baseView addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView).offset(8);
        make.left.equalTo(self.baseView);
        make.right.equalTo(self.baseView);
        make.width.equalTo(SCREEN_WIDTH);
        make.height.equalTo(CELL__HEIGHT * self.btnTitles.count);
    }];
    
    self.btnCancle = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:COLOR_FONT_GRAY];
        [btn.titleLabel setTextColor:COLOR_MY_WHITE];
        [btn setTitle:@"取消付款" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    [self.baseView addSubview:self.btnCancle];
    [self.btnCancle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.bottom).offset(HFixHeightBaseOn568(15));
        make.left.equalTo(self.baseView).offset(HFixWidthBaseOn320(10));
        make.width.equalTo(SCREEN_WIDTH / 2.f - HFixWidthBaseOn320(10));
        make.height.equalTo(BNT_HEIGHT);
    }];
    
    self.btnConfirm = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:COLOR_THEME];
        [btn.titleLabel setTextColor:COLOR_MY_WHITE];
        [btn setTitle:@"确认付款" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    [self.baseView addSubview:self.btnConfirm];
    [self.btnConfirm makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnCancle);
        make.left.equalTo(self.btnCancle.right);
        make.width.equalTo(self.btnCancle);
        make.height.equalTo(self.btnCancle);
    }];
    
    
    
    self.btnMaskLayer = ({
        UIButton *btn = [[UIButton alloc] initWithFrame:self.view.bounds];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn setTitleColor:COLOR_MY_WHITE forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(hideKeyboardAction) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    [self.view addSubview:self.btnMaskLayer];
    [self.btnMaskLayer setHidden:YES];
    
    [self getKeyBoardView];
    
    
    //一旦进入输入密码界面就弹出键盘
//    NSIndexPath *path = [NSIndexPath indexPathForRow:self.btnTitles.count - 1 inSection:0];
//    ConsumeResultCell *cell = (ConsumeResultCell *)[self.tableView cellForRowAtIndexPath:path];
//    UITextField *tf = cell.tfContent;
//    if ([tf.text length] == 0) {
//        tf.placeholder = @"";
//    }
//    
//    CGFloat y = CGRectGetMaxY(self.btnConfirm.frame);
//    [UIView animateKeyframesWithDuration:0.25 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
//        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
//        CGFloat keyboardH  = [KeyBoardView getHeight];
//        [self.keyBoardView updateConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.view.bottom).offset(-keyboardH);
//        }];
//        CGFloat offsety = keyboardH - (SCREEN_HEIGHT - y - 64);
//        [self.baseView setContentOffset:CGPointMake(0, offsety>0? offsety:0)];
//    } completion:^(BOOL finished) {
//        [self.btnMaskLayer setHidden:NO];
//        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
//    }];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self showKeyboard];
}

- (void)getKeyBoardView
{
    __unsafe_unretained SZBTADEnterPSDViewController *weakSelf = self;
    self.keyBoardView = [[KeyBoardView alloc] init];
    self.keyBoardView.keyBoardClick = ^(NSInteger number){
        
        NSIndexPath *path = [NSIndexPath indexPathForRow:weakSelf.btnTitles.count-1 inSection:0];
        ConsumeResultCell *cell = (ConsumeResultCell *)[weakSelf.tableView cellForRowAtIndexPath:path];
        NSMutableString *content = [NSMutableString stringWithString:cell.tfContent.text];
        switch (number) {
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
            case 7:
            case 8:
            case 9:
                if (content.length < 6) {
                    [content appendString:[NSString stringWithFormat:@"%zd",number]];
                }
                break;
            case 11:
                if (content.length < 6) {
                    [content appendString:@"0"];
                }
                break;
            case 10://clear
                content = [NSMutableString stringWithString:@""];
                break;
            case 12://delete
                if (content.length > 0) {
                    [content deleteCharactersInRange:NSMakeRange(content.length-1, 1)];
                }
                break;
            default:
                break;
        }
        cell.tfContent.text = content;
    };
    [self.view addSubview:self.keyBoardView];
    [self.keyBoardView updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view.bottom);
        make.height.equalTo([KeyBoardView getHeight]);
    }];
}

- (void)cancleAction
{
    //    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"取消当前交易" message:nil delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    //    [alterView show];
//    if (self.tadeType == type_balance) {
        HomePageViewController *homeVc = [[HomePageViewController alloc] init];
        [self.navigationController pushViewController:homeVc animated:YES];
//    }else {
//        RateViewController *rateVc = [[RateViewController alloc] init];
//        [self.navigationController pushViewController:rateVc animated:YES];
//    }
    
}

- (void)confirmAction
{
    NSIndexPath *path = [NSIndexPath indexPathForRow:self.btnTitles.count - 1 inSection:0];
    ConsumeResultCell *cell = (ConsumeResultCell *)[self.tableView cellForRowAtIndexPath:path];
    UITextField *tf = cell.tfContent;
    
    if (tf.text.length < 6 && tf.text.length > 0) {
        [MBProgressHUD showError:@"请输入正确的密码" toView:self.view];
    }
    
    if ([tf.text length] != 0 && tf.text.length == 6) {
        NSData *archiveData = [[NSUserDefaults standardUserDefaults] objectForKey:TranceInfo];
        NSArray *infos = nil;
        if (archiveData) {
            infos = [NSKeyedUnarchiver unarchiveObjectWithData:archiveData];
        }
        NSString *termianlNo = [[NSUserDefaults standardUserDefaults] objectForKey:TerminalNo];
        NSString *batchNo = nil;//批次号
        NSInteger voucherNo = 0;//流水号
        OrderItem *orderItem = nil;
        for (OrderItem *item in infos) {
            if ([item.termianlNo isEqualToString:termianlNo]) {
                voucherNo = [item.voucherNo integerValue];
                //NSLog(@"%ld",voucherNo);
                batchNo = item.batchNo;
                orderItem = item;
            }
        }
        
        AbstractItems *item = [[AbstractItems alloc] init];
        item.n0 = @"0200";              //消息类型
        item.n4 = [POSManger transformAmountFormatWithStr:self.tadeAmount];     //交易金额12位
        //        item.n11 = [NSString stringWithFormat:@"%06zd",++voucherNo];            //交易流水号  进行递增
        //        item.n11 = @"000521";
        item.n11 = self.voucherNo;
        NSLog(@"n11:%@",item.n11);
        item.n14 = [self.cardInfo objectForKey:@"expiryDate"];//卡有效期
        item.n35 = [[self.cardInfo objectForKey:@"track2"] uppercaseString];//磁道数据
        item.n41 = [[NSUserDefaults standardUserDefaults] valueForKey:TerminalNo];//终端号
        item.n42 = [[NSUserDefaults standardUserDefaults] valueForKey:MerchantNo];
        
        item.n49 = @"156";//交易货币代码
        NSString *workKey = [[NSUserDefaults standardUserDefaults] objectForKey:WokeKey];
        
        //NSLog(@"workKey:%@",workKey);
        
        if(workKey.length > 5){
            workKey = [workKey substringToIndex:6];
            NSLog(@"workKey:%@",workKey);
        }
        NSData* mydata = [tf.text dataUsingEncoding:NSUTF8StringEncoding];
        uint8_t byteArray[[mydata length]];
        [mydata getBytes:&byteArray];
        for (int i = 0; i<[mydata length]; i++) {
            char byte = byteArray[i];
            NSLog(@"%c",byte);
        }
        
        mydata = [workKey dataUsingEncoding:NSUTF8StringEncoding];
        uint8_t workByteArray[[mydata length]];
        [mydata getBytes:&workByteArray];
        for (int i = 0; i<[mydata length]; i++) {
            char byte = workByteArray[i];
            NSLog(@"%c",byte);
        }
        
        uint8_t array[[mydata length]];
        for (int i = 0; i<[mydata length]; i++) {
            char byte = byteArray[i];
            char wbyte = workByteArray[i];
            array[i] = byte ^ wbyte;
            NSLog(@"%c",byte ^ wbyte);
            
        }
        
        NSString *hexStr=@"";
        for(int i = 0;i<[mydata length];i++) {
            NSString *newHexStr = [NSString stringWithFormat:@"%x",array[i]&0xff];///16进制数
            if([newHexStr length]==1)
                hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
            else
                hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
            //NSLog(@"hexStr:%@",hexStr);
        }
        item.n52 = [hexStr uppercaseString];
//        item.n53 = [[self.cardInfo objectForKey:@"randomNumber"] uppercaseString];
        if ([item.n52 length] > 0) {
            item.n26 = @"12";
        }
        NSString *str = nil;
        if([[self.cardInfo objectForKey:@"cardType"] integerValue] == 1){
            item.n22 = @"051";           //芯片
        }else{
            item.n22 = @"021";          //磁条
            //item.n2 = [self.cardInfo objectForKey:@"cardNumber"];//卡号
        }
        if(self.tadeType == type_consument || self.tadeType == type_realTime){
            //            item.n2 = [self.cardInfo objectForKey:@"cardNumber"];
            item.n9 = [[NSUserDefaults standardUserDefaults] objectForKey:Rate];
            item.n3 = @"310000";            //交易处理码
            item.n60 = @"22000001003";//交易类型码
            //            item.n59 = @"RNS-1.1.0";
            if([[self.cardInfo objectForKey:@"cardType"] integerValue] == 1){
                NSString *n23 = [self.cardInfo objectForKey:@"cardSerial"];
                item.n23 = [NSString stringWithFormat:@"0%@",n23];
                NSLog(@"n23:%@",item.n23);
                item.n55 = [[self.cardInfo objectForKey:@"data55"] uppercaseString];
                NSLog(@"n55:%@",item.n55);
                str = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",item.n0,item.n3,item.n4,item.n9,item.n11,item.n14,item.n22,item.n23,item.n26,item.n35,item.n41,item.n42,item.n49,item.n52,item.n55,item.n59,item.n60];
            }else{
                
                str = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",item.n0,item.n3,item.n4,item.n9,item.n11,item.n14,item.n22,item.n26,item.n35,item.n41,item.n42,item.n49,item.n52,item.n59,item.n60];
                
            }
            str = [[str stringByAppendingString:MainKey] uppercaseString];
            NSLog(@"str:%@",str);
            item.n64 = [[str md5HexDigest] uppercaseString];//MAC
            
            
            [[NetAPIManger sharedManger] request_TranceWithParams:[item keyValues] andBlock:^(id data, NSError *error) {
                orderItem.voucherNo = [NSString stringWithFormat:@"%zd",voucherNo];
                self.voucherNo = orderItem.voucherNo;
                //NSLog(@"voucherNo:%@",orderItem.voucherNo);
                [[NSUserDefaults standardUserDefaults] setObject:self.voucherNo forKey:VoucherNo];
                //                [[NSUserDefaults standardUserDefaults] setObject:item.n42 forKey:MerchantNo];
                
                [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:infos] forKey:TranceInfo];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                AbstractItems *item = (AbstractItems *)data;
                if(!error && [item.n39 isEqualToString:@"00"]){
                    [[NSUserDefaults standardUserDefaults] setObject:@"00000000" forKey:Amount];
                    SignViewController *signViewController = [[SignViewController alloc] init];
                    signViewController.tadeType = self.tadeType;
                    signViewController.absItem = item;
                    signViewController.cardInfo = self.cardInfo;
                    signViewController.tadeAmount = self.tadeAmount;
                    signViewController.rate = self.rate;
                    [self.navigationController pushViewController:signViewController animated:YES];
                }else {
                    //                    NSError *error = [[NSError alloc] initWithDomain:@"交易失败" code:0 userInfo:@{@"NSLocalizedDescription":@"交易失败"}];
                    //                    [self showStatusBarError:error];
                    
                    //                    NSArray* viewcontrolls = self.navigationController.viewControllers;
                    //                    for (UIViewController* vc in viewcontrolls) {
                    //                        if ([vc isKindOfClass:[ConsumeViewController class]]) {
                    //                            [self.navigationController popToViewController:vc
                    //                                                                  animated:YES];
                    //                        }
                    //                    }
                    
                    
                    
                    if ([[ResponseDictionaryTool responseDic] objectForKey:item.n39]) {
                        
                        NSString *error = [[ResponseDictionaryTool responseDic] objectForKey:item.n39];
                        HomePageViewController *homeVc = [[HomePageViewController alloc] init];
                        homeVc.rate = self.rate;
                        [MBProgressHUD showSuccess:error toView:homeVc.view];
                        [[NSUserDefaults standardUserDefaults] setObject:@"00000000" forKey:Amount];
                        [self.navigationController pushViewController:homeVc animated:YES];
                        
                    }else {
                        HomePageViewController *homeVc = [[HomePageViewController alloc] init];
                        homeVc.rate = self.rate;
                        [MBProgressHUD showSuccess:@"未知错误" toView:homeVc.view];
                        [[NSUserDefaults standardUserDefaults] setObject:@"00000000" forKey:Amount];
                        [self.navigationController pushViewController:homeVc animated:YES];
                    }
                    
                    
                }
            }];
        }else if(self.tadeType == type_balance) {
            //            item.n59 = @"RNS-1.1.0";
            item.n60 = @"01000001003";//交易类型码
            item.n9 = [[NSUserDefaults standardUserDefaults] objectForKey:Rate];
            item.n3 = @"310000";
            //            item.n2 = [self.cardInfo objectForKey:@"cardNumber"];
            NSLog(@"n2:%@",item.n2);
            if([[self.cardInfo objectForKey:@"cardType"] integerValue] == 1){
                NSString *n23 = [self.cardInfo objectForKey:@"cardSerial"];
                item.n23 = [NSString stringWithFormat:@"0%@",n23];
                //                item.n23 = [self.cardInfo objectForKey:@"cardSerial"];
                NSLog(@"n23:%@",item.n23);
                item.n55 = [[self.cardInfo objectForKey:@"data55"] uppercaseString];
                NSLog(@"n55:%@",item.n55);
                str = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",item.n0,item.n3,item.n4,item.n9,item.n11,item.n14,item.n22,item.n23,item.n26,item.n35,item.n41,item.n42,item.n49,item.n52,item.n55,item.n59,item.n60];
                
            }else {
                str = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",item.n0,item.n3,item.n4,item.n9,item.n11,item.n14,item.n22,item.n26,item.n35,item.n41,item.n42,item.n49,item.n52,item.n59,item.n60];
            }
            
            str = [[str stringByAppendingString:MainKey] uppercaseString];
            //            str = [str uppercaseString];
            NSLog(@"str:%@",str);
            item.n64 = [[str md5HexDigest] uppercaseString];//MAC
            
            
            [[NetAPIManger sharedManger] request_BalanceWithParams:[item keyValues] andBlock:^(id data, NSError *error) {
                orderItem.voucherNo = [NSString stringWithFormat:@"%zd",voucherNo];
                self.voucherNo = orderItem.voucherNo;
                //NSLog(@"voucherNo:%@",orderItem.voucherNo);
                [[NSUserDefaults standardUserDefaults] setObject:self.voucherNo forKey:VoucherNo];
                //                [[NSUserDefaults standardUserDefaults] setObject:item.n42 forKey:MerchantNo];
                [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:infos] forKey:TranceInfo];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                AbstractItems *item = (AbstractItems *)data;
                if(!error && [item.n39 isEqualToString:@"00"]){
                    NSString *banlanceStr = @"";
                    if([item.n54 length] > 11){
                        banlanceStr = [item.n54 substringFromIndex:item.n54.length - 12];
                        NSLog(@"%@",banlanceStr);
                        banlanceStr = [POSManger transformAmountFormatWithStr:banlanceStr];
                        NSLog(@"%@",banlanceStr);
                        
                    }
                    ConsumeResultViewController *consumeResultViewController = [[ConsumeResultViewController alloc] init];
                    consumeResultViewController.tadeType = self.tadeType;
                    consumeResultViewController.tadeAmount = banlanceStr;
                    consumeResultViewController.cardInfo = self.cardInfo;
                    [self.navigationController pushViewController:consumeResultViewController animated:YES];
                }else {
                    
                    if ([item.n39 isEqualToString:@"55"]) {
                        NSString *error = [[ResponseDictionaryTool responseDic] objectForKey:item.n39];
                        HomePageViewController *homeVc = [[HomePageViewController alloc] init];
                        [MBProgressHUD showSuccess:error toView:homeVc.view];
                        [self.navigationController pushViewController:homeVc animated:YES];
                        NSLog(@"vonum:%@",[AC_POSManger shareInstance].vouchNo);
                    }
                    
                    if ([[ResponseDictionaryTool responseDic] objectForKey:item.n39]) {
                        NSString *error = [[ResponseDictionaryTool responseDic] objectForKey:item.n39];
                        HomePageViewController *homeVc = [[HomePageViewController alloc] init];
                        [MBProgressHUD showSuccess:error toView:homeVc.view];
                        [self.navigationController pushViewController:homeVc animated:YES];
                        
                    }else {
                        [MBProgressHUD showSuccess:@"未知错误" toView:self.view];
                    }
                }
            }];
        }else if(self.tadeType == type_revoke) {
            //item.n60 = @"23000001003";//交易类型码
            item.n601 = @"23";
            item.n602 = [NSString stringWithFormat:@"%@",self.batchNo];
            item.n603 = @"003";
            item.n60 = [NSString stringWithFormat:@"%@%@%@",item.n601,item.n602,item.n603];
            NSLog(@"n60:%@",item.n60);
            item.n61 = [NSString stringWithFormat:@"%@%@",self.batchNo, self.originalVoucherNo];
            if([[self.cardInfo objectForKey:@"cardType"] integerValue] == 1){
                item.n55 = [[self.cardInfo objectForKey:@"data55"] uppercaseString];
                str = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",item.n0,item.n4,item.n11,item.n14,item.n22,item.n26,item.n35,item.n41,item.n42,item.n49,item.n52,item.n53,item.n55,item.n59,item.n60,item.n61];
            }else {
                str = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",item.n0,item.n4,item.n11,item.n14,item.n22,item.n26,item.n35,item.n41,item.n42,item.n49,item.n52,item.n53,item.n59,item.n60,item.n61];
            }
            
            str = [[str stringByAppendingString:MainKey] uppercaseString];
            NSLog(@"str:%@",str);
            item.n64 = [[str md5HexDigest] uppercaseString];//MAC
            
            [[NetAPIManger sharedManger] request_BalanceWithParams:[item keyValues] andBlock:^(id data, NSError *error) {
                //orderItem.voucherNo = [NSString stringWithFormat:@"%zd",voucherNo];
                //                [[NSUserDefaults standardUserDefaults] setObject:item.n42 forKey:MerchantNo];
                [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:infos] forKey:TranceInfo];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                AbstractItems *item = (AbstractItems *)data;
                if(!error && [item.n39 isEqualToString:@"00"]){
                    SignViewController *signViewController = [[SignViewController alloc] init];
                    signViewController.tadeType = self.tadeType;
                    signViewController.absItem = item;
                    signViewController.cardInfo = self.cardInfo;
                    signViewController.tadeAmount = self.tadeAmount;
                    [self.navigationController pushViewController:signViewController animated:YES];
                }else {
                    if ([[ResponseDictionaryTool responseDic] objectForKey:item.n39]) {
                        NSString *error = [[ResponseDictionaryTool responseDic] objectForKey:item.n39];
                        QueryrRecordViewController *queryVc = [[QueryrRecordViewController alloc]init];
                        [MBProgressHUD showSuccess:error toView:queryVc.view];
                        [self.navigationController pushViewController:queryVc animated:YES];
                    }else {
                        [MBProgressHUD showSuccess:@"未知错误" toView:self.view];
                    }
                }
            }];
            
            
            //            [[NetAPIManger sharedManger] request_BalanceWithParams:[item keyValues] andBlock:^(id data, NSError *error) {
            //                orderItem.voucherNo = [NSString stringWithFormat:@"%zd",voucherNo];
            //                self.voucherNo = orderItem.voucherNo;
            //                [[NSUserDefaults standardUserDefaults] setObject:self.voucherNo forKey:VoucherNo];
            //                [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:infos] forKey:TranceInfo];
            //                [[NSUserDefaults standardUserDefaults] synchronize];
            //
            //                AbstractItems *item = (AbstractItems *)data;
            //                if(!error && [item.n39 isEqualToString:@"00"]){
            //                    ConsumeResultViewController *consumeResultViewController = [[ConsumeResultViewController alloc] init];
            //                    consumeResultViewController.tadeType = self.tadeType;
            //                    consumeResultViewController.tadeAmount = self.tadeAmount;
            //                    [self.navigationController pushViewController:consumeResultViewController animated:YES];
            //                }else {
            //
            //                }
            //            }];
        }
        
        //        [[POSManger shareInstance] TRANS_SaleTimeOut:0 andAmount:1 andPWDLength:[cell.tfContent.text length] andPWD:cell.tfContent.text andBlock:^(BOOL result, FieldTrackData data) {
        //            if (result == SUCCESS) {
        //                NSData *archiveData = [[NSUserDefaults standardUserDefaults] objectForKey:TranceInfo];
        //                NSArray *infos = nil;
        //                if (archiveData) {
        //                    infos = [NSKeyedUnarchiver unarchiveObjectWithData:archiveData];
        //                }
        //                NSString *termianlNo = [[NSUserDefaults standardUserDefaults] objectForKey:TerminalNo];
        //                NSString *batchNo = nil;//批次号
        //                NSInteger voucherNo = 0;//流水号
        //                OrderItem *orderItem = nil;
        //                for (OrderItem *item in infos) {
        //                    if ([item.termianlNo isEqualToString:termianlNo]) {
        //                        voucherNo = [item.voucherNo integerValue];
        //                        batchNo = item.batchNo;
        //                        orderItem = item;
        //                    }
        //                }
        //
        //                AbstractItems *item = [[AbstractItems alloc] init];
        //                item.n0 = @"0200";              //消息类型
        //                item.n4 = [POSManger transformAmountFormatWithStr:self.tadeAmount];     //交易金额12位
        //                item.n11 = [NSString stringWithFormat:@"%06zd",++voucherNo];            //交易流水号  进行递增
        //                item.n14 = [[NSString alloc] initWithCString:(const char*)data.CardValid encoding:NSASCIIStringEncoding];//卡有效期
        //                item.n35 = [[POSManger shareInstance] hexBytToString:data.szTrack2 :data.nEncryTrack2Len];//磁道数据
        //                item.n41 = [[NSUserDefaults standardUserDefaults] valueForKey:TerminalNo];//终端号
        //                item.n42 = [[NSUserDefaults standardUserDefaults] valueForKey:MerchantNo];//商户号
        //                item.n49 = @"156";//交易货币代码
        //                item.n52 = [[[POSManger shareInstance] hexBytToString:data.sPIN :8] uppercaseString];
        //                if ([item.n52 length] > 0) {
        //                    item.n26 = @"12";
        //                }
        //                item.n55 = [[[POSManger shareInstance] hexBytToString:data.Field55Iccdata :data.IccdataLen] uppercaseString];
        //                NSString *str = nil;
        //                if(data.iCardtype == 1){
        //                    item.n22 = @"051";           //芯片
        //                    item.n53 = @"2600000000000000";
        //                }else {
        //                    item.n22 = @"021";          //磁条
        //                    item.n53 = @"0600000000000000";
        //                    item.n2 = [[NSString alloc] initWithCString:(const char*)data.TrackPAN encoding:NSASCIIStringEncoding];//卡号
        //                }
        //
        //
        //
        //                if(self.tadeType == type_consument || self.tadeType == type_realTime){
        //                    item.n3 = @"310000";            //交易处理码
        //                    item.n60 = @"22000001003";//交易类型码
        //                    if(data.iCardtype == 1){
        //                        str = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",item.n0,item.n3,item.n4,item.n11,item.n14,item.n22,item.n26,item.n35,item.n41,item.n42,item.n49,item.n52,item.n53,item.n55,item.n60];
        //                    }else {
        //                        str = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",item.n0,item.n2,item.n3,item.n4,item.n11,item.n14,item.n22,item.n26,item.n35,item.n41,item.n42,item.n49,item.n52,item.n53,item.n55,item.n60];
        //                    }
        //                    str = [str stringByAppendingString:MainKey];
        //                    item.n64 = [[str md5HexDigest] uppercaseString];//MAC
        //
        //                    [[NetAPIManger sharedManger] request_TranceWithParams:[item keyValues] andBlock:^(id data, NSError *error) {
        //                        orderItem.voucherNo = [NSString stringWithFormat:@"%zd",voucherNo];
        //                        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:infos] forKey:TranceInfo];
        //                        [[NSUserDefaults standardUserDefaults] synchronize];
        //
        //                        AbstractItems *item = (AbstractItems *)data;
        //                        //AbstractItems *item = [AbstractItems objectWithKeyValues:data];
        //                        if(!error && [item.n39 isEqualToString:@"00"]){
        //                            SignViewController *signViewController = [[SignViewController alloc] init];
        //                            signViewController.tadeType = self.tadeType;
        //                            //signViewController.item = item;
        //                            [self.navigationController pushViewController:signViewController animated:YES];
        //                        }else {
        //
        //                        }
        //                    }];
        //
        //                }else if(self.tadeType == type_balance) {
        //                    item.n60 = @"01000001003";//交易类型码
        //                    if(data.iCardtype == 1){
        //                        str = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@",item.n0,item.n4,item.n11,item.n14,item.n22,item.n26,item.n35,item.n41,item.n42,item.n49,item.n52,item.n53,item.n55,item.n60];
        //                    }else {
        //                        str = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",item.n0,item.n2,item.n4,item.n11,item.n14,item.n22,item.n26,item.n35,item.n41,item.n42,item.n49,item.n52,item.n53,item.n55,item.n60];
        //                    }
        //
        //                    str = [str stringByAppendingString:MainKey];
        //                    item.n64 = [[str md5HexDigest] uppercaseString];//MAC
        //
        //
        //                    [[NetAPIManger sharedManger] request_BalanceWithParams:[item keyValues] andBlock:^(id data, NSError *error) {
        //                        orderItem.voucherNo = [NSString stringWithFormat:@"%zd",voucherNo];
        //                        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:infos] forKey:TranceInfo];
        //                        [[NSUserDefaults standardUserDefaults] synchronize];
        //
        //                        AbstractItems *item = (AbstractItems *)data;
        //                        if(!error && [item.n39 isEqualToString:@"00"]){
        //                            ConsumeResultViewController *consumeResultViewController = [[ConsumeResultViewController alloc] init];
        //                            consumeResultViewController.tadeType = self.tadeType;
        //                            consumeResultViewController.tadeAmount = self.tadeAmount;
        //                            [self.navigationController pushViewController:consumeResultViewController animated:YES];
        //                        }else {
        //
        //                        }
        //                    }];
        //
        //                }else if (self.tadeType == type_revoke) {
        //                    item.n60 = @"22000001003";//交易类型码
        //                    //item.n61 = [NSString stringWithFormat:@"%@%@",self.item.terminalBatchNo, self.item.termianlVoucherNo];
        //                    if(data.iCardtype == 1){
        //                        str = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",item.n0,item.n4,item.n11,item.n14,item.n22,item.n26,item.n35,item.n41,item.n42,item.n49,item.n52,item.n53,item.n55,item.n60,item.n61];
        //                    }else {
        //                        str = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",item.n0,item.n2,item.n4,item.n11,item.n14,item.n22,item.n26,item.n35,item.n41,item.n42,item.n49,item.n52,item.n53,item.n55,item.n60,item.n61];
        //                    }
        //
        //                    str = [str stringByAppendingString:MainKey];
        //                    item.n64 = [[str md5HexDigest] uppercaseString];//MAC
        //
        //
        //                    [[NetAPIManger sharedManger] request_BalanceWithParams:[item keyValues] andBlock:^(id data, NSError *error) {
        //                        orderItem.voucherNo = [NSString stringWithFormat:@"%zd",voucherNo];
        //                        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:infos] forKey:TranceInfo];
        //                        [[NSUserDefaults standardUserDefaults] synchronize];
        //
        //                        AbstractItems *item = (AbstractItems *)data;
        //                        if(!error && [item.n39 isEqualToString:@"00"]){
        //                            ConsumeResultViewController *consumeResultViewController = [[ConsumeResultViewController alloc] init];
        //                            consumeResultViewController.tadeType = self.tadeType;
        //                            consumeResultViewController.tadeAmount = self.tadeAmount;
        //                            [self.navigationController pushViewController:consumeResultViewController animated:YES];
        //                        }else {
        //
        //                        }
        //                    }];
        //                }
        //            }else {
        //
        //            }
        //        }];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
    }else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.btnTitles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL__HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConsumeResultCell *cell = nil;
    if (indexPath.row == self.btnTitles.count-1) {
        cell = (ConsumeResultCell *)[tableView dequeueReusableCellWithIdentifier:TextFielddenfity forIndexPath:indexPath];
        [cell setType:[self.btnTitles objectAtIndex:indexPath.row] andContent:@""];
        __unsafe_unretained SZBTADEnterPSDViewController *weakSelf = self;
        cell.tapTfContentBlock = ^{
            [weakSelf showKeyboard];
        };
        
        //KVO方法监听textField的改变
        [cell.tfContent addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
        
        NSLog(@"tf:%@",cell.tfContent);
        
    }else {
        cell = (ConsumeResultCell *)[tableView dequeueReusableCellWithIdentifier:LableIdenfity forIndexPath:indexPath];
        
        if (self.merchantName.length > 0) {
            switch (indexPath.row) {
                case 0:
                    [cell setType:[self.btnTitles objectAtIndex:indexPath.row] andContent:self.merchantName];
                    break;
                case 1:
                    [cell setType:[self.btnTitles objectAtIndex:indexPath.row] andContent:[POSManger getTadeTypeStr:self.tadeType]];
                    break;
                case 2:
                    [cell setType:[self.btnTitles objectAtIndex:indexPath.row] andContent:[self.cardInfo objectForKey:@"cardNumber"]];
                    break;
                case 3:{
                    
                    NSRange range1 = NSMakeRange(5, 3);
                    NSRange range2 = NSMakeRange(3, 2);
                    NSString *str1 = [[[NSUserDefaults standardUserDefaults] objectForKey:Rate] substringWithRange:range1];
                    NSString *str2 = [[[NSUserDefaults standardUserDefaults] objectForKey:Rate] substringWithRange:range2];
                    NSString *str3 = [[NSString stringWithFormat:@"%f",[str1 floatValue]/100] substringToIndex:4];
                    NSString *str4 = [NSString stringWithFormat:@"%d",[str2 intValue]];
                    self.strRate = [NSString stringWithFormat:@"%@-%@",str3,str4];
                    
                    [cell setType:[self.btnTitles objectAtIndex:indexPath.row] andContent:self.strRate];
                    break;
                }
                case 4:
                    [cell setType:[self.btnTitles objectAtIndex:indexPath.row] andContent:self.tadeAmount];
                    break;
                default:
                    break;
            }
        }else {
            switch (indexPath.row) {
                case 0:
                    [cell setType:[self.btnTitles objectAtIndex:indexPath.row] andContent:[POSManger getTadeTypeStr:self.tadeType]];
                    break;
                case 1:
                    [cell setType:[self.btnTitles objectAtIndex:indexPath.row] andContent:[self.cardInfo objectForKey:@"cardNumber"]];
                    break;
                case 2:{
                    NSRange range1 = NSMakeRange(5, 3);
                    NSRange range2 = NSMakeRange(3, 2);
                    NSString *str1 = [[[NSUserDefaults standardUserDefaults] objectForKey:Rate] substringWithRange:range1];
                    NSString *str2 = [[[NSUserDefaults standardUserDefaults] objectForKey:Rate] substringWithRange:range2];
                    NSString *str3 = [[NSString stringWithFormat:@"%f",[str1 floatValue]/100] substringToIndex:4];
                    NSString *str4 = [NSString stringWithFormat:@"%d",[str2 intValue]];
                    self.strRate = [NSString stringWithFormat:@"%@-%@",str3,str4];
                    
                    [cell setType:[self.btnTitles objectAtIndex:indexPath.row] andContent:self.strRate];
                    break;
                }
                case 3:
                    [cell setType:[self.btnTitles objectAtIndex:indexPath.row] andContent:self.tadeAmount];
                    break;
                default:
                    break;
            }
        }
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


//KVO监听方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    UITextView *tf = object;
    
    if (tf.text.length >= 6) {
        [self hideKeyboardAction];
    }
    
    
}

- (void)hideKeyboardAction
{
    NSIndexPath *path = [NSIndexPath indexPathForRow:self.btnTitles.count - 1 inSection:0];
    ConsumeResultCell *cell = (ConsumeResultCell *)[self.tableView cellForRowAtIndexPath:path];
    UITextField *tf = cell.tfContent;
    if ([tf.text length] == 0) {
        tf.placeholder = @"请输入密码";
    }
    
    [UIView animateKeyframesWithDuration:0.25 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [self.keyBoardView updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.bottom);
        }];
        [self.baseView setContentOffset:CGPointMake(0, 0)];
    } completion:^(BOOL finished) {
        [self.btnMaskLayer setHidden:YES];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];
    
}

- (void)showKeyboard
{
    NSIndexPath *path = [NSIndexPath indexPathForRow:self.btnTitles.count - 1 inSection:0];
    ConsumeResultCell *cell = (ConsumeResultCell *)[self.tableView cellForRowAtIndexPath:path];
    UITextField *tf = cell.tfContent;
    if ([tf.text length] == 0) {
        tf.placeholder = @"";
    }
    
    CGFloat y = CGRectGetMaxY(self.btnConfirm.frame);
    [UIView animateKeyframesWithDuration:0.25 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        CGFloat keyboardH  = [KeyBoardView getHeight];
        [self.keyBoardView updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.bottom).offset(-keyboardH);
        }];
        CGFloat offsety = keyboardH - (SCREEN_HEIGHT - y - 64);
        [self.baseView setContentOffset:CGPointMake(0, offsety>0? offsety:0)];
    } completion:^(BOOL finished) {
        [self.btnMaskLayer setHidden:NO];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];
}

@end
