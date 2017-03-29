//
//  CashInstructionViewController.m
//  HuiYingTianXia
//
//  Created by 朱颖宇 on 15/10/29.
//  Copyright © 2015年 tsmc. All rights reserved.
//

#import "CashInstructionViewController.h"

@interface CashInstructionViewController ()<UIScrollViewDelegate>

@property(nonatomic, strong)UIScrollView *baseView;//底层scrollview

@end

@implementation CashInstructionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"提现说明"];
    [self setBackBarButtonItemWithTitle:@"返回"];
    
    self.baseView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.baseView.backgroundColor = [UIColor clearColor];
    self.baseView.delegate = self;
    [self.view addSubview:self.baseView];
    
    if (IPHONE4__4S) {
        self.baseView.contentSize = CGSizeMake(0, SCREEN_HEIGHT * 4);
    }else if (IPHONE5__5S) {
        self.baseView.contentSize = CGSizeMake(0, SCREEN_HEIGHT * 3.3);
    }else if (IPHONE6) {
        self.baseView.contentSize = CGSizeMake(0, SCREEN_HEIGHT * 2.9);
    }else {
        self.baseView.contentSize = CGSizeMake(0, SCREEN_HEIGHT * 2.7);
    }
    
    UIImage *image = [UIImage imageNamed:@"提现说明"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    if (IPHONE4__4S) {
        CGRect imageFrame = CGRectMake(10, 0, image.size.width/2 - 50, image.size.height/2 - 50);
        imageView.frame = imageFrame;
        
    }else if (IPHONE5__5S) {
        CGRect imageFrame = CGRectMake(10, 0, image.size.width/2 - 50, image.size.height/2 - 50);
        imageView.frame = imageFrame;
    }else if (IPHONE6) {
        CGRect imageFrame = CGRectMake(10, 0, image.size.width/2 - 50, image.size.height/2 - 50);
        imageView.frame = imageFrame;
    }else {
        CGRect imageFrame = CGRectMake(10, 0, image.size.width/2 + 40, image.size.height/2 + 40);
        imageView.frame = imageFrame;
    }
    [self.baseView addSubview:imageView];
}


@end
