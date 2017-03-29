//
//  NewBusinessDetailViewController.m
//  HuiYingTianXia
//
//  Created by liguo.chen on 16/12/30.
//  Copyright © 2016年 tsmc. All rights reserved.
//

#import "NewBusinessDetailViewController.h"
#import "BankViewController.h"
#import "OrderItem.h"
#import "AbstractItems.h"
#import "MJExtension.h"
#import "NSString+MD5HexDigest.h"
#import "NetAPIManger.h"
#import "MBProgressHUD+Add.h"
#import "ResponseDictionaryTool.h"
#import "MBProgressHUD+Add.h"
#import "HomePageViewController.h"
#import "PhotoViewController.h"
#import "ZJUsefulPickerView.h"
#import "ManageTypeDictionary.h"

static NSString *temporaryCardId;
static NSString *temporaryBankname;
static NSString *temporaryCardname;
static NSString *temporaryCardnumber;

@interface NewBusinessDetailViewController ()<UIScrollViewDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)UIScrollView *baseView;//底层scrollview

@property(strong,nonatomic) NSArray *bankArray;

@property(strong,nonatomic)AbstractItems *item;

@property(strong,nonatomic)NSString *bankName;

@property(strong,nonatomic) UIButton *confirmBtn;

@property(strong,nonatomic)UITextField *tfPhoneNumber;//手机号码文本框
@property(strong,nonatomic)UITextField *tfCardID;//身份证号文本框
@property(strong,nonatomic)UITextField *tfBankName;//银行名称文本框
@property(strong,nonatomic)UITextField *tfCardName;//开户姓名文本框
@property(strong,nonatomic)UITextField *tfCardNumber;//银行卡号文本框

@property(strong,nonatomic) UITextField *merchantName;//商户名称
@property(strong,nonatomic) UITextField *merchantShortName;//商户简称
@property(strong,nonatomic) UITextField *serviceTel;//客服电话
@property(strong,nonatomic) ZJSelectedTextField *manageType;//经营类目
@property(strong,nonatomic) UITextField *shopAddress;//店铺地址

@property(nonatomic, assign) CGFloat viewFrameY;//背景View的y值


@end

@implementation NewBusinessDetailViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.barTintColor = COLOR_THEME;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"WeChatOrder"];

}

