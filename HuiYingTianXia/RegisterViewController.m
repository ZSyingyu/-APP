//
//  RegisterViewController.m
//  HuiYingTianXia
//
//  Created by tsmc on 15-3-18.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import "RegisterViewController.h"
#import "TTTAttributedLabel.h"
#import "AbstractItems.h"
#import "Encode_3DES.h"
#import "NSString+MD5HexDigest.h"
#import "MJExtension.h"
#import "HomePageViewController.h"
#import "LoginViewController.h"
#import "MBProgressHUD+Add.h"
#import "ResponseDictionaryTool.h"

@interface RegisterViewController ()<UITextFieldDelegate,TTTAttributedLabelDelegate,UIAlertViewDelegate>
@property(nonatomic, strong)UIScrollView *baseView;
@property(nonatomic, strong)UITextField *tfPhone;//手机号
@property(nonatomic, strong)UIView *linePhone;
@property(nonatomic, strong)UITextField *tfNewPwd;
@property(nonatomic, strong)UIView *lineNewPwd;
@property(nonatomic, strong)UITextField *tfConfirmPwd;
@property(nonatomic, strong)UIView *lineConfirmPwd;
@property(strong,nonatomic)UITextField *randCode;//验证码
@property(strong,nonatomic)UIView *lineSecondPwd;

@property(nonatomic, strong)UIButton *btnResign;

@property(nonatomic, assign)CGFloat animationTime;
@property(nonatomic, assign)UIViewAnimationOptions animationCurve;
@property(nonatomic, assign)CGRect keyboardFrame;

@property(strong,nonatomic)UIButton *numButton;//验证码按钮

@end

@implementation RegisterViewController

