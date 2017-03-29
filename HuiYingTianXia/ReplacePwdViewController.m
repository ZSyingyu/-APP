//
//  ReplacePwdViewController.m
//  HuiYingTianXia
//
//  Created by 朱颖宇 on 15/8/17.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import "ReplacePwdViewController.h"
#import "NSString+MD5HexDigest.h"
#import "MJExtension.h"
#import "MBProgressHUD+Add.h"
#import "MBProgressHUD.h"
#import "ResponseDictionaryTool.h"
#import "LoginViewController.h"


@interface ReplacePwdViewController ()<UITextFieldDelegate,UIAlertViewDelegate,UIApplicationDelegate,UIScrollViewDelegate>
@property(nonatomic, strong)UIScrollView *baseView;
@property(nonatomic, assign)CGRect keyboardFrame;
@property(nonatomic, strong)UITextField *tfPhone;//手机号
@property(nonatomic, strong)UIView *linePhone;
@property(nonatomic, strong)UITextField *tfNewPwd;
@property(nonatomic, strong)UIView *lineNewPwd;
@property(nonatomic, strong)UITextField *tfConfirmPwd;
@property(nonatomic, strong)UIView *lineConfirmPwd;
@property(strong,nonatomic)UITextField *randCode;//验证码
@property(strong,nonatomic)UIView *lineSecondPwd;

@property(nonatomic, strong)UIButton *btnResign;

@property(strong,nonatomic)UIButton *numButton;//验证码按钮

@property(nonatomic, assign)CGFloat animationTime;
@property(nonatomic, assign)UIViewAnimationOptions animationCurve;


@end

