//
//  TradeDetailInfoViewController.m
//  HuiYingTianXia
//
//  Created by 朱颖宇 on 15/9/29.
//  Copyright © 2015年 tsmc. All rights reserved.
//

#import "TradeDetailInfoViewController.h"
#import "POSManger.h"
#import "NSString+MD5HexDigest.h"
#import "NetAPIManger.h"
#import "NetAPIClient.h"
#import "MJExtension.h"
#import "TradeRecordViewController.h"
#import "MBProgressHUD+Add.h"
#import "ResponseDictionaryTool.h"

@interface TradeDetailInfoViewController ()

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
@property(strong,nonatomic)UIView *signView;//签名view
@property(strong,nonatomic)UILabel *signLabel;//签名label
@property(strong,nonatomic)UIImageView *signImageView;//签名imageView
@property(strong,nonatomic)UIButton *cancleBtn;//取消按钮
@property(strong,nonatomic)UIButton *confirmBtn;//确定按钮

@end

@implementation TradeDetailInfoViewController

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self dismissLine];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"交易明细";
    [self setBackBarButtonItemWithRealTitle:@"返回"];
    self.navigationController.navigationBar.barTintColor = COLOR_THEME;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [MBProgressHUD showSuccess:@"提现最低额度为500.00" toView:self.view];
    
    self.baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.baseScrollView.backgroundColor = COLOR_THE_WHITE;
    if (IPHONE4__4S) {
        self.baseScrollView.contentSize = CGSizeMake(0, SCREEN_HEIGHT * 1.4);
    }else if (IPHONE5__5S) {
        self.baseScrollView.contentSize = CGSizeMake(0, SCREEN_HEIGHT * 1.2);
    }else if (IPHONE6) {
        self.baseScrollView.contentSize = CGSizeMake(0, SCREEN_HEIGHT * 1.1 - 50);
    }else {
        self.baseScrollView.contentSize = CGSizeMake(0, SCREEN_HEIGHT * 1.2);
    }
    [self.view addSubview:self.baseScrollView];
    
    self.tradeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90)];
    self.tradeView.backgroundColor = COLOR_THEME;
    [self.baseScrollView addSubview:self.tradeView];
    
