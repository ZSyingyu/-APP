//
//  RaiseQuotaViewController.m
//  HuiYingTianXia
//
//  Created by 朱颖宇 on 15/10/21.
//  Copyright © 2015年 tsmc. All rights reserved.
//

#import "RaiseQuotaViewController.h"
#import "UIView+Extension.h"
#import "AbstractItems.h"
#import "NSString+MD5HexDigest.h"
#import "MJExtension.h"
#import "BankViewController.h"
#import "ResponseDictionaryTool.h"
#import "MBProgressHUD+Add.h"
#import "HomePageViewController.h"
#import "UIImageView+WebCache.h"

@interface RaiseQuotaViewController ()<UIScrollViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UITextFieldDelegate>

@property(nonatomic, strong)UIScrollView *baseView;//底层scrollview

@property(strong,nonatomic) NSArray *bankArray;
@property(strong,nonatomic)NSString *bankName;

@property(strong,nonatomic)UILabel *nameLabel;//姓名label
@property(strong,nonatomic)UITextField *nameTextField;//姓名textField
@property(strong,nonatomic)UIView *nameLine;//姓名分割线
@property(strong,nonatomic)UILabel *cardIDLabel;//身份证label
@property(strong,nonatomic)UITextField *cardIDTextField;//身份证textField
@property(strong,nonatomic)UIView *cardIDLine;//身份证分割线
@property(strong,nonatomic)UILabel *banknameLabel;//银行名称label
@property(strong,nonatomic)UITextField *banknameTextField;//银行名称textField
@property(strong,nonatomic)UIView *banknameLine;//银行名称分割线
@property(strong,nonatomic)UILabel *bankNumLabel;//银行卡号label
@property(strong,nonatomic)UITextField *bankNumTextField;//银行卡号textField
@property(strong,nonatomic)UIView *bankNumLine;//银行账号分割线
@property(strong,nonatomic)UILabel *statusLabel;//审核状态label
@property(strong,nonatomic)UILabel *checkStatus;//审核状态
@property(strong,nonatomic)UIView *statusLine;//审核状态分割线
@property(strong,nonatomic)UILabel *cashQuotaLabel;//提现额度label
@property(strong,nonatomic)UILabel *cashQuota;//提现额度
@property(strong,nonatomic)UIView *quotaLine;//提现额度分割线
@property(strong,nonatomic)UILabel *checkIdeaLabel;//提现额度label
@property(strong,nonatomic)UILabel *checkIdea;//提现额度
@property(strong,nonatomic)UIView *ideaLine;//提现额度分割线
@property(strong,nonatomic)UIButton *meansBtn;//资料上传button
@property(strong,nonatomic)UILabel *cardFrontLabel;//身份证正面label
@property(strong,nonatomic)UIImageView *cardFrontImageView;//身份证正面照
@property(strong,nonatomic)UIButton *cardFrontBtn;//点击上传button
@property(strong,nonatomic)UILabel *cardBackLabel;//身份证背面label
@property(strong,nonatomic)UIImageView *cardBackImageView;//身份证反面照
@property(strong,nonatomic)UIButton *cardBackBtn;//点击上传button
@property(strong,nonatomic)UILabel *bankFrontLabel;//银行卡正面label
@property(strong,nonatomic)UIImageView *bankFrontImageView;//银行卡正面照
@property(strong,nonatomic)UIButton *bankFrontBtn;//点击上传button
@property(strong,nonatomic)UILabel *bankBackLabel;//银行卡背面label
@property(strong,nonatomic)UIImageView *bankBackImageView;//银行卡背面照
@property(strong,nonatomic)UIButton *bankBackBtn;//点击上传button
@property(strong,nonatomic)UILabel *handcardlabel;//手持照label
@property(strong,nonatomic)UIImageView *handcardImageView;//手持照
@property(strong,nonatomic)UIButton *handcardBtn;//点击上传button
@property(strong,nonatomic)UIButton *confirmBtn;//确认按钮

@property(strong,nonatomic)UILabel *phoneNumLabel;//联系电话label
@property(strong,nonatomic)UITextField *phoneNumTextField;//联系电话textField
@property(strong,nonatomic)UIView *phoneNumLine;//联系电话分割线