@implementation ReplacePwdViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setNavTitle:@"找回密码"];
    [self setBackBarButtonItemWithTitle:@"返回"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldTextDidChange:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputKeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [self addKeyboardNotification];
    
    self.baseView = [[UIScrollView alloc] init];
    [self.baseView setBackgroundColor:[UIColor clearColor]];
//    self.baseView.contentSize = CGSizeMake(0, 1000);
    self.baseView.delegate = self;
    self.baseView.showsHorizontalScrollIndicator = NO;
    self.baseView.scrollEnabled = NO;
    [self.view addSubview:self.baseView];
    [self.baseView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.width.equalTo(SCREEN_WIDTH);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    [tap setNumberOfTapsRequired:1];
    [tap setNumberOfTouchesRequired:1];
    [self.baseView addGestureRecognizer:tap];
    
//    UIImageView *iv = [[UIImageView alloc] init];
//    [iv setUserInteractionEnabled:NO];
//    [iv setImage:[UIImage imageNamed:@"logo"]];
//    [self.baseView addSubview:iv];
//    [iv makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.baseView).offset(40);
//        make.centerX.equalTo(self.baseView);
//        make.height.equalTo(iv.image.size.height * 0.6);
//        make.width.equalTo(iv.image.size.width * 0.6);
//    }];
//    
    UIImage *iconImg = [UIImage imageNamed:@"User"];
    UIImageView *iconView = [[UIImageView alloc] initWithImage:iconImg];
    [self.baseView addSubview:iconView];
    [iconView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(15);
        make.left.equalTo(self.baseView).offset(HFixWidthBaseOn320(60));
        make.height.equalTo(iconImg.size.height);
        make.width.equalTo(iconImg.size.width);
    }];
    
    self.tfPhone = [[UITextField alloc] init];
    self.tfPhone.delegate = self;
    self.tfPhone.placeholder = @"请输入手机号";
    [self.tfPhone setFont:FONT_15];
    self.tfPhone.returnKeyType = UIReturnKeyNext;
    self.tfPhone.keyboardType = UIKeyboardTypeNumberPad;
    self.tfPhone.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.baseView addSubview:self.tfPhone];
    [self.tfPhone makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(15);
        make.left.equalTo(iconView).offset(HFixWidthBaseOn320(20));
        make.right.equalTo(self.baseView).offset(HFixWidthBaseOn320(-50));
        make.height.equalTo(self.tfPhone.font.lineHeight);
        make.width.equalTo(SCREEN_WIDTH - HFixWidthBaseOn320(50) - HFixWidthBaseOn320(65));
    }];
    
    self.linePhone = [[UIView alloc] init];
    [self.linePhone setBackgroundColor:COLOR_LINE];
    [self.baseView addSubview:self.linePhone];
    [self.linePhone makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tfPhone.bottom).offset(18);
        make.left.equalTo(self.baseView).offset(HFixWidthBaseOn320(50));
        make.right.equalTo(self.baseView).offset(HFixWidthBaseOn320(-50));
        make.height.equalTo(LINE_HEIGTH);
    }];
    
    UIImage *randImage = [UIImage imageNamed:@"验证码"];
    UIImageView *randView = [[UIImageView alloc] initWithImage:randImage];
    [self.baseView addSubview:randView];
    [randView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.linePhone.bottom).offset(18);
        make.left.equalTo(self.baseView).offset(HFixWidthBaseOn320(60));
        make.height.equalTo(iconImg.size.height);
        make.width.equalTo(iconImg.size.width);
    }];
    
    self.randCode = [[UITextField alloc] init];
    self.randCode.delegate = self;
    self.randCode.placeholder = @"请输入验证码";
    [self.randCode setFont:FONT_15];
    self.randCode.returnKeyType = UIReturnKeyNext;
    self.randCode.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.randCode.keyboardType = UIKeyboardTypeNumberPad;
    //    self.randCode.secureTextEntry = YES;
    [self.baseView addSubview:self.randCode];
    [self.randCode makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.linePhone.bottom).offset(18);
        make.left.equalTo(self.tfPhone);
        make.right.equalTo(self.tfPhone);
        make.height.equalTo(self.tfPhone);
    }];
    
    self.numButton = [[JKCountDownButton alloc]init];
    self.numButton = [JKCountDownButton buttonWithType:UIButtonTypeCustom];
    [self.numButton setBackgroundColor:COLOR_FONT_GRAY];
    [self.numButton setTitleColor:COLOR_MY_WHITE forState:UIControlStateNormal];
    [self.numButton setFont:[UIFont systemFontOfSize:14]];
    [self.numButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.numButton addTarget:self action:@selector(randCodeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseView addSubview:self.numButton];
    [self.numButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.linePhone.bottom).offset(10);
        make.right.equalTo(self.tfPhone).offset(-10);
        make.height.equalTo(35);
        make.left.equalTo(self.tfPhone).offset(100);
    }];
    
    
    
    self.lineNewPwd = [[UIView alloc] init];
    [self.lineNewPwd setBackgroundColor:COLOR_LINE];
    [self.baseView addSubview:self.lineNewPwd];
    [self.lineNewPwd makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.randCode.bottom).offset(18);
        make.left.equalTo(self.linePhone);
        make.right.equalTo(self.linePhone);
        make.height.equalTo(LINE_HEIGTH);
    }];
    
    UIImage *newPwdImage = [UIImage imageNamed:@"Lock"];
    UIImageView *newPwdView = [[UIImageView alloc] initWithImage:newPwdImage];
    [self.baseView addSubview:newPwdView];
    [newPwdView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineNewPwd.bottom).offset(18);
        make.left.equalTo(self.baseView).offset(HFixWidthBaseOn320(60));
        make.height.equalTo(iconImg.size.height);
        make.width.equalTo(iconImg.size.width);
    }];
    
    self.tfNewPwd = [[UITextField alloc] init];
    self.tfNewPwd.delegate = self;
    self.tfNewPwd.placeholder = @"请输入新的密码";
    self.tfNewPwd.secureTextEntry = YES;
    [self.tfNewPwd setFont:FONT_15];
    self.tfNewPwd.returnKeyType = UIReturnKeyNext;
    self.tfNewPwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.baseView addSubview:self.tfNewPwd];
    [self.tfNewPwd makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineNewPwd.bottom).offset(18);
        make.left.equalTo(self.tfPhone);
        make.right.equalTo(self.tfPhone);
        make.height.equalTo(self.tfPhone);
    }];
    
    self.lineConfirmPwd = [[UIView alloc] init];
    [self.lineConfirmPwd setBackgroundColor:COLOR_LINE];
    [self.baseView addSubview:self.lineConfirmPwd];
    [self.lineConfirmPwd makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tfNewPwd.bottom).offset(18);
        make.left.equalTo(self.linePhone);
        make.right.equalTo(self.linePhone);
        make.height.equalTo(LINE_HEIGTH);
    }];
    
    UIImage *secondPwdImage = [UIImage imageNamed:@"Lock"];
    UIImageView *secondPwdView = [[UIImageView alloc] initWithImage:secondPwdImage];
    [self.baseView addSubview:secondPwdView];
    [secondPwdView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineConfirmPwd.bottom).offset(18);
        make.left.equalTo(self.baseView).offset(HFixWidthBaseOn320(60));
        make.height.equalTo(iconImg.size.height);
        make.width.equalTo(iconImg.size.width);
    }];
    
    self.tfConfirmPwd = [[UITextField alloc]init];
    self.tfConfirmPwd.delegate = self;
    self.tfConfirmPwd.placeholder = @"确认密码";
    self.tfConfirmPwd.secureTextEntry = YES;
    [self.tfConfirmPwd setFont:FONT_15];
    self.tfConfirmPwd.returnKeyType = UIReturnKeyDone;
    self.tfConfirmPwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.baseView addSubview:self.tfConfirmPwd];
    [self.tfConfirmPwd makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineConfirmPwd.bottom).offset(18);
        make.left.equalTo(self.tfPhone);
        make.right.equalTo(self.tfPhone);
        make.height.equalTo(self.tfPhone);
    }];
    
    self.lineSecondPwd = [[UIView alloc] init];
    [self.lineSecondPwd setBackgroundColor:COLOR_LINE];
    [self.baseView addSubview:self.lineSecondPwd];
    [self.lineSecondPwd makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tfConfirmPwd.bottom).offset(18);
        make.left.equalTo(self.linePhone);
        make.right.equalTo(self.linePhone);
        make.height.equalTo(LINE_HEIGTH);
    }];
    
    
    self.btnResign = [[UIButton alloc] init];
    [self.btnResign setBackgroundColor:COLOR_FONT_GRAY];
    [self.btnResign setTitleColor:COLOR_MY_WHITE forState:UIControlStateNormal];
    [self.btnResign addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    [self.btnResign setTitle:@"确定" forState:UIControlStateNormal];
    [self.baseView addSubview:self.btnResign];
    [self.btnResign makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineSecondPwd).offset(25);
        make.centerX.equalTo(self.baseView);
        make.height.equalTo(BNT_HEIGHT);
        make.width.equalTo(self.tfPhone);
    }];
    
}

