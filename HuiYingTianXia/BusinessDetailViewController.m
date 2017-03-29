//
//  BusinessDetailViewController.m
//  HuiYingTianXia
//
//  Created by 朱颖宇 on 15/6/18.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import "BusinessDetailViewController.h"
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

static NSString *temporaryCardId;
static NSString *temporaryBankname;
static NSString *temporaryCardname;
static NSString *temporaryCardnumber;

@interface BusinessDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

- (IBAction)cancle:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong,nonatomic) NSArray *bankArray;

@property(strong,nonatomic)NSMutableArray *businessDetails;
@property(strong,nonatomic)NSString *cardName;
@property(strong,nonatomic)NSString *bankName;
@property(strong,nonatomic)NSString *cardID;//身份证号
- (IBAction)confirm:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *confirm;
@property(strong,nonatomic)AbstractItems *item;

@property(strong,nonatomic)UITextField *tfPhoneNumber;//手机号码文本框
@property(strong,nonatomic)UITextField *tfCardID;//身份证号文本框
@property(strong,nonatomic)UITextField *tfBankName;//银行名称文本框
@property(strong,nonatomic)UITextField *tfCardName;//开户姓名文本框
@property(strong,nonatomic)UITextField *tfCardNumber;//银行卡号文本框
@property(strong,nonatomic)UILabel *passCheckLabel;//认证状态:审核通过
@property(strong,nonatomic)UILabel *unCertifyLabel;//认证状态:未认证
@property(strong,nonatomic)UILabel *uncheckLabel;//认证状态:未审核
@property(strong,nonatomic)UILabel *checkRefuseLabel;//认证状态:审核拒绝
@property(strong,nonatomic)UILabel *checkAgainLabel;//认证状态:重新审核
@property(strong,nonatomic)UILabel *statusDescriptLabel;//状态描述
@property(strong,nonatomic)UITextView *checkInfomation;//审核意见

@property(nonatomic, assign)CGFloat animationTime;
@property(nonatomic, assign)UIViewAnimationOptions animationCurve;
@property(nonatomic, assign)CGRect keyboardFrame;

@property(nonatomic)CGRect tableFrame;

////临时变量
//@property(strong,nonatomic)NSString *temporaryCardId;
//@property(strong,nonatomic)NSString *temporaryBankname;
//@property(strong,nonatomic)NSString *temporaryCardname;
//@property(strong,nonatomic)NSString *temporaryCardnumber;
@property(strong,nonatomic)NSString *bankcode;
@property(strong,nonatomic)NSString *name;

@end

@implementation BusinessDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    
}