- (void)dealloc
{
    [self removeKeyboardNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    //去除到登录页面时导航栏的背景色
    [self.navigationController.view setBackgroundColor:COLOR_MY_WHITE];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldTextDidChange:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputKeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [self addKeyboardNotification];
    
    [self setNavTitle:@"注册"];
    [self setBackBarButtonItemWithTitle:@"返回"];
    
    self.baseView = [[UIScrollView alloc] init];
    [self.baseView setBackgroundColor:[UIColor clearColor]];
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
    
    self.tfPhone = [[UITextField alloc] init];
    self.tfPhone.delegate = self;
    self.tfPhone.placeholder = @"注册手机号";
    [self.tfPhone setFont:FONT_15];
    self.tfPhone.returnKeyType = UIReturnKeyNext;
    self.tfPhone.keyboardType = UIKeyboardTypeNumberPad;
    self.tfPhone.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.baseView addSubview:self.tfPhone];
    [self.tfPhone makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView).offset(16);
        make.left.equalTo(self.baseView).offset(HFixWidthBaseOn320(10));
        make.right.equalTo(self.baseView).offset(HFixWidthBaseOn320(-10));
        make.height.equalTo(self.tfPhone.font.lineHeight);
        make.width.equalTo(SCREEN_WIDTH - 2 * HFixWidthBaseOn320(10));
    }];
    
    self.linePhone = [[UIView alloc] init];
    [self.linePhone setBackgroundColor:COLOR_LINE];
    [self.baseView addSubview:self.linePhone];
    [self.linePhone makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tfPhone.bottom).offset(18);
        make.left.equalTo(self.tfPhone);
        make.right.equalTo(self.tfPhone);
        make.height.equalTo(LINE_HEIGTH);
    }];
    
    self.randCode = [[UITextField alloc] init];
    self.randCode.delegate = self;
    self.randCode.placeholder = @"输入验证码";
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
    [self.numButton setBackgroundColor:COLOR_THEME];
    [self.numButton setTitleColor:COLOR_MY_WHITE forState:UIControlStateNormal];
    [self.numButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.numButton addTarget:self action:@selector(randCodeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseView addSubview:self.numButton];
    [self.numButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.linePhone.bottom).offset(10);
        make.right.equalTo(self.tfPhone).offset(-10);
        make.height.equalTo(35);
        make.left.equalTo(self.tfPhone).offset(120);
    }];
    
    
    
    self.lineNewPwd = [[UIView alloc] init];
    [self.lineNewPwd setBackgroundColor:COLOR_LINE];
    [self.baseView addSubview:self.lineNewPwd];
    [self.lineNewPwd makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.randCode.bottom).offset(18);
        make.left.equalTo(self.tfPhone);
        make.right.equalTo(self.tfPhone);
        make.height.equalTo(LINE_HEIGTH);
    }];

    self.tfNewPwd = [[UITextField alloc] init];
    self.tfNewPwd.delegate = self;
    self.tfNewPwd.placeholder = @"请输入密码";
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
        make.left.equalTo(self.tfPhone);
        make.right.equalTo(self.tfPhone);
        make.height.equalTo(LINE_HEIGTH);
    }];
    
    self.tfConfirmPwd = [[UITextField alloc]init];
    self.tfConfirmPwd.delegate = self;
    self.tfConfirmPwd.placeholder = @"请再次输入";
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
        make.left.equalTo(self.tfPhone);
        make.right.equalTo(self.tfPhone);
        make.height.equalTo(LINE_HEIGTH);
    }];
    
    
    self.btnResign = [[UIButton alloc] init];
    [self.btnResign setBackgroundColor:COLOR_THEME];
    [self.btnResign setTitleColor:COLOR_MY_WHITE forState:UIControlStateNormal];
    [self.btnResign addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    [self.btnResign setTitle:@"立即注册" forState:UIControlStateNormal];
    [self.baseView addSubview:self.btnResign];
    [self.btnResign makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineSecondPwd).offset(40);
        make.left.equalTo(self.tfPhone);
        make.right.equalTo(self.tfPhone);
        make.height.equalTo(BNT_HEIGHT);
        make.width.equalTo(self.tfPhone);
    }];
    
    NSString *content = @"";
    NSRange range = [content rangeOfString:@""];
    TTTAttributedLabel *labAgree = [[TTTAttributedLabel alloc] init];
    labAgree.font = FONT_12;
    labAgree.numberOfLines = 0;
    [labAgree setLineSpacing:5];
    labAgree.text = content;
    [labAgree setTextAlignment:NSTextAlignmentCenter];
    labAgree.delegate = self;
    NSMutableDictionary *linkAttributes = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                           COLOR_FONT_BLUE ,(NSString *)kCTForegroundColorAttributeName,
                                           nil];
    NSMutableDictionary *actLinkAttributes = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                              [UIColor blackColor] ,(NSString *)kCTForegroundColorAttributeName,nil];
    labAgree.linkAttributes = linkAttributes;
    labAgree.activeLinkAttributes = actLinkAttributes;
    [labAgree addLinkToURL:[NSURL URLWithString:@"link"] withRange:range];
    
    [self.baseView addSubview:labAgree];
    [labAgree makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.baseView);
        make.right.equalTo(self.baseView);
        make.bottom.equalTo(self.view).offset(-41);
        make.height.equalTo(labAgree.font.lineHeight * 3);
    }];
    
    self.numButton.enabled = NO;
    self.numButton.backgroundColor = COLOR_FONT_GRAY;
    
    self.btnResign.enabled = NO;
    self.btnResign.backgroundColor = COLOR_FONT_GRAY;
    
}

