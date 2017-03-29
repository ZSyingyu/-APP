//
//  ManagerAccountViewController.m
//  HuiYingTianXia
//
//  Created by liguo.chen on 16/2/29.
//  Copyright © 2016年 tsmc. All rights reserved.
//

#import "ManagerAccountViewController.h"
#import "MBProgressHUD+Add.h"
#import "MBProgressHUD.h"
#import "RealTimeViewController.h"
#import "TradeRecordViewController.h"
#import "QueryrRecordViewController.h"

#import "AbstractItems.h"
#import "NSString+MD5HexDigest.h"
#import "NSString+Util.h"
#import "UIScrollView+MJRefresh.h"
#import "MJExtension.h"
#import "POSManger.h"
#import "OrderItem.h"

@interface ManagerAccountViewController ()
{
    UIWindow *windows;
    UIView *view;
    UILabel *label;
}
@property(nonatomic, strong)NSArray *btnTitles;
@property(strong,nonatomic)NSArray *btnSelectedTitles;
@property(strong,nonatomic)UILabel *moneyLabel;
@property(nonatomic, assign)NSInteger page;//分页

@end

#define BTN_WIDTH HFixWidthBaseOn320(106.7)
#define LONG_BTN_WIDTH HFixWidthBaseOn320(198)
#define BTN_HEIGHT HFixWidthBaseOn320(106.7)

@implementation ManagerAccountViewController

-(instancetype)init {
    self=[super init];
    if (self) {
        self.tabBarItem.title = @"账户管理";
        self.tabBarController.tabBar.barTintColor = COLOR_THEME;
        self.tabBarItem.image = [[UIImage imageNamed:@"账户管理2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem.selectedImage=[[UIImage imageNamed:@"账户管理1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.page = 1;
    [self reloadData];
    self.moneyLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:Money];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"账户管理";
    
    UIImage *circleImage = [UIImage imageNamed:@"圆"];
    UIImageView *circleIamgeView = [[UIImageView alloc] init];
    CGRect frame = circleIamgeView.frame;
    frame.origin.y = 20.0;
    frame.size.width = circleImage.size.width;
    frame.size.height = circleImage.size.height;
    circleIamgeView.frame = frame;
    CGPoint center = circleIamgeView.center;
    center.x = SCREEN_WIDTH/2;
    circleIamgeView.center = center;
    circleIamgeView.image = circleImage;
    [self.view addSubview:circleIamgeView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    CGRect frame1 = titleLabel.frame;
    frame1.origin.y = 100.0;
    frame1.size.width = circleIamgeView.frame.size.width;
    frame1.size.height = 20.0;
    titleLabel.frame = frame1;
    CGPoint center1 = titleLabel.center;
    center1.x = SCREEN_WIDTH/2;
    titleLabel.center = center1;
    titleLabel.text = @"今日交易总金额";
    titleLabel.font = FONT_22;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    self.moneyLabel = [[UILabel alloc] init];
    CGRect frame2 = self.moneyLabel.frame;
    frame2.origin.y = CGRectGetMaxY(titleLabel.frame) + 20;
    frame2.size.width = circleIamgeView.frame.size.width;
    frame2.size.height = 20.0;
    self.moneyLabel.frame = frame2;
    CGPoint center2 = self.moneyLabel.center;
    center2.x = SCREEN_WIDTH/2;
    self.moneyLabel.center = center2;
    NSLog(@"money:%@",[[NSUserDefaults standardUserDefaults] objectForKey:Money]);
    self.moneyLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:Money];
    self.moneyLabel.font = FONT_23;
    self.moneyLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.moneyLabel];
    
    self.btnTitles = @[@"实时结算",@"交易明细"];
    
    UIButton *btnLine1 = nil;
    for (int i = 0; i < 2; i++) {
        
        btnLine1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnLine1 setTitle:[self.btnTitles objectAtIndex:i] forState:UIControlStateNormal];
        [btnLine1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnLine1.layer.cornerRadius = 5.0;
        btnLine1.layer.masksToBounds = YES;
        [btnLine1 setTag:i];
        
        [btnLine1 setBackgroundColor:COLOR_THEME];
        [btnLine1 setFrame:CGRectMake(30 + ((SCREEN_WIDTH - 60 - 15)/2 + 15) * i, CGRectGetMaxY(circleIamgeView.frame) + 20, (SCREEN_WIDTH - 60 - 15)/2, 50)];
        [btnLine1 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnLine1];
        
    }
    
    UILabel *promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(btnLine1.frame) + 20, SCREEN_WIDTH, 60)];
    promptLabel.text = @"请及时实名认证并绑定有效储蓄卡,未及时\n提取营业收入,将自动转入绑定的储蓄卡内";
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.textColor = COLOR_FONT_GRAY;
    promptLabel.numberOfLines = 0;
    [self.view addSubview:promptLabel];
    
}

