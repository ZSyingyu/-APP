//
//  HomePageViewController.m
//  HuiYingTianXia
//
//  Created by tsmc on 15-3-19.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)

#import "HomePageViewController.h"
#import "ConsumeViewController.h"
#import "SwingCardViewController.h"
#import "QueryrRecordViewController.h"
#import "SettingViewController.h"
#import "POSManger.h"
#import "AC_POSManger.h"
#import "MBProgressHUD+Add.h"
//#import "RateVIew.h"
#import "BusinessDetailViewController.h"
#import "RateViewController.h"
#import "MBProgressHUD.h"
#import "ACSwingCardViewController.h"
#import "MFBTSwingCardViewController.h"
#import "XNBTSwingCardViewController.h"
#import "TradeRecordViewController.h"
//#import "YFSwingCardViewController.h"
#import "RealTimeViewController.h"
#import "RaiseQuotaViewController.h"
#import "NSString+MD5HexDigest.h"
#import "MJExtension.h"
#import "BandingListViewController.h"
#import "InstructionViewController.h"
#import "PublicNoticeViewController.h"
#import "NoticeListViewController.h"
#import "ResponseDictionaryTool.h"

#import "CCLocationManager.h"
#import "MFBTADSwingCardViewController.h"
#import "XNBTADSwingCardViewController.h"
#import "ZCBTADSwingCardViewController.h"

#import "SVWebViewController.h"

#import "webViewController.h"

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
#import "TradeRecordViewController.h"


#import "SZBTADConsumeViewController.h"

#import "SZBlueConsumeViewController.h"

//#import "BankViewController.h"

#import "ScrollImage.h"

#import "AutoSlideScrollView.h"

#import "ZFScanViewController.h"

#import "MyCodeViewController.h"

#import "NewBusinessDetailViewController.h"

#import "WeChatConsumeViewController.h"

@interface HomePageViewController()<AC_POSMangerDelegate,UIScrollViewDelegate,CLLocationManagerDelegate,UIAlertViewDelegate,ScrollImageDelegate>

{
    CLLocationManager *locationmanager;
    UIWindow *windows;
    UIView *view;
    UILabel *label;
}

@property(nonatomic, strong)UIScrollView *baseView;
@property(nonatomic, strong)UIImageView *iv;
@property(nonatomic, strong)UILabel *labTitle;
@property(nonatomic, strong)UIButton *btnSet;
@property(nonatomic, strong)UILabel *labNumber;
@property(nonatomic, strong)UIImageView *ivAdvert;
@property(nonatomic, strong)NSArray *btnTitles;
@property(strong,nonatomic)NSArray *btnSelectedTitles;

@property(strong,nonatomic)UIPageControl *pageControl;
@property (nonatomic , retain) UIScrollView *scrollView;
@property (strong, nonatomic ) NSTimer *timer;
@property(strong,nonatomic)NSMutableArray *imageNames;
@property(strong,nonatomic)UIImage *image1;
@property(strong,nonatomic)UIImage *image2;
@property(strong,nonatomic)UIImage *image3;
@property(strong,nonatomic)UIImage *image4;

@property(strong,nonatomic)NSString *noticeId;//公告id
@property(strong,nonatomic)UIButton *leftButton;
@property (nonatomic , retain) AutoSlideScrollView *mainScorllView;

@end

#define BTN_WIDTH HFixWidthBaseOn320(80)
#define LONG_BTN_WIDTH HFixWidthBaseOn320(198)
#define BTN_HEIGHT HFixWidthBaseOn320(80)

static NSInteger clickNum = 1;

@implementation HomePageViewController

@synthesize pageControl;

-(instancetype)init {
    self=[super init];
    if (self) {
        self.tabBarItem.title = @"首页";
        self.tabBarController.tabBar.barTintColor = COLOR_THEME;
        self.tabBarItem.image = [[UIImage imageNamed:@"首页2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem.selectedImage=[[UIImage imageNamed:@"首页1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.barTintColor = COLOR_THEME;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:JuJue];
    [[NSUserDefaults standardUserDefaults] setObject:@"TabBar进入" forKey:@"RealType"];

}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self dismissLine];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [UIApplication sharedApplication].keyWindow.backgroundColor = COLOR_THEME;
}

//-(void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置导航栏
    [self.navigationController.navigationBar setHidden:NO];
