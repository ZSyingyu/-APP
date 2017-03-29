//
//  CardCertifyViewController.m
//  HuiYingTianXia
//
//  Created by liguo.chen on 15/11/23.
//  Copyright © 2015年 tsmc. All rights reserved.
//

#import "CardCertifyViewController.h"

@interface CardCertifyViewController ()<UIScrollViewDelegate>

@property(nonatomic, strong)UIScrollView *baseView;//底层scrollview

@end

@implementation CardCertifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"银行卡认证说明"];
    [self setBackBarButtonItemWithTitle:@"返回"];
    
    self.baseView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.baseView.backgroundColor = [UIColor clearColor];
    self.baseView.delegate = self;
    [self.view addSubview:self.baseView];
    
    if (IPHONE4__4S) {
        self.baseView.contentSize = CGSizeMake(0, SCREEN_HEIGHT * 7);
    }else if (IPHONE5__5S) {
        self.baseView.contentSize = CGSizeMake(0, SCREEN_HEIGHT * 5.4);
    }else if (IPHONE6) {
        self.baseView.contentSize = CGSizeMake(0, SCREEN_HEIGHT * 4.7);
    }else {
        self.baseView.contentSize = CGSizeMake(0, SCREEN_HEIGHT *4.2);
    }
    
    UIImage *image = [UIImage imageNamed:@"银行卡认证"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    if (IPHONE4__4S) {
        CGRect imageFrame = CGRectMake(10, 10, image.size.width/2 - 45, image.size.height/2 - 45);
        imageView.frame = imageFrame;
    }else if (IPHONE5__5S) {
        CGRect imageFrame = CGRectMake(10, 10, image.size.width/2 - 45, image.size.height/2 - 45);
        imageView.frame = imageFrame;
    }else if (IPHONE6) {
        CGRect imageFrame = CGRectMake(10, 10, image.size.width/2, image.size.height/2 - 40);
        imageView.frame = imageFrame;
    }else {
        CGRect imageFrame = CGRectMake(10, 10, image.size.width/2 + 45, image.size.height/2 - 40);
        imageView.frame = imageFrame;
    }
    
    [self.baseView addSubview:imageView];
    
}



@end
