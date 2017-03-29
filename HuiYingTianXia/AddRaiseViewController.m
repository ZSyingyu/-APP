//
//  AddRaiseViewController.m
//  HuiYingTianXia
//
//  Created by 朱颖宇 on 15/11/3.
//  Copyright © 2015年 tsmc. All rights reserved.
//

#import "AddRaiseViewController.h"
#import "UIView+Extension.h"
#import "AbstractItems.h"
#import "NSString+MD5HexDigest.h"
#import "MJExtension.h"
#import "BankViewController.h"
#import "ResponseDictionaryTool.h"
#import "MBProgressHUD+Add.h"
#import "HomePageViewController.h"
#import "MJRefreshGifHeader.h"
#import "MBProgressHUD.h"
#import "PohtoDetailViewController.h"

@interface AddRaiseViewController ()<UIScrollViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UITextFieldDelegate>
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
@property(strong,nonatomic)UIButton *detailBtn;//详情按钮
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

//图片2进制路径
@property(strong,nonatomic)NSString *filePath;
@property(strong,nonatomic)AbstractItems *item;
@property(nonatomic, assign)CGRect keyboardFrame;

@property(strong,nonatomic)MBProgressHUD *hud;//加载框

@property(nonatomic, assign)BOOL meansOk;//资料上传是否成功

@property(nonatomic, assign)BOOL photoOk;//照片上传是否成功

@property(strong,nonatomic)NSMutableArray *imageArray;//图片数组
@end

static NSInteger flag;
static NSString *name;
static NSString *cardId;
static NSString *bankname;
static NSString *bankcard;
static NSString *phoneNum;

@implementation AddRaiseViewController

- (AbstractItems *)item
{
    if (!_item) {
        _item = [[AbstractItems alloc] init];
    }
    return _item;
}

