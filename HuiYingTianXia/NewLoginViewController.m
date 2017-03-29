//
//  NewLoginViewController.m
//  HuiYingTianXia
//
//  Created by liguo.chen on 16/2/29.
//  Copyright © 2016年 tsmc. All rights reserved.
//

#import "NewLoginViewController.h"
#import "Common.h"
#import "AbstractItems.h"
#import "NSString+MD5HexDigest.h"
#import "MJExtension.h"
#import "MBProgressHUD+Add.h"
#import "MBProgressHUD.h"
#import "IQKeyboardManager.h"
#import "IQKeyboardReturnKeyHandler.h"
#import "FLAnimatedImage.h"
#import "RegisterViewController.h"
#import "ReplacePwdViewController.h"
#import "HomePageViewController.h"
#import "ResponseDictionaryTool.h"
#import "BusinessDetailViewController.h"
#import "AppDelegate.h"
#import "TabBarViewController.h"

#import "NewBusinessDetailViewController.h"

#import "WSRollView.h"//加载背景动图

@interface NewLoginViewController ()<UITextFieldDelegate,UIApplicationDelegate,UIAlertViewDelegate>
{
    UIImageView *_imgView;
    UIView *_coverView;//盖在imageView上
    NSInteger buttonIndex;
}
@property (nonatomic, strong) IQKeyboardReturnKeyHandler *returnKeyHandler;
@property(strong,nonatomic)UITextField *phoneTextField;
@property(strong,nonatomic)UITextField *psdTextField;
@property(strong,nonatomic)UIButton *loginBtn;
@property(strong,nonatomic)UIButton *getPsdBtn;
@property(strong,nonatomic)UIButton *fogotPsdBtn;
@property(strong,nonatomic)UIButton *psdBtn;
@property(strong,nonatomic)UIButton *registBtn;
@property(strong,nonatomic)NSMutableDictionary *noticeDic;
//@property(strong,nonatomic)NSString *voucherNo;
@property(strong,nonatomic)AbstractItems *items;
@property(strong,nonatomic)UIButton *rememberPsdBtn;

@end

