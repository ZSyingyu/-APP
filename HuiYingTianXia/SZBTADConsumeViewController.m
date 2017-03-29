//
//  SZBTADConsumeViewController.m
//  HuiYingTianXia
//
//  Created by liguo.chen on 16/5/18.
//  Copyright © 2016年 tsmc. All rights reserved.
//

#import "SZBTADConsumeViewController.h"
#import "SwingCardViewController.h"
#import "POSManger.h"
#import "AC_POSManger.h"
#import "AbstractItems.h"
#import "MJExtension.h"
#import "NSString+MD5HexDigest.h"
#import "ResponseDictionaryTool.h"
#import "MBProgressHUD+Add.h"
#import "MF_POSManager.h"
//#import "SDK/MPosController.h"

#import "SDK2/MPosController.h"
#import "SVProgressHUD/SVProgressHUD.h"
#import "MLTableAlert/MLTableAlert.h"
#import "MFBTADSwingCardViewController.h"
#import "SZBTADSwingCardViewController.h"

@interface SZBTADConsumeViewController ()<AC_POSMangerDelegate,MF_POSMangerDelegate,MPosDelegate>
@property(nonatomic, strong)UILabel *labNumber;
@property(nonatomic, strong)NSArray *btnTitles;
@property(nonatomic, assign)NSMutableString *realStr;
@property(nonatomic, assign)NSInteger numerical;
@property(nonatomic, assign)NSNumber *realNumber;
@property(nonatomic, strong)NSString *showStr;
@property(nonatomic, strong)NSNumberFormatter *formatter;
@property(nonatomic, assign)BOOL isFloat;

@property(nonatomic, assign)NSInteger floatTen;//用于fix .00 bug
@property(nonatomic, assign)NSInteger floatDigits;
@property(strong,nonatomic)NSString *amount;//输入的金额


@property (strong, nonatomic) MPosController *posCtrl;
@property (assign, nonatomic) EU_POS_CARDTYPE cardType;
@property (assign, nonatomic) MFEU_MSR_EMV_PIN emvPinReq;
@property(nonatomic)MFEU_MSR_OPENCARD_RESP *resp;

@property(strong,nonatomic)MF_POSManager *manager;

@end

typedef enum {
    ACTION_UNKNOWN = 0,
    ACTION_TEST,
    ACTION_QUERY,
    ACTION_SALE,
} MFEU_POS_ACTION;

#define BTN_WIDTH HFixWidthBaseOn320(80)
#define BTN_HEIGHT HFixHeightBaseOn568(76)
#define MAX_COUNT_LENGTH 6

@implementation SZBTADConsumeViewController