//    [MBProgressHUD showSuccess:@"提现最低额度为500.00" toView:self.baseScrollView];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:MerchantSource] isEqualToString:@"APP"]) {
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
        self.tdName.text = self.name;
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
        
        if (![self.cardNum isEqualToString:@""]) {
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
        }else {
            self.tradeNumbelLael = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.tdTimeLine.frame) + 3, 80, 30)];
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
        }
        
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
        
        if (![self.authorizeNum isEqualToString:@""]) {
            self.authorizeNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.tdStatusLine.frame) + 3, 80, 30)];
            self.authorizeNumberLabel.text = @"授权码:";
            self.authorizeNumberLabel.font = [UIFont systemFontOfSize:18];
            self.authorizeNumberLabel.textColor = [UIColor blackColor];
            [self.baseScrollView addSubview:self.authorizeNumberLabel];
            
            self.authorizeNumber = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.authorizeNumberLabel.frame), self.authorizeNumberLabel.frame.origin.y, SCREEN_WIDTH - 20 - self.authorizeNumberLabel.frame.size.width, self.authorizeNumberLabel.frame.size.height)];
            self.authorizeNumber.text = self.authorizeNum;
            self.authorizeNumber.textAlignment = NSTextAlignmentRight;
            self.authorizeNumber.font = [UIFont systemFontOfSize:18];
            self.authorizeNumber.textColor = [UIColor blackColor];
            [self.baseScrollView addSubview:self.authorizeNumber];
            
            self.authorizeNumberLine = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.authorizeNumberLabel.frame) + 3, SCREEN_WIDTH - 20, 1)];
            self.authorizeNumberLine.backgroundColor = [UIColor lightGrayColor];
            [self.baseScrollView addSubview:self.authorizeNumberLine];
            
            self.signView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.authorizeNumberLine.frame) + 5, SCREEN_WIDTH - 20, 100)];
            self.signView.backgroundColor = [UIColor whiteColor];
            [self.baseScrollView addSubview:self.signView];
            
            self.signLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 3, self.signView.frame.size.width, 30)];
            self.signLabel.text = @"持卡人签字:";
            self.signLabel.textColor = [UIColor blackColor];
            self.signLabel.font = [UIFont systemFontOfSize:17];
            [self.signView addSubview:self.signLabel];
            
            self.signImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.signLabel.frame), self.signView.frame.size.width, self.signView.frame.size.height - self.signLabel.frame.size.height)];
            self.signImageView.backgroundColor = [UIColor whiteColor];
            NSURL *url = [NSURL URLWithString:self.imageUrl];
            self.signImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            [self.signView addSubview:self.signImageView];
            
            self.cancleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            self.cancleBtn.frame = CGRectMake(10, CGRectGetMaxY(self.signView.frame) + 30, (SCREEN_WIDTH - 20 - 30)/2, 40);
            self.cancleBtn.backgroundColor = COLOR_THEME;
            [self.cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
            [self.cancleBtn setTintColor:[UIColor whiteColor]];
            [self.cancleBtn addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
            [self.baseScrollView addSubview:self.cancleBtn];
            
            self.confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            self.confirmBtn.frame = CGRectMake(CGRectGetMaxX(self.cancleBtn.frame) + 30, CGRectGetMaxY(self.signView.frame) + 30, (SCREEN_WIDTH - 20 - 30)/2, 40);
            self.confirmBtn.backgroundColor = COLOR_THEME;
            [self.confirmBtn setTitle:@"提现" forState:UIControlStateNormal];
            [self.confirmBtn setTintColor:[UIColor whiteColor]];
            [self.confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
            [self.baseScrollView addSubview:self.confirmBtn];
            
        }else if ([self.authorizeNum isEqualToString:@""]) {
            [self.authorizeNumberLabel setHidden:YES];
            [self.authorizeNumber setHidden:YES];
            [self.authorizeNumberLine setHidden:YES];
            
            self.signView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.tdStatusLine.frame) + 5, SCREEN_WIDTH - 20, 100)];
            self.signView.backgroundColor = [UIColor whiteColor];
            [self.baseScrollView addSubview:self.signView];
            
            self.signLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 3, self.signView.frame.size.width, 30)];
            self.signLabel.text = @"持卡人签字:";
            self.signLabel.textColor = [UIColor blackColor];
            self.signLabel.font = [UIFont systemFontOfSize:17];
            [self.signView addSubview:self.signLabel];
            
            self.signImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.signLabel.frame), self.signView.frame.size.width, self.signView.frame.size.height - self.signLabel.frame.size.height)];
            self.signImageView.backgroundColor = [UIColor whiteColor];
            NSURL *url = [NSURL URLWithString:self.imageUrl];
            self.signImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            [self.signView addSubview:self.signImageView];
            
            self.cancleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            self.cancleBtn.frame = CGRectMake(10, CGRectGetMaxY(self.signView.frame) + 30, (SCREEN_WIDTH - 20 - 30)/2, 40);
            self.cancleBtn.backgroundColor = COLOR_THEME;
            [self.cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
            [self.cancleBtn setTintColor:[UIColor whiteColor]];
            [self.cancleBtn addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
            [self.baseScrollView addSubview:self.cancleBtn];
            
            self.confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            self.confirmBtn.frame = CGRectMake(CGRectGetMaxX(self.cancleBtn.frame) + 30, CGRectGetMaxY(self.signView.frame) + 30, (SCREEN_WIDTH - 20 - 30)/2, 40);
            self.confirmBtn.backgroundColor = COLOR_THEME;
            [self.confirmBtn setTitle:@"提现" forState:UIControlStateNormal];
            [self.confirmBtn setTintColor:[UIColor whiteColor]];
            [self.confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
            [self.baseScrollView addSubview:self.confirmBtn];
            
        }
    }else {
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
        self.tdName.text = self.name;
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
        
        if (![self.authorizeNum isEqualToString:@""]) {
            self.authorizeNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.tdStatusLine.frame) + 3, 80, 30)];
            self.authorizeNumberLabel.text = @"授权码:";
            self.authorizeNumberLabel.font = [UIFont systemFontOfSize:18];
            self.authorizeNumberLabel.textColor = [UIColor blackColor];
            [self.baseScrollView addSubview:self.authorizeNumberLabel];
            
            self.authorizeNumber = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.authorizeNumberLabel.frame), self.authorizeNumberLabel.frame.origin.y, SCREEN_WIDTH - 20 - self.authorizeNumberLabel.frame.size.width, self.authorizeNumberLabel.frame.size.height)];
            self.authorizeNumber.text = self.authorizeNum;
            self.authorizeNumber.textAlignment = NSTextAlignmentRight;
            self.authorizeNumber.font = [UIFont systemFontOfSize:18];
            self.authorizeNumber.textColor = [UIColor blackColor];
            [self.baseScrollView addSubview:self.authorizeNumber];
            
            self.authorizeNumberLine = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.authorizeNumberLabel.frame) + 3, SCREEN_WIDTH - 20, 1)];
            self.authorizeNumberLine.backgroundColor = [UIColor lightGrayColor];
            [self.baseScrollView addSubview:self.authorizeNumberLine];
            