@property(strong,nonatomic)UIImage *image1;
@property(strong,nonatomic)UIImage *image2;
@property(strong,nonatomic)UIImage *image3;
@property(strong,nonatomic)UIImage *image4;
@property(strong,nonatomic)UIImage *image5;
@property(strong,nonatomic)UIImage *image;
@property(strong,nonatomic)NSString *imageName;
@property(nonatomic, assign)BOOL photoOk;//照片上传是否成功

//图片2进制路径
@property(strong,nonatomic)NSString *filePath;
@property(strong,nonatomic)AbstractItems *item;
@property(nonatomic, assign)CGRect keyboardFrame;

@property(strong,nonatomic)MBProgressHUD *hud;//加载框

@end

static NSInteger flag;
static NSString *cardname;
static NSString *cardId;
static NSString *bankname;
static NSString *bankcard;
static NSString *phoneNum;

@implementation RaiseQuotaViewController

- (AbstractItems *)item
{
    if (!_item) {
        _item = [[AbstractItems alloc] init];
    }
    return _item;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"审核结果"];
    //    [self setBackBarButtonItemWithTitle:@"返回"];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn setTitleColor:COLOR_MY_WHITE forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"NavBackSorrow"] forState:UIControlStateNormal];
    [btn setContentMode:UIViewContentModeScaleAspectFill];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -7, 0, 50)];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 10)];
    [btn addTarget:self action:@selector(RaiseBackAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldTextDidChange:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputKeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [self addKeyboardNotification];
    
    self.baseView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.baseView.backgroundColor = [UIColor clearColor];
    self.baseView.delegate = self;
    [self.view addSubview:self.baseView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideBoard)];
    [tap setNumberOfTapsRequired:1];
    [tap setNumberOfTouchesRequired:1];
    [self.baseView addGestureRecognizer:tap];
    
    if (IPHONE4__4S) {
        self.baseView.contentSize = CGSizeMake(0, SCREEN_HEIGHT * 1.5);
    }else if (IPHONE5__5S) {
        self.baseView.contentSize = CGSizeMake(0, SCREEN_HEIGHT * 1.3);
    }else if (IPHONE6) {
        self.baseView.contentSize = CGSizeMake(0, SCREEN_HEIGHT * 1.5);
    }else {
        self.baseView.contentSize = CGSizeMake(0, SCREEN_HEIGHT * 1.5);
    }
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 115, 50)];
    self.nameLabel.text = @"姓           名";
    self.nameLabel.font = [UIFont systemFontOfSize:18];
    self.nameLabel.textColor = [UIColor blackColor];
    [self.baseView addSubview:self.nameLabel];
    
    self.nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nameLabel.frame), self.nameLabel.origin.y, SCREEN_WIDTH - CGRectGetMaxX(self.nameLabel.frame) - 10, 50)];
    self.nameTextField.text = [self.name stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.nameTextField.tag = 100;
    self.nameTextField.delegate = self;
    [self.baseView addSubview:self.nameTextField];
    
    self.nameLine = [[UIView alloc] initWithFrame:CGRectMake(self.nameLabel.origin.x, CGRectGetMaxY(self.nameTextField.frame), SCREEN_WIDTH - 20, 1)];
    self.nameLine.backgroundColor = COLOR_LINE;
    [self.baseView addSubview:self.nameLine];
    
    self.cardIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.nameLabel.origin.x, CGRectGetMaxY(self.nameLine.frame) + 3, self.nameLabel.size.width, self.nameLabel.size.height)];
    self.cardIDLabel.text = @"身 份 证 号";
    self.cardIDLabel.font = [UIFont systemFontOfSize:18];
    self.cardIDLabel.textColor = [UIColor blackColor];
    [self.baseView addSubview:self.cardIDLabel];
    
    self.cardIDTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.cardIDLabel.frame), self.cardIDLabel.origin.y, SCREEN_WIDTH - CGRectGetMaxX(self.cardIDLabel.frame) - 10, 50)];
    self.cardIDTextField.text = [NSString stringWithFormat:@"%@********%@",[self.cardid substringToIndex:6],[self.cardid substringFromIndex:self.cardid.length - 4]];
    self.cardIDTextField.tag = 200;
    self.cardIDTextField.delegate = self;
    [self.baseView addSubview:self.cardIDTextField];
    
    self.cardIDLine = [[UIView alloc] initWithFrame:CGRectMake(self.cardIDLabel.origin.x, CGRectGetMaxY(self.cardIDTextField.frame), SCREEN_WIDTH - 20, 1)];
    self.cardIDLine.backgroundColor = COLOR_LINE;
    [self.baseView addSubview:self.cardIDLine];
    
    self.banknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.nameLabel.origin.x, CGRectGetMaxY(self.cardIDLine.frame) + 3, self.nameLabel.size.width, self.nameLabel.size.height)];
    self.banknameLabel.text = @"银 行 名 称";
    self.banknameLabel.font = [UIFont systemFontOfSize:18];
    self.banknameLabel.textColor = [UIColor blackColor];
    [self.baseView addSubview:self.banknameLabel];
    
    self.banknameTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.banknameLabel.frame), self.banknameLabel.origin.y, SCREEN_WIDTH - CGRectGetMaxX(self.banknameLabel.frame) - 10, 50)];
    self.banknameTextField.text = self.bankname;
    self.banknameTextField.tag = 300;
    self.banknameTextField.delegate = self;
    [self.baseView addSubview:self.banknameTextField];
    
    self.banknameLine = [[UIView alloc] initWithFrame:CGRectMake(self.banknameLabel.origin.x, CGRectGetMaxY(self.banknameTextField.frame), SCREEN_WIDTH - 20, 1)];
    self.banknameLine.backgroundColor = COLOR_LINE;
    [self.baseView addSubview:self.banknameLine];
    
    self.bankNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.nameLabel.origin.x, CGRectGetMaxY(self.banknameLine.frame) + 3, self.nameLabel.size.width, self.nameLabel.size.height)];
    self.bankNumLabel.text = @"银 行 卡 号";
    self.bankNumLabel.font = [UIFont systemFontOfSize:18];
    self.bankNumLabel.textColor = [UIColor blackColor];
    [self.baseView addSubview:self.bankNumLabel];
    
    self.bankNumTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.bankNumLabel.frame), self.bankNumLabel.origin.y, SCREEN_WIDTH - CGRectGetMaxX(self.bankNumLabel.frame) - 10, 50)];
    if (self.banknumber.length > 10) {
        self.bankNumTextField.text = [NSString stringWithFormat:@"%@********%@",[self.banknumber substringToIndex:6],[self.banknumber substringFromIndex:self.banknumber.length - 4]];
    }else {
        self.bankNumTextField.text = self.banknumber;
    }
    self.bankNumTextField.tag = 400;
    self.bankNumTextField.delegate = self;
    [self.baseView addSubview:self.bankNumTextField];
    
    self.bankNumLine = [[UIView alloc] initWithFrame:CGRectMake(self.bankNumLabel.origin.x, CGRectGetMaxY(self.bankNumTextField.frame), SCREEN_WIDTH - 20, 1)];
    self.bankNumLine.backgroundColor = COLOR_LINE;
    [self.baseView addSubview:self.bankNumLine];
    
    self.phoneNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.nameLabel.origin.x, CGRectGetMaxY(self.bankNumLine.frame) + 3, self.nameLabel.size.width, self.nameLabel.size.height)];
    self.phoneNumLabel.text = @"持卡人手机号";
    self.phoneNumLabel.font = [UIFont systemFontOfSize:18];
    self.phoneNumLabel.textColor = [UIColor blackColor];
    [self.baseView addSubview:self.phoneNumLabel];
    
    self.phoneNumTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.phoneNumLabel.frame), self.phoneNumLabel.origin.y, SCREEN_WIDTH - CGRectGetMaxX(self.phoneNumLabel.frame) - 10, 50)];
    self.phoneNumTextField.text = self.phoneNo;
    self.phoneNumTextField.tag = 500;
    self.phoneNumTextField.delegate = self;
    self.phoneNumTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.baseView addSubview:self.phoneNumTextField];
    
    self.phoneNumLine = [[UIView alloc] initWithFrame:CGRectMake(self.bankNumLabel.origin.x, CGRectGetMaxY(self.phoneNumTextField.frame), SCREEN_WIDTH - 20, 1)];
    self.phoneNumLine.backgroundColor = COLOR_LINE;
    [self.baseView addSubview:self.phoneNumLine];
    
    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.nameLabel.origin.x, CGRectGetMaxY(self.phoneNumLine.frame) + 3, self.nameLabel.size.width, self.nameLabel.size.height)];
    self.statusLabel.text = @"审 核 状 态";
    self.statusLabel.font = [UIFont systemFontOfSize:18];
    self.statusLabel.textColor = [UIColor blackColor];
    [self.baseView addSubview:self.statusLabel];
    
    self.checkStatus = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.statusLabel.frame), self.statusLabel.origin.y, SCREEN_WIDTH - CGRectGetMaxX(self.statusLabel.frame) - 10, 50)];
    self.checkStatus.text = self.status;
    [self.baseView addSubview:self.checkStatus];
    
    self.statusLine = [[UIView alloc] initWithFrame:CGRectMake(self.statusLabel.origin.x, CGRectGetMaxY(self.checkStatus.frame), SCREEN_WIDTH - 20, 1)];
    self.statusLine.backgroundColor = COLOR_LINE;
    [self.baseView addSubview:self.statusLine];
    
    if ([self.status isEqualToString:@"审核通过"]) {
        self.cashQuotaLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.nameLabel.origin.x, CGRectGetMaxY(self.statusLine.frame) + 3, self.nameLabel.size.width, self.nameLabel.size.height)];
        self.cashQuotaLabel.text = @"提 现 额 度";
        self.cashQuotaLabel.font = [UIFont systemFontOfSize:18];
        self.cashQuotaLabel.textColor = [UIColor blackColor];
        [self.baseView addSubview:self.cashQuotaLabel];
        
        self.cashQuota = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.cashQuotaLabel.frame), self.cashQuotaLabel.origin.y, SCREEN_WIDTH - CGRectGetMaxX(self.cashQuotaLabel.frame) - 10, 50)];
        self.cashQuota.text = self.quota;
        [self.baseView addSubview:self.cashQuota];
        
        self.quotaLine = [[UIView alloc] initWithFrame:CGRectMake(self.cashQuotaLabel.origin.x, CGRectGetMaxY(self.cashQuota.frame), SCREEN_WIDTH - 20, 1)];
        self.quotaLine.backgroundColor = COLOR_LINE;
        [self.baseView addSubview:self.quotaLine];
        
        self.meansBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        self.meansBtn.frame = CGRectMake(30, CGRectGetMaxY(self.bankNumLine.frame) + 40, SCREEN_WIDTH - 60, 40);
        [self.meansBtn setTitle:@"确认提交" forState:UIControlStateNormal];
        [self.meansBtn setTintColor:[UIColor whiteColor]];
        [self.meansBtn setBackgroundColor:COLOR_THEME];
        [self.meansBtn addTarget:self action:@selector(meansAction) forControlEvents:UIControlEventTouchUpInside];
        //    [self.meansBtn setHidden:YES];
        [self.baseView addSubview:self.meansBtn];
        
        
        
        [self.meansBtn setHidden:YES];
        
        self.nameTextField.enabled = NO;
        self.cardIDTextField.enabled = NO;
        self.banknameTextField.enabled = NO;
        self.bankNumTextField.enabled = NO;
        self.phoneNumTextField.enabled = NO;
        
    }else if ([self.status isEqualToString:@"审核拒绝"]) {
        
        self.checkIdeaLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.nameLabel.origin.x, CGRectGetMaxY(self.statusLine.frame) + 3, self.nameLabel.size.width, self.nameLabel.size.height)];
        self.checkIdeaLabel.text = @"审 核 意 见";
        self.checkIdeaLabel.font = [UIFont systemFontOfSize:18];
        self.checkIdeaLabel.textColor = [UIColor blackColor];
        [self.baseView addSubview:self.checkIdeaLabel];
        
        self.checkIdea = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.checkIdeaLabel.frame), self.checkIdeaLabel.origin.y, SCREEN_WIDTH - CGRectGetMaxX(self.checkIdeaLabel.frame) - 10, 50)];
        self.checkIdea.text = self.checkview;
        [self.baseView addSubview:self.checkIdea];
        
        self.ideaLine = [[UIView alloc] initWithFrame:CGRectMake(self.checkIdeaLabel.origin.x, CGRectGetMaxY(self.checkIdea.frame), SCREEN_WIDTH - 20, 1)];
        self.ideaLine.backgroundColor = COLOR_LINE;
        [self.baseView addSubview:self.ideaLine];
        
        self.meansBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        self.meansBtn.frame = CGRectMake(30, CGRectGetMaxY(self.ideaLine.frame) + 40, SCREEN_WIDTH - 60, 40);
        [self.meansBtn setTitle:@"确认提交" forState:UIControlStateNormal];
        [self.meansBtn setTintColor:[UIColor whiteColor]];
        [self.meansBtn setBackgroundColor:COLOR_THEME];
        [self.meansBtn addTarget:self action:@selector(meansAction) forControlEvents:UIControlEventTouchUpInside];
        //    [self.meansBtn setHidden:YES];
        [self.baseView addSubview:self.meansBtn];
        
        [self.meansBtn setHidden:NO];
        
        //        self.nameTextField.enabled = NO;
        //        self.cardIDTextField.enabled = NO;
        //        self.banknameTextField.enabled = NO;
        //        self.bankNumTextField.enabled = NO;
        
        
    }else if ([self.status isEqualToString:@"创建"]) {
        
        self.meansBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        self.meansBtn.frame = CGRectMake(30, CGRectGetMaxY(self.statusLine.frame) + 40, SCREEN_WIDTH - 60, 40);
        [self.meansBtn setTitle:@"确认提交" forState:UIControlStateNormal];
        [self.meansBtn setTintColor:[UIColor whiteColor]];
        [self.meansBtn setBackgroundColor:COLOR_THEME];
        [self.meansBtn addTarget:self action:@selector(meansAction) forControlEvents:UIControlEventTouchUpInside];
        //    [self.meansBtn setHidden:YES];
        [self.baseView addSubview:self.meansBtn];
        
        
        
        [self.meansBtn setHidden:NO];
        
        //        self.nameTextField.enabled = NO;
        //        self.cardIDTextField.enabled = NO;
        //        self.banknameTextField.enabled = NO;
        //        self.bankNumTextField.enabled = NO;
        
        
    }else {
        
        self.meansBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        self.meansBtn.frame = CGRectMake(30, CGRectGetMaxY(self.bankNumLine.frame) + 40, SCREEN_WIDTH - 60, 40);
        [self.meansBtn setTitle:@"确认提交" forState:UIControlStateNormal];
        [self.meansBtn setTintColor:[UIColor whiteColor]];
        [self.meansBtn setBackgroundColor:COLOR_THEME];
        [self.meansBtn addTarget:self action:@selector(meansAction) forControlEvents:UIControlEventTouchUpInside];
        //    [self.meansBtn setHidden:YES];
        [self.baseView addSubview:self.meansBtn];
        
        [self.meansBtn setHidden:YES];
        
        self.nameTextField.enabled = NO;
        self.cardIDTextField.enabled = NO;
        self.banknameTextField.enabled = NO;
        self.bankNumTextField.enabled = NO;
    }
    
}

