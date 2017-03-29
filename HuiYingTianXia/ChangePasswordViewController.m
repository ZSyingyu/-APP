//
//  ChangePasswordViewController.m
//  HuiYingTianXia
//
//  Created by 朱颖宇 on 15/6/16.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "BaseViewController.h"
#import "SettingViewController.h"
#import "NetAPIManger.h"
#import "AbstractItems.h"
#import "NSString+MD5HexDigest.h"
#import "MJExtension.h"
#import "ResponseDictionaryTool.h"
#import "MBProgressHUD+Add.h"


@interface ChangePasswordViewController ()<UIActionSheetDelegate>
- (IBAction)backSetting:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *originalPassword;

@property (weak, nonatomic) IBOutlet UITextField *alterPassword;
@property (weak, nonatomic) IBOutlet UITextField *checkAlterPassword;
//@property(copy,nonatomic)NSDictionary *dic;
@property (weak, nonatomic) IBOutlet UIButton *changeButton;
- (IBAction)confirm:(UIButton *)sender;


@end

@implementation ChangePasswordViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self.originalPassword setSecureTextEntry:YES];
    [self.alterPassword setSecureTextEntry:YES];
    [self.checkAlterPassword setSecureTextEntry:YES];
    
    self.originalPassword.delegate = self;
    self.alterPassword.delegate = self;
    self.checkAlterPassword.delegate = self;
    
    //[self setBackBarButtonItemWithTitle:@"返回"];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    self.originalPassword.returnKeyType = UIReturnKeyNext;
    if ([self.originalPassword endEditing:YES]) {
        [self.originalPassword resignFirstResponder];
    }else if ([self.alterPassword endEditing:YES]) {
        [self.alterPassword resignFirstResponder];
    }else if ([self.checkAlterPassword endEditing:YES]) {
        [self.checkAlterPassword resignFirstResponder];
    }
    return YES;
}



- (IBAction)backSetting:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)confirm:(UIButton *)sender {
    
    
    if ([self.originalPassword.text length] > 5 && [self.alterPassword.text length] > 5 && [self.alterPassword.text isEqualToString:self.checkAlterPassword.text ]) {
        
        AbstractItems *item = [[AbstractItems alloc] init];
        item.n1 = [[NSUserDefaults standardUserDefaults] objectForKey:Account];
        item.n3 = @"190929";
        item.n8 = [self.originalPassword.text md5HexDigest];
        item.n9 = [self.alterPassword.text md5HexDigest];
        item.n42 = [[NSUserDefaults standardUserDefaults] objectForKey:MerchantNo];
        
//        NSString *n42 = item.n42;
//        NSData *data = [n42 dataUsingEncoding:NSUTF8StringEncoding];
//        NSArray *infoArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//        NSDictionary *dict = infoArray.firstObject;

        
//        item.n59 = @"CHDS-1.0.0";
        NSString *macStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",item.n0,item.n1,item.n3,item.n8,item.n9,item.n42,item.n59, MainKey];
        item.n64 = [[macStr md5HexDigest] uppercaseString];
        
        [[NetAPIManger sharedManger] request_changePwdWithParams:[item keyValues] andBlock:^(id data, NSError *error) {
            AbstractItems *item = (AbstractItems *)data;
            if (!error && [[item n39] isEqualToString:@"00"]) {
                [[NSUserDefaults standardUserDefaults] setObject:self.alterPassword.text forKey:Password];
                [self showStatusBarSuccessStr:@"修改密码成功"];
                
                [self dismissViewControllerAnimated:YES completion:nil];
                
            }else {
                NSError *error = [[NSError alloc] initWithDomain:@"修改密码失败" code:0 userInfo:@{@"NSLocalizedDescription":@"修改密码失败"}];
                [self showStatusBarError:error];
            }
        }];
        
        
    }else{
        NSError *error = [[NSError alloc] initWithDomain:@"密码输入有误" code:0 userInfo:@{@"NSLocalizedDescription":@"密码输入有误"}];
        [self showStatusBarError:error];
        
    }
    
}
@end