//    self.navigationItem.hidesBackButton = YES;
//    [self setNavTitle:@"来买单"];
    
    //自定义导航栏标题
    UIView *titleView = [[UIView alloc] init];
    CGRect frame = titleView.frame;
    frame.origin.y = 0.0f;
    frame.size.width = 130.0f;
    frame.size.height = 35.0f;
    titleView.frame = frame;
    CGPoint center = titleView.center;
    center.x = SCREEN_WIDTH/2;
    titleView.center = center;
    //    titleView.backgroundColor = [UIColor redColor];
    
    UIImage *titleImage = [UIImage imageNamed:@"首页-来买单"];
    UIImageView *imageView = [[UIImageView alloc] init];
    CGRect imageFrame = imageView.frame;
    imageFrame.origin.y = 10.0f;
    imageFrame.size.width = titleImage.size.width;
    imageFrame.size.height = titleImage.size.height;
    imageView.frame = imageFrame;
    CGPoint imageCenter = imageView.center;
    imageCenter.x = titleView.frame.size.width/2;
    imageView.center = imageCenter;
    imageView.contentMode = UIViewContentModeScaleAspectFit;//设置内容样式,通过保持长宽比缩放内容适应视图的大小,任何剩余的区域的视图的界限是透明的。
    [imageView setImage:titleImage];
    [titleView addSubview:imageView];
    self.navigationItem.titleView = titleView;//设置导航栏的titleView为imageView
    
    [self dismissLine];

    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
    headView.backgroundColor = COLOR_THEME;
    [self.view addSubview:headView];
    
    NSArray *btnArr = @[@"ZY二维码",@"ZY提现",@"ZY扫一扫"];
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(15 + ((SCREEN_WIDTH - 50)/3 + 10) * i, 20, (SCREEN_WIDTH - 50)/3, (SCREEN_WIDTH - 50)/3)];
        [btn setImage:[UIImage imageNamed:[btnArr objectAtIndex:i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(headBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 1001 + i;
        [headView addSubview:btn];
    }
    
    self.labTitle = [[UILabel alloc] init];
    self.labTitle.font = FONT_18;
    [self.labTitle setTextAlignment:NSTextAlignmentCenter];
    self.labTitle.textColor = COLOR_MY_WHITE;
    //self.labTitle.text = self.absItem.n63;
    self.labTitle.text = @"";
    [self.view addSubview:self.labTitle];
    [self.labTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(44);
    }];
    
    
    NSDictionary *attributes = [[NSDictionary alloc] initWithObjectsAndKeys:
                                [UIFont fontWithName:@"ArialRoundedMTBold" size:42.0],
                                NSFontAttributeName,
                                COLOR_MY_WHITE,
                                NSForegroundColorAttributeName,
                                nil];
    NSString *amount = self.absItem.n4.length > 0? self.absItem.n4 : @"0";
    amount = [POSManger transformAmountWithPoint:amount];
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:amount attributes:attributes];
    self.labNumber = [[UILabel alloc] init];
    [self.labNumber setTextAlignment:NSTextAlignmentLeft];
    self.labNumber.attributedText= attStr;
    self.labNumber.text = @"";
    [self.labNumber setShadowOffset:CGSizeMake(-0.5, -0.5)];
    [self.labNumber setShadowColor:COLOR_FONT_GRAY];
    [self.view addSubview:self.labNumber];
    [self.labNumber makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iv).offset(16 + 64 - 5);
        make.left.equalTo(self.iv).offset(10);
        make.right.equalTo(self.iv).offset(-10);
        make.height.equalTo(self.labNumber.font.lineHeight);
    }];
    
    self.baseView = [[UIScrollView alloc] init];
    self.baseView.frame = CGRectMake(0, CGRectGetMaxY(headView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - 413);
    [self.baseView setBackgroundColor:[UIColor clearColor]];
    [self.baseView setBounces:YES];//弹跳效果
    [self.baseView setShowsVerticalScrollIndicator:NO];//是否出现滚动条
    //    self.baseView.scrollEnabled = YES;//是否可以滚动
//    if (IPHONE4__4S) {
//        self.baseView.contentSize = CGSizeMake(SCREEN_WIDTH, 2000);
//    }else if (IPHONE5__5S){
//        self.baseView.contentSize = CGSizeMake(SCREEN_WIDTH, 594);
//    }else if (IPHONE6){
        self.baseView.contentSize = CGSizeMake(SCREEN_WIDTH, BTN_HEIGHT * 2);
//    }else{
//        self.baseView.contentSize = CGSizeMake(SCREEN_WIDTH, 0);
//    }
    
    [self.view addSubview:self.baseView];
    
    
//    self.btnTitles = @[@"个人付款",@"余额查询",@"实名认证",@"信用卡认证",@"信用卡还款",@"转账汇款",@"即尚VIP",@"信用卡申请",@"代还信用卡"];
    self.btnTitles = @[@"操作说明QB",@"商户信息QB",@"交易明细QB",@"信用贷款QB",@"微信收款QB",@"支付宝收款QB",@"ZY更多"];
    
//    self.btnSelectedTitles = @[@"消费1",@"余额1",@"商户1",@"申请提额图标-选择",@"明细1",@"结算1",@"转账1",@"点卡充值-1",@"大众点评-1",@"股票行情-1",@"叫车-1",@"机票-1",@"旅游-1",@"手机充值-1",@"水电煤-1"];
    
    UIButton *btnLine1 = nil;
    for (int i = 0; i < 4; i++) {
        
        btnLine1 = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *imageName = [self.btnTitles objectAtIndex:i];
        btnLine1.layer.borderColor = COLOR_LINE.CGColor;
        btnLine1.layer.borderWidth = LINE_HEIGTH;
        [btnLine1 setTag:i];
        
        [btnLine1 setBackgroundColor:COLOR_MY_WHITE];
        [btnLine1 setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
//        NSString *selectedImage = [self.btnSelectedTitles objectAtIndex:i];
//        [btnLine1 setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateHighlighted];
        [btnLine1 setFrame:CGRectMake(i * (BTN_WIDTH - 0.5), 0, BTN_WIDTH, BTN_HEIGHT)];
        [btnLine1 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.baseView addSubview:btnLine1];
        
    }
    
    UIButton *btnLine2 = nil;
    for (int i = 0; i < 3; i++) {
        btnLine2 = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *imageName = [self.btnTitles objectAtIndex:i+4];
        btnLine2.layer.borderColor = COLOR_LINE.CGColor;
        btnLine2.layer.borderWidth = LINE_HEIGTH;
        [btnLine2 setTag:i+4];
        
        [btnLine2 setBackgroundColor:COLOR_MY_WHITE];
        [btnLine2 setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
//        NSString *selectedImage = [self.btnSelectedTitles objectAtIndex:i+3];
//        [btnLine2 setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateHighlighted];
        [btnLine2 setFrame:CGRectMake(i * (BTN_WIDTH - 0.5), CGRectGetMaxY(btnLine1.frame) - 0.5, BTN_WIDTH, BTN_HEIGHT)];
        [btnLine2 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.baseView addSubview:btnLine2];
        
    }
    
//    UIButton *btnLine3 = nil;
//    for (int i = 0; i < 4; i++) {
//        btnLine3 = [UIButton buttonWithType:UIButtonTypeCustom];
//        NSString *imageName = [self.btnTitles objectAtIndex:i+8];
//        btnLine3.layer.borderColor = COLOR_LINE.CGColor;
//        btnLine3.layer.borderWidth = LINE_HEIGTH;
//        [btnLine3 setTag:i+8];
//        
//        [btnLine3 setBackgroundColor:COLOR_MY_WHITE];
//        [btnLine3 setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
//        [btnLine3 setFrame:CGRectMake(i * (BTN_WIDTH - 0.5), CGRectGetMaxY(btnLine2.frame) - 0.5, BTN_WIDTH, BTN_HEIGHT)];
//        [btnLine3 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
//        [self.baseView addSubview:btnLine3];
//        
//    }
//
//    UIButton *btnLine4 = nil;
//    for (int i = 0; i < 3; i++) {
//        btnLine4 = [UIButton buttonWithType:UIButtonTypeCustom];
//        NSString *imageName = [self.btnTitles objectAtIndex:i+9];
//        btnLine4.layer.borderColor = COLOR_LINE.CGColor;
//        btnLine4.layer.borderWidth = LINE_HEIGTH;
//        [btnLine4 setTag:i+9];
//        
//        [btnLine4 setBackgroundColor:COLOR_MY_WHITE];
//        [btnLine4 setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
////        NSString *selectedImage = [self.btnSelectedTitles objectAtIndex:i+9];
////        [btnLine4 setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateHighlighted];
//        [btnLine4 setFrame:CGRectMake(i * (BTN_WIDTH - 0.5), CGRectGetMaxY(btnLine3.frame) - 0.5, BTN_WIDTH, BTN_HEIGHT)];
//        [btnLine4 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
//        [self.baseView addSubview:btnLine4];
//        
//    }
//    
//    UIButton *btnLine5 = nil;
//    for (int i = 0; i < 3; i++) {
//        btnLine5 = [UIButton buttonWithType:UIButtonTypeCustom];
//        NSString *imageName = [self.btnTitles objectAtIndex:i+12];
//        btnLine5.layer.borderColor = COLOR_LINE.CGColor;
//        btnLine5.layer.borderWidth = LINE_HEIGTH;
//        [btnLine5 setTag:i+12];
//        
//        [btnLine5 setBackgroundColor:COLOR_MY_WHITE];
//        [btnLine5 setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
////        NSString *selectedImage = [self.btnSelectedTitles objectAtIndex:i+12];
////        [btnLine5 setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateHighlighted];
//        [btnLine5 setFrame:CGRectMake(i * (BTN_WIDTH - 0.5), CGRectGetMaxY(btnLine4.frame) - 0.5, BTN_WIDTH, BTN_HEIGHT)];
//        [btnLine5 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
//        [self.baseView addSubview:btnLine5];
//        
//    }
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    NSMutableArray *viewsArray = [@[] mutableCopy];
    UIImage *image1;
    UIImage *image2;
    UIImage *image3;
    UIImage *image4;
    if (IPHONE4__4S || IPHONE5__5S) {
        image1 = [UIImage imageNamed:@"滚屏1N"];
        image2 = [UIImage imageNamed:@"滚屏2N"];
        image3 = [UIImage imageNamed:@"滚屏3N"];
        image4 = [UIImage imageNamed:@"滚屏4N"];
    }else if (IPHONE6) {
        image1 = [UIImage imageNamed:@"滚屏1"];
        image2 = [UIImage imageNamed:@"滚屏2"];
        image3 = [UIImage imageNamed:@"滚屏3"];
        image4 = [UIImage imageNamed:@"滚屏4"];
    }else {
        image1 = [UIImage imageNamed:@"滚屏1B"];
        image2 = [UIImage imageNamed:@"滚屏2B"];
        image3 = [UIImage imageNamed:@"滚屏3B"];
        image4 = [UIImage imageNamed:@"滚屏4B"];
    }
    NSArray *imageArray = @[image1,image2,image3,image4];
    for (int i = 0; i < imageArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, 120)];
        imageView.image = imageArray[i];
        imageView.contentMode = UIViewContentModeRedraw;
        if (!imageView.image) {
            imageView.image = [UIImage imageNamed:@"暂无图片"];
        }
        [viewsArray addObject:imageView];
    }
    
    self.mainScorllView = [[AutoSlideScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.baseView.frame) + 10, SCREEN_WIDTH, 130) animationDuration:2];
    
    self.mainScorllView.totalPagesCount = ^NSInteger(void){
        return viewsArray.count;
    };
    self.mainScorllView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
        return viewsArray[pageIndex];
    };
    self.mainScorllView.TapActionBlock = ^(NSInteger pageIndex){
        NSLog(@"点击了第%ld个",pageIndex);
    };
    [self.view addSubview:self.mainScorllView];
    
    
    //获取地理位置信息