//自定义弹出框
-(void)updataWindows {
    windows = [UIApplication sharedApplication].keyWindow;
    view = [[UIView alloc]initWithFrame:CGRectMake(40, SCREEN_HEIGHT/2 - 40, SCREEN_WIDTH - 80, 80)];
    view.backgroundColor = [UIColor blackColor];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 8.0f;
    label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.bounds.size.width, 80)];
    label.numberOfLines = 3;
    label.text = @" 您的信息已经重新提交，我们正在在加紧审核，请稍侯 ";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [windows addSubview:view];
    [view addSubview:label];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        //        [_scandone dismissAnimated:YES];
        [view removeFromSuperview];
    });
}

- (void)btnAction:(UIButton *)btn{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:MerchantSource] isEqualToString:@"APP"]) {
        //如果商户处于重新审核状态
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10D"] || [[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10C"]) {
            switch (btn.tag) {
                case 0:{
                    [self updataWindows];
                }
                    break;
                case 1:{
                    [self updataWindows];
                }
                    break;
                default:
                    break;
            }
        }else {
            switch (btn.tag) {
                case 0:{
                    TradeRecordViewController *realVc = [[TradeRecordViewController alloc] initWithNibName:@"TradeRecordViewController" bundle:nil];
                    //            [self.navigationController.navigationBar setHidden:NO];
                    realVc.hidesBottomBarWhenPushed  =YES;
                    [self.navigationController pushViewController:realVc animated:YES];
                }
                    break;
                case 1:{
                    if ([[[NSUserDefaults standardUserDefaults] objectForKey:Rate] isEqualToString:@"00000000"]) {
                        [MBProgressHUD showSuccess:@"请联系客服设置交易费率" toView:self.view];
                    }else {
                    
                        RealTimeViewController *realVc = [[RealTimeViewController alloc] initWithNibName:@"RealTimeViewController" bundle:nil];
                        //            [self.navigationController.navigationBar setHidden:NO];
                        realVc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:realVc animated:YES];
                        
                    }
                }
                    break;
                default:
                    break;
            }
        }
    }else {
        switch (btn.tag) {
            case 0:{
                TradeRecordViewController *realVc = [[TradeRecordViewController alloc] initWithNibName:@"TradeRecordViewController" bundle:nil];
                //                [self.navigationController.navigationBar setHidden:NO];
                realVc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:realVc animated:YES];

            }
                break;
            case 1:{
                QueryrRecordViewController *queryrRecordViewController = [[QueryrRecordViewController alloc] init];
                //                [self.navigationController.navigationBar setHidden:NO];
                queryrRecordViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:queryrRecordViewController animated:YES];

            }
                break;
            default:
                break;
        }
    }

}

-(void)reloadData {
    AbstractItems *item = [[AbstractItems alloc] init];
    item.n0 = @"0700";
    item.n3 = @"190978";
    item.n9 = @"00000000";
    item.n42 = [[NSUserDefaults standardUserDefaults] objectForKey:MerchantNo];
    NSLog(@"%@",item.n42);
    item.n60 = @"03000001010";
    NSString *str = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",item.n0, item.n3, item.n9,item.n42, item.n59,item.n60, MainKey];
    NSLog(@"str:%@",str);
    item.n64 = [[str md5HexDigest] uppercaseString];
    [[NetAPIManger sharedManger] request_RecordWithParams:[item keyValues] andBlock:^(id data, NSError *error) {
        AbstractItems *item = (AbstractItems *)data;
        if ([item.n39 isEqual:@"00"] && !error) {
            if (item.n57.count != 0) {
                NSLog(@"n57:%@",item.n57);
                for (OrderItem *order in item.n57) {
                    NSLog(@"order:%@",order);
                    NSString *str = [NSString stringWithFormat:@"%@",order.todayAmount];
                    NSLog(@"str:%@",str);
                    NSString *moneyStr = [POSManger transformAmountWithPoint:str];
                    NSLog(@"moneyStr:%@",moneyStr);
                    [[NSUserDefaults standardUserDefaults] setObject:moneyStr forKey:Money];
                }
            }
        }
        
    }];
}

@end
