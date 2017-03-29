//
//  VersionInfoViewController.m
//  HuiYingTianXia
//
//  Created by liguo.chen on 16/3/3.
//  Copyright © 2016年 tsmc. All rights reserved.
//

#import "VersionInfoViewController.h"
#import "AbstractItems.h"



@interface VersionInfoViewController ()

@end

@implementation VersionInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"版本信息";
    [self setBackBarButtonItemWithTitle:@"返回"];
    
    UIImage *image = [UIImage imageNamed:@"版本图片"];
    UIImageView *imageView = [[UIImageView alloc] init];
    CGRect frame = imageView.frame;
    frame.origin.y = 20.0;
    frame.size.width = image.size.width;
    frame.size.height = image.size.height;
    imageView.frame = frame;
    CGPoint center = imageView.center;
    center.x = SCREEN_WIDTH/2;
    imageView.center = center;
    imageView.image = image;
    imageView.layer.cornerRadius = 10.0;
    imageView.layer.masksToBounds = YES;
    [self.view addSubview:imageView];
    
    
    AbstractItems *item = [[AbstractItems alloc] init];
    NSLog(@"n59:%@",item.n59);
    NSRange range = [item.n59 rangeOfString:@"-"];
    NSString *str = [item.n59 substringFromIndex:range.location + 1];
    NSString *str1 = [NSString stringWithFormat:@"版本信息:%@",str];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame) + 20, SCREEN_WIDTH, 20)];
    nameLabel.text = str1;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = FONT_20;
    [self.view addSubview:nameLabel];
    
    UILabel *companyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(nameLabel.frame) + 20, SCREEN_WIDTH, 20)];
    companyLabel.text = @"河北即尚信息技术服务有限公司";
    companyLabel.textAlignment = NSTextAlignmentCenter;
    companyLabel.textColor = COLOR_FONT_GRAY;
//    [self.view addSubview:companyLabel];
    

}



@end