//    if (IS_IOS8) {
//        [UIApplication sharedApplication].idleTimerDisabled = TRUE;
//        locationmanager = [[CLLocationManager alloc] init];
//        [locationmanager requestAlwaysAuthorization];        //NSLocationAlwaysUsageDescription
//        [locationmanager requestWhenInUseAuthorization];     //NSLocationWhenInUseDescription
//        locationmanager.delegate = self;
//    }
//    [self getAllInfo];
    
    //公告alertview
    self.dictionary = [[NSUserDefaults standardUserDefaults] objectForKey:Notice];
    NSLog(@"noticeId:%@",[[NSUserDefaults standardUserDefaults] objectForKey:Notice]);
    //    ![self.noticeId isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:Notice][@"id"]]
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:Notice] isEqual:nil] && [[[NSUserDefaults standardUserDefaults] objectForKey:Isread] isEqualToString:@"0"]) {
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:@"查看新的公告" delegate:self cancelButtonTitle:@"先不看了" otherButtonTitles:@"查看", nil];
        alertview.tag = 1;
        [alertview show];
        //        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:Notice];
    }else {
        
    }
    
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10D"] && clickNum == 1) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"您的信息已经重新提交，我们正在加紧审核，请稍侯" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        alertView.tag = 2;
        [alertView show];
    }
}