- (NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [[NSMutableArray alloc] init];
    }
    return _imageArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"提交信息"];
    //    [self setBackBarButtonItemWithTitle:@"返回"];
    self.meansOk = NO;
    
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:HandUpload];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:CardFrontUpload];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:CardBackUpload];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:BankFrontUpload];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:BankBackUpload];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn setTitleColor:COLOR_MY_WHITE forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"NavBackSorrow"] forState:UIControlStateNormal];
    [btn setContentMode:UIViewContentModeScaleAspectFill];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -7, 0, 50)];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 10)];
    [btn addTarget:self action:@selector(quotaBackAction) forControlEvents:UIControlEventTouchUpInside];
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
        self.baseView.contentSize = CGSizeMake(0, SCREEN_HEIGHT * 1.7);
    }else if (IPHONE5__5S) {
        self.baseView.contentSize = CGSizeMake(0, SCREEN_HEIGHT * 1.4);
    }else if (IPHONE6) {
        self.baseView.contentSize = CGSizeMake(0, SCREEN_HEIGHT * 1.5);
    }else {
        self.baseView.contentSize = CGSizeMake(0, SCREEN_HEIGHT * 1.5);
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"银行卡认证说明" message:@"1》持卡人进行卡认证后,认证卡每日刷卡次数增加,单笔额度提高,可以做实时到账.2》身份证、银行卡正反面照片,银行卡背面签名与身份证上的名字一致,卡主手持身份证银行卡正面照片(详情见操作说明)." delegate:self cancelButtonTitle:nil otherButtonTitles:@"暂不申请",@"申请认证", nil];
    alertView.tag = 1;
    [alertView show];
    
    self.image1 = [UIImage imageNamed:@"添加照片"];
    self.image2 = [UIImage imageNamed:@"添加照片"];
    self.image3 = [UIImage imageNamed:@"添加照片"];
    self.image4 = [UIImage imageNamed:@"添加照片"];
    self.image5 = [UIImage imageNamed:@"添加照片"];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 115, 50)];
    self.nameLabel.text = @"姓           名";
    self.nameLabel.font = [UIFont systemFontOfSize:18];
    self.nameLabel.textColor = [UIColor blackColor];
    [self.baseView addSubview:self.nameLabel];
    
    self.nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nameLabel.frame), self.nameLabel.origin.y, SCREEN_WIDTH - CGRectGetMaxX(self.nameLabel.frame) - 10, 50)];
    //    self.nameTextField.backgroundColor = [UIColor redColor];
    //    self.item.n5 = [[NSUserDefaults standardUserDefaults] objectForKey:RaiseCardName];
    self.nameTextField.text = self.item.n5?self.item.n5:@"";
    //        self.nameTextField.text = name?name:@"";
    self.nameTextField.tag = 100;
    self.nameTextField.delegate = self;
    self.nameTextField.keyboardType = UIKeyboardTypeNamePhonePad;
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
    //    self.nameTextField.backgroundColor = [UIColor redColor];
    //    self.item.n6 = [[NSUserDefaults standardUserDefaults] objectForKey:RaiseCardID];
    self.cardIDTextField.text = self.item.n6?self.item.n6:@"";
    //    self.cardIDTextField.text = cardId?cardId:@"";
    self.cardIDTextField.tag = 200;
    self.cardIDTextField.delegate = self;
    //    self.cardIDTextField.keyboardType = UIKeyboardTypeDefault;
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
    //    self.nameTextField.backgroundColor = [UIColor redColor];
    if (_bankName.length == 0) {
        //        _bankName = [[NSUserDefaults standardUserDefaults] objectForKey:RaiseBankName];
    }
    self.banknameTextField.text = _bankName?_bankName:@"";
    //    self.banknameTextField.text = bankname?bankname:@"";
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
    //    self.nameTextField.backgroundColor = [UIColor redColor];
    //    self.item.n7 = [[NSUserDefaults standardUserDefaults] objectForKey:RaiseCardNumber];
    self.bankNumTextField.text = self.item.n7?self.item.n7:@"";
    //    self.bankNumTextField.text = bankcard?bankcard:@"";
    self.bankNumTextField.tag = 400;
    self.bankNumTextField.delegate = self;
    self.bankNumTextField.keyboardType = UIKeyboardTypeNumberPad;
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
    //    self.nameTextField.backgroundColor = [UIColor redColor];
    //    self.item.n7 = [[NSUserDefaults standardUserDefaults] objectForKey:RaiseCardNumber];
    self.phoneNumTextField.text = self.item.n7?self.item.n7:@"";
    //    self.bankNumTextField.text = bankcard?bankcard:@"";
    self.phoneNumTextField.tag = 500;
    self.phoneNumTextField.delegate = self;
    self.phoneNumTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.baseView addSubview:self.phoneNumTextField];
    
    self.phoneNumLine = [[UIView alloc] initWithFrame:CGRectMake(self.bankNumLabel.origin.x, CGRectGetMaxY(self.phoneNumTextField.frame), SCREEN_WIDTH - 20, 1)];
    self.phoneNumLine.backgroundColor = COLOR_LINE;
    [self.baseView addSubview:self.phoneNumLine];
    
    self.meansBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.meansBtn.frame = CGRectMake(10, CGRectGetMaxY(self.phoneNumLine.frame) + 40, SCREEN_WIDTH - 20, 40);
    [self.meansBtn setTitle:@"确认提交" forState:UIControlStateNormal];
    [self.meansBtn setTintColor:[UIColor whiteColor]];
    [self.meansBtn setBackgroundColor:COLOR_THEME];
    [self.meansBtn addTarget:self action:@selector(meansAction) forControlEvents:UIControlEventTouchUpInside];
    //    [self.meansBtn setHidden:YES];
    [self.baseView addSubview:self.meansBtn];
    
    // 设置姓名输入必须是汉字的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.nameTextField];
}

-(void)textFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > 8) {
                textField.text = [toBeString substringToIndex:8];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > 8) {
            textField.text = [toBeString substringToIndex:8];
        }
    }
}