- (void)viewWillDisAppear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
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
    
    [self setBackBarButtonItemWithTitle:@"返回"];
    [self setNavTitle:@"商户详情"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.bounces = NO;
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 0)];
    self.tableView.tableFooterView = footView;
    
    [self.confirm setBackgroundColor:COLOR_THEME];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请确保信息填写正确，生效后不可修改" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    //    [alertView show];
    
    //设置输入文本框
    self.tfPhoneNumber = [[UITextField alloc]init];
    self.tfPhoneNumber.frame = CGRectMake(120, 1.5, SCREEN_WIDTH - 120, 50);
    self.tfPhoneNumber.delegate = self;
    self.tfPhoneNumber.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    self.tfCardID = [[UITextField alloc]init];
    self.tfCardID.frame = CGRectMake(120, 1.5, SCREEN_WIDTH - 120, 50);
    self.tfCardID.delegate = self;
    self.tfCardID.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    
    self.tfBankName = [[UITextField alloc]init];
    self.tfBankName.frame = CGRectMake(120, 1.5, SCREEN_WIDTH - 120, 50);
    self.tfBankName.delegate = self;
    
    self.tfCardName = [[UITextField alloc]init];
    self.tfCardName.frame = CGRectMake(120, 1.5, SCREEN_WIDTH - 120, 50);
    self.tfCardName.delegate = self;
    
    self.tfCardNumber = [[UITextField alloc]init];
    self.tfCardNumber.frame = CGRectMake(120, 1.5, SCREEN_WIDTH - 120, 50);
    self.tfCardNumber.delegate = self;
    self.tfCardNumber.keyboardType = UIKeyboardTypeNumberPad;
    
    self.passCheckLabel = [[UILabel alloc]init];
    self.passCheckLabel.text = @"审核通过";
    self.passCheckLabel.frame = CGRectMake(120, 1.5, 80, 50);
    
    self.unCertifyLabel = [[UILabel alloc]init];
    self.unCertifyLabel.text = @"未认证";
    self.unCertifyLabel.frame = CGRectMake(120, 1.5, 80, 50);
    
    self.uncheckLabel = [[UILabel alloc]init];
    self.uncheckLabel.text = @"未审核";
    self.uncheckLabel.frame = CGRectMake(120, 1.5, 80, 50);
    
    self.checkAgainLabel = [[UILabel alloc]init];
    self.checkAgainLabel.text = @"重新审核";
    self.checkAgainLabel.frame = CGRectMake(120, 1.5, 80, 50);
    
    self.checkRefuseLabel = [[UILabel alloc]init];
    self.checkRefuseLabel.text = @"审核拒绝";
    self.checkRefuseLabel.frame = CGRectMake(120, 1.5, 80, 50);
    
    self.statusDescriptLabel = [[UILabel alloc] init];
    self.statusDescriptLabel.textAlignment = NSTextAlignmentLeft;
    self.statusDescriptLabel.font = [UIFont systemFontOfSize:14];
    self.statusDescriptLabel.frame = CGRectMake(120, 1.5, SCREEN_WIDTH - 120, 50);
    
    self.checkInfomation = [[UITextView alloc] init];
    self.checkInfomation.textAlignment = NSTextAlignmentLeft;
    self.checkInfomation.font = [UIFont systemFontOfSize:14];
    self.checkInfomation.frame = CGRectMake(120, 1.5, SCREEN_WIDTH - 120, 40);
    
    //添加键盘弹出通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.tableFrame = self.tableView.frame;
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:CardID] length] > 0 && [[[NSUserDefaults standardUserDefaults] valueForKey:BankName] length] > 0 && [[[NSUserDefaults standardUserDefaults] valueForKey:CardName] length] > 0 && [[[NSUserDefaults standardUserDefaults] valueForKey:CardNumber] length] > 0) {
        
    }else{
        [alertView show];
    }
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10A"] || [[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10C"]) {
        [self.confirm setTitle:@"下一步" forState:UIControlStateNormal];
        [self.confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10B"]) {
        self.tfCardID.enabled = NO;
        self.tfCardName.enabled = NO;
        self.tfBankName.enabled = NO;
        self.tfCardNumber.enabled = NO;
        
        [self.confirm setTitle:@"下一页" forState:UIControlStateNormal];
        [self.confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    //读取数据库中的商户信息
    //    if ([[[NSUserDefaults standardUserDefaults] valueForKey:CardID] length] > 0 && [[[NSUserDefaults standardUserDefaults] valueForKey:BankName] length] > 0 && [[[NSUserDefaults standardUserDefaults] valueForKey:CardName] length] > 0 && [[[NSUserDefaults standardUserDefaults] valueForKey:CardNumber] length] > 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:HandCard] length] > 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:FrontCard] length] > 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:BackCard] length] > 0) {
    ////        self.tfCardID.text = [[NSUserDefaults standardUserDefaults] objectForKey:CardID];
    //        self.tfCardID.enabled = NO;
    ////        self.tfCardName.text = [[NSUserDefaults standardUserDefaults] objectForKey:CardName];
    //        self.tfCardName.enabled = NO;
    ////        self.tfBankName.text = [[NSUserDefaults standardUserDefaults] objectForKey:BankName];
    //        self.tfBankName.enabled = NO;
    ////        self.tfCardNumber.text = [[NSUserDefaults standardUserDefaults] objectForKey:CardNumber];
    //        self.tfCardNumber.enabled = NO;
    //
    //        [self.confirm setTitle:@"下一页" forState:UIControlStateNormal];
    //        [self.confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //        //        [self.tableView reloadData];
    //
    //    }
    
}

- (IBAction)cancle:(id)sender {
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:JuJue] isEqualToString:@"拒绝"]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 8;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    
    for (UIView *view in cell.subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
            [view removeFromSuperview];
        }
    }
    
    if (indexPath.row == 0) {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:Account] length] == 11) {
            cell.textLabel.text = @"手机号码";
        }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:Account] length] > 11) {
            cell.textLabel.text = @"商户编号";
        }
        self.tfPhoneNumber.placeholder = [[NSUserDefaults standardUserDefaults] objectForKey:Account];
        self.item.n1 = self.tfPhoneNumber.text;
        self.tfPhoneNumber.enabled = NO;
        self.tfPhoneNumber.tag = indexPath.row + 100;
        [cell.contentView addSubview:self.tfPhoneNumber];
        
    }else if (indexPath.row == 1){
        
        cell.textLabel.text = @"身份证号";
        self.tfCardID.placeholder = @"请填写";
        self.item.n6 = [[NSUserDefaults standardUserDefaults] objectForKey:CardID];
        self.tfCardID.text = self.item.n6?self.item.n6:@"";
        if (self.tfCardID.text.length > 10) {
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10A"] || [[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10C"]) {
                self.tfCardID.text = self.item.n6;
            }else {
                self.tfCardID.text = [NSString stringWithFormat:@"%@*****%@",[self.tfCardID.text substringToIndex:6],[self.tfCardID.text substringFromIndex:self.tfCardID.text.length - 4]];
                NSLog(@"%@",self.tfCardID.text);
            }
        }
        
        self.tfCardID.tag = indexPath.row + 100;
        [cell.contentView addSubview:self.tfCardID];
        
    }else if (indexPath.row == 2){
        
        cell.textLabel.text = @"银行名称";
        if (_bankName.length == 0) {
            _bankName = [[NSUserDefaults standardUserDefaults] objectForKey:BankName];
        }
        self.tfBankName.text = _bankName?_bankName:@"";
        self.tfBankName.tag = indexPath.row + 100;
        [cell.contentView addSubview:self.tfBankName];
        
    }else if (indexPath.row == 3){
        
        cell.textLabel.text = @"储蓄卡号";
        self.tfCardNumber.placeholder = @"必填";
        self.item.n7 = [[NSUserDefaults standardUserDefaults] objectForKey:CardNumber];
        self.tfCardNumber.text = self.item.n7?self.item.n7:@"";
        if (self.tfCardNumber.text.length > 10) {
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10A"] || [[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10C"]) {
                self.tfCardNumber.text = self.item.n7;
            }else {
                self.tfCardNumber.text = [NSString stringWithFormat:@"%@*****%@",[self.tfCardNumber.text substringToIndex:6],[self.tfCardNumber.text substringFromIndex:self.tfCardNumber.text.length - 4]];
                NSLog(@"%@",self.tfCardNumber.text);
            }
            
        }
        self.tfCardNumber.tag = indexPath.row + 100;
        self.tfCardNumber.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        [cell.contentView addSubview:self.tfCardNumber];
        
    }else if (indexPath.row == 4){
        
        cell.textLabel.text = @"开户姓名";
        self.tfCardName.placeholder = @"必填";
        self.item.n5 = [[NSUserDefaults standardUserDefaults] objectForKey:CardName];
        self.tfCardName.text = self.item.n5?self.item.n5:@"";
        if (self.tfCardName.text.length == 2) {
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10A"] || [[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10C"]) {
                self.tfCardName.text = self.item.n5;
            }else {
                self.tfCardName.text = [NSString stringWithFormat:@"*%@",[self.tfCardName.text substringFromIndex:1]];
                NSLog(@"%@",self.tfCardName.text);
            }
        }
        if (self.tfCardName.text.length > 2) {
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10A"] || [[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10C"]) {
                self.tfCardName.text = self.item.n5;
            }else {
                self.tfCardName.text = [NSString stringWithFormat:@"*%@",[self.tfCardName.text substringFromIndex:self.tfCardName.text.length - 2]];
            }
        }
        self.tfCardName.tag = indexPath.row + 100;
        [cell.contentView addSubview:self.tfCardName];
        
        
    }else if (indexPath.row == 5) {
        cell.textLabel.text = @"商户状态";
        [cell.contentView addSubview:self.passCheckLabel];
        [cell.contentView addSubview:self.unCertifyLabel];
        [cell.contentView addSubview:self.uncheckLabel];
        [cell.contentView addSubview:self.checkRefuseLabel];
        [cell.contentView addSubview:self.checkAgainLabel];
        
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:CardID] length] > 0 && [[[NSUserDefaults standardUserDefaults] valueForKey:BankName] length] > 0 && [[[NSUserDefaults standardUserDefaults] valueForKey:CardName] length] > 0 && [[[NSUserDefaults standardUserDefaults] valueForKey:CardNumber] length] > 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:HandCard] length] > 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:FrontCard] length] > 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:BackCard] length] > 0) {
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10A"]) {
                [self.passCheckLabel setHidden:YES];
                [self.unCertifyLabel setHidden:YES];
                [self.uncheckLabel setHidden:NO];
                [self.checkRefuseLabel setHidden:YES];
                [self.checkAgainLabel setHidden:YES];
            }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10B"]) {
                [self.passCheckLabel setHidden:NO];
                [self.unCertifyLabel setHidden:YES];
                [self.uncheckLabel setHidden:YES];
                [self.checkRefuseLabel setHidden:YES];
                [self.checkAgainLabel setHidden:YES];
            }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10C"]) {
                [self.passCheckLabel setHidden:YES];
                [self.unCertifyLabel setHidden:YES];
                [self.uncheckLabel setHidden:YES];
                [self.checkRefuseLabel setHidden:NO];
                [self.checkAgainLabel setHidden:YES];
            }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10D"]) {
                [self.passCheckLabel setHidden:YES];
                [self.unCertifyLabel setHidden:YES];
                [self.uncheckLabel setHidden:YES];
                [self.checkRefuseLabel setHidden:YES];
                [self.checkAgainLabel setHidden:NO];
            }
        }else{
            [self.passCheckLabel setHidden:YES];
            [self.unCertifyLabel setHidden:NO];
            [self.uncheckLabel setHidden:YES];
            [self.checkRefuseLabel setHidden:YES];
            [self.checkAgainLabel setHidden:YES];
        }
    }else if (indexPath.row == 6) {
        cell.textLabel.text = @"状态描述";
        [cell.contentView addSubview:self.statusDescriptLabel];
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:CardID] length] > 0 && [[[NSUserDefaults standardUserDefaults] valueForKey:BankName] length] > 0 && [[[NSUserDefaults standardUserDefaults] valueForKey:CardName] length] > 0 && [[[NSUserDefaults standardUserDefaults] valueForKey:CardNumber] length] > 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:HandCard] length] > 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:FrontCard] length] > 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:BackCard] length] > 0) {
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10A"]) {
                self.statusDescriptLabel.text = @"已提交商户信息,未完成审核状态";
            }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10B"]) {
                self.statusDescriptLabel.text = @"提交商户信息审核通过";
            }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10C"]) {
                self.statusDescriptLabel.text = @"提交商户信息审核拒绝";
            }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10D"]) {
                self.statusDescriptLabel.text = @"提交商户信息正等待审核";
            }
        }else{
            [cell setHidden:YES];
        }
    }else if (indexPath.row == 7) {
        //        if (![[[NSUserDefaults standardUserDefaults] valueForKey:W8Str] isEqualToString:@""]) {
        //            cell.textLabel.text = @"审核意见";
        //            self.checkInfomation.text = [[NSUserDefaults standardUserDefaults] valueForKey:CheckInfomation];
        //            [cell.contentView addSubview:self.checkInfomation];
        cell.textLabel.text = @"审核意见";
        [cell.contentView addSubview:self.checkInfomation];
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:CardID] length] > 0 && [[[NSUserDefaults standardUserDefaults] valueForKey:BankName] length] > 0 && [[[NSUserDefaults standardUserDefaults] valueForKey:CardName] length] > 0 && [[[NSUserDefaults standardUserDefaults] valueForKey:CardNumber] length] > 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:HandCard] length] > 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:FrontCard] length] > 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:BackCard] length] > 0 ) {
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10C"] && ![[[NSUserDefaults standardUserDefaults] valueForKey:W8Str] isEqualToString:@""]) {
                
                self.checkInfomation.text = [[NSUserDefaults standardUserDefaults] valueForKey:CheckInfomation];
            }else {
                [cell setHidden:YES];
            }
        }else{
            [cell setHidden:YES];
        }
    }
    
    return cell;
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (![temporaryCardId isEqualToString:@""] || ![temporaryCardname isEqualToString:@""] || ![temporaryCardnumber isEqualToString:@""] || ![temporaryBankname isEqualToString:@""]) {
        self.tfCardID.text = temporaryCardId;
        //        self.tfBankName.text = bankName;
        self.tfCardName.text = temporaryCardname;
        self.tfCardNumber.text = temporaryCardnumber;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

//点击键盘上得换行自动跳到下一行,到最后一行后收起键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.tfCardID.returnKeyType = UIReturnKeyDone;
    
    if ([self.tfCardID endEditing:YES]) {
        [self.tfCardID resignFirstResponder];
    }else if ([self.tfCardName endEditing:YES]){
        [self.tfCardName resignFirstResponder];
    }else if ([self.tfCardNumber endEditing:YES]){
        [self.tfCardNumber resignFirstResponder];
    }
    return YES;
}

