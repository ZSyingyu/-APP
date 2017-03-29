//
//  TradeDetailViewController.m
//  HuiYingTianXia
//
//  Created by 朱颖宇 on 15/9/11.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import "TradeDetailViewController.h"
#import "NSString+MD5HexDigest.h"
#import "NetAPIManger.h"
#import "NetAPIClient.h"
#import "MJExtension.h"
#import "TradeRecordViewController.h"
#import "MBProgressHUD+Add.h"
#import "ResponseDictionaryTool.h"
#import "POSManger.h"

@interface TradeDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *tdAmount;
@property (weak, nonatomic) IBOutlet UILabel *tdName;
@property (weak, nonatomic) IBOutlet UILabel *tdType;
@property (weak, nonatomic) IBOutlet UILabel *tdRate;
@property (weak, nonatomic) IBOutlet UILabel *tdTime;
@property (weak, nonatomic) IBOutlet UILabel *tdStatus;
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;
- (IBAction)cancleAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
- (IBAction)confirmAction:(id)sender;
@property (weak, nonatomic) IBOutlet UINavigationBar *navibar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backItem;
- (IBAction)backAction:(id)sender;

@end

@implementation TradeDetailViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = COLOR_THE_WHITE;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navibar.barTintColor = COLOR_THE_WHITE;
    [self.navibar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       
       NSForegroundColorAttributeName:[UIColor blackColor]}];
//    self.navigationItem.title = @"交易明细";
//    [self setBackBarButtonItemWithRealTitle:@"返回"];
    
    [MBProgressHUD showSuccess:@"提现最低额度为500.00" toView:self.view];
    
    self.tdAmount.text = [POSManger transformAmountWithPoint:self.amount];
    self.tdTime.text = self.time;
    self.tdType.text = self.type;
    self.tdStatus.text = self.status;
    self.tdRate.text = [NSString stringWithFormat:@"%@-%@",self.strRate,self.maxFee];
    self.tdName.text = self.name;
}

- (IBAction)cancleAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)confirmAction:(id)sender {
    
    AbstractItems *item = [[AbstractItems alloc]init];
    item.n0 = @"0200";
    item.n3 = @"190989";
    item.n11 = self.originalVoucherNo;
    NSLog(@"n11:%@",item.n11);
    item.n60 = self.orderNo;
    NSLog(@"n60:%@",item.n60);
    NSString *str = [NSString stringWithFormat:@"%@%@%@%@%@%@",item.n0,item.n3,item.n11,item.n59,item.n60,MainKey];
    NSLog(@"str:%@",str);
    item.n64 = [[str md5HexDigest] uppercaseString];
    
    [[NetAPIManger sharedManger] request_CashWithParams:[item keyValues] andBlock:^(id data, NSError *error) {
        AbstractItems *item = (AbstractItems *)data;
        if (!error && [item.n39 isEqualToString:@"00"]) {
            TradeRecordViewController *queryVc = [[TradeRecordViewController alloc] init];
            [MBProgressHUD showSuccess:@"提现受理中" toView:queryVc.view];
            [self.navigationController pushViewController:queryVc animated:YES];
            
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
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
