//
//  RateInstructionViewController.m
//  HuiYingTianXia
//
//  Created by 朱颖宇 on 15/10/29.
//  Copyright © 2015年 tsmc. All rights reserved.
//

#import "RateInstructionViewController.h"

@interface RateInstructionViewController ()<UIScrollViewDelegate>

@property(nonatomic, strong)UIScrollView *baseView;//底层scrollview

@end

@implementation RateInstructionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"费率说明"];
    [self setBackBarButtonItemWithTitle:@"返回"];
    
    self.baseView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.baseView.backgroundColor = [UIColor clearColor];
    self.baseView.delegate = self;
    [self.view addSubview:self.baseView];
    
    if (IPHONE4__4S) {
        self.baseView.contentSize = CGSizeMake(0, SCREEN_HEIGHT * 1.8);
    }else if (IPHONE5__5S) {
        self.baseView.contentSize = CGSizeMake(0, SCREEN_HEIGHT * 1.5);
    }else if (IPHONE6) {
        self.baseView.contentSize = CGSizeMake(0, SCREEN_HEIGHT * 1.2 + 30);
    }else {
        self.baseView.contentSize = CGSizeMake(0, SCREEN_HEIGHT * 1.2 + 30);
    }
    
    UIImage *image = [UIImage imageNamed:@"费率说明"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    if (IPHONE4__4S) {
        CGRect imageFrame = CGRectMake(10, 10, image.size.width/2 - 50, image.size.height/2 - 50);
        imageView.frame = imageFrame;
        
    }else if (IPHONE5__5S) {
        CGRect imageFrame = CGRectMake(10, 10, image.size.width/2 - 50, image.size.height/2 - 50);
        imageView.frame = imageFrame;
    }else if (IPHONE6) {
        CGRect imageFrame = CGRectMake(10, 10, image.size.width/2 - 50, image.size.height/2 - 50);
        imageView.frame = imageFrame;
    }else {
        CGRect imageFrame = CGRectMake(10, 10, image.size.width/2 + 40, image.size.height/2 + 40);
        imageView.frame = imageFrame;
    }
    
    [self.baseView addSubview:imageView];
    
}


@end
