//
//  POSConsumeDetailViewController.m
//  HuiYingTianXia
//
//  Created by liguo.chen on 15/11/20.
//  Copyright © 2015年 tsmc. All rights reserved.
//

#import "POSConsumeDetailViewController.h"

#import "POSManger.h"
#import "NSString+MD5HexDigest.h"
#import "NetAPIManger.h"
#import "NetAPIClient.h"
#import "MJExtension.h"
#import "TradeRecordViewController.h"
#import "MBProgressHUD+Add.h"
#import "ResponseDictionaryTool.h"


@interface POSConsumeDetailViewController ()

@property(strong,nonatomic)UIScrollView *baseScrollView;//底层滚动视图
@property(strong,nonatomic)UIView *tradeView;//交易金额view
@property(strong,nonatomic)UILabel *tradeLabel;//交易金额label
@property(strong,nonatomic)UILabel *tdAmount;//交易金额(数字)
@property(strong,nonatomic)UILabel *tradeNameLabel;//商户姓名label
@property(strong,nonatomic)UILabel *tdName;//商户姓名显示
@property(strong,nonatomic)UIView *tdNameLine;//商户姓名line
@property(strong,nonatomic)UILabel *tradeTypeLabel;//交易类型label
@property(strong,nonatomic)UILabel *tdType;//交易类型显示
@property(strong,nonatomic)UIView *tdTypeLine;//交易类型line
@property(strong,nonatomic)UILabel *tradeRateLabel;//交易费率label
@property(strong,nonatomic)UILabel *tdRate;//交易费率显示
@property(strong,nonatomic)UIView *tdRateLine;//交易费率line
@property(strong,nonatomic)UILabel *tradeTimeLabel;//交易时间label
@property(strong,nonatomic)UILabel *tdTime;//交易时间显示
@property(strong,nonatomic)UIView *tdTimeLine;//交易时间line
@property(strong,nonatomic)UILabel *tradeCardNumberLabel;//交易卡号label
@property(strong,nonatomic)UILabel *tdCardNumber;//交易卡号显示
@property(strong,nonatomic)UIView *tdCardNumberLine;//交易卡号line
@property(strong,nonatomic)UILabel *tradeNumbelLael;//交易编号label
@property(strong,nonatomic)UILabel *tdNumber;//交易编号显示
@property(strong,nonatomic)UIView *tdNumberLine;//交易编号line
@property(strong,nonatomic)UILabel *authorizeNumberLabel;//授权码label
@property(strong,nonatomic)UILabel *authorizeNumber;//授权码显示
@property(strong,nonatomic)UIView *authorizeNumberLine;//授权码line
@property(strong,nonatomic)UILabel *tradeStatusLabel;//交易状态label
@property(strong,nonatomic)UILabel *tdStatus;//交易状态显示
@property(strong,nonatomic)UIView *tdStatusLine;//交易状态line
@property(strong,nonatomic)UILabel *cashStatusLabel;//提现状态label
@property(strong,nonatomic)UILabel *cashStatus;//提现状态显示
@property(strong,nonatomic)UIView *cashStatusLine;//提现状态line
@property(strong,nonatomic)UIView *signView;//签名view
@property(strong,nonatomic)UILabel *signLabel;//签名label
@property(strong,nonatomic)UIImageView *signImageView;//签名imageView
//@property(strong,nonatomic)UIButton *cancleBtn;//取消按钮
@property(strong,nonatomic)UIButton *confirmBtn;//确定按钮

@end