- (void)quotaBackAction {
    NSLog(@"返回按钮");
    if (self.meansOk == NO) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if (self.meansOk == YES) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确认取消银行卡认证" delegate:self cancelButtonTitle:@"删除信息" otherButtonTitles:@"继续申请", nil];
        alertView.tag = 3;
        [alertView show];
    }
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1) {
        if (buttonIndex == 0) {
            NSLog(@"暂不申请");
            [self.navigationController popViewControllerAnimated:YES];
        }else if (buttonIndex == 1) {
            NSLog(@"申请提额");
            [alertView setHidden:YES];
        }
    }else if (alertView.tag == 2) {
        AbstractItems *item = [[AbstractItems alloc] init];
        item.n0 = @"0700";
        item.n3 = @"190949";
        item.n42 = [[NSUserDefaults standardUserDefaults] objectForKey:MerchantNo];
        item.n7 = self.bankNumTextField.text;
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
            //            if (self.meansOk == YES && self.photoOk != YES) {
            AbstractItems *item = [[AbstractItems alloc] init];
            item.n0 = @"0700";
            item.n3 = @"190943";
            item.n7 = self.bankNumTextField.text;
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
            //            }
            
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
                NSString *string = [textField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                self.item.n43 = string;
                //                self.item.n5 = textField.text;
                name = textField.text;
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
        self.item.n41 = self.bankNumTextField.text;
        self.item.n42 = self.cardIDTextField.text;
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
    
    if (self.nameTextField.text) {
        for (int i = 0; i < self.nameTextField.text.length; i++) {
            NSRange range=NSMakeRange(i,1);
            NSString *subString=[self.nameTextField.text substringWithRange:range];
            const char *cString=[subString UTF8String];
            if (strlen(cString)==3){
                NSLog(@"昵称是汉字");
                
            }else{
                NSLog(@"昵称是不是汉字");
                //                self.meansBtn.enabled = NO;
                [MBProgressHUD showError:@"请输入中文姓名" toView:self.view];
            }
        }
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

#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.nameTextField) {
        
        for (int i = 0; i < self.nameTextField.text.length; i++) {
            NSRange range=NSMakeRange(i,1);
            NSString *subString=[self.nameTextField.text substringWithRange:range];
            const char *cString=[subString UTF8String];
            if (strlen(cString)==3){
                NSLog(@"昵称是汉字");
                
            }else{
                NSLog(@"昵称是不是汉字");
                //                self.meansBtn.enabled = NO;
                [MBProgressHUD showError:@"请输入中文姓名" toView:self.view];
            }
        }
        
    }else if (textField == self.bankNumTextField) {
        if (textField.text.length > 19 && string.length != 0 ) {
            return NO;
        }
    }else if (textField == self.cardIDTextField) {
        if (textField.text.length > 17 && string.length != 0) {
            return NO;
        }
    }else if (textField == self.phoneNumTextField) {
        if (textField.text.length > 10 && string.length != 0) {
            return NO;
        }
    }
    return YES;
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
            self.item.n45 = code;
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
        _bankArray = @[@{@"北京银行":@"313003"},@{@"光大银行":@"303"},@{@"广发银行":@"306"},@{@"建设银行":@"105"},@{@"交通银行":@"301"},@{@"民生银行":@"305"},@{@"农业银行":@"103"},@{@"平安银行":@"307"},@{@"浦发银行":@"310"},@{@"邮政储蓄银行":@"403"},@{@"招商银行":@"308"},@{@"中国工商银行":@"102"},@{@"中国银行":@"104"},@{@"中信银行":@"302"},@{@"上海银行":@"313062"},@{@"杭州银行":@"313027"},@{@"北京农商银行":@"402002"},@{@"华夏银行":@"304"},@{@"兴业银行":@"309"}];
    }
    return _bankArray;
}

@end



