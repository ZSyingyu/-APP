//
//  TradeViewController.m
//  HuiYingTianXia
//
//  Created by 朱颖宇 on 15/9/14.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import "TradeViewController.h"
#import "POSManger.h"
#import "MBProgressHUD+Add.h"
#import "MBProgressHUD.h"

@interface TradeViewController ()


@property (weak, nonatomic) IBOutlet UILabel *tdAmount;
@property (weak, nonatomic) IBOutlet UILabel *tdName;
@property (weak, nonatomic) IBOutlet UILabel *tdType;
@property (weak, nonatomic) IBOutlet UILabel *tdRate;
@property (weak, nonatomic) IBOutlet UILabel *tdTime;
@property (weak, nonatomic) IBOutlet UILabel *tdStatus;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
- (IBAction)confirmAction:(id)sender;

@property (weak, nonatomic) IBOutlet UINavigationBar *navibar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backItem;
- (IBAction)backAction:(id)sender;

@end

@implementation TradeViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navibar.barTintColor = COLOR_THE_WHITE;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navibar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       
       NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.navibar.barTintColor = COLOR_THE_WHITE;
    
//    [MBProgressHUD showSuccess:@"提现最低额度为500.00" toView:self.view];
    
    self.tdAmount.text = [POSManger transformAmountWithPoint:self.amount]; 
    self.tdTime.text = self.time;
    self.tdType.text = self.type;
    self.tdStatus.text = self.status;
    self.tdRate.text = [NSString stringWithFormat:@"%@-%@",self.strRate,self.maxFee];
    self.tdName.text = self.name;
}

- (IBAction)confirmAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)backAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