- (AbstractItems *)item
{
    if (!_item) {
        _item = [[AbstractItems alloc] init];
    }
    return _item;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"商户详情"];
    [self setBackBarButtonItemWithTitle:@"返回"];
    self.baseView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.baseView.backgroundColor = [UIColor clearColor];
    self.baseView.delegate = self;
    [self.view addSubview:self.baseView];
    
    if (IPHONE4__4S) {
        self.baseView.contentSize = CGSizeMake(0, SCREEN_HEIGHT * 2.0);
    }else if (IPHONE5__5S) {
        self.baseView.contentSize = CGSizeMake(0, SCREEN_HEIGHT * 1.9);
    }else if (IPHONE6) {
        self.baseView.contentSize = CGSizeMake(0, SCREEN_HEIGHT * 1.4);
    }else {
        self.baseView.contentSize = CGSizeMake(0, SCREEN_HEIGHT * 1.4);
    }
    
    NSArray *labelArr = @[@"手机号码",@"身份证号",@"银行名称",@"储蓄卡号",@"开户姓名",@"商户名称",@"商户简称",@"客服电话",@"经营类目",@"店铺地址",@"商户状态",@"状态描述"];
    
    for (int i = 0; i < labelArr.count; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10 + 50 * i, 110, 30)];
        label.text = [labelArr objectAtIndex:i];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:15];
        label.backgroundColor = [UIColor whiteColor];
        [self.baseView addSubview:label];
        
        UITextField *textfield;
        ZJSelectedTextField *tf;
        if (i == 8) {
            tf = [[ZJSelectedTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame) + 10, label.frame.origin.y, SCREEN_WIDTH - CGRectGetMaxX(label.frame) - 20, label.frame.size.height)];
            tf.delegate = self;
            tf.tag = 1001 + i;
            tf.font = FONT_15;
            [self.baseView addSubview:tf];
        }else {
            textfield = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame) + 10, label.frame.origin.y, SCREEN_WIDTH - CGRectGetMaxX(label.frame) - 20, label.frame.size.height)];
            textfield.delegate = self;
            textfield.font = FONT_15;
            textfield.tag = 1001 + i;
            [textfield addTarget:self action:@selector(textFieldTargetTag:) forControlEvents:UIControlEventEditingChanged];
            [self.baseView addSubview:textfield];
        }
        
        if (textfield.tag == 1001) {//手机号码
            textfield.text = [[NSUserDefaults standardUserDefaults] objectForKey:Account];
            textfield.enabled = NO;
            textfield.textColor = COLOR_FONT_GRAY;
        }else if (textfield.tag == 1002) {//身份证号
            self.tfCardID = textfield;
            textfield.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            textfield.textColor = [UIColor blackColor];
            if (![[[NSUserDefaults standardUserDefaults] objectForKey:CardID] isEqualToString:@""]) {
                textfield.enabled = NO;
                self.item.n6 = [[NSUserDefaults standardUserDefaults] objectForKey:CardID];
                textfield.text = self.item.n6?self.item.n6:@"";
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10A"]) {
                    textfield.enabled = YES;
                    textfield.text = self.item.n6;
                }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10C"]) {
                    textfield.enabled = YES;
                    textfield.text = self.item.n6;
                }else {
                    textfield.enabled = NO;
                    textfield.text = [NSString stringWithFormat:@"%@******%@",[textfield.text substringToIndex:6],[textfield.text substringFromIndex:textfield.text.length - 4]];
                }
            }else {
                textfield.enabled = YES;
            }
        }else if (textfield.tag == 1003) {//银行名称
            self.tfBankName = textfield;
            textfield.textColor = [UIColor blackColor];
            if (![[[NSUserDefaults standardUserDefaults] objectForKey:BankName] isEqualToString:@""]) {
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10A"]) {
                    textfield.enabled = YES;
                    _bankName = [[NSUserDefaults standardUserDefaults] objectForKey:BankName];
                }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10C"]) {
                    textfield.enabled = YES;
                    _bankName = [[NSUserDefaults standardUserDefaults] objectForKey:BankName];
                }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10B"]) {
                    textfield.enabled = NO;
                    _bankName = [[NSUserDefaults standardUserDefaults] objectForKey:BankName];
                }else {
                    textfield.enabled = NO;
                    _bankName = [[NSUserDefaults standardUserDefaults] objectForKey:BankName];
                }
            }else {
                textfield.enabled = YES;
            }
            textfield.text = _bankName?_bankName:@"";
        }else if (textfield.tag == 1004) {//储蓄卡号
            self.tfCardNumber = textfield;
            textfield.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            textfield.textColor = [UIColor blackColor];
            if (![[[NSUserDefaults standardUserDefaults] objectForKey:CardNumber] isEqualToString:@""]) {
                self.item.n7 = [[NSUserDefaults standardUserDefaults] objectForKey:CardNumber];
                textfield.text = self.item.n7?self.item.n7:@"";
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10A"]) {
                    textfield.enabled = YES;
                    textfield.text = self.item.n7;
                }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10C"]) {
                    textfield.enabled = YES;
                    textfield.text = self.item.n7;
                }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10B"]) {
                    textfield.enabled = NO;
                    textfield.text = [NSString stringWithFormat:@"%@******%@",[textfield.text substringToIndex:6],[textfield.text substringFromIndex:textfield.text.length - 4]];
                }else {
                    textfield.enabled = NO;
                    textfield.text = [NSString stringWithFormat:@"%@******%@",[textfield.text substringToIndex:6],[textfield.text substringFromIndex:textfield.text.length - 4]];
                }
                
            }else {
                textfield.enabled = YES;
            }
            
        }else if (textfield.tag == 1005) {//开户姓名
            self.tfCardName = textfield;
            self.item.n5 = [[NSUserDefaults standardUserDefaults] objectForKey:CardName];
            textfield.text = self.item.n5?self.item.n5:@"";
            if (![[[NSUserDefaults standardUserDefaults] objectForKey:CardName] isEqualToString:@""]) {
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:CardName] length] == 2) {
                    if ([[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10A"]) {
                        textfield.enabled = YES;
                        textfield.text = self.item.n5;
                    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10C"]) {
                        textfield.enabled = YES;
                        textfield.text = self.item.n5;
                    }else {
                        textfield.enabled = NO;
                        textfield.text = [NSString stringWithFormat:@"*%@",[textfield.text substringFromIndex:1]];
                    }
                }
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:CardName] length] > 2) {
                    if ([[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10A"]) {
                        textfield.enabled = YES;
                        textfield.text = self.item.n5;
                    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10C"]) {
                        textfield.enabled = YES;
                        textfield.text = self.item.n5;
                    }else {
                        textfield.enabled = NO;
                        textfield.text = [NSString stringWithFormat:@"*%@",[textfield.text substringFromIndex:textfield.text.length - 2]];
                    }
                }
                
            }else {
                textfield.enabled = YES;
            }

            
        }else if (textfield.tag == 1006) {//商户名称
            
            self.merchantName = textfield;
            self.item.n49 = [[NSUserDefaults standardUserDefaults] objectForKey:@"merchantName"];
            textfield.text = self.item.n49?self.item.n49:@"";
            if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"merchantName"] isEqualToString:@""]) {
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10A"]) {
                    textfield.enabled = YES;
                    textfield.text = self.item.n49;
                }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10C"]) {
                    textfield.enabled = YES;
                    textfield.text = self.item.n49;
                }else {
                    textfield.enabled = NO;
                }
                
            }else {
                textfield.enabled = YES;
            }
            
            
        }else if (textfield.tag == 1007) {//商户简称
            
            self.merchantShortName = textfield;
            self.item.n45 = [[NSUserDefaults standardUserDefaults] objectForKey:@"merchantShortName"];
            textfield.text = self.item.n45?self.item.n45:@"";
            if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"merchantShortName"] isEqualToString:@""]) {
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10A"]) {
                    textfield.enabled = YES;
                    textfield.text = self.item.n45;
                }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10C"]) {
                    textfield.enabled = YES;
                    textfield.text = self.item.n45;
                }else {
                    textfield.enabled = NO;
                }
                
            }else {
                textfield.enabled = YES;
            }
        }
        else if (textfield.tag == 1008) {//客服电话
            self.serviceTel = textfield;
            self.item.n46 = [[NSUserDefaults standardUserDefaults] objectForKey:@"serviceTel"];
            textfield.text = self.item.n46?self.item.n46:@"";
            if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"serviceTel"] isEqualToString:@""]) {
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10A"]) {
                    textfield.enabled = YES;
                    textfield.text = self.item.n46;
                }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10C"]) {
                    textfield.enabled = YES;
                    textfield.text = self.item.n46;
                }else {
                    textfield.enabled = NO;
                }
                
            }else {
                textfield.enabled = YES;
            }
            
        }else if (tf.tag == 1009) {//经营类目
            self.manageType = tf;
            self.item.n47 = [[NSUserDefaults standardUserDefaults] objectForKey:ManageTypeID];
            
            static NSString *manageTypeName;//必须用static修饰  否则在下面的block中给manageTypeName赋值会报错
            
            __weak typeof(self) weakSelf = self;
            [[ManageTypeDictionary ManageTypeDic] enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if ([obj isEqualToString:weakSelf.item.n47]) {
                    
                    manageTypeName = [NSString stringWithFormat:@"%@",key];
                    
                }
            }];
            
            tf.text = manageTypeName?manageTypeName:@"";
            if (![[[NSUserDefaults standardUserDefaults] objectForKey:ManageTypeID] isEqualToString:@""]) {
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10A"]) {
                    tf.enabled = YES;
                    tf.text = manageTypeName;
                }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10C"]) {
                    tf.enabled = YES;
                    tf.text = manageTypeName;
                }else {
                    tf.enabled = NO;
                }
                
            }else {
                tf.enabled = YES;
            }
            
        }else if (textfield.tag == 1010) {//店铺地址
            self.shopAddress = textfield;
            self.item.n48 = [[NSUserDefaults standardUserDefaults] objectForKey:@"shopAddress"];
            textfield.text = self.item.n48?self.item.n48:@"";
            if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"shopAddress"] isEqualToString:@""]) {
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10A"]) {
                    textfield.enabled = YES;
                    textfield.text = self.item.n48;
                }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10C"]) {
                    textfield.enabled = YES;
                    textfield.text = self.item.n48;
                }else {
                    textfield.enabled = NO;
                }
                
            }else {
                textfield.enabled = YES;
            }
            
        }
        else if (textfield.tag == 1011) {//商户状态
            textfield.enabled = NO;
            textfield.textColor = [UIColor blackColor];
            if ([[[NSUserDefaults standardUserDefaults] valueForKey:CardID] length] > 0 && [[[NSUserDefaults standardUserDefaults] valueForKey:BankName] length] > 0 && [[[NSUserDefaults standardUserDefaults] valueForKey:CardName] length] > 0 && [[[NSUserDefaults standardUserDefaults] valueForKey:CardNumber] length] > 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:HandCard] length] > 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:FrontCard] length] > 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:BackCard] length] > 0) {
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10A"]) {
                    textfield.text = @"未审核";
                }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10B"]) {
                    textfield.text = @"审核通过";
                }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10C"]) {
                    textfield.text = @"审核拒绝";
                }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10D"]) {
                    textfield.text = @"重新审核";
                }
            }else{
                textfield.text = @"未认证";
            }
        }else if (textfield.tag == 1012) {//状态描述
            textfield.enabled = NO;
            textfield.textColor = [UIColor blackColor];
            if ([[[NSUserDefaults standardUserDefaults] valueForKey:CardID] length] > 0 && [[[NSUserDefaults standardUserDefaults] valueForKey:BankName] length] > 0 && [[[NSUserDefaults standardUserDefaults] valueForKey:CardName] length] > 0 && [[[NSUserDefaults standardUserDefaults] valueForKey:CardNumber] length] > 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:HandCard] length] > 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:FrontCard] length] > 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:BackCard] length] > 0) {
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10A"]) {
                    textfield.text = @"已提交商户信息,未完成审核状态";
                }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10B"]) {
                    textfield.text = @"提交商户信息审核通过";
                }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10C"]) {
                    textfield.text = @"提交商户信息审核拒绝";
                }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10D"]) {
                    textfield.text = @"提交商户信息正等待审核";
                }
            }else{
                
            }
        }
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 50 * (i + 1), SCREEN_WIDTH - 20, 1)];
        line.backgroundColor = COLOR_LINE;
        [self.baseView addSubview:line];
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请确保信息填写正确，生效后不可修改" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:CardID] length] > 0 && [[[NSUserDefaults standardUserDefaults] valueForKey:BankName] length] > 0 && [[[NSUserDefaults standardUserDefaults] valueForKey:CardName] length] > 0 && [[[NSUserDefaults standardUserDefaults] valueForKey:CardNumber] length] > 0) {
        
    }else{
        [alertView show];
    }
    
    UIButton *confirmBtn = [[UIButton alloc] init];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn setBackgroundColor:COLOR_THEME];
    [confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [self.baseView addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.baseView.contentSize.height - 150);
        //        make.top.equalTo(self.baseView.contentSize.height).offset(-100);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(50);
    }];
    self.confirmBtn = confirmBtn;
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:CardID] length] > 0 && [[[NSUserDefaults standardUserDefaults] valueForKey:BankName] length] > 0 && [[[NSUserDefaults standardUserDefaults] valueForKey:CardName] length] > 0 && [[[NSUserDefaults standardUserDefaults] valueForKey:CardNumber] length] > 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:HandCard] length] > 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:FrontCard] length] > 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:BackCard] length] > 0) {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10A"]) {
            [self.confirmBtn setTitle:@"下一步" forState:UIControlStateNormal];
            [self.confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10B"]) {
            [self.confirmBtn setTitle:@"下一页" forState:UIControlStateNormal];
            [self.confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10C"]) {
            [self.confirmBtn setTitle:@"下一步" forState:UIControlStateNormal];
            [self.confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        } else {
        }
    }else {
        [self.confirmBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [self.confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.confirmBtn.userInteractionEnabled = YES;
    }
}

-(void)confirmAction {
    self.item.n0 = @"0700";
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10C"]) {
        if ([self.tfCardID.text length] > 0  && [self.tfBankName.text length] > 0 && [self.tfCardName.text length] > 0 && [self.tfCardNumber.text length] > 0 && [self.merchantName.text length] >0 && [self.merchantShortName.text length] >0 && [self.serviceTel.text length] >0 && [self.manageType.text length] >0 && [self.shopAddress.text length] >0) {
            self.item.n1 = [[NSUserDefaults standardUserDefaults] objectForKey:Account];
            self.item.n3 = @"190938";
            self.item.n43 = [[NSUserDefaults standardUserDefaults] objectForKey:Code];
            self.item.n5 = [self.tfCardName.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            self.item.n49 = [self.merchantName.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            self.item.n45 = [self.merchantShortName.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            self.item.n46 = [self.serviceTel.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            self.item.n47 = [[NSUserDefaults standardUserDefaults] objectForKey:ManageTypeID];
            self.item.n48 = [self.shopAddress.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *macStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@",self.item.n0,self.item.n1,self.item.n3,self.item.n5,self.item.n6,self.item.n7,self.item.n43,self.item.n45,self.item.n46,self.item.n47,self.item.n48,self.item.n49,self.item.n59,MainKey];
            NSLog(@"macStr:%@",macStr);
            self.item.n64 = [[macStr md5HexDigest] uppercaseString];
            [[NetAPIManger sharedManger] request_DetailsWithParams:[self.item keyValues] andBlock:^(id data, NSError *error) {
                AbstractItems *item = (AbstractItems *)data;
                if ([item.n39 isEqualToString:@"00"]) {
                    
                    [[NSUserDefaults standardUserDefaults] setObject:item.n7 forKey:CardNumber];
                    //            [[NSUserDefaults standardUserDefaults] setObject:item.n43 forKey:BankName];
                    [[NSUserDefaults standardUserDefaults] setObject:_bankName forKey:BankName];
                    [[NSUserDefaults standardUserDefaults] setObject:item.n6 forKey:CardID];
                    //            [[NSUserDefaults standardUserDefaults] setObject:item.n5 forKey:CardName];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:self.tfCardName.text forKey:CardName];
                    
                    //更新用户的风控审核状态
                    [[NSUserDefaults standardUserDefaults] setObject:item.n43 forKey:FreezeStatus];
                    
                    PhotoViewController *photoVc = [[PhotoViewController alloc]init];
                    [self.navigationController pushViewController:photoVc animated:YES];
                    
                }else{
                    
                    if ([item.n39 isEqualToString:@"ZE"]) {
                        NSString *error = [[ResponseDictionaryTool responseDic] objectForKey:item.n39];
                        //                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                        //                    [alertView show];
                        [MBProgressHUD showSuccess:error toView:self.view];
                    }
                    
                    if ([[ResponseDictionaryTool responseDic] objectForKey:item.n39]) {
                        NSString *error = [[ResponseDictionaryTool responseDic] objectForKey:item.n39];
                        NSLog(@"error:%@",error);
                        [MBProgressHUD showSuccess:error toView:self.view];
                    }else {
                        [MBProgressHUD showSuccess:@"未知错误" toView:self.view];
                    }
                }
                
                
            }];
            
            if (self.tfCardID.text.length != 18 && self.tfCardID.text.length != 15) {
                [MBProgressHUD showError:@"请输入正确的身份证号" toView:self.view];
            }else if ([self.tfBankName.text isEqualToString:@""]){
                [MBProgressHUD showError:@"请选择正确的银行名称" toView:self.view];
            }else if ([self.tfCardName.text isEqualToString:@""] || self.tfCardName.text.length < 2){
                [MBProgressHUD showError:@"请输入正确的开户姓名" toView:self.view];
            }else if ([self.tfCardNumber.text isEqualToString:@""]){
                [MBProgressHUD showError:@"请输入正确的银行卡号" toView:self.view];
            }else if ([self.tfCardID.text isEqualToString:@""] && [self.tfBankName.text isEqualToString:@""] && [self.tfCardName.text isEqualToString:@""] && [self.tfCardNumber.text isEqualToString:@""]){
                [MBProgressHUD showError:@"请输入个人信息" toView:self.view];
            }
        } else {
            
        }
    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10A"] || [[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10E"]) {
        if ([self.tfCardID.text length] > 0  && [self.tfBankName.text length] > 0 && [self.tfCardName.text length] > 0 && [self.tfCardNumber.text length] > 0 && [self.merchantName.text length] >0 && [self.merchantShortName.text length] >0 && [self.serviceTel.text length] >0 && [self.manageType.text length] >0 && [self.shopAddress.text length] >0) {
            self.item.n1 = [[NSUserDefaults standardUserDefaults] objectForKey:Account];
            self.item.n3 = @"190938";
            self.item.n43 = [[NSUserDefaults standardUserDefaults] objectForKey:Code];
            self.item.n5 = [self.tfCardName.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            self.item.n49 = [self.merchantName.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            self.item.n45 = [self.merchantShortName.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            self.item.n46 = [self.serviceTel.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            self.item.n47 = [[NSUserDefaults standardUserDefaults] objectForKey:ManageTypeID];
            self.item.n48 = [self.shopAddress.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *macStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@",self.item.n0,self.item.n1,self.item.n3,self.item.n5,self.item.n6,self.item.n7,self.item.n43,self.item.n45,self.item.n46,self.item.n47,self.item.n48,self.item.n49,self.item.n59,MainKey];
            NSLog(@"macStr:%@",macStr);
            self.item.n64 = [[macStr md5HexDigest] uppercaseString];
            [[NetAPIManger sharedManger] request_DetailsWithParams:[self.item keyValues] andBlock:^(id data, NSError *error) {
                AbstractItems *item = (AbstractItems *)data;
                if ([item.n39 isEqualToString:@"00"]) {
                    
                    [[NSUserDefaults standardUserDefaults] setObject:item.n7 forKey:CardNumber];
                    //            [[NSUserDefaults standardUserDefaults] setObject:item.n43 forKey:BankName];
                    [[NSUserDefaults standardUserDefaults] setObject:_bankName forKey:BankName];
                    [[NSUserDefaults standardUserDefaults] setObject:item.n6 forKey:CardID];
                    //            [[NSUserDefaults standardUserDefaults] setObject:item.n5 forKey:CardName];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:self.tfCardName.text forKey:CardName];
                    
                    PhotoViewController *photoVc = [[PhotoViewController alloc]init];
                    [self.navigationController pushViewController:photoVc animated:YES];
                }else{
                    if ([item.n39 isEqualToString:@"ZE"]) {
                        NSString *error = [[ResponseDictionaryTool responseDic] objectForKey:item.n39];
                        //                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                        //                    [alertView show];
                        [MBProgressHUD showSuccess:error toView:self.view];
                    }
                    
                    if ([[ResponseDictionaryTool responseDic] objectForKey:item.n39]) {
                        NSString *error = [[ResponseDictionaryTool responseDic] objectForKey:item.n39];
                        NSLog(@"error:%@",error);
                        [MBProgressHUD showSuccess:error toView:self.view];
                    }else {
                        [MBProgressHUD showSuccess:@"未知错误" toView:self.view];
                    }
                }
                
            }];
            
            if (self.tfCardID.text.length != 18 && self.tfCardID.text.length != 15) {
                [MBProgressHUD showError:@"请输入正确的身份证号" toView:self.view];
            }else if ([self.tfBankName.text isEqualToString:@""]){
                [MBProgressHUD showError:@"请选择正确的银行名称" toView:self.view];
            }else if ([self.tfCardName.text isEqualToString:@""] || self.tfCardName.text.length < 2){
                [MBProgressHUD showError:@"请输入正确的开户姓名" toView:self.view];
            }else if ([self.tfCardNumber.text isEqualToString:@""]){
                [MBProgressHUD showError:@"请输入正确的银行卡号" toView:self.view];
            }else if ([self.tfCardID.text isEqualToString:@""] && [self.tfBankName.text isEqualToString:@""] && [self.tfCardName.text isEqualToString:@""] && [self.tfCardNumber.text isEqualToString:@""]){
                [MBProgressHUD showError:@"请输入个人信息" toView:self.view];
            }else {
            
            }
        }
    }else {
        
    }
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10B"]) {
        
        //            if (![self.tfCardNumber.text containsString:@"*"]) {
        //                self.item.n1 = [[NSUserDefaults standardUserDefaults] objectForKey:Account];
        //                //    self.item.n59 = @"CHDS-1.0.0";
        //                self.item.n3 = @"190938";
        //                self.item.n5 = [[[NSUserDefaults standardUserDefaults] objectForKey:MerchantName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //                self.item.n6 = [[NSUserDefaults standardUserDefaults] objectForKey:CardID];
        //                self.item.n43 = [[NSUserDefaults standardUserDefaults] objectForKey:Code];
        //                NSString *macStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",self.item.n0,self.item.n1,self.item.n2,self.item.n3,self.item.n5,self.item.n6,self.item.n7,self.item.n8,self.item.n9,self.item.n10,self.item.n11,self.item.n12,self.item.n43,self.item.n59,MainKey];
        //                NSLog(@"macStr:%@",macStr);
        //                self.item.n64 = [[macStr md5HexDigest] uppercaseString];
        //                [[NetAPIManger sharedManger] request_DetailsWithParams:[self.item keyValues] andBlock:^(id data, NSError *error) {
        //                    AbstractItems *item = (AbstractItems *)data;
        //                    if ([item.n39 isEqualToString:@"00"]) {
        //
        //                        [[NSUserDefaults standardUserDefaults] setObject:item.n7 forKey:CardNumber];
        //                        //            [[NSUserDefaults standardUserDefaults] setObject:item.n43 forKey:BankName];
        //                        [[NSUserDefaults standardUserDefaults] setObject:_bankName forKey:BankName];
        //                        [[NSUserDefaults standardUserDefaults] setObject:item.n6 forKey:CardID];
        //                        //            [[NSUserDefaults standardUserDefaults] setObject:item.n5 forKey:CardName];
        //
        //                        [[NSUserDefaults standardUserDefaults] setObject:self.tfCardName.text forKey:CardName];
        //
        //                        //更新用户的风控审核状态
        //                        [[NSUserDefaults standardUserDefaults] setObject:item.n43 forKey:FreezeStatus];
        //
        //                        //geiW8Str赋值,以确保下个界面上传照片按钮可用
        //                        [[NSUserDefaults standardUserDefaults] setObject:@"已修改个人信息" forKey:W8Str];
        
        PhotoViewController *photoVc = [[PhotoViewController alloc]init];
        [self.navigationController pushViewController:photoVc animated:YES];
        
        //                    }else{
        //
        //                        if ([item.n39 isEqualToString:@"ZE"]) {
        //                            NSString *error = [[ResponseDictionaryTool responseDic] objectForKey:item.n39];
        //                            //                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        //                            //                    [alertView show];
        //                            [MBProgressHUD showSuccess:error toView:self.view];
        //                        }
        //
        //                        if ([[ResponseDictionaryTool responseDic] objectForKey:item.n39]) {
        //                            NSString *error = [[ResponseDictionaryTool responseDic] objectForKey:item.n39];
        //                            NSLog(@"error:%@",error);
        //                            [MBProgressHUD showSuccess:error toView:self.view];
        //                        }else {
        //                            [MBProgressHUD showSuccess:@"未知错误" toView:self.view];
        //                        }
        //                    }
        //
        //
        //                }];
        //
        //                if ([self.tfBankName.text isEqualToString:@""]){
        //                    [MBProgressHUD showError:@"请选择正确的银行名称" toView:self.view];
        //                }else if ([self.tfCardNumber.text isEqualToString:@""]){
        //                    [MBProgressHUD showError:@"请输入正确的银行卡号" toView:self.view];
        //                }
        //            }else {
        //                PhotoViewController *photoVc = [[PhotoViewController alloc]init];
        //                [self.navigationController pushViewController:photoVc animated:YES];
        //            }
        
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 1003) {
        BankViewController *bankVC = [[BankViewController alloc] initWithSelectedBankBlock:^(NSString *code, NSString *name) {
            NSLog(@"%@",code);
            self.item.n43 = code;
            [[NSUserDefaults standardUserDefaults] setObject:code forKey:Code];
            //            [[NSUserDefaults standardUserDefaults] setObject:code forKey:BankCode];
            //            [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            textField.text = name;
        }];
        bankVC.dataArray = self.bankArray;
        [self.navigationController pushViewController:bankVC animated:YES];
        return NO;
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    return YES;
}

-(void)textFieldTargetTag:(UITextField *)textField {
    NSLog(@"text内容发生变化");
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.tag == 1009) {
        self.manageType = (ZJSelectedTextField *)textField;
        
        NSString *typeOnePath = [[NSBundle mainBundle] pathForResource:@"TypeOne" ofType:@"plist"];
        NSString *typeTwoPath = [[NSBundle mainBundle] pathForResource:@"TypeTwo" ofType:@"plist"];
        NSString *typeThreePath = [[NSBundle mainBundle] pathForResource:@"TypeThree" ofType:@"plist"];
        
        NSArray *typeOneArr = [NSArray arrayWithContentsOfFile:typeOnePath];
        NSDictionary *typeTwoDic = [NSDictionary dictionaryWithContentsOfFile:typeTwoPath];
        NSDictionary *typeThreeDic = [NSDictionary dictionaryWithContentsOfFile:typeThreePath];
        
        NSArray *multipleAssociatedData = @[typeOneArr,typeTwoDic,typeThreeDic];
        
        [self.manageType showMultipleAssociatedColPickerWithToolBarText:@"请选择经营类目" withDefaultValues:@[@"美食", @"中餐", @"川菜"] withData:multipleAssociatedData withCancelHandler:^{
            NSLog(@"quxiaole -----");
//            textField.text = @"";
            
        } withDoneHandler:^(UITextField *textField, NSArray *selectedValues) {
            NSLog(@"%@---", selectedValues);
            NSLog(@"%@ %@ %@",selectedValues[0],selectedValues[1],selectedValues[2]);
            if ([selectedValues[1] isEqualToString:@""]) {
                self.manageType.text = [NSString stringWithFormat:@"%@",selectedValues[0]];
            }else if (![selectedValues[1] isEqualToString:@""] && [selectedValues[2] isEqualToString:@""]) {
                self.manageType.text = [NSString stringWithFormat:@"%@ %@",selectedValues[0],selectedValues[1]];
            }else if (![selectedValues[1] isEqualToString:@""] && ![selectedValues[2] isEqualToString:@""]) {
                self.manageType.text = [NSString stringWithFormat:@"%@ %@ %@",selectedValues[0],selectedValues[1],selectedValues[2]];
            }
            
            self.item.n47 = [[ManageTypeDictionary ManageTypeDic] valueForKey:self.manageType.text];
            NSLog(@"n47:%@",self.item.n47);
            [[NSUserDefaults standardUserDefaults] setObject:self.item.n47 forKey:ManageTypeID];
        }];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 1001://手机号
        {
            self.item.n1 = textField.text;
        }
            break;
        case 1002://身份证号
        {
            
            if (textField.text.length > 0) {
                self.item.n6 = textField.text;
                temporaryCardId = textField.text;
            }
            
            //            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        }
            break;
        case 1003://银行名称
        {
            
            
            if (textField.text.length > 0) {
                self.item.n43 = textField.text;
                temporaryBankname = textField.text;
            }
            
        }
            break;
        case 1004://银行卡号
        {
            
            if (textField.text.length > 0) {
                self.item.n7 = textField.text;
                temporaryCardnumber = textField.text;
            }
            
            //            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
            
        }
            break;
        case 1005://开户姓名
        {
            
            if (textField.text.length > 0) {
                NSString *string = [textField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                self.item.n5 = string;
                NSLog(@"n5:%@",self.item.n5);
                temporaryCardname = textField.text;
            }
            //            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
            
            
        }
            break;
        case 1006://商户名称
        {
            if (textField.text.length > 0) {
                self.item.n49 = [textField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            }
        }
            break;
        case 1007://商户简称
        {
            if (textField.text.length > 0) {
                self.item.n45 = [textField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            }
        }
            break;
        case 1008://客服电话
        {
            if (textField.text.length > 0) {
                self.item.n46 = [textField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            }
        }
            break;
        case 1009://经营类目
        {
//            if (textField.text.length > 0) {
//                self.item.n47 = [textField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            }
        }
            break;
        case 1010://店铺地址
        {
            if (textField.text.length > 0) {
                self.item.n48 = [textField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            }
        }
            break;
            
        default:
            break;
    }
}

- (NSArray *)bankArray
{
    if (!_bankArray) {
        _bankArray = @[@{@"北京银行":@"313003"},@{@"光大银行":@"303"},@{@"广发银行":@"306"},@{@"建设银行":@"105"},@{@"交通银行":@"301"},@{@"民生银行":@"305"},@{@"农业银行":@"103"},@{@"平安银行":@"307"},@{@"浦发银行":@"310"},@{@"邮政储蓄银行":@"403"},@{@"招商银行":@"308"},@{@"中国工商银行":@"102"},@{@"中国银行":@"104"},@{@"中信银行":@"302"},@{@"上海银行":@"313062"},@{@"杭州银行":@"313027"}];
    }
    return _bankArray;
}



/**
 *  设置返回按钮标题
 */
- (void)setBackBarButtonItemWithTitle:(NSString *)title
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn setTitleColor:COLOR_MY_WHITE forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"NavBackSorrow"] forState:UIControlStateNormal];
    [btn setContentMode:UIViewContentModeScaleAspectFill];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -7, 0, 50)];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 10)];
    [btn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

/**
 *  返回按钮点击事件
 */
- (void)backAction:(id)sender
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:JuJue] isEqualToString:@"拒绝"]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

//判断字符串是否含有汉字
- (BOOL)includeChinese:(NSString *)str
{
    for(int i=0; i< [str length];i++)
    {
        int a =[str characterAtIndex:i];
        if( a >0x4e00&& a <0x9fff){
            return YES;
        }
    }
    return NO;
}

@end
