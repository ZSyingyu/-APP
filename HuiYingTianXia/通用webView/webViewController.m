//
//  webViewController.m
//  OptimalCar
//
//  Created by RoarRain on 15/5/26.
//  Copyright (c) 2015年 technology. All rights reserved.
//

#import "webViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"

@interface webViewController ()<UIWebViewDelegate>

@end

@implementation webViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = self.titles;
    [self loadWebView];
    [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
    UIImage *image = [UIImage imageNamed:@"返回"];
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, image.size.width/2, image.size.height/2)];
    [leftButton setImage:image forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
}

/**
 *  返回按钮点击事件
 */
- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadWebView
{
    self.webView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    self.webView.delegate = self;
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    self.webView.scalesPageToFit = YES;//实现页面缩放
    [self.webView loadRequest:request];
}

-(void)webViewDidStartLoad:(UIWebView *)webView {
//    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