-(void)randCodeAction:(JKCountDownButton *)sender{
    
    sender.enabled = NO;
    sender.backgroundColor = COLOR_FONT_GRAY;
    [sender startWithSecond:60];
    
    [sender didChange:^NSString *(JKCountDownButton *countDownButton,int second) {
        NSString *title = [NSString stringWithFormat:@"%d秒后重新获取",second];
        return title;
    }];
    [sender didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
        countDownButton.enabled = YES;
        countDownButton.backgroundColor = COLOR_THEME;
        return @"点击重新获取";
        
    }];
    
    if (self.tfPhone.text.length == 11 && [[self.tfPhone.text substringToIndex:1] isEqualToString:@"1"]) {
        self.numButton.enabled = YES;
        self.numButton.backgroundColor = COLOR_THEME;
        
        AbstractItems *item = [[AbstractItems alloc] init];
        item.n1 = self.tfPhone.text;
        item.n3 = @"190919";
        NSString *str = [NSString stringWithFormat:@"%@%@%@%@%@",item.n0,item.n1,item.n3,item.n59,MainKey];
        item.n64 = [[str md5HexDigest] uppercaseString];
        [[NetAPIManger sharedManger] request_MessageWithParams:[item keyValues] andBlock:^(id data, NSError *error) {
            
            AbstractItems *item = (AbstractItems *)data;
            
            if (!error && [item.n39 isEqualToString:@"00"]) {
                [[NSUserDefaults standardUserDefaults] setObject:item.n1 forKey:Account];
                [MBProgressHUD showSuccess:@"验证码已发送，30分钟内有效，请注意查收" toView:self.view];
                
                self.numButton.enabled = NO;
                self.numButton.backgroundColor = COLOR_FONT_GRAY;
                
                [self.randCode becomeFirstResponder];
                
            }else{
                NSString *error = [[ResponseDictionaryTool responseDic] objectForKey:item.n39];
                //NSLog(@"error:%@",error);
                [MBProgressHUD showSuccess:error toView:self.view];
            }
        }];
        
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"验证码已发送，30分钟内有效，请注意查收" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [alertView show];
    }else {
        [MBProgressHUD showSuccess:@"请输入正确手机号" toView:self.view];
    }
    
    
}

