//
//  PohtoDetailViewController.m
//  HuiYingTianXia
//
//  Created by 朱颖宇 on 15/7/20.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import "PohtoDetailViewController.h"

@interface PohtoDetailViewController ()
- (IBAction)backItem:(id)sender;

@end

@implementation PohtoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}



- (IBAction)backItem:(id)sender {
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:Certify] isEqualToString:@"资质认证"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:Certify] isEqualToString:@"银行卡认证"]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}
@end
