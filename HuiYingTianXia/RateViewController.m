//
//  RateViewController.m
//  HuiYingTianXia
//
//  Created by 朱颖宇 on 15/6/19.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import "RateViewController.h"
#import "ConsumeViewController.h"
#import "AbstractItems.h"
#import "NetAPIManger.h"
#import "MJExtension.h"
#import "MFADConsumeViewController.h"
#import "MFBTConsumeViewController.h"
//#import "YFBTConsumeViewController.h"
#import "XNBTConsumeViewController.h"
//#import "BaseViewController.h"
#import "BBADConsumeViewController.h"
#import "HomePageViewController.h"
#import "BBBTConsumeViewController.h"
#import "MFBTADConsumeViewController.h"
#import "XNBTADConsumeViewController.h"
#import "ZCBTADConsumeViewController.h"

@interface RateViewController ()
- (IBAction)cancle:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIButton *marketRate;
@property (weak, nonatomic) IBOutlet UIButton *wholesaleRate;
@property (weak, nonatomic) IBOutlet UIButton *foodRate;
@property (weak, nonatomic) IBOutlet UIButton *realtime;

- (IBAction)marketRate:(UIButton *)sender;
- (IBAction)wholesaleRate:(UIButton *)sender;
- (IBAction)foodRate:(UIButton *)sender;
- (IBAction)realtime:(UIButton *)sender;



@end



@implementation RateViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [[UIApplication sharedApplication].keyWindow setBackgroundColor:[UIColor whiteColor]];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)cancle:(UIBarButtonItem *)sender {
    
    HomePageViewController *homeVc = [[HomePageViewController alloc] init];
    [self.navigationController pushViewController:homeVc animated:YES];
    
//    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)marketRate:(UIButton *)sender {

    self.rate = @"00000049";
    [self choosePOS];
//    ConsumeViewController *consumeVc = [[ConsumeViewController alloc]init];
//    [self.navigationController pushViewController:consumeVc animated:YES];
    
//    consumeVc.rate = self.rate;
//    NSString *str = [self.rate substringFromIndex:1];
//    NSString *str1 = @"0";
//    consumeVc.rate = [NSString stringWithFormat:@"%@%@",str1,str];
//    NSLog(@"rate:%@",consumeVc.rate);
}

- (IBAction)wholesaleRate:(UIButton *)sender {

    self.rate = @"00000078";
    [self choosePOS];
//    ConsumeViewController *consumeVc = [[ConsumeViewController alloc]init];
//    [self.navigationController pushViewController:consumeVc animated:YES];
////    consumeVc.rate = self.rate;
//    NSString *str = [self.rate substringFromIndex:1];
//    NSString *str1 = @"0";
//    consumeVc.rate = [NSString stringWithFormat:@"%@%@",str1,str];
//    NSLog(@"rate:%@",consumeVc.rate);

}

- (IBAction)foodRate:(UIButton *)sender {

    self.rate = @"00000125";
    [self choosePOS];
//    ConsumeViewController *consumeVc = [[ConsumeViewController alloc]init];
//    [self.navigationController pushViewController:consumeVc animated:YES];
////    consumeVc.rate = self.rate;
//    NSString *str = [self.rate substringFromIndex:1];
//    NSString *str1 = @"0";
//    consumeVc.rate = [NSString stringWithFormat:@"%@%@",str1,str];
//    NSLog(@"rate:%@",consumeVc.rate);

}

- (IBAction)realtime:(UIButton *)sender {
    
    self.rate = @"00035078";
    [self choosePOS];
//    ConsumeViewController *consumeVc = [[ConsumeViewController alloc]init];
//    [self.navigationController pushViewController:consumeVc animated:YES];
////    consumeVc.rate = self.rate;
//    NSString *str = [self.rate substringFromIndex:1];
//    NSString *str1 = @"0";
//    consumeVc.rate = [NSString stringWithFormat:@"%@%@",str1,str];
//    NSLog(@"rate:%@",consumeVc.rate);
}

