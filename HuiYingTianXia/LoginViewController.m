//
//  LoginViewController.m
//  HuiYingTianXia
//
//  Created by tsmc on 15-3-17.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "HomePageViewController.h"
#import "AbstractItems.h"
#import "MJExtension.h"
#import "NSString+MD5HexDigest.h"
#import "ProfileUtil.h"
#import "ResponseDictionaryTool.h"
#import "MBProgressHUD+Add.h"
#import "OrderItem.h"
#import "MerchantInfo.h"
#import "AppDelegate.h"
#import "ReplacePwdViewController.h"
#import "MBProgressHUD.h"
#import "BusinessDetailViewController.h"

@interface LoginViewController ()<UITextFieldDelegate,UIAlertViewDelegate,UIApplicationDelegate,UIAlertViewDelegate>
@property(nonatomic, strong)UIScrollView *baseView;
@property(nonatomic, strong)UITextField *tfUserName;
@property(nonatomic, strong)UITextField *tfPassword;
@property(nonatomic, strong)UIView *lineUserName;
@property(nonatomic, strong)UIView *linePassword;
@property(nonatomic, strong)UIButton *btnLogin;
@property(nonatomic, assign)CGPoint startPoint;

@property(nonatomic, assign)CGFloat animationTime;
@property(nonatomic, assign)UIViewAnimationOptions animationCurve;
@property(nonatomic, assign)CGRect keyboardFrame;

@property(strong,nonatomic)NSMutableDictionary *noticeDic;
//@property(strong,nonatomic)NSString *voucherNo;
@property(strong,nonatomic)AbstractItems *items;

@end

@implementation LoginViewController

- (void)dealloc
{
    [self removeKeyboardNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.baseView setDelegate:nil];
}

//-(void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldTextDidChange:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
    
    self.baseView = [[UIScrollView alloc] init];
    [self.baseView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.baseView];
    [self.baseView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.width.equalTo(SCREEN_WIDTH);
        make.height.equalTo(SCREEN_HEIGHT);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    [tap setNumberOfTapsRequired:1];
    [tap setNumberOfTouchesRequired:1];
    [self.baseView addGestureRecognizer:tap];
    
    UIImageView *iv = [[UIImageView alloc] init];
    [iv setUserInteractionEnabled:NO];
    [iv setImage:[UIImage imageNamed:@"logo"]];
    [self.baseView addSubview:iv];
    [iv makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView).offset(SCREEN_HEIGHT * 0.16);
        make.centerX.equalTo(self.baseView);
        make.height.equalTo(iv.image.size.height * 0.6);
        make.width.equalTo(iv.image.size.width * 0.6);
    }];
    
    UIImage *iconImg = [UIImage imageNamed:@"User"];
    UIImageView *ivLeft = [[UIImageView alloc] initWithImage:iconImg];
    [ivLeft setContentMode:UIViewContentModeLeft];
    [ivLeft setBounds:CGRectMake(0, 0, iconImg.size.width+6, iconImg.size.height)];
    
    self.tfUserName = [[UITextField alloc] init];
    self.tfUserName.delegate = self;
    [self.tfUserName setLeftView:ivLeft];
    self.tfUserName.leftViewMode = UITextFieldViewModeAlways;
    self.tfUserName.placeholder = @"手机号/商户编号";
    self.tfUserName.returnKeyType = UIReturnKeyNext;
    self.tfUserName.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.tfUserName.keyboardType = UIKeyboardTypeNumberPad;
    self.tfUserName.adjustsFontSizeToFitWidth = YES;
    [self.baseView addSubview:self.tfUserName];
    [self.tfUserName makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iv.bottom).offset(SCREEN_HEIGHT * 0.13);
        make.left.equalTo(self.baseView).offset(57);
        make.right.equalTo(self.baseView).offset(-57);
        make.height.equalTo(18);
    }];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:Account] == nil ) {
        self.tfUserName.text = @"";
    }
    self.tfUserName.text = [[NSUserDefaults standardUserDefaults] objectForKey:Account];
    
    self.lineUserName = [[UIView alloc] init];
    [self.lineUserName setBackgroundColor:COLOR_LINE];
    [self.baseView addSubview:self.lineUserName];
    [self.lineUserName makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tfUserName.bottom).offset(12);
        make.left.equalTo(self.baseView).offset(43);
        make.right.equalTo(self.baseView).offset(-43);
        make.height.equalTo(LINE_HEIGTH);
        make.width.equalTo(SCREEN_WIDTH - 2*43);
    }];

    iconImg = [UIImage imageNamed:@"Lock"];
    ivLeft = [[UIImageView alloc] initWithImage:iconImg];
    [ivLeft setContentMode:UIViewContentModeLeft];
    [ivLeft setBounds:CGRectMake(0, 0, iconImg.size.width+6, iconImg.size.height)];
    
    self.tfPassword = [[UITextField alloc] init];
    self.tfPassword.delegate = self;
    [self.tfPassword setLeftView:ivLeft];
    self.tfPassword.leftViewMode = UITextFieldViewModeAlways;
    self.tfPassword.placeholder = @"输入登录密码";
    self.tfPassword.returnKeyType = UIReturnKeyDone;
    self.tfPassword.secureTextEntry = YES;
    self.tfPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.baseView addSubview:self.tfPassword];
    [self.tfPassword makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineUserName).offset(26);
        make.left.equalTo(self.tfUserName);
        make.right.equalTo(self.tfUserName);
        make.height.equalTo(self.tfUserName);
    }];
    