- (void)loadView
{
    [super loadView];
    [self setBackBarButtonItemWithTitle:@"返回"];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    //    [self setBackBarButtonItemWithTitle:@"返回"];
    [self setHomeBackBarButtonItemWithTitle:@"返回"];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    
    
    self.navigationItem.title = @"消费";
    self.floatTen = -1;
    self.floatDigits = -1;
    
    self.formatter = [[NSNumberFormatter alloc] init];
    self.formatter.numberStyle = kCFNumberFormatterDecimalStyle;
    
    self.numerical = 0;
    self.isFloat = NO;
    
    CGFloat height = IPHONE4__4S? 80 : 124;
    
    self.labNumber = [[UILabel alloc] init];
    self.labNumber.font = [UIFont systemFontOfSize:35];
    [self.labNumber setTextAlignment:NSTextAlignmentRight];
    self.labNumber.text = self.showStr;
    [self.view addSubview:self.labNumber];
    [self.labNumber makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view).offset(LEFT_PAD);
        make.right.equalTo(self.view).offset(-RIGHT_PAD);
        make.height.equalTo(height);
    }];
    
    self.btnTitles = @[@"7",@"8",@"9",@"4",@"5",@"6",@"1",@"2",@"3",@"0",@"10",@"11",@"C",@"清除"];
    
    for (int i = 0; i < self.btnTitles.count - 2; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *number = [self.btnTitles objectAtIndex:i];
        
        [btn setTag:number.integerValue];
        [btn setBackgroundColor:COLOR_MY_WHITE];
        [btn setContentMode:UIViewContentModeBottom];
        [btn setFrame:CGRectMake((i%3) * BTN_WIDTH, (i/3) * BTN_HEIGHT + height, BTN_WIDTH, BTN_HEIGHT)];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",number]];
        UIView *view = [[UIView alloc] init];
        [view setUserInteractionEnabled:NO];
        view.layer.contents = (id)image.CGImage;
        [view setBounds:CGRectMake(0, 0, image.size.width, image.size.height)];
        view.center = CGPointMake(BTN_WIDTH/2.f, BTN_HEIGHT /2.f);
        [btn addSubview:view];
        
    }
    
    for (int i = 0; i < self.btnTitles.count - 12; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTag:i + 12];
        [btn setBackgroundColor:COLOR_MY_WHITE];
        [btn setContentMode:UIViewContentModeBottom];
        [btn setFrame:CGRectMake(3 * BTN_WIDTH, i * 2 * BTN_HEIGHT + height, BTN_WIDTH, 2 * BTN_HEIGHT)];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        
        UIImage *image = [UIImage imageNamed:[self.btnTitles objectAtIndex:i + 12]];
        UIView *view = [[UIView alloc] init];
        [view setUserInteractionEnabled:NO];
        view.layer.contents = (id)image.CGImage;
        [view setBounds:CGRectMake(0, 0, image.size.width, image.size.height)];
        view.center = CGPointMake(BTN_WIDTH/2.f, BTN_HEIGHT);
        [btn addSubview:view];
    }
    
    for (int i = 0; i < 2; i++) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(BTN_WIDTH * i, height, LINE_HEIGTH, BTN_HEIGHT * 4)];
        [line setBackgroundColor:COLOR_LINE];
        [self.view addSubview:line];
    }
    
    for (int i = 0; i < 5; i++) {
        CGFloat w;
        if ((i+1) % 2 == 0) {
            w = SCREEN_WIDTH  - BTN_WIDTH;
        }else {
            w = SCREEN_WIDTH;
        }
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, height + i*BTN_HEIGHT, w, LINE_HEIGTH)];
        [line setBackgroundColor:COLOR_LINE];
        [self.view addSubview:line];
    }
    
    
    for (int i = 1; i < 4; i++) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(BTN_WIDTH * i, height, LINE_HEIGTH, BTN_HEIGHT * 4)];
        [line setBackgroundColor:COLOR_LINE];
        [self.view addSubview:line];
    }
    
    UIButton *btnConfirm = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnConfirm setBackgroundColor:COLOR_THEME];
    [btnConfirm.titleLabel setTextColor:COLOR_MY_WHITE];
    [btnConfirm setContentMode:UIViewContentModeBottom];
    [btnConfirm setTitle:@"确认收款" forState:UIControlStateNormal];
    [btnConfirm.titleLabel setFont:FONT_17];
    [btnConfirm addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnConfirm];
    [btnConfirm makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.equalTo(BNT_HEIGHT);
        make.bottom.equalTo(self.view).offset(-20);
    }];
}

- (NSString *)showStr
{
    NSInteger intPart = self.numerical / 100;
    NSInteger folatPart = self.numerical % 100;
    
    NSNumber *number = [NSNumber numberWithInteger:intPart];
    
    self.formatter = [[NSNumberFormatter alloc] init];
    self.formatter.numberStyle = kCFNumberFormatterDecimalStyle;
    _showStr = [self.formatter stringFromNumber:number];
    
    if(folatPart >= 10){//两位数
        _showStr = [_showStr stringByAppendingString:[NSString stringWithFormat:@".%zd",folatPart]];
    }else if(folatPart >= 1){//一位数
        _showStr = [_showStr stringByAppendingString:[NSString stringWithFormat:@".0%zd",folatPart]];
    }else if(folatPart == 0){//0
        _showStr = [_showStr stringByAppendingString:@".00"];
    }
    
    return _showStr;
}

- (NSInteger)getIntPartLength
{
    NSInteger intPart = self.numerical /100;
    NSString *intStr = [NSString stringWithFormat:@"%zd",intPart];
    return [intStr length];
}

