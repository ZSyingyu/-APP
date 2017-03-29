//
//  ApplyWithdrawViewController.m
//  HuiYingTianXia
//
//  Created by tsmc on 15-3-22.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import "ApplyWithdrawViewController.h"
@interface ApplyWithdrawViewController()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong)UIScrollView *baseView;

@end

@implementation ApplyWithdrawViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"申请结算";
    [self setBackBarButtonItemWithTitle:@"返回"];
    [self setRightBarButtonItemWithTitle:@"首页"];
    
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
}

- (void)createCellUtilWithStartY:(CGFloat)starty 
{
    UIView *baseUtil = [[UIView alloc] init];
    [baseUtil setBackgroundColor:[UIColor clearColor]];
    [self.baseView addSubview:baseUtil];
    [baseUtil makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(starty);
    }];
    
}

@end