//    self.tfPassword.text = @"123456";

    
    self.linePassword = [[UIView alloc] init];
    [self.linePassword setBackgroundColor:COLOR_LINE];
    [self.baseView addSubview:self.linePassword];
    [self.linePassword makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tfPassword.bottom).offset(12);
        make.left.equalTo(self.lineUserName);
        make.right.equalTo(self.lineUserName);
        make.height.equalTo(LINE_HEIGTH);
        
    }];
    
    self.btnLogin = [[UIButton alloc] init];
    [self.btnLogin setBackgroundColor:COLOR_FONT_GRAY];
    [self.btnLogin setTitleColor:COLOR_MY_WHITE forState:UIControlStateNormal];
    [self.btnLogin setTitle:@"登录" forState:UIControlStateNormal];
    [self.btnLogin addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.btnLogin setEnabled:NO];
    [self.baseView addSubview:self.btnLogin];
    [self.btnLogin makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.linePassword).offset(25);
        //make.left.equalTo(self.baseView).offset(73);
        make.left.equalTo(self.baseView).offset(45);
        //make.right.equalTo(self.baseView).offset(-73);
        make.right.equalTo(self.baseView).offset(-45);
        make.height.equalTo(BNT_HEIGHT);
    }];
    
    
    UIView *line = [[UIView alloc] init];
    [line setBackgroundColor:COLOR_LINE];
//    [line setBackgroundColor:[UIColor clearColor]];
    [self.baseView addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-60);
        make.height.equalTo([UIFont systemFontOfSize:14].lineHeight);
        make.width.equalTo(1);
    }];
    
    UIButton *btnRegister = [[UIButton alloc] init];
    [btnRegister setBackgroundColor:[UIColor clearColor]];
    [btnRegister setTitleColor:COLOR_LINE forState:UIControlStateNormal];
    [btnRegister.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btnRegister setTitle:@"注册账号" forState:UIControlStateNormal];
    [btnRegister addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    [self.baseView addSubview:btnRegister];
    [btnRegister makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line);
        make.right.equalTo(line.left).offset(HFixWidthBaseOn320(-7));
        make.height.equalTo(line);
//        make.top.equalTo(line);
//        make.centerX.equalTo(self.view);
//        make.height.equalTo(line);
    }];
    
    UILabel *editionLabel = [[UILabel alloc]init];
    [editionLabel setBackgroundColor:[UIColor clearColor]];
    [editionLabel setTextColor:COLOR_LINE];
    [editionLabel setFont:[UIFont systemFontOfSize:13]];
    AbstractItems *item = [[AbstractItems alloc] init];
    NSLog(@"n59:%@",item.n59);
    NSString *str = [item.n59 substringFromIndex:5];
    NSString *str1 = [NSString stringWithFormat:@"版本信息:%@",str];
    [editionLabel setText:str1];
    [self.baseView addSubview:editionLabel];
    [editionLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(btnRegister).offset(20);
        make.height.equalTo([UIFont systemFontOfSize:13].lineHeight);
        
    }];
    
    UIButton *btnFindPwd = [[UIButton alloc] init];
    [btnFindPwd setBackgroundColor:[UIColor clearColor]];
    [btnFindPwd setTitleColor:COLOR_LINE forState:UIControlStateNormal];
    [btnFindPwd.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btnFindPwd setTitle:@"找回密码" forState:UIControlStateNormal];
    [btnFindPwd addTarget:self action:@selector(findPwdAction) forControlEvents:UIControlEventTouchUpInside];
    [self.baseView addSubview:btnFindPwd];
    [btnFindPwd makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line);
        make.left.equalTo(line.right).offset(HFixWidthBaseOn320(7));
        make.height.equalTo(line);
    }];
    