- (void)btnAction:(UIButton *)btn
{
    switch (btn.tag) {
        case 0:
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:{
            if(self.isFloat){
                if(self.numerical % 100 == 0  && self.floatTen == -1 && self.floatDigits == -1){//刚点击完小数点
                    self.numerical = self.numerical + btn.tag*10;
                    self.floatTen = btn.tag;
                }else if(self.numerical % 10 == 0  && self.floatDigits == -1){//小数点后一位
                    self.numerical = self.numerical + btn.tag*1;
                    self.floatDigits = btn.tag;
                }else { //小数点后两位
                    //已经达到小数点后两位不能输入
                }
            }else {
                if([self getIntPartLength] < MAX_COUNT_LENGTH)//小于最大值
                    self.numerical = self.numerical*10 + btn.tag*100;
            }
        }
            break;
        case 10:{//点
            self.isFloat = YES;
        }
            break;
        case 11://00
            if(!self.isFloat){
                if([self getIntPartLength] < MAX_COUNT_LENGTH - 1){
                    self.numerical *= 100;
                }else if([self getIntPartLength] < MAX_COUNT_LENGTH){
                    self.numerical *= 10;
                }
            }
            
            break;
        case 12://C
            self.numerical = 0;
            self.isFloat = NO;
            self.floatTen = -1;
            self.floatDigits = -1;
            
            break;
        case 13://清除
            if(!self.isFloat){
                if(self.numerical >= 1000){
                    NSInteger floatPart = self.numerical % 100;
                    self.numerical /= 1000;
                    self.numerical =self.numerical*100 + floatPart ;
                }else if(self.numerical >=100){
                    self.numerical %= 100;
                }
            }else {
                if(self.numerical % 100 == 0 && self.floatTen == -1 && self.floatDigits == -1){//刚点击完小数点
                    self.isFloat = NO;
                    self.numerical /= 1000;
                    self.numerical *= 100;
                    self.floatTen = -1;
                    self.floatDigits = -1;
                }else if(self.numerical % 10 == 0 && self.floatDigits == -1){//小数点后一位
                    self.numerical /= 100;
                    self.numerical *= 100;
                    self.floatTen = -1;
                }else { //小数点后两位
                    self.numerical /= 10;
                    self.numerical *= 10;
                    self.floatDigits = -1;
                }
            }
            break;
        default:
            break;
    }
    
    [self.labNumber setText:self.showStr];
}


- (void)confirmAction
{
    //    [[POSManger shareInstance] openAndBandingWithBolck:^(BOOL result, NSString *message) {
    //        if (result == SUCCESS) {
    //            SwingCardViewController *swingCardVC = [[SwingCardViewController alloc] init];
    //            swingCardVC.tadeType = self.tadeType;
    //            swingCardVC.tadeAmount = self.labNumber.text;
    //            [self.navigationController pushViewController:swingCardVC animated:YES];
    //        }else {
    //            NSLog(@"%@",message);
    //        }
    //    }];
    
    self.amount = [POSManger transformAmountFormatWithStr:self.labNumber.text];
    [[NSUserDefaults standardUserDefaults] setObject:self.amount forKey:Amount];
    NSLog(@"amount:%@",self.amount);
    
    
    if([self.labNumber.text isEqualToString:@"0.00"]){
        NSError *error = [NSError errorWithDomain:@"error" code:0 userInfo:@{@"NSLocalizedDescription":@"消费金额不能为0"}];
        [self showStatusBarError:error];
        
        return;
    }
    
    //    [[AC_POSManger shareInstance] setDeleagte:self];
    //    [[AC_POSManger shareInstance] openAndBanding];
    
    
    
    
    
    
    [self waitingForCardSwipe:SUCCESS];
}


- (void)backAction:(id)sender
{
    [self.navigationController.navigationBar setHidden:YES];
    [super backAction:sender];
    
}

- (void)waitingForCardSwipe:(BOOL)status
{
    if(status == SUCCESS) {
        
        SZBTADSwingCardViewController *swingCardVC = [[SZBTADSwingCardViewController alloc] init];
        swingCardVC.tadeType = self.tadeType;
        swingCardVC.rate = self.rate;
        swingCardVC.tadeAmount = self.labNumber.text;
        
        //        self.voucherNo = [AC_POSManger shareInstance].vouchNo;
        self.voucherNo = [MF_POSManager shareInstance].vouchNo;
        NSLog(@"voucherNo:%@",self.voucherNo);
        swingCardVC.voucherNo = self.voucherNo;
        NSLog(@"voucherNo:%@",swingCardVC.voucherNo);
        
        [self.navigationController pushViewController:swingCardVC animated:YES];
        
        
        
    }
}

@end