- (void)backAction:(id)sender
{
    [self.navigationController.navigationBar setHidden:YES];
    //    [super backAction:sender];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)randCodeAction:(JKCountDownButton *)sender{
    
    sender.enabled = NO;
    sender.backgroundColor = COLOR_FONT_GRAY;
    [sender startWithSecond:60];
    
    [sender didChange:^NSString *(JKCountDownButton *countDownButton,int second) {
        NSString *title = [NSString stringWithFormat:@"%d秒后失效",second];
        return title;
    }];
    [sender didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
        countDownButton.enabled = YES;
        countDownButton.backgroundColor = COLOR_THEME;
        return @"点击重新获取";
        
    }];
    
    AbstractItems *item = [[AbstractItems alloc] init];
    item.n1 = self.tfPhone.text;
    item.n3 = @"190919";
    NSString *str = [NSString stringWithFormat:@"%@%@%@%@%@",item.n0,item.n1,item.n3,item.n59,MainKey];
    item.n64 = [[str md5HexDigest] uppercaseString];
    [[NetAPIManger sharedManger] request_MessageWithParams:[item keyValues] andBlock:^(id data, NSError *error) {
        
        AbstractItems *item = (AbstractItems *)data;
        
        if (!error && [item.n39 isEqualToString:@"00"]) {
            [[NSUserDefaults standardUserDefaults] setObject:item.n1 forKey:Account];
            [self.randCode becomeFirstResponder];
        }else{
            if ([[ResponseDictionaryTool responseDic] objectForKey:item.n39]) {
                NSString *error = [[ResponseDictionaryTool responseDic] objectForKey:item.n39];
                NSLog(@"error:%@",error);
                [MBProgressHUD showSuccess:error toView:self.view];
            }else {
//                [MBProgressHUD showSuccess:@"未知错误" toView:self.view];
            }
        }
    }];
}