-(void)headBtnAction:(UIButton *)btn {
    if (btn.tag == 1001) {
        NSLog(@"二维码");
//        [MBProgressHUD showSuccess:@"暂未开放,敬请期待!" toView:self.view];
        MyCodeViewController *codeVc = [[MyCodeViewController alloc] init];
        codeVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:codeVc animated:YES];
        
    }else if (btn.tag == 1002) {
        NSLog(@"提现");
        
        TradeRecordViewController *realVc = [[TradeRecordViewController alloc] initWithNibName:@"TradeRecordViewController" bundle:nil];
        //            [self.navigationController.navigationBar setHidden:NO];
        realVc.hidesBottomBarWhenPushed  =YES;
        [self.navigationController pushViewController:realVc animated:YES];
        
//        if ([[[NSUserDefaults standardUserDefaults] objectForKey:Rate] isEqualToString:@"00000000"]) {
//            [MBProgressHUD showSuccess:@"请联系客服设置交易费率" toView:self.view];
//        }else {
//            
//            if ([[[NSUserDefaults standardUserDefaults] objectForKey:CardID] length] > 0 && [[[NSUserDefaults standardUserDefaults] valueForKey:BankName] length] > 0 && [[[NSUserDefaults standardUserDefaults] valueForKey:CardName] length] > 0 && [[[NSUserDefaults standardUserDefaults] valueForKey:CardNumber] length] > 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:HandCard] length] > 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:FrontCard] length] > 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:BackCard] length] > 0) {
//                
//                self.flag = [[NSUserDefaults standardUserDefaults] objectForKey:Tag];
//                
//                //                            RateViewController *rateVc = [[RateViewController alloc]initWithNibName:@"RateViewController" bundle:nil];
//                //                            rateVc.tag = self.flag;
//                //    //                        rateVc.hidesBottomBarWhenPushed = YES;
//                //                            [[NSUserDefaults standardUserDefaults] setObject:@"00" forKey:Type];
//                //                            [self.navigationController pushViewController:rateVc animated:YES];
//                [self choosePOS];
//                
//            }else{
//                
//                [MBProgressHUD showSuccess:@"请先进入商户信息进行实名认证" toView:self.view];
//                
//            }
//            
//        }

        
    }else if (btn.tag == 1003) {
        NSLog(@"扫一扫");
//        [MBProgressHUD showSuccess:@"暂未开放,敬请期待!" toView:self.view];
        
        ZFScanViewController * vc = [[ZFScanViewController alloc] init];
        vc.returnScanBarCodeValue = ^(NSString * barCodeString){
            //扫描完成后，在此进行后续操作
            NSLog(@"扫描结果======%@",barCodeString);
        };
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"index:%ld",(long)buttonIndex);
    if (alertView.tag == 1) {
        if (buttonIndex == 0) {
            alertView.hidden = YES;
            self.noticeId = @"";
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:Isread];
        }else if (buttonIndex == 1) {
            PublicNoticeViewController *publicVc = [[PublicNoticeViewController alloc] init];
            publicVc.titleStr = [self.dictionary valueForKey:@"title"];
            publicVc.contentStr = [self.dictionary valueForKey:@"content"];
            [self.navigationController pushViewController:publicVc animated:YES];
//            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:Notice];
            
            self.noticeId = @"";
            publicVc.hidesBottomBarWhenPushed = YES;
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:Isread];
        }
    }else if (alertView.tag == 2) {
        [alertView setHidden:YES];
        clickNum = 0;
    }
    

}

-(void)getAllInfo
{
    __block NSString *string;
    __block __weak HomePageViewController *wself = self;
    
    
    if (IS_IOS8) {
        
        [[CCLocationManager shareLocation]getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
            string = [NSString stringWithFormat:@"%f %f",locationCorrrdinate.latitude,locationCorrrdinate.longitude];
        } withAddress:^(NSString *addressString) {
            NSLog(@"%@",addressString);
            string = [NSString stringWithFormat:@"%@\n%@",string,addressString];
            [wself setLabelText:string];
            
        }];
    }
    
}

-(void)setLabelText:(NSString *)text
{
    NSLog(@"text %@",text);
//    _textLabel.text = text;
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    if (IPHONE4__4S) {
        [self.baseView setContentSize:CGSizeMake(SCREEN_WIDTH, 9*(BTN_HEIGHT+6) -6 +  66)];
    }
}

- (void)setAction
{
    SettingViewController *settingViewController = [[SettingViewController alloc] init];
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController pushViewController:settingViewController animated:YES];
}

- (void)noticeAction
{
    NSLog(@"消息列表");
    AbstractItems *item = [[AbstractItems alloc] init];
    item.n0 = @"0700";
    item.n3 = @"190103";
    item.n42 = [[NSUserDefaults standardUserDefaults] objectForKey:MerchantNo];
    NSString *macStr = [NSString stringWithFormat:@"%@%@%@%@%@",item.n0,item.n3,item.n42,item.n59,MainKey];
    NSLog(@"macStr:%@",macStr);
    item.n64 = [macStr md5HexDigest];
    
    [[NetAPIManger sharedManger] request_NoticeListWithParams:[item keyValues] andBlock:^(id data, NSError *error) {
        AbstractItems *item = (AbstractItems *)data;
        if ([item.n39 isEqualToString:@"00"]) {
            NSLog(@"成功");
            NoticeListViewController *noticeVc = [[NoticeListViewController alloc] init];
            if ([item.n60 length] > 0) {
                NSString *n60 = item.n60;
                NSData *data = [n60 dataUsingEncoding:NSUTF8StringEncoding];
                NSMutableArray *infoArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//                for (dic in infoArray) {
//                    NSLog(@"dic:%@",dic);
                    noticeVc.listArray = infoArray;
//                    NSLog(@"listArray:%@",noticeVc.listArray);
//                }
                
                [self.leftButton setImage:[UIImage imageNamed:@"信封-没有新消息"] forState:UIControlStateNormal];
            }
            [self.navigationController pushViewController:noticeVc animated:YES];
            
            
        }else {
            NSLog(@"失败");
            
            if ([[ResponseDictionaryTool responseDic] objectForKey:item.n39]) {
                NSString *error = [[ResponseDictionaryTool responseDic] objectForKey:item.n39];
                NSLog(@"error:%@",error);
                [MBProgressHUD showSuccess:error toView:self.view];
            }else {
                [MBProgressHUD showSuccess:@"未知错误" toView:self.view];
            }
        }
        
    }];
    
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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
//        [_scandone dismissAnimated:YES];
        [view removeFromSuperview];
    });
}