//    btnFindPwd.hidden = YES;
//    btnFindPwd.enabled = NO;
    
    [self addKeyboardNotification];
}

-(void)viewDidAppear:(BOOL)animated {
    [self.tfUserName removeFromSuperview];
    [self.tfPassword removeFromSuperview];
}

- (void)textFieldTextDidChange:(NSNotification *)notification
{
    UITextField *tf = [notification object];
    NSString *newText = tf.text;
    if (tf == self.tfUserName) {
        if ([self.tfPassword.text length] > 5 && [self.tfPassword.text length] < 15 && [newText length] >= 11) {
            [self.btnLogin setBackgroundColor:COLOR_THEME];
            [self.btnLogin setEnabled:YES];
        }else{
            [self.btnLogin setBackgroundColor:COLOR_FONT_GRAY];
            [self.btnLogin setEnabled:NO];
        }
    }else if (tf == self.tfPassword) {
        if ([newText length] > 0 && [newText length] < 15 && [self.tfUserName.text length] >= 11) {
            [self.btnLogin setBackgroundColor:COLOR_THEME];
            [self.btnLogin setEnabled:YES];
        }else{
            [self.btnLogin setBackgroundColor:COLOR_FONT_GRAY];
            [self.btnLogin setEnabled:NO];
        }
    }
    
}