@implementation POSConsumeDetailViewController

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = COLOR_THEME;
}

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBar.barTintColor = COLOR_THEME;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"交易明细";
    [self setBackBarButtonItemWithTitle:@"返回"];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    self.baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.baseScrollView.backgroundColor = COLOR_THE_WHITE;
    if (IPHONE4__4S) {
        self.baseScrollView.contentSize = CGSizeMake(0, SCREEN_HEIGHT * 1.4 + 40);
    }else if (IPHONE5__5S) {
        self.baseScrollView.contentSize = CGSizeMake(0, SCREEN_HEIGHT * 1.2 + 40);
    }else if (IPHONE6) {
        self.baseScrollView.contentSize = CGSizeMake(0, SCREEN_HEIGHT * 1.1 - 10);
    }else {
        self.baseScrollView.contentSize = CGSizeMake(0, SCREEN_HEIGHT * 1.2 + 40);
    }
    [self.view addSubview:self.baseScrollView];
    
    self.tradeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90)];
    self.tradeView.backgroundColor = COLOR_THEME;
    [self.baseScrollView addSubview:self.tradeView];
    
    //    [MBProgressHUD showSuccess:@"提现最低额度为500.00" toView:self.baseScrollView];
    
    self.tradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.tradeView.frame.size.width, 30)];
    self.tradeLabel.text = @"交易金额(元)";
    self.tradeLabel.font = [UIFont systemFontOfSize:19];
    self.tradeLabel.backgroundColor = [UIColor clearColor];
    self.tradeLabel.textColor = [UIColor whiteColor];
    [self.baseScrollView addSubview:self.tradeLabel];
    
    self.tdAmount = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tradeLabel.frame) + 10, SCREEN_WIDTH - 15, self.tradeLabel.frame.size.height)];
    self.tdAmount.text = [POSManger transformAmountWithPoint:self.amount];
    self.tdAmount.font = [UIFont systemFontOfSize:22];
    self.tdAmount.textAlignment = NSTextAlignmentRight;
    self.tdAmount.backgroundColor = [UIColor clearColor];
    self.tdAmount.textColor = [UIColor whiteColor];
    [self.baseScrollView addSubview:self.tdAmount];
    
    self.tradeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.tradeView.frame) + 30, 80, 30)];
    self.tradeNameLabel.text = @"商户名称:";
    self.tradeNameLabel.font = [UIFont systemFontOfSize:18];
    self.tradeNameLabel.textColor = [UIColor blackColor];
    [self.baseScrollView addSubview:self.tradeNameLabel];
    
    self.tdName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.tradeNameLabel.frame), self.tradeNameLabel.frame.origin.y, SCREEN_WIDTH - 20 - self.tradeNameLabel.frame.size.width, self.tradeNameLabel.frame.size.height)];
    self.tdName.text = [[NSUserDefaults standardUserDefaults] objectForKey:CardName];
    self.tdName.textAlignment = NSTextAlignmentRight;
    self.tdName.font = [UIFont systemFontOfSize:18];
    self.tdName.textColor = [UIColor blackColor];
    [self.baseScrollView addSubview:self.tdName];
    
    self.tdNameLine = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.tradeNameLabel.frame) + 3, SCREEN_WIDTH - 20, 1)];
    self.tdNameLine.backgroundColor = [UIColor lightGrayColor];
    [self.baseScrollView addSubview:self.tdNameLine];
    
    self.tradeTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.tdNameLine.frame) + 3, 80, 30)];
    self.tradeTypeLabel.text = @"交易类型:";
    self.tradeTypeLabel.font = [UIFont systemFontOfSize:18];
    self.tradeTypeLabel.textColor = [UIColor blackColor];
    [self.baseScrollView addSubview:self.tradeTypeLabel];
    
    self.tdType = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.tradeTypeLabel.frame), self.tradeTypeLabel.frame.origin.y, SCREEN_WIDTH - 20 - self.tradeTypeLabel.frame.size.width, self.tradeTypeLabel.frame.size.height)];
    self.tdType.text = self.type;
    self.tdType.textAlignment = NSTextAlignmentRight;
    self.tdType.font = [UIFont systemFontOfSize:18];
    self.tdType.textColor = [UIColor blackColor];
    [self.baseScrollView addSubview:self.tdType];
    
    self.tdTypeLine = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.tradeTypeLabel.frame) + 3, SCREEN_WIDTH - 20, 1)];
    self.tdTypeLine.backgroundColor = [UIColor lightGrayColor];
    [self.baseScrollView addSubview:self.tdTypeLine];
    
    self.tradeRateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.tdTypeLine.frame) + 3, 80, 30)];
    self.tradeRateLabel.text = @"交易费率:";
    self.tradeRateLabel.font = [UIFont systemFontOfSize:18];
    self.tradeRateLabel.textColor = [UIColor blackColor];
    [self.baseScrollView addSubview:self.tradeRateLabel];
    
    self.tdRate = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.tradeRateLabel.frame), self.tradeRateLabel.frame.origin.y, SCREEN_WIDTH - 20 - self.tradeRateLabel.frame.size.width, self.tradeRateLabel.frame.size.height)];
    self.tdRate.text = [NSString stringWithFormat:@"%@-%@",self.strRate,self.maxFee];
    self.tdRate.textAlignment = NSTextAlignmentRight;
    self.tdRate.font = [UIFont systemFontOfSize:18];
    self.tdRate.textColor = [UIColor blackColor];
    [self.baseScrollView addSubview:self.tdRate];
    
    self.tdRateLine = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.tradeRateLabel.frame) + 3, SCREEN_WIDTH - 20, 1)];
    self.tdRateLine.backgroundColor = [UIColor lightGrayColor];
    [self.baseScrollView addSubview:self.tdRateLine];
    
    self.tradeTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.tdRateLine.frame) + 3, 80, 30)];
    self.tradeTimeLabel.text = @"交易时间:";
    self.tradeTimeLabel.font = [UIFont systemFontOfSize:18];
    self.tradeTimeLabel.textColor = [UIColor blackColor];
    [self.baseScrollView addSubview:self.tradeTimeLabel];
    
    self.tdTime = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.tradeTimeLabel.frame), self.tradeTimeLabel.frame.origin.y, SCREEN_WIDTH - 20 - self.tradeTimeLabel.frame.size.width, self.tradeTimeLabel.frame.size.height)];
    self.tdTime.text = self.time;
    self.tdTime.textAlignment = NSTextAlignmentRight;
    self.tdTime.font = [UIFont systemFontOfSize:18];
    self.tdTime.textColor = [UIColor blackColor];
    [self.baseScrollView addSubview:self.tdTime];
    
    self.tdTimeLine = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.tradeTimeLabel.frame) + 3, SCREEN_WIDTH - 20, 1)];
    self.tdTimeLine.backgroundColor = [UIColor lightGrayColor];
    [self.baseScrollView addSubview:self.tdTimeLine];
    
    self.tradeCardNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.tdTimeLine.frame) + 3, 80, 30)];
    self.tradeCardNumberLabel.text = @"交易卡号:";
    self.tradeCardNumberLabel.font = [UIFont systemFontOfSize:18];
    self.tradeCardNumberLabel.textColor = [UIColor blackColor];
    [self.baseScrollView addSubview:self.tradeCardNumberLabel];
    
    self.tdCardNumber = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.tradeCardNumberLabel.frame), self.tradeCardNumberLabel.frame.origin.y, SCREEN_WIDTH - 20 - self.tradeCardNumberLabel.frame.size.width, self.tradeCardNumberLabel.frame.size.height)];
    self.tdCardNumber.text = self.cardNum;
    self.tdCardNumber.textAlignment = NSTextAlignmentRight;
    self.tdCardNumber.font = [UIFont systemFontOfSize:18];
    self.tdCardNumber.textColor = [UIColor blackColor];
    [self.baseScrollView addSubview:self.tdCardNumber];
    
    self.tdCardNumberLine = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.tradeCardNumberLabel.frame) + 3, SCREEN_WIDTH - 20, 1)];
    self.tdCardNumberLine.backgroundColor = [UIColor lightGrayColor];
    [self.baseScrollView addSubview:self.tdCardNumberLine];
    
    self.tradeNumbelLael = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.tdCardNumberLine.frame) + 3, 80, 30)];
    self.tradeNumbelLael.text = @"交易编号:";
    self.tradeNumbelLael.font = [UIFont systemFontOfSize:18];
    self.tradeNumbelLael.textColor = [UIColor blackColor];
    [self.baseScrollView addSubview:self.tradeNumbelLael];
    
    self.tdNumber = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.tradeNumbelLael.frame), self.tradeNumbelLael.frame.origin.y, SCREEN_WIDTH - 20 - self.tradeNumbelLael.frame.size.width, self.tradeNumbelLael.frame.size.height)];
    self.tdNumber.text = self.tradeNum;
    self.tdNumber.textAlignment = NSTextAlignmentRight;
    self.tdNumber.font = [UIFont systemFontOfSize:18];
    self.tdNumber.textColor = [UIColor blackColor];
    [self.baseScrollView addSubview:self.tdNumber];
    
    self.tdNumberLine = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.tradeNumbelLael.frame) + 3, SCREEN_WIDTH - 20, 1)];
    self.tdNumberLine.backgroundColor = [UIColor lightGrayColor];
    [self.baseScrollView addSubview:self.tdNumberLine];
    
    self.tradeStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.tdNumberLine.frame) + 3, 80, 30)];
    self.tradeStatusLabel.text = @"交易状态:";
    self.tradeStatusLabel.font = [UIFont systemFontOfSize:18];
    self.tradeStatusLabel.textColor = [UIColor blackColor];
    [self.baseScrollView addSubview:self.tradeStatusLabel];
    
    self.tdStatus = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.tradeStatusLabel.frame), self.tradeStatusLabel.frame.origin.y, SCREEN_WIDTH - 20 - self.tradeStatusLabel.frame.size.width, self.tradeStatusLabel.frame.size.height)];
    self.tdStatus.text = self.status;
    self.tdStatus.textAlignment = NSTextAlignmentRight;
    self.tdStatus.font = [UIFont systemFontOfSize:18];
    self.tdStatus.textColor = [UIColor blackColor];
    [self.baseScrollView addSubview:self.tdStatus];
    
    self.tdStatusLine = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.tradeStatusLabel.frame) + 3, SCREEN_WIDTH - 20, 1)];
    self.tdStatusLine.backgroundColor = [UIColor lightGrayColor];
    [self.baseScrollView addSubview:self.tdStatusLine];
    
    
    if (![self.cStatus isEqualToString:@""]) {
        NSString *str = nil;
        if ([self.cStatus isEqualToString:@"10A"]) {
            str = @"提现受理失败";
        }else if ([self.cStatus isEqualToString:@"10B"]) {
            str = @"提现中";
        }else if ([self.cStatus isEqualToString:@"10C"]) {
            str = @"提现成功";
        }else if ([self.cStatus isEqualToString:@"10D"]) {
            str = @"提现失败";
        }
        self.cashStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.tdStatusLine.frame) + 3, 80, 30)];
        self.cashStatusLabel.text = @"提现状态:";
        self.cashStatusLabel.font = [UIFont systemFontOfSize:18];
        self.cashStatusLabel.textColor = [UIColor blackColor];
        [self.baseScrollView addSubview:self.cashStatusLabel];
        
        self.cashStatus = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.cashStatusLabel.frame), self.cashStatusLabel.frame.origin.y, SCREEN_WIDTH - 20 - self.cashStatusLabel.frame.size.width, self.cashStatusLabel.frame.size.height)];
        self.cashStatus.text = str;
        self.cashStatus.textAlignment = NSTextAlignmentRight;
        self.cashStatus.font = [UIFont systemFontOfSize:18];
        self.cashStatus.textColor = [UIColor greenColor];
        [self.baseScrollView addSubview:self.cashStatus];
        
        self.cashStatusLine = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.cashStatusLabel.frame) + 3, SCREEN_WIDTH - 20, 1)];
        self.cashStatusLine.backgroundColor = [UIColor lightGrayColor];
        [self.baseScrollView addSubview:self.cashStatusLine];
        
        self.confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        self.confirmBtn.frame = CGRectMake(20, CGRectGetMaxY(self.cashStatusLine.frame) + 30, SCREEN_WIDTH - 40, 40);
        self.confirmBtn.backgroundColor = COLOR_THEME;
        [self.confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.confirmBtn setTintColor:[UIColor whiteColor]];
        [self.confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
        [self.baseScrollView addSubview:self.confirmBtn];
    }else {
        self.confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        self.confirmBtn.frame = CGRectMake(20, CGRectGetMaxY(self.tdStatusLine.frame) + 30, SCREEN_WIDTH - 40, 40);
        self.confirmBtn.backgroundColor = COLOR_THEME;
        [self.confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.confirmBtn setTintColor:[UIColor whiteColor]];
        [self.confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
        [self.baseScrollView addSubview:self.confirmBtn];
    }
    
    
}


- (void)confirmAction {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
