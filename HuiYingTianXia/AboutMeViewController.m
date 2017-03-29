//
//  AboutMeViewController.m
//  HuiYingTianXia
//
//  Created by liguo.chen on 16/2/29.
//  Copyright © 2016年 tsmc. All rights reserved.
//

#import "AboutMeViewController.h"

@interface AboutMeViewController ()

@end

@implementation AboutMeViewController

-(instancetype)init {
    self=[super init];
    if (self) {
        self.tabBarItem.title = @"我的";
        self.tabBarController.tabBar.barTintColor = COLOR_THEME;
        self.tabBarItem.image = [[UIImage imageNamed:@"销售数据-ios未选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem.selectedImage=[[UIImage imageNamed:@"销售数据-ios"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