@implementation NewLoginViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //移动快慢的秒数    //移动的大小
//    [_imgView.layer addAnimation:[self moveX:2.5f X:[NSNumber numberWithFloat:-50.0f]] forKey:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
    self.returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    self.returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDone;
    //        self.returnKeyHandler.toolbarManageBehaviour = IQAutoToolbarBySubviews;
    
    //背景动图(可根据图片的长宽比来确定动图是横向滑动还是纵向滑动)
    WSRollView *wsRoll = [[WSRollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    wsRoll.backgroundColor = [UIColor whiteColor];
    wsRoll.timeInterval = 0.05; //移动一次需要的时间
    wsRoll.rollSpace = 0.5; //每次移动的像素距离
    wsRoll.image = [UIImage imageNamed:@"563x750.png"];//本地图片
//    wsRoll.rollImageURL = @"http://jiangsu.china.com.cn/uploadfile/2016/0122/1453449251090847.jpg"; //网络图片地址
    [wsRoll startRoll]; //开始滚动
    [self.view addSubview:wsRoll];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldTextDidChange:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
    
    self.navigationController.navigationBarHidden = YES;
    
    UIImage *logoImage = [UIImage imageNamed:@"logo"];
    UIImageView *logoImageView = [[UIImageView alloc] init];
    CGRect frame = logoImageView.frame;
    frame.origin.y = SCREEN_HEIGHT * 0.16;
    frame.size.width = logoImage.size.width * 0.8;
    frame.size.height = logoImage.size.height * 0.8;
    logoImageView.frame = frame;
    CGPoint center = logoImageView.center;
    center.x = SCREEN_WIDTH/2;
    logoImageView.center = center;
    logoImageView.image = logoImage;
    [self.view addSubview:logoImageView];
    
    UIImage *inputImage = [UIImage imageNamed:@"输入框"];
    UIImageView *inputImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(logoImageView.frame) + SCREEN_HEIGHT * 0.1, SCREEN_WIDTH - 40, 100)];
    inputImageView.image = inputImage;
    inputImageView.userInteractionEnabled = YES;
    [self.view addSubview:inputImageView];
    
    UIImage *phoneImage = [UIImage imageNamed:@"User-1"];
    UIImageView *phoneImageView = [[UIImageView alloc] init];
    CGRect frame2 = phoneImageView.frame;
    frame2.origin.x = 15.0;
    frame2.origin.y = 10.0;
    frame2.size.width = phoneImage.size.width;
    frame2.size.height = phoneImage.size.height;
    phoneImageView.frame = frame2;
    phoneImageView.image = phoneImage;
    [inputImageView addSubview:phoneImageView];
    
    self.phoneTextField = [[UITextField alloc] init];
    CGRect frame1 = self.phoneTextField.frame;
    frame1.origin.x = CGRectGetMaxX(phoneImageView.frame) + 8;
    frame1.origin.y = phoneImageView.frame.origin.y;
    frame1.size.width = inputImageView.frame.size.width - CGRectGetMaxX(phoneImageView.frame) - 8;
    frame1.size.height = phoneImageView.frame.size.height;
    self.phoneTextField.frame = frame1;
    self.phoneTextField.delegate = self;
    self.phoneTextField.placeholder = @"请输入手机号码";
    self.phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phoneTextField.font = FONT_14;
    [inputImageView addSubview:self.phoneTextField];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:Account] == nil ) {
        self.phoneTextField.text = @"";
    }
    self.phoneTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:Account];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(5, 50, inputImageView.frame.size.width - 10, 1)];
    line.backgroundColor = COLOR_FONT_GRAY;
    [inputImageView addSubview:line];
    
    UIImage *psdImage = [UIImage imageNamed:@"Lock-1"];
    UIImageView *psdImageView = [[UIImageView alloc] init];
    CGRect frame4 = psdImageView.frame;
    frame4.origin.x = 15.0;
    frame4.origin.y = 60.0;
    frame4.size.width = psdImage.size.width;
    frame4.size.height = psdImage.size.height;
    psdImageView.frame = frame4;
    psdImageView.image = psdImage;
    [inputImageView addSubview:psdImageView];
    
    UIImage *showPsdImage = [UIImage imageNamed:@"显示密码"];
    self.psdTextField = [[UITextField alloc] init];
    CGRect frame6 = self.psdTextField.frame;
    frame6.origin.x = CGRectGetMaxX(psdImageView.frame) + 8;
    frame6.origin.y = 60.0;
    frame6.size.width = inputImageView.frame.size.width - CGRectGetMaxX(psdImageView.frame) - 16 - showPsdImage.size.width;
    frame6.size.height = psdImageView.frame.size.height;
    self.psdTextField.frame = frame6;
    self.psdTextField.delegate = self;
    self.psdTextField.placeholder = @"请输入登录密码";
    self.psdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.psdTextField.secureTextEntry = YES;
    self.psdTextField.font = FONT_14;
    [inputImageView addSubview:self.psdTextField];
    
    buttonIndex = 0;
    self.rememberPsdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.rememberPsdBtn];
    self.rememberPsdBtn.frame = CGRectMake(20, CGRectGetMaxY(inputImageView.frame) + 10, 90, 20);
    //    self.rememberPsdBtn.backgroundColor = [UIColor redColor];
    [self.rememberPsdBtn setTitle:@"记住密码" forState:UIControlStateNormal];
    [self.rememberPsdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:RememberPsd] isEqualToString:@"1"]) {
        [self.rememberPsdBtn setImage:[UIImage imageNamed:@"记住密码"] forState:UIControlStateNormal];
    }else {
        [self.rememberPsdBtn setImage:[UIImage imageNamed:@"未勾选"] forState:UIControlStateNormal];
    }
    [self.rememberPsdBtn setFont:FONT_13];
    [self.rememberPsdBtn layoutIfNeeded];
    [self.rememberPsdBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 10)];
    [self.rememberPsdBtn setImageEdgeInsets:UIEdgeInsetsMake(0, self.rememberPsdBtn.titleLabel.bounds.size.width, 0, -self.rememberPsdBtn.titleLabel.bounds.size.width)];
