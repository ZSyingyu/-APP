//
//  BalanceDetailViewController.m
//  HuiYingTianXia
//
//  Created by 朱颖宇 on 15/6/26.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import "BalanceDetailViewController.h"
#import "AbstractItems.h"

@interface BalanceDetailViewController ()

@property(nonatomic, strong)UIScrollView *baseView;

@end

@implementation BalanceDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"交易详情";
    [self setBackBarButtonItemWithTitle:@"返回"];
    
    
    self.baseView = [[UIScrollView alloc] init];
    [self.baseView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.baseView];
    [self.baseView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.width.equalTo(SCREEN_WIDTH);
    }];
    
    AbstractItems *item = [[AbstractItems alloc]init];
    
    UILabel *labBusiness = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 100, 35)];
    [labBusiness setText:@"商户名称"];
    [labBusiness setFont:[UIFont systemFontOfSize:20]];
    [labBusiness setTextColor:[UIColor lightGrayColor]];
    [self.baseView addSubview:labBusiness];
    
    UILabel *labName = [[UILabel alloc]initWithFrame:CGRectMake(100, 20, SCREEN_WIDTH - 100, 35)];
    item.n5 = [[NSUserDefaults standardUserDefaults] objectForKey:MerchantName];
    [labName setText:item.n5];
    [labName setFont:[UIFont systemFontOfSize:20]];
    [labName setTextColor:[UIColor blackColor]];
    [self.baseView addSubview:labName];
    
    UILabel *labType = [[UILabel alloc]initWithFrame:CGRectMake(10, 60, 100, 35)];
    [labType setText:@"交易类型"];
    [labType setFont:[UIFont systemFontOfSize:20]];
    [labType setTextColor:[UIColor lightGrayColor]];
    [self.baseView addSubview:labType];

    UILabel *labTypeName = [[UILabel alloc]initWithFrame:CGRectMake(100, 60, SCREEN_WIDTH - 100, 35)];
    [labTypeName setText:@"余额查询"];
    [labTypeName setFont:[UIFont systemFontOfSize:20]];
    [labTypeName setTextColor:[UIColor blackColor]];
    [self.baseView addSubview:labTypeName];
    
    UILabel *labCardNumber = [[UILabel alloc]initWithFrame:CGRectMake(10, 100, 100, 35)];
    [labCardNumber setText:@"交易卡号"];
    [labCardNumber setFont:[UIFont systemFontOfSize:20]];
    [labCardNumber setTextColor:[UIColor lightGrayColor]];
    [self.baseView addSubview:labCardNumber];


    UILabel *labNumber = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, SCREEN_WIDTH - 100, 35)];
//    item.n2 = [self.cardInfo objectForKey:@"cardNumber"];
    labNumber.text = self.cardNumber;
    [labNumber setText:item.n2];
    [labNumber setFont:[UIFont systemFontOfSize:20]];
    [labNumber setTextColor:[UIColor blackColor]];
    [self.baseView addSubview:labNumber];
    
    UIView *intervalView = [[UIView alloc]initWithFrame:CGRectMake(0, 160, SCREEN_WIDTH, 1)];
    [intervalView setBackgroundColor:[UIColor lightGrayColor]];
    [self.baseView addSubview:intervalView];
    
    
}


@end