- (void)backAction:(id)sender
{
    [self.navigationController.navigationBar setHidden:YES];
//    [super backAction:sender];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)registerAction
{
    if (![self.tfNewPwd.text isEqualToString:self.tfConfirmPwd.text]) {
        NSError *error = [[NSError alloc] initWithDomain:@"密码输入不一致" code:0 userInfo:@{@"NSLocalizedDescription":@"密码输入不一致"}];
        [self showStatusBarError:error];
        return;
    }
    
    AbstractItems *userItems = [[AbstractItems alloc] init];
    userItems.n3 = @"190918";
    userItems.n1 = self.tfPhone.text;
    userItems.n8 = [[self.tfNewPwd.text md5HexDigest] uppercaseString];
//    userItems.n44 = @"2800004";
    
//    userItems.n44 = @"100602183";//测试
    
    userItems.n44 = @"2800001";//小飞测试
    
    //TODO...
    userItems.n52 = self.randCode.text;
    NSString *macStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",userItems.n0,userItems.n1,userItems.n3,userItems.n8,userItems.n44,userItems.n52,userItems.n59, MainKey];
    NSLog(@"macStr:%@",macStr);
    userItems.n64 = [[macStr md5HexDigest] uppercaseString];
    
    [[NetAPIManger sharedManger] request_RegisterWithParams:[userItems keyValues] andBlock:^(id data, NSError *error) {
        if (!error && [[(AbstractItems *)data n39] isEqualToString:@"00"]) {
            AbstractItems *items = [[AbstractItems alloc] init];
            items.n3 = @"190928";
            items.n1 = userItems.n1;
            items.n8 = userItems.n8;
            
            NSString *macStr = [NSString stringWithFormat:@"%@%@%@%@%@%@",items.n0,items.n1,items.n3,items.n8,items.n59,MainKey];
            items.n64 = [[macStr md5HexDigest] uppercaseString];
            [[NetAPIManger sharedManger] request_LoginWithParams:[items keyValues] andBlock:^(id data, NSError *error) {
                if (!error && [[(AbstractItems *)data n39] isEqualToString:@"00"]) {
                    self.btnResign.backgroundColor = COLOR_FONT_GRAY;
                    self.btnResign.enabled = NO;
                    //存储
                    [[NSUserDefaults standardUserDefaults] setObject:items.n1 forKey:Account];
                    [[NSUserDefaults standardUserDefaults] setObject:items.n8 forKey:Password];
                    [[NSUserDefaults standardUserDefaults] setObject:items.n57 forKey:TranceInfo];
                    if ([items.n42 length] > 0) {
                        NSString *n42 = items.n42;
                        NSData *data = [n42 dataUsingEncoding:NSUTF8StringEncoding];
                        NSArray *infoArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                        NSDictionary *dict = infoArray.firstObject;
                        //            NSLog(@"dict:%@",dict);
                        
                        [[NSUserDefaults standardUserDefaults] setObject:dict[@"merchantNo"] forKey:MerchantNo];

                    }
//                    LoginViewController *loginVc = [[LoginViewController alloc]init];
//                    [MBProgressHUD showSuccess:@"即尚支付,欢迎您" toView:loginVc.view];
////                    [self.navigationController.navigationBar setHidden:YES];
////                    [self.navigationController pushViewController:loginVc animated:YES];
//                    [self.navigationController popViewControllerAnimated:YES];
                    [MBProgressHUD showSuccess:@"来买单,欢迎您" toView:self.view];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
                        [self dismissViewControllerAnimated:YES completion:nil];
                    });
                    
                    
                }

            }];
            
        }else {
            
            if ([[(AbstractItems *)data n39] isEqualToString:@"ZD"]) {
                NSString *error = [[ResponseDictionaryTool responseDic] objectForKey:[(AbstractItems *)data n39]];
//                [MBProgressHUD showSuccess:error toView:self.view];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:error delegate:self cancelButtonTitle:nil  otherButtonTitles:@"确定", nil];
                [alertView show];
            }
            
            if ([[(AbstractItems *)data n39] isEqualToString:@"ZC"]) {
                NSString *error = [[ResponseDictionaryTool responseDic] objectForKey:[(AbstractItems *)data n39]];
                [MBProgressHUD showSuccess:error toView:self.view];
                
            }
            
            
            NSError *error = [[NSError alloc] initWithDomain:@"注册失败" code:0 userInfo:@{@"NSLocalizedDescription":@"注册失败"}];
            [self showStatusBarError:error];
        }
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

        [self.navigationController popViewControllerAnimated:YES];
    
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
    }else if([self.tfNewPwd isFirstResponder]) {
        offsetY = CGRectGetMaxY(self.lineNewPwd.frame) + self.keyboardFrame.size.height + NAVIGATIONBAT_HEIGTH - SCREEN_HEIGHT;
        offsetY = offsetY >= 0? offsetY : 0;
        
        [UIView animateWithDuration:self.animationTime delay:0 options:self.animationCurve animations:^{
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            self.baseView.contentOffset = CGPointMake(0, offsetY);
        } completion:^(BOOL finished) {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }];
    }else if([self.tfConfirmPwd isFirstResponder]) {
        offsetY = CGRectGetMaxY(self.lineConfirmPwd.frame) + self.keyboardFrame.size.height + NAVIGATIONBAT_HEIGTH - SCREEN_HEIGHT;
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

- (void)textFieldTextDidChange:(NSNotification *)notification
{
    UITextField *tf = [notification object];
    NSString *newText = tf.text;
    if (tf == self.tfPhone) {
        
        if (newText.length == 11 && [[newText substringToIndex:1] isEqualToString:@"1"]) {
            self.numButton.enabled = YES;
            self.numButton.backgroundColor = COLOR_THEME;
            
        }
        
        if ([self.tfNewPwd.text length] > 5 &&
            [self.tfNewPwd.text length] < 15 &&
            [self.tfConfirmPwd.text length] > 5 &&
            [self.tfConfirmPwd.text length] < 15 &&
            [newText length] == 11 && self.randCode.text.length == 6) {
            
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
            [self.tfPhone.text length] == 11 && self.randCode.text.length == 6) {
            
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
            [self.tfPhone.text length] == 11 && self.randCode.text.length == 6) {
            
            [self.btnResign setBackgroundColor:COLOR_THEME];
            [self.btnResign setEnabled:YES];
        }else{
            [self.btnResign setBackgroundColor:COLOR_FONT_GRAY];
            [self.btnResign setEnabled:NO];
        }
    }

    
    if ([self.tfPhone.text length] == 11 && [self.tfNewPwd.text length] > 5 && [self.tfConfirmPwd.text length] > 5 && self.randCode.text.length == 6) {
        [self.btnResign setBackgroundColor:COLOR_THEME];
        self.btnResign.enabled = YES;
    }else{
        [self.btnResign setBackgroundColor:COLOR_FONT_GRAY];
        self.btnResign.enabled = NO;
    }
    
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


#pragma mark TTTAttributedLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{

}

@end
