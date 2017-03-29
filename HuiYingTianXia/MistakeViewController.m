//
//  MistakeViewController.m
//  HuiYingTianXia
//
//  Created by 朱颖宇 on 15/10/29.
//  Copyright © 2015年 tsmc. All rights reserved.
//

#import "MistakeViewController.h"

@interface MistakeViewController ()<UIScrollViewDelegate>

@property(nonatomic, strong)UIScrollView *baseView;//底层scrollview

@end

@implementation MistakeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"错误提示"];
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
    
    UIImage *image = [UIImage imageNamed:@"错误提示"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    if (IPHONE4__4S) {
        CGRect imageFrame = CGRectMake(10, 10, image.size.width/3 - 45, image.size.height/3 - 45);
        imageView.frame = imageFrame;
    }else if (IPHONE5__5S) {
        CGRect imageFrame = CGRectMake(10, 10, image.size.width/3 - 45, image.size.height/3 - 45);
        imageView.frame = imageFrame;
    }else if (IPHONE6) {
        CGRect imageFrame = CGRectMake(10, 10, image.size.width/3, image.size.height/3 - 40);
        imageView.frame = imageFrame;
    }else {
        CGRect imageFrame = CGRectMake(10, 10, image.size.width/3 + 45, image.size.height/3 - 40);
        imageView.frame = imageFrame;
    }
    
    [self.baseView addSubview:imageView];
}

@end