//            self.signView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.authorizeNumberLine.frame) + 5, SCREEN_WIDTH - 20, 100)];
//            self.signView.backgroundColor = [UIColor whiteColor];
//            [self.baseScrollView addSubview:self.signView];
//            
//            self.signLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 3, self.signView.frame.size.width, 30)];
//            self.signLabel.text = @"持卡人签字:";
//            self.signLabel.textColor = [UIColor blackColor];
//            self.signLabel.font = [UIFont systemFontOfSize:17];
//            [self.signView addSubview:self.signLabel];
//            
//            self.signImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.signLabel.frame), self.signView.frame.size.width, self.signView.frame.size.height - self.signLabel.frame.size.height)];
//            self.signImageView.backgroundColor = [UIColor whiteColor];
//            NSURL *url = [NSURL URLWithString:self.imageUrl];
//            self.signImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
//            [self.signView addSubview:self.signImageView];
            
            self.cancleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            self.cancleBtn.frame = CGRectMake(10, CGRectGetMaxY(self.authorizeNumberLine.frame) + 30, (SCREEN_WIDTH - 20 - 30)/2, 40);
            self.cancleBtn.backgroundColor = COLOR_THEME;
            [self.cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
            [self.cancleBtn setTintColor:[UIColor whiteColor]];
            [self.cancleBtn addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
            [self.baseScrollView addSubview:self.cancleBtn];
            
            self.confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            self.confirmBtn.frame = CGRectMake(CGRectGetMaxX(self.cancleBtn.frame) + 30, CGRectGetMaxY(self.authorizeNumberLine.frame) + 30, (SCREEN_WIDTH - 20 - 30)/2, 40);
            self.confirmBtn.backgroundColor = COLOR_THEME;
            [self.confirmBtn setTitle:@"提现" forState:UIControlStateNormal];
            [self.confirmBtn setTintColor:[UIColor whiteColor]];
            [self.confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
            [self.baseScrollView addSubview:self.confirmBtn];
            
        }else if ([self.authorizeNum isEqualToString:@""]) {
            [self.authorizeNumberLabel setHidden:YES];
            [self.authorizeNumber setHidden:YES];
            [self.authorizeNumberLine setHidden:YES];
            
//            self.signView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.tdStatusLine.frame) + 5, SCREEN_WIDTH - 20, 100)];
//            self.signView.backgroundColor = [UIColor whiteColor];
//            [self.baseScrollView addSubview:self.signView];
            
//            self.signLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 3, self.signView.frame.size.width, 30)];
//            self.signLabel.text = @"持卡人签字:";
//            self.signLabel.textColor = [UIColor blackColor];
//            self.signLabel.font = [UIFont systemFontOfSize:17];
//            [self.signView addSubview:self.signLabel];
//            
//            self.signImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.signLabel.frame), self.signView.frame.size.width, self.signView.frame.size.height - self.signLabel.frame.size.height)];
//            self.signImageView.backgroundColor = [UIColor whiteColor];
//            NSURL *url = [NSURL URLWithString:self.imageUrl];
//            self.signImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
//            [self.signView addSubview:self.signImageView];
            
            self.cancleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            self.cancleBtn.frame = CGRectMake(10, CGRectGetMaxY(self.tdStatusLine.frame) + 30, (SCREEN_WIDTH - 20 - 30)/2, 40);
            self.cancleBtn.backgroundColor = COLOR_THEME;
            [self.cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
            [self.cancleBtn setTintColor:[UIColor whiteColor]];
            [self.cancleBtn addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
            [self.baseScrollView addSubview:self.cancleBtn];
            
            self.confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            self.confirmBtn.frame = CGRectMake(CGRectGetMaxX(self.cancleBtn.frame) + 30, CGRectGetMaxY(self.tdStatusLine.frame) + 30, (SCREEN_WIDTH - 20 - 30)/2, 40);
            self.confirmBtn.backgroundColor = COLOR_THEME;
            [self.confirmBtn setTitle:@"提现" forState:UIControlStateNormal];
            [self.confirmBtn setTintColor:[UIColor whiteColor]];
            [self.confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
            [self.baseScrollView addSubview:self.confirmBtn];
            
        }
    }
    
    
}

- (void)cancleAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)confirmAction {
    AbstractItems *item = [[AbstractItems alloc]init];
    item.n0 = @"0200";
    item.n3 = @"190989";
    item.n11 = self.originalVoucherNo;
    NSLog(@"n11:%@",item.n11);
    item.n60 = self.tradeNum;
    NSLog(@"n60:%@",item.n60);
    NSString *str = [NSString stringWithFormat:@"%@%@%@%@%@%@",item.n0,item.n3,item.n11,item.n59,item.n60,MainKey];
    NSLog(@"str:%@",str);
    item.n64 = [[str md5HexDigest] uppercaseString];
    
    [[NetAPIManger sharedManger] request_CashWithParams:[item keyValues] andBlock:^(id data, NSError *error) {
        AbstractItems *item = (AbstractItems *)data;
        if (!error && [item.n39 isEqualToString:@"00"]) {
            [MBProgressHUD showSuccess:@"提现受理中" toView:self.view];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [NSThread sleepForTimeInterval:1];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            });
//            TradeRecordViewController *queryVc = [[TradeRecordViewController alloc] init];
//            [MBProgressHUD showSuccess:@"提现受理中" toView:queryVc.view];
//            [self.navigationController pushViewController:queryVc animated:YES];
            
        }else{
            
            if ([[ResponseDictionaryTool responseDic] objectForKey:item.n39]) {
                NSString *error = [[ResponseDictionaryTool responseDic] objectForKey:item.n39];
                NSLog(@"error:%@",error);
                [MBProgressHUD showSuccess:error toView:self.view];
            }else {
                [MBProgressHUD showSuccess:@"未知错误" toView:self.view];
            }
            
        }
    }];
}

@end