- (void)cardNameKeyboardShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    CGFloat keyboardTop = keyboardRect.origin.y;
    CGRect newTextViewFrame = self.view.bounds;
    newTextViewFrame.origin.y = self.view.bounds.origin.y - 60;
    newTextViewFrame.size.height = keyboardTop - self.view.bounds.origin.y + 50;
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    self.tableView.frame = newTextViewFrame;
    [UIView commitAnimations];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    //keyboardRect = [self.tableView convertRect:keyboardRect fromView:nil];
    
    CGFloat keyboardTop = keyboardRect.origin.y;
    CGRect newTextViewFrame = self.view.bounds;
    //    CGRect newTextViewFrame = self.tableView.bounds;
    newTextViewFrame.size.height = keyboardTop - self.view.bounds.origin.y;
    //    newTextViewFrame.size.height = keyboardTop - self.tableView.bounds.origin.y;
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    self.tableView.frame = newTextViewFrame;
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    //    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    //    self.tableView.frame = CGRectMake(0,-64,self.view.bounds.size.width,0);
    //self.tableView.frame = self.view.bounds;
    self.tableView.frame = self.tableFrame;
    [UIView commitAnimations];
}

-(void)viewDidUnload{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:nil object:nil];
}

- (IBAction)confirm:(UIButton *)sender {
    if (([self.tfCardID.text length] == 15 || [self.tfCardID.text length] == 18) && [self.tfBankName.text length] > 0 && [self.tfCardName.text length] > 0 && [self.tfCardNumber.text length] > 0 ) {
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10C"]) {
            self.item.n1 = [[NSUserDefaults standardUserDefaults] objectForKey:Account];
            //    self.item.n59 = @"CHDS-1.0.0";
            self.item.n3 = @"190938";
            self.item.n5 = [self.tfCardName.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            self.item.n43 = [[NSUserDefaults standardUserDefaults] objectForKey:Code];
            NSString *macStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",self.item.n0,self.item.n1,self.item.n3,self.item.n5,self.item.n6,self.item.n7,self.item.n43, self.item.n59,MainKey];
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
            
        }
//            if (self.tfCardID.text.length != 18 && self.tfCardID.text.length != 15) {
//                [MBProgressHUD showError:@"请输入正确的身份证号" toView:self.view];
//            }else if ([self.tfBankName.text isEqualToString:@""]){
//                [MBProgressHUD showError:@"请选择正确的银行名称" toView:self.view];
//            }else if ([self.tfCardName.text isEqualToString:@""] || self.tfCardName.text.length < 2){
//                [MBProgressHUD showError:@"请输入正确的开户姓名" toView:self.view];
//            }else if ([self.tfCardNumber.text isEqualToString:@""]){
//                [MBProgressHUD showError:@"请输入正确的银行卡号" toView:self.view];
//            }else if ([self.tfCardID.text isEqualToString:@""] && [self.tfBankName.text isEqualToString:@""] && [self.tfCardName.text isEqualToString:@""] && [self.tfCardNumber.text isEqualToString:@""]){
//                [MBProgressHUD showError:@"请输入个人信息" toView:self.view];
//            }
        
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10A"]) {
            self.item.n1 = [[NSUserDefaults standardUserDefaults] objectForKey:Account];
            //    self.item.n59 = @"CHDS-1.0.0";
            self.item.n3 = @"190938";
            self.item.n43 = [[NSUserDefaults standardUserDefaults] objectForKey:Code];
            self.item.n5 = [self.tfCardName.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *macStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",self.item.n0,self.item.n1,self.item.n3,self.item.n5,self.item.n6,self.item.n7,self.item.n43, self.item.n59,MainKey];
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
            
//            if (self.tfCardID.text.length != 18 && self.tfCardID.text.length != 15) {
//                [MBProgressHUD showError:@"请输入正确的身份证号" toView:self.view];
//            }else if ([self.tfBankName.text isEqualToString:@""]){
//                [MBProgressHUD showError:@"请选择正确的银行名称" toView:self.view];
//            }else if ([self.tfCardName.text isEqualToString:@""] || self.tfCardName.text.length < 2){
//                [MBProgressHUD showError:@"请输入正确的开户姓名" toView:self.view];
//            }else if ([self.tfCardNumber.text isEqualToString:@""]){
//                [MBProgressHUD showError:@"请输入正确的银行卡号" toView:self.view];
//            }else if ([self.tfCardID.text isEqualToString:@""] && [self.tfBankName.text isEqualToString:@""] && [self.tfCardName.text isEqualToString:@""] && [self.tfCardNumber.text isEqualToString:@""]){
//                [MBProgressHUD showError:@"请输入个人信息" toView:self.view];
//            }
        }
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:FreezeStatus] isEqualToString:@"10B"]) {
            PhotoViewController *photoVc = [[PhotoViewController alloc]init];
            [self.navigationController pushViewController:photoVc animated:YES];
        }
        
    }else {
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
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 102) {
        BankViewController *bankVC = [[BankViewController alloc] initWithSelectedBankBlock:^(NSString *code, NSString *name) {
            NSLog(@"%@",code);
            _bankName = name;
            self.item.n43 = code;
            self.bankcode = code;
            [[NSUserDefaults standardUserDefaults] setObject:code forKey:Code];
            //            [[NSUserDefaults standardUserDefaults] setObject:code forKey:BankCode];
            [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }];
        bankVC.dataArray = self.bankArray;
        [self.navigationController pushViewController:bankVC animated:YES];
        return NO;
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.tag == 101 || textField.tag == 104) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    }
    if (textField.tag == 103) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cardNameKeyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 100://手机号
        {
            self.item.n1 = textField.text;
        }
            break;
        case 101://身份证号
        {
            
            if (textField.text.length > 0) {
                self.item.n6 = textField.text;
                temporaryCardId = textField.text;
            }
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        }
            break;
        case 102://银行名称
        {
            
            
            if (textField.text.length > 0) {
                self.item.n43 = textField.text;
                temporaryBankname = textField.text;
            }
            
        }
            break;
        case 103://银行卡号
        {
            
            if (textField.text.length > 0) {
                self.item.n7 = textField.text;
                temporaryCardnumber = textField.text;
            }
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
            
        }
            break;
        case 104://开户姓名
        {
            
            if (textField.text.length > 0) {
                NSString *string = [textField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                self.item.n5 = string;
                NSLog(@"n5:%@",self.item.n5);
                self.name = string;
                temporaryCardname = textField.text;
            }
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
            
            
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



- (IBAction)viewTouchDown:(id)sender {
    
    [self.tfCardID resignFirstResponder];
    [self.tfCardName resignFirstResponder];
    [self.tfCardNumber resignFirstResponder];
    
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}
@end
