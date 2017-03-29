//
//  WeChatResultViewController.m
//  HuiYingTianXia
//
//  Created by liguo.chen on 16/9/20.
//  Copyright © 2016年 tsmc. All rights reserved.
//

#import "WeChatResultViewController.h"
#import "HomePageViewController.h"
#import "TabBarViewController.h"

@interface WeChatResultViewController ()

@end

@implementation WeChatResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"支付成功";
    [self setBackBarButtonItemWithTitle:@"返回"];
    
    UIImage *image = [UIImage imageNamed:@"支付成功"];
    UIImageView *imageView = [[UIImageView alloc] init];
    CGRect frame = imageView.frame;
    frame.origin.y = 15;
    frame.size.width = image.size.width;
    frame.size.height = image.size.height;
    imageView.frame = frame;
    CGPoint center = imageView.center;
    center.x = SCREEN_WIDTH/2;
    imageView.center = center;
    imageView.image = image;
    [self.view addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame), SCREEN_WIDTH, 40)];
    titleLabel.text = @"支付成功";
    titleLabel.textColor = [UIColor colorWithHexString:@"06b7f4"];
    titleLabel.font = FONT_18;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    UILabel *amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame), SCREEN_WIDTH, 40)];
    amountLabel.text = [NSString stringWithFormat:@"¥%@",self.amountStr];
    amountLabel.textColor = [UIColor blackColor];
    amountLabel.font = FONT_25;
    amountLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:amountLabel];
}

/**
 *  设置返回按钮标题
 */
- (void)setBackBarButtonItemWithTitle:(NSString *)title
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn setTitleColor:COLOR_MY_WHITE forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"NavBackSorrow"] forState:UIControlStateNormal];
    [btn setContentMode:UIViewContentModeScaleAspectFill];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -7, 0, 50)];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 10)];
    [btn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

/**
 *  返回按钮点击事件
 */
- (void)backAction:(id)sender
{
//    [self.navigationController popToRootViewControllerAnimated:YES];
    TabBarViewController *tabBarVc = [[TabBarViewController alloc] init];
    [self presentViewController:tabBarVc animated:YES completion:nil];
}

@end