- (void)btnAction:(UIButton *)btn
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:MerchantSource] isEqualToString:@"APP"]) {
        //如果商户处于重新审核状态
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10D"] || [[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10C"]) {
            switch (btn.tag) {
                case 0:{
//                    [MBProgressHUD showSuccess:@"您的信息已经重新提交，我们正在在加紧审核，请稍侯" toView:self.view];
                    [self updataWindows];
                }
                    break;
                case 1:{
                    //                    [MBProgressHUD showSuccess:@"您的信息已经重新提交，我们正在在加紧审核，请稍侯" toView:self.view];
                    [self updataWindows];
                }
                    break;
                case 2:{
                    //                    [MBProgressHUD showSuccess:@"您的信息已经重新提交，我们正在在加紧审核，请稍侯" toView:self.view];
                    [self updataWindows];
                }
                    break;
                case 3:{
                    //                    [MBProgressHUD showSuccess:@"您的信息已经重新提交，我们正在在加紧审核，请稍侯" toView:self.view];
                    [self updataWindows];
                }
                    break;
                case 4:{
                    [MBProgressHUD showSuccess:@"通道关闭" toView:self.view];
//                    [self updataWindows];
                }
                    
                    break;
                case 5:
                    [MBProgressHUD showSuccess:@"通道关闭" toView:self.view];
                    break;
                case 6:{
                   [MBProgressHUD showSuccess:@"暂未开放,敬请期待!" toView:self.view];
//                    [self updataWindows];
                }
                    break;
                case 7:{
                                [MBProgressHUD showSuccess:@"暂未开放,敬请期待!" toView:self.view];
//                    InstructionViewController *instructionVc = [[InstructionViewController alloc] init];
//                    [self.navigationController pushViewController:instructionVc animated:YES];
                    
                }
                    break;
                case 8:
                    [MBProgressHUD showSuccess:@"暂未开放,敬请期待!" toView:self.view];
                    break;
                case 9:
                    [MBProgressHUD showSuccess:@"暂未开放,敬请期待!" toView:self.view];
                    break;
                case 10:
                    [MBProgressHUD showSuccess:@"暂未开放,敬请期待!" toView:self.view];
                    break;
                case 11:
                    [MBProgressHUD showSuccess:@"暂未开放,敬请期待!" toView:self.view];
                    break;
                case 12:
                    [MBProgressHUD showSuccess:@"暂未开放,敬请期待!" toView:self.view];
                    break;
                case 13:
                    [MBProgressHUD showSuccess:@"暂未开放,敬请期待!" toView:self.view];
                    break;
                case 14:
                    [MBProgressHUD showSuccess:@"暂未开放,敬请期待!" toView:self.view];
                    break;
                case 15:
                    [MBProgressHUD showSuccess:@"暂未开放,敬请期待!" toView:self.view];
                    break;
                default:
                    break;
            }
        }else {
            switch (btn.tag) {
                case 0:{//操作说明
                    [MBProgressHUD showSuccess:@"暂未开放,敬请期待!" toView:self.view];
//                    BandingListViewController *bandVc = [[BandingListViewController alloc] init];
//                    bandVc.hidesBottomBarWhenPushed = YES;
//                    [self.navigationController pushViewController:bandVc animated:YES];
                    
                }
                    break;
                case 1:{//商户信息
                    
//                    BusinessDetailViewController *businessDetailVc = [[BusinessDetailViewController alloc]initWithNibName:@"BusinessDetailViewController" bundle:nil];
//                    businessDetailVc.hidesBottomBarWhenPushed = YES;
//                    [self.navigationController pushViewController:businessDetailVc animated:YES];
                    
                    
                    NewBusinessDetailViewController *businessVc = [[NewBusinessDetailViewController alloc] init];
                    businessVc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:businessVc animated:YES];
                    
                    
//                    self.flag = [[NSUserDefaults standardUserDefaults] objectForKey:Tag];
//                    
//                    if ([[[NSUserDefaults standardUserDefaults] objectForKey:CardID] length] > 0 && [[[NSUserDefaults standardUserDefaults] valueForKey:BankName] length] > 0 && [[[NSUserDefaults standardUserDefaults] valueForKey:CardName] length] > 0 && [[[NSUserDefaults standardUserDefaults] valueForKey:CardNumber] length] > 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:HandCard] length] > 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:FrontCard] length] > 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:BackCard] length] > 0) {
//                        
//                        if ([[[NSUserDefaults standardUserDefaults] objectForKey:Tag] isEqualToString:@"艾创音频"]) {
//                            self.tadeType = type_balance;
//                            
//                            [[NSUserDefaults standardUserDefaults] setObject:@"31" forKey:Type];
//                            [[NSUserDefaults standardUserDefaults] setObject:@"00000000" forKey:Amount];
//                            [[AC_POSManger shareInstance] setDeleagte:self];
//                            [[AC_POSManger shareInstance] openAndBanding];
//                            
//                            ACSwingCardViewController *swingVc = [[ACSwingCardViewController alloc] init];
//                            swingVc.tadeType = self.tadeType;
////                            swingVc.hidesBottomBarWhenPushed = YES;
//                            [self.navigationController pushViewController:swingVc animated:YES];
//                            
//                            
//                        }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:Tag] isEqualToString:@"艾创蓝牙"]){
//                            
//                        }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:Tag] isEqualToString:@"魔方音频"]){
//                            self.tadeType = type_balance;
//                            
//                            [[NSUserDefaults standardUserDefaults] setObject:@"31" forKey:Type];
//                            [[NSUserDefaults standardUserDefaults] setObject:@"00000000" forKey:Amount];
//                            //                    [[AC_POSManger shareInstance] setDeleagte:self];
//                            //                    [[AC_POSManger shareInstance] openAndBanding];
//                            
//                            SwingCardViewController *swingVc = [[SwingCardViewController alloc] init];
//                            swingVc.tadeType = self.tadeType;
////                            swingVc.hidesBottomBarWhenPushed = YES;
//                            [self.navigationController pushViewController:swingVc animated:YES];
//                            
//                        }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:Tag] isEqualToString:@"魔方蓝牙"]){
//                            self.tadeType = type_balance;
//                            
//                            [[NSUserDefaults standardUserDefaults] setObject:@"31" forKey:Type];
//                            [[NSUserDefaults standardUserDefaults] setObject:@"00000000" forKey:Amount];
//                            //                    [[AC_POSManger shareInstance] setDeleagte:self];
//                            //                    [[AC_POSManger shareInstance] openAndBanding];
//                            
//                            MFBTSwingCardViewController *swingVc = [[MFBTSwingCardViewController alloc] init];
//                            swingVc.tadeType = self.tadeType;
////                            swingVc.hidesBottomBarWhenPushed = YES;
//                            [self.navigationController pushViewController:swingVc animated:YES];
//                            
//                        }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:Tag] isEqualToString:@"鑫诺蓝牙"]){
//                            self.tadeType = type_balance;
//                            
//                            [[NSUserDefaults standardUserDefaults] setObject:@"31" forKey:Type];
//                            [[NSUserDefaults standardUserDefaults] setObject:@"00000000" forKey:Amount];
//                            //                    [[AC_POSManger shareInstance] setDeleagte:self];
//                            //                    [[AC_POSManger shareInstance] openAndBanding];
//                            
//                            XNBTSwingCardViewController *swingVc = [[XNBTSwingCardViewController alloc] init];
//                            swingVc.tadeType = self.tadeType;
////                            swingVc.hidesBottomBarWhenPushed = YES;
//                            [self.navigationController pushViewController:swingVc animated:YES];
//                            
//                        }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:Tag] isEqualToString:@"BBPOS音频"]){
//                            self.tadeType = type_balance;
//                            
//                            [[NSUserDefaults standardUserDefaults] setObject:@"31" forKey:Type];
//                            [[NSUserDefaults standardUserDefaults] setObject:@"00000000" forKey:Amount];
//                            //                    [[AC_POSManger shareInstance] setDeleagte:self];
//                            //                    [[AC_POSManger shareInstance] openAndBanding];
//                            
//                            XNBTSwingCardViewController *swingVc = [[XNBTSwingCardViewController alloc] init];
//                            swingVc.tadeType = self.tadeType;
////                            swingVc.hidesBottomBarWhenPushed = YES;
//                            [self.navigationController pushViewController:swingVc animated:YES];
//                            
//                        }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:Tag] isEqualToString:@"BBPOS蓝牙"]){
//                            self.tadeType = type_balance;
//                            
//                            [[NSUserDefaults standardUserDefaults] setObject:@"31" forKey:Type];
//                            [[NSUserDefaults standardUserDefaults] setObject:@"00000000" forKey:Amount];
//                            //                    [[AC_POSManger shareInstance] setDeleagte:self];
//                            //                    [[AC_POSManger shareInstance] openAndBanding];
//                            
//                            XNBTSwingCardViewController *swingVc = [[XNBTSwingCardViewController alloc] init];
//                            swingVc.tadeType = self.tadeType;
////                            swingVc.hidesBottomBarWhenPushed = YES;
//                            [self.navigationController pushViewController:swingVc animated:YES];
//                            
//                        }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:Tag] isEqualToString:@"魔方蓝牙无键盘"]){
//                            self.tadeType = type_balance;
//                            
//                            [[NSUserDefaults standardUserDefaults] setObject:@"31" forKey:Type];
//                            [[NSUserDefaults standardUserDefaults] setObject:@"00000000" forKey:Amount];
//                            //                    [[AC_POSManger shareInstance] setDeleagte:self];
//                            //                    [[AC_POSManger shareInstance] openAndBanding];
//                            
//                            MFBTADSwingCardViewController *swingVc = [[MFBTADSwingCardViewController alloc] init];
//                            swingVc.tadeType = self.tadeType;
////                            swingVc.hidesBottomBarWhenPushed = YES;
//                            [self.navigationController pushViewController:swingVc animated:YES];
//                            
//                        }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:Tag] isEqualToString:@"鑫诺蓝牙无键盘"]){
//                            self.tadeType = type_balance;
//                            
//                            [[NSUserDefaults standardUserDefaults] setObject:@"31" forKey:Type];
//                            [[NSUserDefaults standardUserDefaults] setObject:@"00000000" forKey:Amount];
//                            //                    [[AC_POSManger shareInstance] setDeleagte:self];
//                            //                    [[AC_POSManger shareInstance] openAndBanding];
//                            
//                            XNBTADSwingCardViewController *swingVc = [[XNBTADSwingCardViewController alloc] init];
//                            swingVc.tadeType = self.tadeType;
////                            swingVc.hidesBottomBarWhenPushed = YES;
//                            [self.navigationController pushViewController:swingVc animated:YES];
//                            
//                        }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:Tag] isEqualToString:@"中磁蓝牙无键盘"]){
//                            self.tadeType = type_balance;
//                            
//                            [[NSUserDefaults standardUserDefaults] setObject:@"31" forKey:Type];
//                            [[NSUserDefaults standardUserDefaults] setObject:@"00000000" forKey:Amount];
//                            //                    [[AC_POSManger shareInstance] setDeleagte:self];
//                            //                    [[AC_POSManger shareInstance] openAndBanding];
//                            
//                            XNBTADSwingCardViewController *swingVc = [[XNBTADSwingCardViewController alloc] init];
//                            swingVc.tadeType = self.tadeType;
////                            swingVc.hidesBottomBarWhenPushed = YES;
//                            [self.navigationController pushViewController:swingVc animated:YES];
//                            
//                        }else {
//                            self.tadeType = type_balance;
//                            
//                            [[NSUserDefaults standardUserDefaults] setObject:@"31" forKey:Type];
//                            [[NSUserDefaults standardUserDefaults] setObject:@"00000000" forKey:Amount];
//                            [[AC_POSManger shareInstance] setDeleagte:self];
//                            [[AC_POSManger shareInstance] openAndBanding];
//                            
//                            ACSwingCardViewController *swingVc = [[ACSwingCardViewController alloc] init];
//                            swingVc.tadeType = self.tadeType;
////                            swingVc.hidesBottomBarWhenPushed = YES;
//                            [self.navigationController pushViewController:swingVc animated:YES];
//                            
//                        }
//                        
//                        
//                    }else{
//                        [MBProgressHUD showSuccess:@"请先进入商户信息进行实名认证" toView:self.view];
//                    }
                    
                }
                    break;
                case 2:{//交易明细
                    
                    if ([[[NSUserDefaults standardUserDefaults] objectForKey:Rate] isEqualToString:@"00000000"]) {
                        [MBProgressHUD showSuccess:@"请联系客服设置交易费率" toView:self.view];
                    }else {
                        
                        RealTimeViewController *realVc = [[RealTimeViewController alloc] initWithNibName:@"RealTimeViewController" bundle:nil];
                        //            [self.navigationController.navigationBar setHidden:NO];
                        realVc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:realVc animated:YES];
                        [[NSUserDefaults standardUserDefaults] setObject:@"首页进入" forKey:@"RealType"];
                        
                    }
                    
                }
                    break;
                case 3:{//信用贷款
                    [MBProgressHUD showSuccess:@"暂未开放,敬请期待!" toView:self.view];
                    
                    
                }
                    break;
                case 4:{//微信支付
//                    [MBProgressHUD showSuccess:@"更多精彩内容,敬请期待!" toView:self.view];
//                    NSURL *URL = [NSURL URLWithString:@"https://www.cardniu.com/loan/wx/speed-loan.html?channel=guangdt9&qz_gdt=gjlj2v6oaaal5f7szfka&from=singlemessage&isappinstalled=0"];
//                    SVWebViewController *webViewController = [[SVWebViewController alloc] initWithURL:URL];
//                    webViewController.hidesBottomBarWhenPushed = YES;
//                    [self.navigationController pushViewController:webViewController animated:YES];
                    
                    //可以直接打开APP(配合plist文件使用)
//                    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay://"]])//判断已经安装
//                    {
//                        NSLog(@" installed");
//                        NSURL *url = [NSURL URLWithString:@"alipay://"];
//                        [[UIApplication sharedApplication] openURL:url];
//                        //    return  YES;
//                    }
//                    else
//                    {
//                        //在这里提示安装
//                        //APPStore地址:itms-apps://itunes.apple.com/
//                        NSURL *url = [NSURL URLWithString:@"itms-apps://itunes.apple.com/"];//直接跳APPStore或者下载地址
//                        [[UIApplication sharedApplication] openURL:url];
//                    }
                    
                    if ([[[NSUserDefaults standardUserDefaults] objectForKey:CardID] length] > 0 && [[[NSUserDefaults standardUserDefaults] valueForKey:BankName] length] > 0 && [[[NSUserDefaults standardUserDefaults] valueForKey:CardName] length] > 0 && [[[NSUserDefaults standardUserDefaults] valueForKey:CardNumber] length] > 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:HandCard] length] > 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:FrontCard] length] > 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:BackCard] length] > 0) {
                        
                        //                        AbstractItems *items = [[AbstractItems alloc] init];
                        //                        items.n0 = @"0700";
                        //                        items.n1 = [[NSUserDefaults standardUserDefaults] objectForKey:Account];
                        //                        items.n3 = @"190097";
                        //                        NSString *macStr = [NSString stringWithFormat:@"%@%@%@%@%@",items.n0,items.n1,items.n3,items.n59,MainKey];
                        //                        NSLog(@"macStr:%@",macStr);
                        //                        items.n64 = [[macStr md5HexDigest] uppercaseString];
                        //
                        //                        [[NetAPIManger sharedManger] request_RaiseQuotaListWithParams:[items keyValues] andBlock:^(id data, NSError *error) {
                        //                            AbstractItems *item = (AbstractItems *)data;
                        //                            if ([item.n39 isEqualToString:@"00"]) {
                        //                                NSLog(@"成功");
                        WeChatConsumeViewController *wechatVc = [[WeChatConsumeViewController alloc] init];
                        wechatVc.clickButtonStatus = @"微信";
                        //                                wechatVc.rate = [[NSUserDefaults standardUserDefaults] objectForKey:Rate];
                        wechatVc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:wechatVc animated:YES];
                        
                        //                            }else {
                        //                                NSLog(@"失败");
                        //                                if ([[ResponseDictionaryTool responseDic] objectForKey:item.n39]) {
                        //                                    NSString *error = [[ResponseDictionaryTool responseDic] objectForKey:item.n39];
                        //                                    NSLog(@"error:%@",error);
                        //                                    [MBProgressHUD showSuccess:error toView:self.view];
                        //                                }else {
                        //                                    [MBProgressHUD showSuccess:@"未知错误" toView:self.view];
                        //                                }
                        //                            }
                        //                        }];
                        
                    }else{
                        
                        [MBProgressHUD showSuccess:@"请先进入商户信息进行实名认证" toView:self.view];
                        
                    }
                    
                }
                    
                    break;
                case 5:{//支付宝支付
//                    [MBProgressHUD showSuccess:@"更多精彩内容,敬请期待!" toView:self.view];
//                    NSURL *URL = [NSURL URLWithString:@"http://credit.u51.com/"];
//                    SVWebViewController *webViewController = [[SVWebViewController alloc] initWithURL:URL];
//                    webViewController.hidesBottomBarWhenPushed = YES;
//                    [self.navigationController pushViewController:webViewController animated:YES];
                    
                    WeChatConsumeViewController *wechatVc = [[WeChatConsumeViewController alloc] init];
                    wechatVc.clickButtonStatus = @"支付宝";
                    //                                wechatVc.rate = [[NSUserDefaults standardUserDefaults] objectForKey:Rate];
                    wechatVc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:wechatVc animated:YES];
                }
                    break;
                case 6:{//更多
                    [MBProgressHUD showSuccess:@"暂未开放,敬请期待!" toView:self.view];
                    
//                    NSURL *URL = [NSURL URLWithString:@"http://www.jishangzhifu.com/page1000021"];
//                    SVWebViewController *webViewController = [[SVWebViewController alloc] initWithURL:URL];
//                    webViewController.hidesBottomBarWhenPushed = YES;
//                    [self.navigationController pushViewController:webViewController animated:YES];
                }
                    break;
                case 7:{//信用卡申请
//                    [MBProgressHUD showSuccess:@"暂未开放,敬请期待!" toView:self.view];
                    
                    NSURL *URL = [NSURL URLWithString:@"http://m.51credit.com/mp/kaku/"];
                    SVWebViewController *webViewController = [[SVWebViewController alloc] initWithURL:URL];
                    webViewController.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:webViewController animated:YES];
                }
                    break;
                case 8:{//银行卡余额
                    [MBProgressHUD showSuccess:@"即将开放" toView:self.view];
                }
                    break;
                case 9://转账汇款
                    [MBProgressHUD showSuccess:@"暂未开放,敬请期待!" toView:self.view];
                    break;
                case 10://生活缴费
                    [MBProgressHUD showSuccess:@"暂未开放,敬请期待!" toView:self.view];
                    break;
                case 11://话费充值
                    [MBProgressHUD showSuccess:@"暂未开放,敬请期待!" toView:self.view];
                    break;
                case 12:
                    [MBProgressHUD showSuccess:@"暂未开放,敬请期待!" toView:self.view];
                    break;
                case 13:
                    [MBProgressHUD showSuccess:@"暂未开放,敬请期待!" toView:self.view];
                    break;
                case 14:
                    [MBProgressHUD showSuccess:@"暂未开放,敬请期待!" toView:self.view];
                    break;
                case 15:
                    [MBProgressHUD showSuccess:@"暂未开放,敬请期待!" toView:self.view];
                    break;
                default:
                    break;
            }
        }
        
        
        
    }else {
        switch (btn.tag) {
            case 0:{
                [MBProgressHUD showSuccess:@"暂未开放" toView:self.view];
            }
                break;
            case 1:{
                [MBProgressHUD showSuccess:@"暂未开放" toView:self.view];
            }
                break;
            case 2:{
                [MBProgressHUD showSuccess:@"暂未开放" toView:self.view];
                
            }
                break;
            case 3:{
                
//                [MBProgressHUD showSuccess:@"暂未开放" toView:self.view];
                
                BandingListViewController *bandVc = [[BandingListViewController alloc] init];
                [self.navigationController pushViewController:bandVc animated:YES];
                
//                AbstractItems *items = [[AbstractItems alloc] init];
//                items.n0 = @"0700";
//                items.n3 = @"190932";
//                items.n42 = [[NSUserDefaults standardUserDefaults] objectForKey:MerchantNo];
//                NSString *macStr = [NSString stringWithFormat:@"%@%@%@%@%@",items.n0,items.n3,items.n42,items.n59, MainKey];
//                NSLog(@"macStr:%@",macStr);
//                items.n64 = [[macStr md5HexDigest] uppercaseString];
//                
//                [[NetAPIManger sharedManger] request_RaiseQuotaListWithParams:[items keyValues] andBlock:^(id data, NSError *error) {
//                    AbstractItems *item = (AbstractItems *)data;
//                    if ([item.n39 isEqualToString:@"00"]) {
//                        NSLog(@"成功");
//                        NSLog(@"count:%lu",(unsigned long)item.n57.count);
//                        BandingListViewController *bandVc = [[BandingListViewController alloc] init];
//                        if (item.n57.count != 0) {
//                            for (OrderItem *order in item.n57) {
//                                bandVc.listArray = item.n57;
//                                NSLog(@"%@",bandVc.listArray);
//                            }
//                            
//                        }
//                        bandVc.hidesBottomBarWhenPushed = YES;
//                        [self.navigationController pushViewController:bandVc animated:YES];
//                        
//                    }else {
//                        NSLog(@"失败");
//                        if ([[ResponseDictionaryTool responseDic] objectForKey:item.n39]) {
//                            NSString *error = [[ResponseDictionaryTool responseDic] objectForKey:item.n39];
//                            NSLog(@"error:%@",error);
//                            [MBProgressHUD showSuccess:error toView:self.view];
//                        }else {
//                            [MBProgressHUD showSuccess:@"未知错误" toView:self.view];
//                        }
//                    }
//                }];
                
            }
                break;
            case 4:{
                
                [MBProgressHUD showSuccess:@"通道关闭" toView:self.view];
                
            }
                
                break;
            case 5:
                [MBProgressHUD showSuccess:@"通道关闭" toView:self.view];
                break;
            case 6:{
                
                [MBProgressHUD showSuccess:@"暂未开放" toView:self.view];
                
            }
                break;
            case 7:{
                
                [MBProgressHUD showSuccess:@"暂未开放" toView:self.view];
                
            }
                break;
            case 8:
                [MBProgressHUD showSuccess:@"暂未开放" toView:self.view];
                break;
            case 9:
                [MBProgressHUD showSuccess:@"暂未开放" toView:self.view];
                break;
            case 10:
                [MBProgressHUD showSuccess:@"暂未开放" toView:self.view];
                break;
            case 11:
                [MBProgressHUD showSuccess:@"暂未开放" toView:self.view];
                break;
            case 12:
                [MBProgressHUD showSuccess:@"暂未开放" toView:self.view];
                break;
            case 13:
                [MBProgressHUD showSuccess:@"暂未开放" toView:self.view];
                break;
            case 14:
                [MBProgressHUD showSuccess:@"暂未开放" toView:self.view];
                break;
            case 15:
                [MBProgressHUD showSuccess:@"暂未开放" toView:self.view];
                break;
            default:
                break;
        }
        
    }
    
}

