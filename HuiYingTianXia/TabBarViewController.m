//
//  TabBarViewController.m
//  库小二
//
//  Created by liguo.chen on 16/1/20.
//  Copyright © 2016年 liguo.chen. All rights reserved.
//

#import "TabBarViewController.h"
#import "Common.h"
#import "HomePageViewController.h"
#import "ManagerAccountViewController.h"
#import "ManagerMoneyViewController.h"
#import "AboutMeViewController.h"
#import "SettingViewController.h"
#import "MBProgressHUD+Add.h"
#import "MBProgressHUD.h"
#import "RealTimeViewController.h"

#import "AbstractItems.h"
#import "NSString+MD5HexDigest.h"
#import "NSString+Util.h"
#import "UIScrollView+MJRefresh.h"
#import "MJExtension.h"
#import "POSManger.h"
#import "OrderItem.h"
#import "ResponseDictionaryTool.h"

@interface TabBarViewController ()<UITabBarControllerDelegate>
@property(nonatomic, assign)NSInteger page;//分页
@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.tabBar.backgroundColor = [UIColor whiteColor];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       COLOR_FONT_GRAY, UITextAttributeTextColor,
                                                       nil] forState:UIControlStateNormal];
    UIColor *titleHighlightedColor = COLOR_THEME;
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       titleHighlightedColor, UITextAttributeTextColor,
                                                       nil] forState:UIControlStateSelected];
    
    HomePageViewController *homeVc = [[HomePageViewController alloc] init];
    UINavigationController *homeNavi = [[UINavigationController alloc]initWithRootViewController:homeVc];
    [self addChildViewController:homeNavi];
    
    RealTimeViewController *realVc = [[RealTimeViewController alloc] init];
    UINavigationController *realNavi = [[UINavigationController alloc] initWithRootViewController:realVc];
    [self addChildViewController:realNavi];
    
//    ManagerAccountViewController *accountVc = [[ManagerAccountViewController alloc] init];
//    UINavigationController *accountNavi = [[UINavigationController alloc]initWithRootViewController:accountVc];
//    [self addChildViewController:accountNavi];
    
    ManagerMoneyViewController *moneyVc = [[ManagerMoneyViewController alloc] init];
    UINavigationController *moneyNavi = [[UINavigationController alloc]initWithRootViewController:moneyVc];
    [self addChildViewController:moneyNavi];
    
//    AboutMeViewController *meVc = [[AboutMeViewController alloc] init];
//    UINavigationController *meNavi = [[UINavigationController alloc]initWithRootViewController:meVc];
//    [self addChildViewController:meNavi];
    
    SettingViewController *meVc = [[SettingViewController alloc] init];
    UINavigationController *meNavi = [[UINavigationController alloc]initWithRootViewController:meVc];
    [self addChildViewController:meNavi];
    
}

@end
