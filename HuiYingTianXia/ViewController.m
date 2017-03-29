//
//  ViewController.m
//  HuiYingTianXia
//
//  Created by tsmc on 15-3-17.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"
#import "NewLoginViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    LoginViewController *login = [[LoginViewController alloc] init];
//    [self.navigationController.navigationBar setHidden:YES];
//    [self.navigationController pushViewController:login animated:YES];
    
    NewLoginViewController *login = [[NewLoginViewController alloc] init];
    [self.navigationController.navigationBar setHidden:YES];
    [self.navigationController pushViewController:login animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