-(void)RaiseBackAction {
    
    if ([self.status isEqualToString:@"审核拒绝"] ) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确认取消银行卡认证" delegate:self cancelButtonTitle:@"删除信息" otherButtonTitles:@"继续申请", nil];
        alertView.tag = 3;
        [alertView show];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1) {
        if (buttonIndex == 0) {
            NSLog(@"暂不申请");
            [self.navigationController popViewControllerAnimated:YES];
        }else if (buttonIndex == 1) {
            NSLog(@"申请认证");
            [alertView setHidden:YES];
        }
    }else if (alertView.tag == 2) {
        AbstractItems *item = [[AbstractItems alloc] init];
        item.n0 = @"0700";
        item.n3 = @"190949";
        item.n42 = [[NSUserDefaults standardUserDefaults] objectForKey:MerchantNo];
        item.n7 = self.banknumber;
        NSString *macStr = [NSString stringWithFormat:@"%@%@%@%@%@%@",item.n0,item.n3,item.n7,item.n42,item.n59,MainKey];
        NSLog(@"macStr:%@",macStr);
        item.n64 = [[macStr md5HexDigest] uppercaseString];
        [[NetAPIManger sharedManger] request_CheckQuotaWithParams:[item keyValues] andBlock:^(id data, NSError *error) {
            AbstractItems *item = (AbstractItems *)data;
            if ([item.n39 isEqualToString:@"00"]) {
                [self.navigationController popViewControllerAnimated:YES];
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
    }else if (alertView.tag == 3) {
        if (buttonIndex == 0) {
            NSLog(@"确认取消");
            AbstractItems *item = [[AbstractItems alloc] init];
            item.n0 = @"0700";
            item.n3 = @"190943";
            item.n7 = self.banknumber;
            item.n42 = [[NSUserDefaults standardUserDefaults] objectForKey:MerchantNo];
            NSString *macStr = [NSString stringWithFormat:@"%@%@%@%@%@%@",item.n0,item.n3,item.n7,item.n42,item.n59,MainKey];
            NSLog(@"macStr:%@",macStr);
            item.n64 = [[macStr md5HexDigest] uppercaseString];
            
            [[NetAPIManger sharedManger] request_QuotaBackWithParams:[item keyValues] andBlock:^(id data, NSError *error) {
                
                AbstractItems *item = (AbstractItems *)data;
                if ([item.n39 isEqualToString:@"00"]) {
                    NSLog(@"成功");
                    [self.navigationController popViewControllerAnimated:YES];
                    self.nameTextField.text = @"";
                    self.cardIDTextField.text = @"";
                    self.banknameTextField.text = @"";
                    self.bankNumTextField.text = @"";
                    self.item.n5 = @"";
                    self.item.n6 = @"";
                    self.item.n7 = @"";
                    _bankName = @"";
                    
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
            
        }else if (buttonIndex == 1) {
            NSLog(@"继续申请");
            [alertView setHidden:YES];
        }
    }
    
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //    self.nameTextField.returnKeyType = UIReturnKeyDone;
    
    if ([self.nameTextField endEditing:YES]) {
        [self.nameTextField resignFirstResponder];
    }else if ([self.cardIDTextField endEditing:YES]){
        [self.cardIDTextField resignFirstResponder];
    }else if ([self.banknameTextField endEditing:YES]){
        [self.banknameTextField resignFirstResponder];
    }else if ([self.bankNumTextField endEditing:YES]){
        [self.bankNumTextField resignFirstResponder];
    }else if ([self.phoneNumTextField endEditing:YES]){
        [self.phoneNumTextField resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    switch (textField.tag) {
        case 100:
        {
            if (textField.text.length > 0) {
                self.item.n43 = textField.text;
                cardname = textField.text;
            }
        }
            break;
        case 200:
        {
            if (textField.text.length > 0) {
                self.item.n42 = textField.text;
                cardId = textField.text;
            }
        }
            break;
        case 300:
        {
            if (textField.text.length > 0) {
                self.item.n45 = textField.text;
                bankname = textField.text;
            }
        }
            break;
        case 400:
        {
            if (textField.text.length > 0) {
                self.item.n41 = textField.text;
                bankcard = textField.text;
            }
        }
            break;
        case 500:
        {
            if (textField.text.length > 0) {
                self.item.n44 = textField.text;
                phoneNum = textField.text;
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)meansAction {
    NSLog(@"上传资料");
    NSLog(@"bankcard:%@",self.bankNumTextField.text);
    NSLog(@"bankname:%@",self.banknameTextField.text);
    
    if ((self.nameTextField.text.length > 1 && self.nameTextField.text.length < 9) && (self.cardIDTextField.text.length == 15 || self.cardIDTextField.text.length == 18) && self.banknameTextField.text.length > 0 && (self.bankNumTextField.text.length > 10 && self.bankNumTextField.text.length < 21) && (self.phoneNumTextField.text.length != 0)) {
        self.item.n0 = @"0700";
        self.item.n3 = @"190105";
        self.item.n1 = [[NSUserDefaults standardUserDefaults] objectForKey:Account];
        //判断银行卡号和身份证号中是否含有*号
        if ([self.bankNumTextField.text rangeOfString:@"*"].location != NSNotFound) {
            self.item.n41 = self.banknumber;
        }else {
            self.item.n41 = self.bankNumTextField.text;
        }
        if ([self.cardIDTextField.text rangeOfString:@"*"].location != NSNotFound) {
            self.item.n42 = self.cardid;
        }else {
            self.item.n42 = self.cardIDTextField.text;
        }
        self.item.n43 = [self.nameTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.item.n44 = self.phoneNumTextField.text;
        self.item.n45 = [[NSUserDefaults standardUserDefaults] objectForKey:BankCode];
        NSLog(@"n7:%@",self.item.n7);
        NSString *macStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@",self.item.n0,self.item.n1,self.item.n3,self.item.n41,self.item.n42,self.item.n43,self.item.n44,self.item.n45,self.item.n59, MainKey];
        NSLog(@"macStr:%@",macStr);
        self.item.n64 = [[macStr md5HexDigest] uppercaseString];
        [[NetAPIManger sharedManger] request_RaiseQuotaWithParams:[self.item keyValues] andBlock:^(id data, NSError *error) {
            
            AbstractItems *item = (AbstractItems *)data;
            if ([item.n39 isEqualToString:@"00"]) {
                NSLog(@"上传成功");
                [MBProgressHUD showSuccess:@"认证成功" toView:self.view];
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [NSThread sleepForTimeInterval:1];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                });
            }else {
                NSLog(@"失败");
                if ([[ResponseDictionaryTool responseDic] objectForKey:item.n39]) {
                    NSString *error = [[ResponseDictionaryTool responseDic] objectForKey:item.n39];
                    NSLog(@"error:%@",error);
                    [MBProgressHUD showSuccess:error toView:self.view];
                }else {
                    [MBProgressHUD showSuccess:@"未知错误" toView:self.view];
                }
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [NSThread sleepForTimeInterval:1];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                });
            }
            
        }];
    }
    
    if (self.nameTextField.text.length == 1) {
        [MBProgressHUD showError:@"请输入正确的姓名" toView:self.view];
    }
    if (self.cardIDTextField.text.length != 15 && self.cardIDTextField.text.length != 18) {
        //        self.meansBtn.enabled = NO;
        [MBProgressHUD showError:@"请输入正确的身份证号" toView:self.view];
    }
    if (self.bankNumTextField.text.length < 15 || self.bankNumTextField.text.length > 20) {
        //        self.meansBtn.enabled = NO;
        [MBProgressHUD showError:@"请输入正确的银行卡号" toView:self.view];
    }
    
    
}

- (void)textFieldTextDidChange:(NSNotification *)notification
{
    UITextField *tf = [notification object];
    NSString *newText = tf.text;
    
    
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

- (void)hideBoard
{
    [self.nameTextField resignFirstResponder];
    [self.cardIDTextField resignFirstResponder];
    [self.banknameTextField resignFirstResponder];
    [self.bankNumTextField resignFirstResponder];
    [self.phoneNumTextField resignFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 300) {
        BankViewController *bankVC = [[BankViewController alloc] initWithSelectedBankBlock:^(NSString *code, NSString *name) {
            NSLog(@"%@",code);
            _bankName = name;
            self.item.n43 = code;
            [[NSUserDefaults standardUserDefaults] setObject:code forKey:BankCode];
            self.banknameTextField.text = _bankName;
            //            [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }];
        bankVC.dataArray = self.bankArray;
        [self.navigationController pushViewController:bankVC animated:YES];
        return NO;
    }
    
    return YES;
}

- (NSArray *)bankArray
{
    if (!_bankArray) {
        _bankArray = @[@{@"北京银行":@"313003"},@{@"光大银行":@"303"},@{@"广发银行":@"306"},@{@"建设银行":@"105"},@{@"交通银行":@"301"},@{@"民生银行":@"305"},@{@"农业银行":@"103"},@{@"平安银行":@"307"},@{@"浦发银行":@"310"},@{@"邮政储蓄银行":@"403"},@{@"招商银行":@"308"},@{@"中国工商银行":@"102"},@{@"中国银行":@"104"},@{@"中信银行":@"302"},@{@"上海银行":@"313062"},@{@"杭州银行":@"313027"}];
    }
    return _bankArray;
}

@end
