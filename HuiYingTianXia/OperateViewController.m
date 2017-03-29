//
//  OperateViewController.m
//  HuiYingTianXia
//
//  Created by 朱颖宇 on 15/10/29.
//  Copyright © 2015年 tsmc. All rights reserved.
//

#import "OperateViewController.h"

@interface OperateViewController ()<UIScrollViewDelegate>

@property(nonatomic, strong)UIScrollView *baseView;//底层scrollview

@end

@implementation OperateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"操作说明"];
    [self setBackBarButtonItemWithTitle:@"返回"];
    
    self.baseView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.baseView.backgroundColor = [UIColor clearColor];
    self.baseView.delegate = self;
    [self.view addSubview:self.baseView];
    
    if (IPHONE4__4S) {
        self.baseView.contentSize = CGSizeMake(0, SCREEN_HEIGHT * 10.5);
    }else if (IPHONE5__5S) {
        self.baseView.contentSize = CGSizeMake(0, SCREEN_HEIGHT * 9);
    }else if (IPHONE6) {
        self.baseView.contentSize = CGSizeMake(0, SCREEN_HEIGHT * 7.5 + 50);
    }else {
        self.baseView.contentSize = CGSizeMake(0, SCREEN_HEIGHT * 7);
    }
    
    UILabel *titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 25)];
    titleLabel1.text = @"如何选择刷卡器";
    titleLabel1.textAlignment = NSTextAlignmentCenter;
    titleLabel1.textColor = [UIColor blackColor];
    titleLabel1.font = [UIFont systemFontOfSize:18];
    titleLabel1.numberOfLines = 0;
    [self.baseView addSubview:titleLabel1];
    
    UILabel *firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(titleLabel1.frame) + 8, SCREEN_WIDTH - 10, 35)];
    firstLabel.text = @"(1)首页面右上角点击设置";
    firstLabel.textColor = [UIColor blackColor];
    firstLabel.font = [UIFont systemFontOfSize:16];
    firstLabel.numberOfLines = 0;
    [self.baseView addSubview:firstLabel];
    
    UIImageView *firstImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"如何选择刷卡器（1）"]];
    CGPoint center1 = firstImageView.center;
    center1.x = [UIApplication sharedApplication].keyWindow.center.x;
    NSLog(@"x:%f",center1.x);
    firstImageView.center = center1;
    CGRect frame1 = firstImageView.frame;
    frame1.origin.y = CGRectGetMaxY(firstLabel.frame) + 4;
    frame1.size.width = 80;
    frame1.size.height = 68;
    firstImageView.frame = frame1;
    NSLog(@"frame:%f",firstImageView.frame.origin.x);
    [self.baseView addSubview:firstImageView];
    
    UILabel *secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(firstLabel.frame.origin.x, CGRectGetMaxY(firstImageView.frame) + 4, firstLabel.frame.size.width, firstLabel.frame.size.height)];
    secondLabel.text = @"(2)设置--选择第四项终端设置";
    secondLabel.textColor = [UIColor blackColor];
    secondLabel.font = [UIFont systemFontOfSize:16];
    secondLabel.numberOfLines = 0;
    [self.baseView addSubview:secondLabel];
    
    UIImageView *secondImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"如何选择刷卡器（2）"]];
    CGRect frame2 = secondImageView.frame;
    frame2.origin.y = CGRectGetMaxY(secondLabel.frame) + 4;
    frame2.size.width = 200;
    frame2.size.height = 91;
    frame2.origin.x = SCREEN_WIDTH/2 - frame2.size.width/2;
    secondImageView.frame = frame2;
    NSLog(@"frame:%f",secondImageView.frame.origin.x);
    [self.baseView addSubview:secondImageView];
    
    UILabel *thirdLabel = [[UILabel alloc] initWithFrame:CGRectMake(firstLabel.frame.origin.x, CGRectGetMaxY(secondImageView.frame) + 4, firstLabel.frame.size.width, 50)];
    thirdLabel.text = @"(3)终端设置里选择对应的刷卡器(音频、蓝牙)";
    thirdLabel.textColor = [UIColor blackColor];
    thirdLabel.font = [UIFont systemFontOfSize:16];
    thirdLabel.numberOfLines = 0;
    [self.baseView addSubview:thirdLabel];
    
    UIImageView *thirdImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"如何选择刷卡器（3）"]];
    CGRect frame3 = thirdImageView.frame;
    frame3.origin.y = CGRectGetMaxY(thirdLabel.frame) + 4;
    frame3.size.width = 200;
    frame3.size.height = 167;
    frame3.origin.x = SCREEN_WIDTH/2 - frame3.size.width/2;
    thirdImageView.frame = frame3;
    NSLog(@"frame:%f",thirdImageView.frame.origin.x);
    [self.baseView addSubview:thirdImageView];

    UILabel *titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel1.frame.origin.x, CGRectGetMaxY(thirdImageView.frame) + 10, titleLabel1.frame.size.width, titleLabel1.frame.size.height)];
    titleLabel2.text = @"如何完善个人信息";
    titleLabel2.textAlignment = NSTextAlignmentCenter;
    titleLabel2.textColor = [UIColor blackColor];
    titleLabel2.font = [UIFont systemFontOfSize:18];
    [self.baseView addSubview:titleLabel2];
    
    UILabel *firstLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(firstLabel.frame.origin.x, CGRectGetMaxY(titleLabel2.frame) + 8, firstLabel.frame.size.width, 50)];
    firstLabel1.text = @"(1)在首页面找到商户信息的按钮,点击进去实名认证";
    firstLabel1.textColor = [UIColor blackColor];
    firstLabel1.font = [UIFont systemFontOfSize:16];
    firstLabel1.numberOfLines = 0;
    [self.baseView addSubview:firstLabel1];
    
    UIImageView *firstImageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"如何完善个人信息（1）"]];
    CGRect frame4 = firstImageView1.frame;
    frame4.origin.y = CGRectGetMaxY(firstLabel1.frame) + 4;
    frame4.size.width = 100;
    frame4.size.height = 80;
    frame4.origin.x = SCREEN_WIDTH/2 - frame4.size.width/2;
    firstImageView1.frame = frame4;
    [self.baseView addSubview:firstImageView1];

    UILabel *secondLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(firstLabel.frame.origin.x, CGRectGetMaxY(firstImageView1.frame) + 4, firstLabel.frame.size.width, 65)];
    secondLabel1.text = @"(2)请输入正确的信息.银行名称,姓名,身份证与开户行一致.否则不能提现到该账户.商户已认证状态才可以进行消费操作.";
    secondLabel1.textColor = [UIColor blackColor];
    secondLabel1.font = [UIFont systemFontOfSize:16];
    secondLabel1.numberOfLines = 0;
    [self.baseView addSubview:secondLabel1];
    
    UIImageView *secondImageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"如何完善个人信息（2）"]];
    CGRect frame5 = secondImageView1.frame;
    frame5.origin.y = CGRectGetMaxY(secondLabel1.frame) + 4;
    frame5.size.width = 200;
    frame5.size.height = 356;
    frame5.origin.x = SCREEN_WIDTH/2 - frame5.size.width/2;
    secondImageView1.frame = frame5;
    [self.baseView addSubview:secondImageView1];

    UILabel *thirdLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(firstLabel.frame.origin.x, CGRectGetMaxY(secondImageView1.frame) + 4, firstLabel.frame.size.width, 65)];
    thirdLabel1.text = @"(3)商户信息输入正确点击下一页照片上传,按照认证说明拍照提交,商户状态已认证即可";
    thirdLabel1.textColor = [UIColor blackColor];
    thirdLabel1.font = [UIFont systemFontOfSize:16];
    thirdLabel1.numberOfLines = 0;
    [self.baseView addSubview:thirdLabel1];
    
    UIImageView *thirdImageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"如何完善个人信息（3）"]];
    CGRect frame6 = thirdImageView1.frame;
    frame6.origin.y = CGRectGetMaxY(thirdLabel1.frame) + 4;
    frame6.size.width = 200;
    frame6.size.height = 196;
    frame6.origin.x = SCREEN_WIDTH/2 - frame6.size.width/2;
    thirdImageView1.frame = frame6;
    [self.baseView addSubview:thirdImageView1];
    
    UILabel *titleLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel1.frame.origin.x, CGRectGetMaxY(thirdImageView1.frame) + 10, titleLabel1.frame.size.width, titleLabel1.frame.size.height)];
    titleLabel3.text = @"如何查询余额";
    titleLabel3.textAlignment = NSTextAlignmentCenter;
    titleLabel3.textColor = [UIColor blackColor];
    titleLabel3.font = [UIFont systemFontOfSize:18];
    [self.baseView addSubview:titleLabel3];
    
    UILabel *firstLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(firstLabel.frame.origin.x, CGRectGetMaxY(titleLabel3.frame) + 8, firstLabel.frame.size.width, 50)];
    firstLabel2.text = @"(1)首页面点击余额查询按钮,进入查询余额页面";
    firstLabel2.textColor = [UIColor blackColor];
    firstLabel2.font = [UIFont systemFontOfSize:16];
    firstLabel2.numberOfLines = 0;
    [self.baseView addSubview:firstLabel2];
    
    UIImageView *firstImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"如何查询余额（1）"]];
    CGRect frame7 = firstImageView2.frame;
    frame7.origin.y = CGRectGetMaxY(firstLabel2.frame) + 4;
    frame7.size.width = 100;
    frame7.size.height = 80;
    frame7.origin.x = SCREEN_WIDTH/2 - frame7.size.width/2;
    firstImageView2.frame = frame7;
    [self.baseView addSubview:firstImageView2];
    
    UILabel *secondLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(firstLabel.frame.origin.x, CGRectGetMaxY(firstImageView2.frame) + 4, firstLabel.frame.size.width, 40)];
    secondLabel2.text = @"(2)插上刷卡器,刷卡或插卡就可以查询余额";
    secondLabel2.textColor = [UIColor blackColor];
    secondLabel2.font = [UIFont systemFontOfSize:16];
    secondLabel2.numberOfLines = 0;
    [self.baseView addSubview:secondLabel2];
    
    UIImageView *secondImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"如何查询余额（2）"]];
    CGRect frame8 = secondImageView2.frame;
    frame8.origin.y = CGRectGetMaxY(secondLabel2.frame) + 4;
    frame8.size.width = 200;
    frame8.size.height = 356;
    frame8.origin.x = SCREEN_WIDTH/2 - frame8.size.width/2;
    secondImageView2.frame = frame8;
    [self.baseView addSubview:secondImageView2];

    UILabel *thirdLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(firstLabel.frame.origin.x, CGRectGetMaxY(secondImageView2.frame) + 4, firstLabel.frame.size.width, 40)];
    thirdLabel2.text = @"(3)输入六位的银行卡交易密码即可查询余额";
    thirdLabel2.textColor = [UIColor blackColor];
    thirdLabel2.font = [UIFont systemFontOfSize:16];
    thirdLabel2.numberOfLines = 0;
    [self.baseView addSubview:thirdLabel2];
    
    UIImageView *thirdImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"如何查询余额（3）"]];
    CGRect frame9 = thirdImageView2.frame;
    frame9.origin.y = CGRectGetMaxY(thirdLabel2.frame) + 4;
    frame9.size.width = 200;
    frame9.size.height = 156;
    frame9.origin.x = SCREEN_WIDTH/2 - frame9.size.width/2;
    thirdImageView2.frame = frame9;
    [self.baseView addSubview:thirdImageView2];
    
    UILabel *titleLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel1.frame.origin.x, CGRectGetMaxY(thirdImageView2.frame) + 10, titleLabel1.frame.size.width, titleLabel1.frame.size.height)];
    titleLabel4.text = @"如何消费交易";
    titleLabel4.textAlignment = NSTextAlignmentCenter;
    titleLabel4.textColor = [UIColor blackColor];
    titleLabel4.font = [UIFont systemFontOfSize:18];
    [self.baseView addSubview:titleLabel4];
    
    UILabel *firstLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(firstLabel.frame.origin.x, CGRectGetMaxY(titleLabel4.frame) + 8, firstLabel.frame.size.width, 50)];
    firstLabel3.text = @"(1)首页面点击消费按钮进去消费功能,选择需要的费率";
    firstLabel3.textColor = [UIColor blackColor];
    firstLabel3.font = [UIFont systemFontOfSize:16];
    firstLabel3.numberOfLines = 0;
    [self.baseView addSubview:firstLabel3];
    
    UIImageView *firstImageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"如何消费交易（1）"]];
    CGRect frame10 = firstImageView3.frame;
    frame10.origin.y = CGRectGetMaxY(firstLabel3.frame) + 4;
    frame10.size.width = 150;
    frame10.size.height = 60;
    frame10.origin.x = SCREEN_WIDTH/2 - frame10.size.width/2;
    firstImageView3.frame = frame10;
    [self.baseView addSubview:firstImageView3];
    
    UIImageView *firstImageView31 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"如何消费交易（1.1）"]];
    CGRect frame13 = firstImageView31.frame;
    frame13.origin.y = CGRectGetMaxY(firstImageView3.frame) + 4;
    frame13.size.width = 150;
    frame13.size.height = 194;
    frame13.origin.x = SCREEN_WIDTH/2 - frame13.size.width/2;
    firstImageView31.frame = frame13;
    [self.baseView addSubview:firstImageView31];
    
    UILabel *secondLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(firstLabel.frame.origin.x, CGRectGetMaxY(firstImageView31.frame) + 4, firstLabel.frame.size.width, 40)];
    secondLabel3.text = @"(2)输入金额后点击确认收款";
    secondLabel3.textColor = [UIColor blackColor];
    secondLabel3.font = [UIFont systemFontOfSize:16];
    secondLabel3.numberOfLines = 0;
    [self.baseView addSubview:secondLabel3];
    
    UIImageView *secondImageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"如何消费交易（2）"]];
    CGRect frame11 = secondImageView3.frame;
    frame11.origin.y = CGRectGetMaxY(secondLabel3.frame) + 4;
    frame11.size.width = 200;
    frame11.size.height = 356;
    frame11.origin.x = SCREEN_WIDTH/2 - frame11.size.width/2;
    secondImageView3.frame = frame11;
    [self.baseView addSubview:secondImageView3];
    
    UILabel *thirdLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(firstLabel.frame.origin.x, CGRectGetMaxY(secondImageView3.frame) + 4, firstLabel.frame.size.width, 40)];
    thirdLabel3.text = @"(3)插入刷卡头后刷磁条卡或插入芯片卡";
    thirdLabel3.textColor = [UIColor blackColor];
    thirdLabel3.font = [UIFont systemFontOfSize:16];
    thirdLabel3.numberOfLines = 0;
    [self.baseView addSubview:thirdLabel3];
    
    UIImageView *thirdImageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"如何消费交易（3）"]];
    CGRect frame12 = thirdImageView3.frame;
    frame12.origin.y = CGRectGetMaxY(thirdLabel3.frame) + 4;
    frame12.size.width = 200;
    frame12.size.height = 156;
    frame12.origin.x = SCREEN_WIDTH/2 - frame12.size.width/2;
    thirdImageView3.frame = frame12;
    [self.baseView addSubview:thirdImageView3];
    
    UILabel *thirdLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(firstLabel.frame.origin.x, CGRectGetMaxY(thirdImageView3.frame) + 4, firstLabel.frame.size.width, 40)];
    thirdLabel4.text = @"(4)输入正确的六位密码,点击确认付款";
    thirdLabel4.textColor = [UIColor blackColor];
    thirdLabel4.font = [UIFont systemFontOfSize:16];
    thirdLabel4.numberOfLines = 0;
    [self.baseView addSubview:thirdLabel4];
    
    UIImageView *thirdImageView4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"如何消费交易（4）"]];
    CGRect frame14 = thirdImageView4.frame;
    frame14.origin.y = CGRectGetMaxY(thirdLabel4.frame) + 4;
    frame14.size.width = 200;
    frame14.size.height = 210;
    frame14.origin.x = SCREEN_WIDTH/2 - frame14.size.width/2;
    thirdImageView4.frame = frame14;
    [self.baseView addSubview:thirdImageView4];
    
    UILabel *thirdLabel5 = [[UILabel alloc] initWithFrame:CGRectMake(firstLabel.frame.origin.x, CGRectGetMaxY(thirdImageView4.frame) + 4, firstLabel.frame.size.width, 40)];
    thirdLabel5.text = @"(5)消费者在签字页面签字确认消费";
    thirdLabel5.textColor = [UIColor blackColor];
    thirdLabel5.font = [UIFont systemFontOfSize:16];
    thirdLabel5.numberOfLines = 0;
    [self.baseView addSubview:thirdLabel5];
    
    UIImageView *thirdImageView5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"如何消费交易（5）"]];
    CGRect frame15 = thirdImageView5.frame;
    frame15.origin.y = CGRectGetMaxY(thirdLabel5.frame) + 4;
    frame15.size.width = 200;
    frame15.size.height = 355;
    frame15.origin.x = SCREEN_WIDTH/2 - frame15.size.width/2;
    thirdImageView5.frame = frame15;
    [self.baseView addSubview:thirdImageView5];
    
    UILabel *noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(firstLabel.frame.origin.x, CGRectGetMaxY(thirdImageView5.frame) + 2, SCREEN_WIDTH, 40)];
    noticeLabel.textAlignment = NSTextAlignmentCenter;
    noticeLabel.text = @"签名必须清晰完整,否则影响到账";
    noticeLabel.textColor = [UIColor redColor];
    noticeLabel.font = [UIFont systemFontOfSize:18];
    [self.baseView addSubview:noticeLabel];
    
    UILabel *thirdLabel6 = [[UILabel alloc] initWithFrame:CGRectMake(firstLabel.frame.origin.x, CGRectGetMaxY(noticeLabel.frame) + 4, firstLabel.frame.size.width, 40)];
    thirdLabel6.text = @"(6)出现交易收据,交易完成";
    thirdLabel6.textColor = [UIColor blackColor];
    thirdLabel6.font = [UIFont systemFontOfSize:16];
    thirdLabel6.numberOfLines = 0;
    [self.baseView addSubview:thirdLabel6];
    
    UIImageView *thirdImageView6 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"如何消费交易（6）"]];
    CGRect frame16 = thirdImageView6.frame;
    frame16.origin.y = CGRectGetMaxY(thirdLabel6.frame) + 4;
    frame16.size.width = 200;
    frame16.size.height = 355;
    frame16.origin.x = SCREEN_WIDTH/2 - frame16.size.width/2;
    thirdImageView6.frame = frame16;
    [self.baseView addSubview:thirdImageView6];
    
    UILabel *titleLabel5 = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel1.frame.origin.x, CGRectGetMaxY(thirdImageView6.frame) + 10, titleLabel1.frame.size.width, titleLabel1.frame.size.height)];
    titleLabel5.text = @"如何查询交易明细";
    titleLabel5.textAlignment = NSTextAlignmentCenter;
    titleLabel5.textColor = [UIColor blackColor];
    titleLabel5.font = [UIFont systemFontOfSize:18];
    [self.baseView addSubview:titleLabel5];
    
    UILabel *firstLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(firstLabel.frame.origin.x, CGRectGetMaxY(titleLabel5.frame) + 8, firstLabel.frame.size.width, 50)];
    firstLabel4.text = @"(1)首页面点击交易明细按钮,查看交易明细,根据费率分别查看交易明细";
    firstLabel4.textColor = [UIColor blackColor];
    firstLabel4.font = [UIFont systemFontOfSize:16];
    firstLabel4.numberOfLines = 0;
    [self.baseView addSubview:firstLabel4];
    
    UIImageView *firstImageView4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"如何查询交易明细"]];
    CGRect frame17 = firstImageView4.frame;
    frame17.origin.y = CGRectGetMaxY(firstLabel4.frame) + 4;
    frame17.size.width = 200;
    frame17.size.height = 355;
    frame17.origin.x = SCREEN_WIDTH/2 - frame17.size.width/2;
    firstImageView4.frame = frame17;
    [self.baseView addSubview:firstImageView4];
    
    UILabel *titleLabel6 = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel1.frame.origin.x, CGRectGetMaxY(firstImageView4.frame) + 10, titleLabel1.frame.size.width, titleLabel1.frame.size.height)];
    titleLabel6.text = @"如何查看APP版本信息";
    titleLabel6.textAlignment = NSTextAlignmentCenter;
    titleLabel6.textColor = [UIColor blackColor];
    titleLabel6.font = [UIFont systemFontOfSize:18];
    [self.baseView addSubview:titleLabel6];
    
    UILabel *firstLabel5 = [[UILabel alloc] initWithFrame:CGRectMake(firstLabel.frame.origin.x, CGRectGetMaxY(titleLabel6.frame) + 8, firstLabel.frame.size.width, 40)];
    firstLabel5.text = @"(1)在APP登录界面查看版本信息";
    firstLabel5.textColor = [UIColor blackColor];
    firstLabel5.font = [UIFont systemFontOfSize:16];
    firstLabel5.numberOfLines = 0;
    [self.baseView addSubview:firstLabel5];
    
    UIImageView *firstImageView5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"如何查看版本信息"]];
    CGRect frame18 = firstImageView5.frame;
    frame18.origin.y = CGRectGetMaxY(firstLabel5.frame) + 4;
    frame18.size.width = 150;
    frame18.size.height = 76;
    frame18.origin.x = SCREEN_WIDTH/2 - frame18.size.width/2;
    firstImageView5.frame = frame18;
    [self.baseView addSubview:firstImageView5];
    
    
    UILabel *secondLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(firstLabel.frame.origin.x, CGRectGetMaxY(firstImageView5.frame) + 4, firstLabel.frame.size.width, 50)];
    secondLabel4.text = @"(2)在首页面右上角点击设置按钮查看版本信息";
    secondLabel4.textColor = [UIColor blackColor];
    secondLabel4.font = [UIFont systemFontOfSize:16];
    secondLabel4.numberOfLines = 0;
    [self.baseView addSubview:secondLabel4];
    
    UIImageView *secondImageView4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"如何查看版本信息（2）"]];
    CGRect frame19 = secondImageView4.frame;
    frame19.origin.y = CGRectGetMaxY(secondLabel4.frame) + 4;
    frame19.size.width = 200;
    frame19.size.height = 93;
    frame19.origin.x = SCREEN_WIDTH/2 - frame19.size.width/2;
    secondImageView4.frame = frame19;
    [self.baseView addSubview:secondImageView4];
    
}



@end