//    [self.rememberPsdBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
//    [self.rememberPsdBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, self.rememberPsdBtn.imageView.bounds.size.width, 0, self.rememberPsdBtn.imageView.bounds.size.width - 10)];
    [self.rememberPsdBtn addTarget:self action:@selector(rememberPsdBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    //    if ([[[NSUserDefaults standardUserDefaults] objectForKey:RememberName] isEqualToString:@"1"] && [[NSUserDefaults standardUserDefaults] objectForKey:Account]) {
    //        self.phoneTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:Account];
    //    }
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:RememberPsd] isEqualToString:@"1"] && [[NSUserDefaults standardUserDefaults] objectForKey:Password]) {
        self.psdTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:Password];
    }
    
    self.loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(inputImageView.frame.origin.x, CGRectGetMaxY(inputImageView.frame) + 40, inputImageView.frame.size.width, 60)];
    [self.loginBtn setTitle:@"登     录" forState:UIControlStateNormal];
    [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginBtn setBackgroundColor:COLOR_THEME];
    self.loginBtn.layer.cornerRadius = 5.0;
    self.loginBtn.layer.masksToBounds = YES;
//    self.loginBtn.alpha = 0.5;
    [self.loginBtn addTarget:self action:@selector(loginBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginBtn];
    
    self.registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.registBtn.frame = CGRectMake(22, CGRectGetMaxY(self.loginBtn.frame) + 5, 90, 20);
    [self.registBtn setTitle:@"用户注册" forState:UIControlStateNormal];
    self.registBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.registBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.registBtn setFont:FONT_14];
    [self.registBtn addTarget:self action:@selector(registBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.registBtn];
    
    self.getPsdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.getPsdBtn.frame = CGRectMake(SCREEN_WIDTH - 25 - 85, CGRectGetMaxY(self.loginBtn.frame) + 5, 90, 20);
    [self.getPsdBtn setTitle:@"找回密码" forState:UIControlStateNormal];
    [self.getPsdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.getPsdBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.getPsdBtn setFont:FONT_14];
    [self.getPsdBtn addTarget:self action:@selector(getPsdBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.getPsdBtn];
    
}

-(void)rememberPsdBtnAction {
    NSLog(@"记住密码");
    if (buttonIndex == 0) {
        [self.rememberPsdBtn setImage:[UIImage imageNamed:@"记住密码"] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:RememberPsd];
        buttonIndex = 1;
    }else if (buttonIndex == 1) {
        [self.rememberPsdBtn setImage:[UIImage imageNamed:@"未勾选"] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:RememberPsd];
        buttonIndex = 0;
    }
}

-(void)loginBtnAction {
    NSLog(@"登录");
    [[NSUserDefaults standardUserDefaults] setObject:@"查询订单" forKey:@"WeChatOrder"];
    if (self.phoneTextField.text.length < 11) {
        [MBProgressHUD showSuccess:@"请输入正确的账号" toView:self.view];
    }else if ([self.psdTextField.text isEqualToString:@""]) {
        [MBProgressHUD showSuccess:@"请输入密码" toView:self.view];
    }else if (![self.phoneTextField.text isEqualToString:@""] && ![self.psdTextField.text isEqualToString:@""]) {
    
        NSInteger voucherNo = 0;
        OrderItem *item = [[OrderItem alloc]init];
        voucherNo = [item.voucherNo integerValue];
        
        AbstractItems *items = [[AbstractItems alloc] init];
        items.n3 = @"190928";
        items.n8 = [self.psdTextField.text md5HexDigest];
        items.n11 = [NSString stringWithFormat:@"%06zd",++voucherNo];
        
        NSString *macStr;
        if (self.phoneTextField.text.length == 11) {
            items.n1 = self.phoneTextField.text;
            //        items.n42 = @"";
            macStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",items.n0,items.n1,items.n3,items.n8,items.n11,items.n59, MainKey];
            NSLog(@"macStr:%@",macStr);
        }else if (self.phoneTextField.text.length > 11) {
            //        items.n1 = @"";
            items.n42 = self.phoneTextField.text;
            macStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",items.n0,items.n3,items.n8,items.n11,items.n42,items.n59, MainKey];
            NSLog(@"macStr:%@",macStr);
        }

//        NSString *macStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",items.n0,items.n1,items.n3,items.n8,items.n11,items.n42,items.n59, MainKey];
        NSLog(@"macStr:%@",macStr);
        items.n64 = [[macStr md5HexDigest] uppercaseString];
        [[NetAPIManger sharedManger] request_LoginWithParams:[items keyValues] andBlock:^(id data, NSError *error) {
            
            item.voucherNo = [NSString stringWithFormat:@"%zd",voucherNo];
            self.voucherNo = item.voucherNo;
            
            AbstractItems *item = (AbstractItems *)data;
            
            if (!error && ([[item n39] isEqualToString:@"00"] || [[item n39] isEqualToString:@"W8"])) {
                //存储
                NSString *merchantName = item.n63.length > 0? item.n63 : @"";
                merchantName = [merchantName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [[NSUserDefaults standardUserDefaults] setObject:merchantName forKey:MerchantName];
                //            [[NSUserDefaults standardUserDefaults] setObject:item.n1 forKey:Account];
                [[NSUserDefaults standardUserDefaults] setObject:self.phoneTextField.text forKey:Account];
                [[NSUserDefaults standardUserDefaults] setObject:self.psdTextField.text forKey:Password];
                
                [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:item.n57] forKey:TranceInfo];
                
                if ([item.n39 isEqualToString:@"00"]) {
                    //                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:Tag];
                    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:W8Str];
                    self.items = item;
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@"打开提示音" forKey:@"IsOpenVoice"];//先设置打开收款成功提示音
                    
                    if ([item.n43 isEqualToString:@""]) {
                        [[NSUserDefaults standardUserDefaults] setObject:@"00000000" forKey:Rate];
                    }else {
                        NSString *str = [NSString stringWithFormat:@"%@",item.n43];
                        NSString *str1 = [str substringFromIndex:2];
                        NSString *str2 = @"000000";
                        NSString *str3 = [str2 stringByAppendingString:str1];
                        [[NSUserDefaults standardUserDefaults] setObject:str3 forKey:Rate];
                    }
                    
                    
                    if (item.n57.count != 0) {
                        for (OrderItem *order in item.n57) {
                            NSLog(@"order:%@",order);
                            if ([order.type isEqualToString:@"10M"]) {
                                [[NSUserDefaults standardUserDefaults] setObject:order.imageUrl forKey:HandCard];
                            }else if ([order.type isEqualToString:@"10E"]) {
                                [[NSUserDefaults standardUserDefaults] setObject:order.imageUrl forKey:FrontCard];
                            }else if ([order.type isEqualToString:@"10K"]) {
                                [[NSUserDefaults standardUserDefaults] setObject:order.imageUrl forKey:BackCard];
                            }else if ([order.type isEqualToString:@"10G"]) {
                                [[NSUserDefaults standardUserDefaults] setObject:order.imageUrl forKey:ShopPhoto];
                            }
                            //                        else if ([order.type isEqualToString:@"10K"]) {
                            //                            [[NSUserDefaults standardUserDefaults] setObject:order.imageUrl forKey:FrontBank];
                            //                            NSLog(@"fbank:%@",[[NSUserDefaults standardUserDefaults] objectForKey:FrontBank]);
                            //                        }else if ([order.type isEqualToString:@"10L"]) {
                            //                            [[NSUserDefaults standardUserDefaults] setObject:order.imageUrl forKey:BackBank];
                            //                            NSLog(@"bbank:%@",[[NSUserDefaults standardUserDefaults] objectForKey:BackBank]);
                            //                        }
                            
                        }
                    }else{
                        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:HandCard];
                        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:FrontCard];
                        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:BackCard];
                        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:FrontBank];
                        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:BackBank];
                        
                    }
                    
                    if ([item.n60 length] > 0) {
                        NSString *n60 = item.n60;
                        NSData *data = [n60 dataUsingEncoding:NSUTF8StringEncoding];
                        NSArray *infoArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                        NSDictionary *dict = infoArray.firstObject;
                        NSLog(@"dict:%@",dict);
                        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:dict];
                        [dic setValue:@"0" forKey:@"isread"];
                        NSLog(@"dic:%@",dic);
                        self.noticeDic = dic;
                        NSLog(@"dictionary:%@",self.noticeDic);
                        if (![dic[@"id"] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:Notice][@"id"]]) {
                            [[NSUserDefaults standardUserDefaults] setObject:dic forKey:Notice];
                            
                            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:Isread];
                            
                            [[NSUserDefaults standardUserDefaults] setObject:dic[@"id"] forKey:NoticeId];
                            
                            [[NSUserDefaults standardUserDefaults] setObject:@"new" forKey:NewImage];
                            NSLog(@"dictionayr:%@",[[NSUserDefaults standardUserDefaults] objectForKey:Notice]);
                        }
                    }else {
                        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:Isread];
                        [[NSUserDefaults standardUserDefaults] setObject:@"old" forKey:NewImage];
                    }
                    
                    NSLog(@"n42:%@",item.n42);
                    NSLog(@"n57:%@",item.n57);
                    //            [[NSUserDefaults standardUserDefaults] setObject:self.voucherNo forKey:VoucherNo];
                    if ([item.n42 length] > 0) {
                        
                        NSString *n42 = item.n42;
                        NSData *data = [n42 dataUsingEncoding:NSUTF8StringEncoding];
                        NSArray *infoArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                        NSDictionary *dict = infoArray.firstObject;
                        //                            NSLog(@"dict:%@",dict);
                        
                        [[NSUserDefaults standardUserDefaults] setObject:dict[@"bankAccount"] forKey:CardNumber];
                        [[NSUserDefaults standardUserDefaults] setObject:dict[@"merchantNo"] forKey:MerchantNo];
                        [[NSUserDefaults standardUserDefaults] setObject:dict[@"bankDetail"] forKey:BankName];
                        [[NSUserDefaults standardUserDefaults] setObject:dict[@"idCardNumber"] forKey:CardID];
                        [[NSUserDefaults standardUserDefaults] setObject:dict[@"bankCode"] forKey:Code];
                        [[NSUserDefaults standardUserDefaults] setObject:dict[@"bankAccountName"] forKey:CardName];
                        [[NSUserDefaults standardUserDefaults] setObject:dict[@"merchantSource"] forKey:MerchantSource];
                        [[NSUserDefaults standardUserDefaults] setObject:dict[@"freezeStatus"] forKey:FreezeStatus];
                        [[NSUserDefaults standardUserDefaults] setObject:dict[@"useStatus"] forKey:UseStatus];
                        //                [[NSUserDefaults standardUserDefaults] setObject:item.n42 forKey:MerchantNo];
                        
                        [[NSUserDefaults standardUserDefaults] setObject:dict[@"merchantCnName"] forKey:@"merchantName"];
                        [[NSUserDefaults standardUserDefaults] setObject:dict[@"merchantShortName"] forKey:@"merchantShortName"];
                        [[NSUserDefaults standardUserDefaults] setObject:dict[@"customerServicePhone"] forKey:@"serviceTel"];
                        [[NSUserDefaults standardUserDefaults] setObject:dict[@"serviceScopeName"] forKey:ManageTypeID];
                        [[NSUserDefaults standardUserDefaults] setObject:dict[@"addrDetail"] forKey:@"shopAddress"];
                    }
                    if ([[[NSUserDefaults standardUserDefaults] objectForKey:UseStatus] isEqualToString:@"10B"]) {
                        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:@"风险账号，暂被停用" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                        alertview.tag = 3;
                        [alertview show];
                    }else if (![item.n44 isEqualToString:item.n59]) {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"发现新版本" delegate:self cancelButtonTitle:@"继续登录" otherButtonTitles:@"更新版本", nil];
                        alertView.tag = 5;
                        [alertView show];
                    }else {
                        TabBarViewController *tabBarVc = [[TabBarViewController alloc] init];
                        [self presentViewController:tabBarVc animated:YES completion:nil];
                        
                        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:JuJue];
                        //                    HomePageViewController *homePageVC = [[HomePageViewController alloc] init];
                        //                    UINavigationController *infoNavi = [[UINavigationController alloc] initWithRootViewController:homePageVC];
                        //                    homePageVC.absItem = item;
                        //                    homePageVC.dictionary = self.noticeDic;
                        //                    [self presentViewController:infoNavi animated:YES completion:nil];
                        //                    NSLog(@"dic:%@",homePageVC.dictionary);
                        //                    [[NSNotificationCenter defaultCenter] postNotificationName:@"home" object:self userInfo:@{@"homeVC":homePageVC}];
                        //                    [self.navigationController.navigationBar setHidden:YES];
                        //                    [self.navigationController pushViewController:homePageVC animated:YES];
                    }
                    
                }
                
                if ([item.n39 isEqualToString:@"W8"]) {
                    NSString *str = [[ResponseDictionaryTool responseDic] objectForKey:item.n39];
                    [[NSUserDefaults standardUserDefaults] setObject:str forKey:W8Str];
                    
                    if (item.n57.count != 0) {
                        for (OrderItem *order in item.n57) {
                            NSLog(@"order:%@",order);
                            if ([order.type isEqualToString:@"10M"]) {
                                [[NSUserDefaults standardUserDefaults] setObject:order.imageUrl forKey:HandCard];
                            }else if ([order.type isEqualToString:@"10E"]) {
                                [[NSUserDefaults standardUserDefaults] setObject:order.imageUrl forKey:FrontCard];
                            }else if ([order.type isEqualToString:@"10K"]) {
                                [[NSUserDefaults standardUserDefaults] setObject:order.imageUrl forKey:BackCard];
                            }else if ([order.type isEqualToString:@"10G"]) {
                                [[NSUserDefaults standardUserDefaults] setObject:order.imageUrl forKey:ShopPhoto];
                            }
                            //                        else if ([order.type isEqualToString:@"10K"]) {
                            //                            [[NSUserDefaults standardUserDefaults] setObject:order.imageUrl forKey:FrontBank];
                            //                        }else if ([order.type isEqualToString:@"10L"]) {
                            //                            [[NSUserDefaults standardUserDefaults] setObject:order.imageUrl forKey:BackBank];
                            //                        }
                        }
                    }else{
                        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:HandCard];
                        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:FrontCard];
                        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:BackCard];
                        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:FrontBank];
                        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:BackBank];
                        
                    }
                    
                    NSLog(@"n42:%@",item.n42);
                    NSLog(@"n57:%@",item.n57);
                    
                    if ([[[NSUserDefaults standardUserDefaults] objectForKey:UseStatus] isEqualToString:@"10B"]) {
                        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:@"风险账号，暂被停用" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                        alertview.tag = 4;
                        [alertview show];
                    }else {
                        NSString *str = [[ResponseDictionaryTool responseDic] objectForKey:item.n39];
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                        alertView.tag = 1;
                        [alertView show];
                        
                        [[NSUserDefaults standardUserDefaults] setObject:str forKey:W8Str];
                    }
                    
                    
                    
                    if ([item.n42 length] > 0) {
                        
                        NSString *n42 = item.n42;
                        NSData *data = [n42 dataUsingEncoding:NSUTF8StringEncoding];
                        NSArray *infoArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                        NSDictionary *dict = infoArray.firstObject;
                        
                        [[NSUserDefaults standardUserDefaults] setObject:dict[@"rcexamineResult"] forKey:CheckInfomation];
                        [[NSUserDefaults standardUserDefaults] setObject:dict[@"bankAccount"] forKey:CardNumber];
                        [[NSUserDefaults standardUserDefaults] setObject:dict[@"merchantNo"] forKey:MerchantNo];
                        [[NSUserDefaults standardUserDefaults] setObject:dict[@"bankDetail"] forKey:BankName];
                        [[NSUserDefaults standardUserDefaults] setObject:dict[@"idCardNumber"] forKey:CardID];
                        [[NSUserDefaults standardUserDefaults] setObject:dict[@"bankCode"] forKey:Code];
                        [[NSUserDefaults standardUserDefaults] setObject:dict[@"bankAccountName"] forKey:CardName];
                        [[NSUserDefaults standardUserDefaults] setObject:dict[@"merchantSource"] forKey:MerchantSource];
                        [[NSUserDefaults standardUserDefaults] setObject:dict[@"freezeStatus"] forKey:FreezeStatus];
                        [[NSUserDefaults standardUserDefaults] setObject:dict[@"useStatus"] forKey:UseStatus];
                        
                        //                    HomePageViewController *homePageVC = [[HomePageViewController alloc] init];
                        //                    homePageVC.absItem = item;
                        //                    [[NSNotificationCenter defaultCenter] postNotificationName:@"home" object:self userInfo:@{@"homeVC":homePageVC}];
                        //                    [self.navigationController.navigationBar setHidden:YES];
                        
                        
                        [[NSUserDefaults standardUserDefaults] setObject:dict[@"merchantCnName"] forKey:@"merchantName"];
                        [[NSUserDefaults standardUserDefaults] setObject:dict[@"merchantShortName"] forKey:@"merchantShortName"];
                        [[NSUserDefaults standardUserDefaults] setObject:dict[@"customerServicePhone"] forKey:@"serviceTel"];
                        [[NSUserDefaults standardUserDefaults] setObject:dict[@"serviceScopeName"] forKey:ManageTypeID];
                        [[NSUserDefaults standardUserDefaults] setObject:dict[@"addrDetail"] forKey:@"shopAddress"];
                        
                    }
                    
                    
                    //            UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:homePageVC];
                    //                NSString *str = [[ResponseDictionaryTool responseDic] objectForKey:item.n39];
                    //                [MBProgressHUD showSuccess:str toView:homePageVC.view];
                    //                [self.navigationController pushViewController:homePageVC animated:YES];
                }else {
                    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:CheckInfomation];
                }
                
                
            }else {
                
                if ([[ResponseDictionaryTool responseDic] objectForKey:item.n39]) {
                    NSString *error = [[ResponseDictionaryTool responseDic] objectForKey:item.n39];
                    NSLog(@"error:%@",error);
                    [MBProgressHUD showSuccess:error toView:self.view];
                }else {
                    [MBProgressHUD showSuccess:@"未知错误" toView:self.view];
                }
                
                if ([item.n39 isEqualToString:@"ZV"]) {
                    NSString *msg = [[ResponseDictionaryTool responseDic] valueForKey:item.n39];
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更新", nil];
                    alertView.tag = 2;
                    [alertView show];
                }
                
            }
        }];
    
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 1) {
        if (buttonIndex == 1) {
//            BusinessDetailViewController *businessVc = [[BusinessDetailViewController alloc] initWithNibName:@"BusinessDetailViewController" bundle:nil];
//            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//            UINavigationController *infoNavi = [[UINavigationController alloc] initWithRootViewController:businessVc];
//            [self presentViewController:infoNavi animated:YES completion:nil];
            
            NewBusinessDetailViewController *businessVc = [[NewBusinessDetailViewController alloc] init];
            UINavigationController *infoNavi = [[UINavigationController alloc] initWithRootViewController:businessVc];
            [self presentViewController:infoNavi animated:YES completion:nil];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"拒绝" forKey:JuJue];
        }
    }else if (alertView.tag == 2) {
        if (buttonIndex == 1) {
            NSString * updateUrlString = @"http://www.laimaidan.com/lmd/down.html";
            
            NSURL * url = [NSURL URLWithString:updateUrlString];
            
            if ([[UIApplication sharedApplication] canOpenURL:url])
            {
                [[UIApplication sharedApplication] openURL:url];
            }
            else
            {
                NSLog(@"can not open");
            }
        }else if (buttonIndex ==0) {
            
        }
    }else if (alertView.tag == 3 || alertView.tag == 4) {
        [alertView setHidden:YES];
    }else if (alertView.tag == 5) {
        if (buttonIndex == 1) {
            NSString * updateUrlString = @"http://www.laimaidan.com/lmd/down.html";
            
            NSURL * url = [NSURL URLWithString:updateUrlString];
            
            if ([[UIApplication sharedApplication] canOpenURL:url])
            {
                [[UIApplication sharedApplication] openURL:url];
            }
            else
            {
                NSLog(@"can not open");
            }
        }else if (buttonIndex ==0) {
            TabBarViewController *tabBarVc = [[TabBarViewController alloc] init];
            [self presentViewController:tabBarVc animated:YES completion:nil];
            
//            HomePageViewController *homeVc = [[HomePageViewController alloc] init];
//            homeVc.absItem = self.items;
//            NSLog(@"item:%@",self.items);
//            homeVc.dictionary = self.noticeDic;
//            NSLog(@"dic:%@",homeVc.dictionary);
//            [self.navigationController.navigationBar setHidden:YES];
//            [self.navigationController pushViewController:homeVc animated:YES];
        }
    }
    
}