- (void)registerAction
{
    AbstractItems *userItems = [[AbstractItems alloc] init];
    userItems.n3 = @"190930";
    userItems.n1 = self.tfPhone.text;
    userItems.n9 = [[self.tfNewPwd.text md5HexDigest] uppercaseString];
    userItems.n52 = self.randCode.text;
    NSString *macStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",userItems.n0,userItems.n1,userItems.n3,userItems.n9,userItems.n52,userItems.n59, MainKey];
    NSLog(@"macStr:%@",macStr);
    userItems.n64 = [[macStr md5HexDigest] uppercaseString];
    
    [[NetAPIManger sharedManger] request_ReplacePwdWithParams:[userItems keyValues] andBlock:^(id data, NSError *error) {
        
        AbstractItems *item = (AbstractItems *)data;
        if (!error && [item.n39 isEqualToString:@"00"]) {
//            LoginViewController *loginVc = [[LoginViewController alloc] init];
//            [MBProgressHUD showSuccess:@"恭喜您成功找回密码" toView:loginVc.view];
//            [self.navigationController pushViewController:loginVc animated:YES];
            [MBProgressHUD showSuccess:@"恭喜您成功找回密码" toView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        }else{
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
    if ([self.tfPhone isFirstResponder]) {
        offsetY = CGRectGetMaxY(self.linePhone.frame) + self.keyboardFrame.size.height + NAVIGATIONBAT_HEIGTH - SCREEN_HEIGHT;
        offsetY = offsetY >= 0? offsetY : 0;
        
        [UIView animateWithDuration:self.animationTime delay:0 options:self.animationCurve animations:^{
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            self.baseView.contentOffset = CGPointMake(0, offsetY);
        } completion:^(BOOL finished) {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }];
    }else if([self.randCode isFirstResponder]) {
        offsetY = CGRectGetMaxY(self.lineNewPwd.frame) + self.keyboardFrame.size.height + NAVIGATIONBAT_HEIGTH - SCREEN_HEIGHT;
        offsetY = offsetY >= 0? offsetY : 0;
        
        [UIView animateWithDuration:self.animationTime delay:0 options:self.animationCurve animations:^{
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            self.baseView.contentOffset = CGPointMake(0, offsetY);
        } completion:^(BOOL finished) {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }];
    }else if([self.tfNewPwd isFirstResponder]) {
        offsetY = CGRectGetMaxY(self.lineConfirmPwd.frame) + self.keyboardFrame.size.height + NAVIGATIONBAT_HEIGTH - SCREEN_HEIGHT;
        offsetY = offsetY >= 0? offsetY : 0;
        
        [UIView animateWithDuration:self.animationTime delay:0 options:self.animationCurve animations:^{
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            self.baseView.contentOffset = CGPointMake(0, offsetY);
        } completion:^(BOOL finished) {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }];
    }else if([self.tfConfirmPwd isFirstResponder]) {
        offsetY = CGRectGetMaxY(self.lineSecondPwd.frame) + self.keyboardFrame.size.height + NAVIGATIONBAT_HEIGTH - SCREEN_HEIGHT;
        offsetY = offsetY >= 0? offsetY : 0;
        
        [UIView animateWithDuration:self.animationTime delay:0 options:self.animationCurve animations:^{
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            self.baseView.contentOffset = CGPointMake(0, offsetY);
        } completion:^(BOOL finished) {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }];
    }
}

- (void)textFieldTextDidChange:(NSNotification *)notification
{
    UITextField *tf = [notification object];
    NSString *newText = tf.text;
    if (tf == self.tfPhone) {
        
        if (newText.length == 11 && [[newText substringToIndex:1] isEqualToString:@"1"]) {
            self.numButton.enabled = YES;
            self.numButton.backgroundColor = COLOR_THEME;
            
        }else {
            self.numButton.enabled = NO;
            self.numButton.backgroundColor = COLOR_FONT_GRAY;
        }
        
        if ([self.tfNewPwd.text length] > 5 &&
            [self.tfNewPwd.text length] < 15 &&
            [self.tfConfirmPwd.text length] > 5 &&
            [self.tfConfirmPwd.text length] < 15 &&
            [newText length] == 11 && self.randCode.text.length == 6 && [self.tfNewPwd.text isEqualToString:self.tfConfirmPwd.text]) {
            
            [self.btnResign setBackgroundColor:COLOR_THEME];
            [self.btnResign setEnabled:YES];
        }else{
            [self.btnResign setBackgroundColor:COLOR_FONT_GRAY];
            [self.btnResign setEnabled:NO];
        }
    }else if (tf == self.tfNewPwd) {
        if ([newText length] > 5 &&
            [newText length] < 15 &&
            [self.tfConfirmPwd.text length] > 5 &&
            [self.tfConfirmPwd.text length] < 15 &&
            [self.tfPhone.text length] == 11 && self.randCode.text.length == 6 && [self.tfNewPwd.text isEqualToString:self.tfConfirmPwd.text]) {
            
            [self.btnResign setBackgroundColor:COLOR_THEME];
            [self.btnResign setEnabled:YES];
        }else{
            [self.btnResign setBackgroundColor:COLOR_FONT_GRAY];
            [self.btnResign setEnabled:NO];
        }
    }else if (tf == self.tfConfirmPwd) {
        if ([newText length] > 5 &&
            [newText length] < 15 &&
            [self.tfNewPwd.text length] > 5 &&
            [self.tfNewPwd.text length] < 15 &&
            [self.tfPhone.text length] == 11 && self.randCode.text.length == 6 && [self.tfNewPwd.text isEqualToString:self.tfConfirmPwd.text]) {
            
            [self.btnResign setBackgroundColor:COLOR_THEME];
            [self.btnResign setEnabled:YES];
        }else{
            [self.btnResign setBackgroundColor:COLOR_FONT_GRAY];
            [self.btnResign setEnabled:NO];
        }
    }
    
    if (![self.tfNewPwd.text isEqualToString:self.tfConfirmPwd.text]) {
        [self.btnResign setBackgroundColor:COLOR_FONT_GRAY];
        [self.btnResign setEnabled:NO];
    }
    
    if ([self.tfPhone.text length] == 11 && [self.tfNewPwd.text length] > 5 && [self.tfConfirmPwd.text length] > 5 && self.randCode.text.length == 6 && [self.tfNewPwd.text isEqualToString:self.tfConfirmPwd.text]) {
        [self.btnResign setBackgroundColor:COLOR_THEME];
        self.btnResign.enabled = YES;
    }else{
        [self.btnResign setBackgroundColor:COLOR_FONT_GRAY];
        self.btnResign.enabled = NO;
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


#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        if (textField == self.tfPhone) {
            [self.tfNewPwd becomeFirstResponder];
        }else if (textField == self.tfNewPwd){
            [self.tfConfirmPwd becomeFirstResponder];
        }else if(textField == self.tfConfirmPwd){
            [self hideKeyBoard];
        }
        [self keyboardShowAnimate];
        return YES;
    }
    
    if (textField == self.tfPhone) {
        if (textField.text.length > 10 && string.length != 0) {
            return NO;
        }
    }else if(textField == self.tfNewPwd) {
        if (textField.text.length > 13 && string.length != 0) {
            return NO;
        }
    }else {
        if (textField.text.length > 13 && string.length != 0) {
            return NO;
        }
    }
    return YES;
}

- (void)hideKeyBoard
{
    [self.tfPhone resignFirstResponder];
    [self.randCode resignFirstResponder];
    [self.tfNewPwd resignFirstResponder];
    [self.tfConfirmPwd resignFirstResponder];
}


@end