-(void)choosePOS {
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:Tag] isEqualToString:@"艾创音频"]) {
        ConsumeViewController *consumeVc = [[ConsumeViewController alloc]init];
        [self.navigationController pushViewController:consumeVc animated:YES];
        NSString *str = [self.rate substringFromIndex:1];
        NSString *str1 = @"0";
        consumeVc.rate = [NSString stringWithFormat:@"%@%@",str1,str];
        NSLog(@"rate:%@",consumeVc.rate);
    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:Tag] isEqualToString:@"艾创蓝牙"]){
        
    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:Tag] isEqualToString:@"魔方音频"]){
        MFADConsumeViewController *consumeVc = [[MFADConsumeViewController alloc]init];
        [self.navigationController pushViewController:consumeVc animated:YES];
        NSString *str = [self.rate substringFromIndex:1];
        NSString *str1 = @"0";
        consumeVc.rate = [NSString stringWithFormat:@"%@%@",str1,str];
        NSLog(@"rate:%@",consumeVc.rate);
        
    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:Tag] isEqualToString:@"魔方蓝牙"]){
        MFBTConsumeViewController *consumeVc = [[MFBTConsumeViewController alloc]init];
        [self.navigationController pushViewController:consumeVc animated:YES];
        NSString *str = [self.rate substringFromIndex:1];
        NSString *str1 = @"0";
        consumeVc.rate = [NSString stringWithFormat:@"%@%@",str1,str];
        NSLog(@"rate:%@",consumeVc.rate);
    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:Tag] isEqualToString:@"鑫诺蓝牙"]){
        XNBTConsumeViewController *consumeVc = [[XNBTConsumeViewController alloc]init];
        [self.navigationController pushViewController:consumeVc animated:YES];
        NSString *str = [self.rate substringFromIndex:1];
        NSString *str1 = @"0";
        consumeVc.rate = [NSString stringWithFormat:@"%@%@",str1,str];
        NSLog(@"rate:%@",consumeVc.rate);
    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:Tag] isEqualToString:@"BBPOS音频"]){
        BBADConsumeViewController *consumeVc = [[BBADConsumeViewController alloc]init];
        [self.navigationController pushViewController:consumeVc animated:YES];
        NSString *str = [self.rate substringFromIndex:1];
        NSString *str1 = @"0";
        consumeVc.rate = [NSString stringWithFormat:@"%@%@",str1,str];
        NSLog(@"rate:%@",consumeVc.rate);
    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:Tag] isEqualToString:@"BBPOS蓝牙"]){
        BBBTConsumeViewController *consumeVc = [[BBBTConsumeViewController alloc]init];
        [self.navigationController pushViewController:consumeVc animated:YES];
        NSString *str = [self.rate substringFromIndex:1];
        NSString *str1 = @"0";
        consumeVc.rate = [NSString stringWithFormat:@"%@%@",str1,str];
        NSLog(@"rate:%@",consumeVc.rate);
    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:Tag] isEqualToString:@"魔方蓝牙无键盘"]){
        MFBTADConsumeViewController *consumeVc = [[MFBTADConsumeViewController alloc]init];
        [self.navigationController pushViewController:consumeVc animated:YES];
        NSString *str = [self.rate substringFromIndex:1];
        NSString *str1 = @"0";
        consumeVc.rate = [NSString stringWithFormat:@"%@%@",str1,str];
        NSLog(@"rate:%@",consumeVc.rate);
    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:Tag] isEqualToString:@"鑫诺蓝牙无键盘"]){
        XNBTADConsumeViewController *consumeVc = [[XNBTADConsumeViewController alloc]init];
        [self.navigationController pushViewController:consumeVc animated:YES];
        NSString *str = [self.rate substringFromIndex:1];
        NSString *str1 = @"0";
        consumeVc.rate = [NSString stringWithFormat:@"%@%@",str1,str];
        NSLog(@"rate:%@",consumeVc.rate);
    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:Tag] isEqualToString:@"中磁蓝牙无键盘"]){
        XNBTADConsumeViewController *consumeVc = [[XNBTADConsumeViewController alloc]init];
        [self.navigationController pushViewController:consumeVc animated:YES];
        NSString *str = [self.rate substringFromIndex:1];
        NSString *str1 = @"0";
        consumeVc.rate = [NSString stringWithFormat:@"%@%@",str1,str];
        NSLog(@"rate:%@",consumeVc.rate);
    }else {
        ConsumeViewController *consumeVc = [[ConsumeViewController alloc]init];
        [self.navigationController pushViewController:consumeVc animated:YES];
        NSString *str = [self.rate substringFromIndex:1];
        NSString *str1 = @"0";
        consumeVc.rate = [NSString stringWithFormat:@"%@%@",str1,str];
        NSLog(@"rate:%@",consumeVc.rate);
    }
}



@end
