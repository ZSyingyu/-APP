//
//  PublicNoticeViewController.m
//  HuiYingTianXia
//
//  Created by 朱颖宇 on 15/10/30.
//  Copyright © 2015年 tsmc. All rights reserved.
//

#import "PublicNoticeViewController.h"

@interface PublicNoticeViewController ()<UIScrollViewDelegate>

@property(nonatomic, strong)UIScrollView *baseView;//底层scrollview

@end

@implementation PublicNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"公告"];
    [self setBackBarButtonItemWithTitle:@"返回"];
    
    self.baseView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.baseView.backgroundColor = [UIColor clearColor];
    self.baseView.delegate = self;
    [self.view addSubview:self.baseView];
    
    if (IPHONE4__4S) {
        self.baseView.contentSize = CGSizeMake(0, SCREEN_HEIGHT * 1.8);
    }else if (IPHONE5__5S) {
        self.baseView.contentSize = CGSizeMake(0, SCREEN_HEIGHT * 1.6);
    }else if (IPHONE6) {
        self.baseView.contentSize = CGSizeMake(0, SCREEN_HEIGHT * 1.3);
    }else {
        self.baseView.contentSize = CGSizeMake(0, SCREEN_HEIGHT *1.2);
    }
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 30)];
    titleLabel.text = self.titleStr;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.numberOfLines = 0;
//    titleLabel.backgroundColor = [UIColor redColor];
    [self.baseView addSubview:titleLabel];
    
    UITextView *contentLabel = [[UITextView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(titleLabel.frame) + 7 , SCREEN_WIDTH - 20, SCREEN_HEIGHT)];
    contentLabel.text = self.contentStr;
    contentLabel.textColor = [UIColor blackColor];
    contentLabel.font = [UIFont systemFontOfSize:18];
    [self.baseView addSubview:contentLabel];
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:Isread];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"old" forKey:NewImage];
}



@end