#pragma mark button action
- (void)loginAction
{
    NSInteger voucherNo = 0;
    OrderItem *item = [[OrderItem alloc]init];
    voucherNo = [item.voucherNo integerValue];
    
    AbstractItems *items = [[AbstractItems alloc] init];
    if (self.tfUserName.text.length == 11) {
        items.n1 = self.tfUserName.text;
        items.n42 = @"";
    }else if (self.tfUserName.text.length > 11) {
        items.n1 = @"";
        items.n42 = self.tfUserName.text;
    }
    items.n3 = @"190928";
    items.n8 = [self.tfPassword.text md5HexDigest];
    items.n11 = [NSString stringWithFormat:@"%06zd",++voucherNo];
    
//    items.n59 = @"CHDS-1.0.0";
    NSString *macStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",items.n0,items.n1,items.n3,items.n8,items.n11,items.n42,items.n59, MainKey];
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
            [[NSUserDefaults standardUserDefaults] setObject:self.tfUserName.text forKey:Account];
            [[NSUserDefaults standardUserDefaults] setObject:item.n8 forKey:Password];
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:item.n57] forKey:TranceInfo];
            
            if ([item.n39 isEqualToString:@"00"]) {
//                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:Tag];
                self.items = item;
                
                if (item.n57.count != 0) {
                    for (OrderItem *order in item.n57) {
                        NSLog(@"order:%@",order);
                        if ([order.type isEqualToString:@"10M"]) {
                            [[NSUserDefaults standardUserDefaults] setObject:order.imageUrl forKey:HandCard];
                        }else if ([order.type isEqualToString:@"10E"]) {
                            [[NSUserDefaults standardUserDefaults] setObject:order.imageUrl forKey:FrontCard];
                        }else if ([order.type isEqualToString:@"10F"]) {
                            [[NSUserDefaults standardUserDefaults] setObject:order.imageUrl forKey:BackCard];
                        }else if ([order.type isEqualToString:@"10K"]) {
                            [[NSUserDefaults standardUserDefaults] setObject:order.imageUrl forKey:FrontBank];
                            NSLog(@"fbank:%@",[[NSUserDefaults standardUserDefaults] objectForKey:FrontBank]);
                        }else if ([order.type isEqualToString:@"10L"]) {
                            [[NSUserDefaults standardUserDefaults] setObject:order.imageUrl forKey:BackBank];
                            NSLog(@"bbank:%@",[[NSUserDefaults standardUserDefaults] objectForKey:BackBank]);
                        }
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
                    
//                    [[NSUserDefaults standardUserDefaults] setObject:dict[@"content"] forKey:Content];
//                    [[NSUserDefaults standardUserDefaults] setObject:dict[@"title"] forKey:Title];
//                    [[NSUserDefaults standardUserDefaults] setObject:dict[@"id"] forKey:Number];
//                    [[NSUserDefaults standardUserDefaults] setObject:dict[@"updateDateStr"] forKey:Time];
//                    NSLog(@"dicto:%@",[[NSUserDefaults standardUserDefaults] objectForKey:Notice]);
//                    NSLog(@"content:%@",[[NSUserDefaults standardUserDefaults] objectForKey:Content]);
//                    NSLog(@"title:%@",[[NSUserDefaults standardUserDefaults] objectForKey:Title]);
//                    NSLog(@"number:%@",[[NSUserDefaults standardUserDefaults] objectForKey:Number]);
//                    NSLog(@"time:%@",[[NSUserDefaults standardUserDefaults] objectForKey:Time]);
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
                    [[NSUserDefaults standardUserDefaults] setObject:dict[@"bankAccountName"] forKey:CardName];
                    [[NSUserDefaults standardUserDefaults] setObject:dict[@"merchantSource"] forKey:MerchantSource];
                    [[NSUserDefaults standardUserDefaults] setObject:dict[@"freezeStatus"] forKey:FreezeStatus];
                    [[NSUserDefaults standardUserDefaults] setObject:dict[@"useStatus"] forKey:UseStatus];
                    //                [[NSUserDefaults standardUserDefaults] setObject:item.n42 forKey:MerchantNo];
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
                    HomePageViewController *homePageVC = [[HomePageViewController alloc] init];
                    homePageVC.absItem = item;
                    homePageVC.dictionary = self.noticeDic;
                    NSLog(@"dic:%@",homePageVC.dictionary);
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"home" object:self userInfo:@{@"homeVC":homePageVC}];
                    [self.navigationController.navigationBar setHidden:YES];
                    [self.navigationController pushViewController:homePageVC animated:YES];
                }
                
            }
            
            if ([item.n39 isEqualToString:@"W8"]) {
                
                if (item.n57.count != 0) {
                    for (OrderItem *order in item.n57) {
                        NSLog(@"order:%@",order);
                        if ([order.type isEqualToString:@"10M"]) {
                            [[NSUserDefaults standardUserDefaults] setObject:order.imageUrl forKey:HandCard];
                        }else if ([order.type isEqualToString:@"10E"]) {
                            [[NSUserDefaults standardUserDefaults] setObject:order.imageUrl forKey:FrontCard];
                        }else if ([order.type isEqualToString:@"10F"]) {
                            [[NSUserDefaults standardUserDefaults] setObject:order.imageUrl forKey:BackCard];
                        }else if ([order.type isEqualToString:@"10K"]) {
                            [[NSUserDefaults standardUserDefaults] setObject:order.imageUrl forKey:FrontBank];
                        }else if ([order.type isEqualToString:@"10L"]) {
                            [[NSUserDefaults standardUserDefaults] setObject:order.imageUrl forKey:BackBank];
                        }
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
                    [[NSUserDefaults standardUserDefaults] setObject:dict[@"bankAccountName"] forKey:CardName];
                    [[NSUserDefaults standardUserDefaults] setObject:dict[@"merchantSource"] forKey:MerchantSource];
                    [[NSUserDefaults standardUserDefaults] setObject:dict[@"freezeStatus"] forKey:FreezeStatus];
                    [[NSUserDefaults standardUserDefaults] setObject:dict[@"useStatus"] forKey:UseStatus];
                
//                    HomePageViewController *homePageVC = [[HomePageViewController alloc] init];
//                    homePageVC.absItem = item;
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"home" object:self userInfo:@{@"homeVC":homePageVC}];
//                    [self.navigationController.navigationBar setHidden:YES];
                    
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

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 1) {
        if (buttonIndex == 1) {
            BusinessDetailViewController *businessVc = [[BusinessDetailViewController alloc] initWithNibName:@"BusinessDetailViewController" bundle:nil];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self.navigationController pushViewController:businessVc animated:YES];
        }
    }else if (alertView.tag == 2) {
        if (buttonIndex == 1) {
            NSString * updateUrlString = @"http://www.ychpay.com/down.html";
            
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
            AppDelegate *app = [UIApplication sharedApplication].delegate;
            UIWindow *window = app.window;
            
            [UIView animateWithDuration:.5f animations:^{
                window.alpha = 0;
                window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
            } completion:^(BOOL finished) {
                exit(0);
            }];
        }
    }else if (alertView.tag == 3 || alertView.tag == 4) {
        [alertView setHidden:YES];
    }else if (alertView.tag == 5) {
        if (buttonIndex == 1) {
            NSString * updateUrlString = @"http://www.ychpay.com/down.html";
            
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
            HomePageViewController *homeVc = [[HomePageViewController alloc] init];
            homeVc.absItem = self.items;
            NSLog(@"item:%@",self.items);
            homeVc.dictionary = self.noticeDic;
            NSLog(@"dic:%@",homeVc.dictionary);
            [self.navigationController.navigationBar setHidden:YES];
            [self.navigationController pushViewController:homeVc animated:YES];
        }
    }
    
}