- (void)hideKeyBoard
{
    [self.phoneTextField resignFirstResponder];
    [self.psdTextField resignFirstResponder];
}

-(void)registBtnAction {
    NSLog(@"注册");
    RegisterViewController *registerViewController = [[RegisterViewController alloc] init];
    UINavigationController *infoNavi = [[UINavigationController alloc] initWithRootViewController:registerViewController];
    [self presentViewController:infoNavi animated:YES completion:nil];
//    [self.navigationController.navigationBar setHidden:NO];
//    [self.navigationController pushViewController:registerViewController animated:YES];
    
}

-(void)getPsdBtnAction {
    NSLog(@"找回登录密码");
    ReplacePwdViewController *repalcePwdVc = [[ReplacePwdViewController alloc] init];
    UINavigationController *infoNavi = [[UINavigationController alloc] initWithRootViewController:repalcePwdVc];
    [self presentViewController:infoNavi animated:YES completion:nil];
//    [self.navigationController.navigationBar setHidden:NO];
//    [self.navigationController pushViewController:repalcePwdVc animated:YES];
}

#pragma mark - Notification

-(void)textFieldTextDidChange:(NSNotification *)notification {
    
    if (self.phoneTextField.text.length > 1 && self.psdTextField.text.length > 5) {
        self.loginBtn.enabled = YES;
        self.loginBtn.backgroundColor = COLOR_THEME;
    }else {
        self.loginBtn.enabled = NO;
        self.loginBtn.backgroundColor = COLOR_THEME;
    }
    
}

#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField == self.phoneTextField) {
        if (textField.text.length > 31 && string.length != 0) {
            return NO;
        }
        
    }else if(textField == self.psdTextField) {
        if (textField.text.length > 15 && string.length != 0) {
            return NO;
        }
    }
    return YES;
}

@end