- (void)waitingForCardSwipe:(BOOL)status
{
    if(status == SUCCESS) {
        SwingCardViewController *swingCardViewController = [[SwingCardViewController alloc] init];
        swingCardViewController.tadeType = type_balance;
        [self.navigationController.navigationBar setHidden:NO];
        [self.navigationController pushViewController:swingCardViewController animated:YES];
    }
}



#pragma RateViewProtocol

- (void)confirmProtocol:(NSString *)rate
{    
    ConsumeViewController *consumeViewController = [[ConsumeViewController alloc] init];
    consumeViewController.tadeType = type_consument;
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController pushViewController:consumeViewController animated:YES];
}

-(void)choosePOS {
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:Tag] isEqualToString:@"神州安付蓝牙"]){
        SZBTADConsumeViewController *consumeVc = [[SZBTADConsumeViewController alloc]init];
        //        UINavigationController *consumeNavi = [[UINavigationController alloc] initWithRootViewController:consumeVc];
        //        [self presentViewController:consumeNavi animated:YES completion:nil];
        [self.navigationController pushViewController:consumeVc animated:YES];
        consumeVc.rate = [[NSUserDefaults standardUserDefaults] objectForKey:Rate];
        NSLog(@"rate:%@",consumeVc.rate);
        NSLog(@"rate:%@",consumeVc.rate);
    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:Tag] isEqualToString:@"神州安付蓝牙有键盘(带非接)"] || [[[NSUserDefaults standardUserDefaults] objectForKey:Tag] isEqualToString:@"神州安付蓝牙有键盘(不带非接)"]){
        SZBlueConsumeViewController *consumeVc = [[SZBlueConsumeViewController alloc]init];
        //        UINavigationController *consumeNavi = [[UINavigationController alloc] initWithRootViewController:consumeVc];
        //        [self presentViewController:consumeNavi animated:YES completion:nil];
        [self.navigationController pushViewController:consumeVc animated:YES];
        consumeVc.rate = [[NSUserDefaults standardUserDefaults] objectForKey:Rate];
        NSLog(@"rate:%@",consumeVc.rate);
        NSLog(@"rate:%@",consumeVc.rate);
    }
    else {
        ConsumeViewController *consumeVc = [[ConsumeViewController alloc]init];
        //        UINavigationController *consumeNavi = [[UINavigationController alloc] initWithRootViewController:consumeVc];
        //        [self presentViewController:consumeNavi animated:YES completion:nil];
        [self.navigationController pushViewController:consumeVc animated:YES];
        consumeVc.rate = [[NSUserDefaults standardUserDefaults] objectForKey:Rate];
        NSLog(@"rate:%@",consumeVc.rate);
    }
}
@end