- (void)registerAction
{
    RegisterViewController *registerViewController = [[RegisterViewController alloc] init];
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController pushViewController:registerViewController animated:YES];
}

- (void)hideKeyBoard
{
    [self.tfUserName resignFirstResponder];
    [self.tfPassword resignFirstResponder];
}

- (void)findPwdAction
{

    ReplacePwdViewController *repalcePwdVc = [[ReplacePwdViewController alloc] init];
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController pushViewController:repalcePwdVc animated:YES];
    
    
}

#pragma mark Keyboard Notification
- (void)inputKeyboardWillShow:(NSNotification *)notification {
    self.animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    self.animationCurve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    self.keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self keyboardShowAnimate];
}

- (void)keyboardShowAnimate
{
    CGFloat offsetY = 0 ;
    if ([self.tfUserName isFirstResponder]) {
        offsetY = CGRectGetMaxY(self.linePassword.frame) + self.keyboardFrame.size.height - SCREEN_HEIGHT;
        offsetY = offsetY >= 0? offsetY : 0;
        
        [UIView animateWithDuration:self.animationTime delay:0 options:self.animationCurve animations:^{
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            self.baseView.contentOffset = CGPointMake(0, offsetY);
        } completion:^(BOOL finished) {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }];
    }else if([self.tfPassword isFirstResponder]) {
        offsetY = CGRectGetMaxY(self.linePassword.frame) + self.keyboardFrame.size.height - SCREEN_HEIGHT;
        offsetY = offsetY >= 0? offsetY : 0;
        
        [UIView animateWithDuration:self.animationTime delay:0 options:self.animationCurve animations:^{
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            self.baseView.contentOffset = CGPointMake(0, offsetY);
        } completion:^(BOOL finished) {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }];
    }
}


- (void)inputKeyboardWillHide:(NSNotification *)notification {
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSInteger animationCurve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    [UIView animateWithDuration:animationTime delay:0 options:animationCurve animations:^{
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        self.baseView.contentOffset = CGPointMake(0, 0);
    } completion:^(BOOL finished) {
        self.keyboardFrame = CGRectZero;
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [self.btnLogin setBackgroundColor:COLOR_FONT_GRAY];
    [self.btnLogin setEnabled:NO];
    return YES;
}

#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        if (textField == self.tfUserName) {
            [self.tfPassword becomeFirstResponder];
        }else if (textField == self.tfPassword){
            [self hideKeyBoard];
        }
        [self keyboardShowAnimate];
        return YES;
    }
    
    
    if ([string isEqualToString:@"\n"]) {
        [self hideKeyBoard];
        return YES;
    }
    
    if (textField == self.tfUserName) {
        if (textField.text.length > 31 && string.length != 0) {
            return NO;
        }
        
    }else if(textField == self.tfPassword) {
        if (textField.text.length > 13 && string.length != 0) {
            return NO;
        }
    }
    return YES;
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
