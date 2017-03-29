//
//  CommonBreakdownViewController.m
//  HuiYingTianXia
//
//  Created by liguo.chen on 15/11/23.
//  Copyright © 2015年 tsmc. All rights reserved.
//

#import "CommonBreakdownViewController.h"

@interface CommonBreakdownViewController ()<UIScrollViewDelegate>

@property(nonatomic, strong)UIScrollView *baseView;//底层scrollview

@end

@implementation CommonBreakdownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"常见故障"];
    [self setBackBarButtonItemWithTitle:@"返回"];
    
    self.baseView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.baseView.backgroundColor = [UIColor clearColor];
    self.baseView.delegate = self;
    [self.view addSubview:self.baseView];
    
    if (IPHONE4__4S) {
        self.baseView.contentSize = CGSizeMake(0, SCREEN_HEIGHT * 1.6);
    }else if (IPHONE5__5S) {
        self.baseView.contentSize = CGSizeMake(0, SCREEN_HEIGHT * 1.2);
    }else if (IPHONE6) {
        self.baseView.contentSize = CGSizeMake(0, SCREEN_HEIGHT);
    }else {
        self.baseView.contentSize = CGSizeMake(0, SCREEN_HEIGHT);
    }
    
    UIImage *image = [UIImage imageNamed:@"常见故障"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    if (IPHONE4__4S) {
        CGRect imageFrame = CGRectMake(5, 10, image.size.width/2 - 45, image.size.height/2 - 45);
        imageView.frame = imageFrame;
    }else if (IPHONE5__5S) {
        CGRect imageFrame = CGRectMake(5, 10, image.size.width/2 - 45, image.size.height/2 - 45);
        imageView.frame = imageFrame;
    }else if (IPHONE6) {
        CGRect imageFrame = CGRectMake(5, 10, image.size.width/2, image.size.height/2 - 40);
        imageView.frame = imageFrame;
    }else {
        CGRect imageFrame = CGRectMake(5, 10, image.size.width/2 + 45, image.size.height/2 - 40);
        imageView.frame = imageFrame;
    }
    
    [self.baseView addSubview:imageView];
    
}

@end
