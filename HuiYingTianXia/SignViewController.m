//
//  SignViewController.m
//  HuiYingTianXia
//
//  Created by tsmc on 15-3-21.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import "SignViewController.h"
#import "ConsumeResultCell.h"
#import "TTTAttributedLabel.h"
#import "SignView.h"
#import "NSString+Util.h"
#import "ConsumeResultViewController.h"
#import "NetAPIManger.h"
#import "NSString+MD5HexDigest.h"
#import "MJExtension.h"
#import "POSManger.h"
#import "MBProgressHUD+Add.h"
#import "MBProgressHUD.h"

@interface SignViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic, strong)UIView *lineView;

@property(nonatomic, strong)UILabel *labSignTip;
@property(nonatomic, strong)UIImageView *ivReSign;
@property(nonatomic, strong)UILabel *labReSign;

@property(nonatomic, strong)SignView *signView;

@property(nonatomic, strong)UIView *lineTwo;
@property(nonatomic, strong)TTTAttributedLabel *labTip;
@property(nonatomic, strong)UIView *lineThree;

@property(nonatomic, strong)UIButton *btnCancle;
@property(nonatomic, strong)UIButton *btnConfirm;
@property(nonatomic, strong)NSArray *btnTitles;
@property(nonatomic, strong)NSArray *tips;
@end

static NSString *LableIdenfity = @"Lable";

@implementation SignViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"签名";
//    [self setBackBarButtonItemWithTitle:@"返回"];
    [self.navigationItem setHidesBackButton:YES];

    NSRange range = NSMakeRange(5, 3);
    NSRange range1 = NSMakeRange(3, 2);
    NSString *str = [self.rate substringWithRange:range];
    NSString *str1 = [self.rate substringWithRange:range1];
    NSString *str2 = [[NSString stringWithFormat:@"%f",[str floatValue]/100] substringToIndex:4];
    NSString *str3 = [NSString stringWithFormat:@"%d",[str1 intValue]];
    NSString *strRate = [NSString stringWithFormat:@"%@-%@",str2,str3];
    
    NSString *merchantName = [[NSUserDefaults standardUserDefaults] objectForKey:MerchantName];
    self.btnTitles = nil;
    if(merchantName.length > 0){
        self.btnTitles = @[@"商户名称",
                           @"交易类型",
                           @"交易卡号",
                           @"交易费率",
                           @"金       额"];
        self.tips = @[merchantName,
                      [POSManger getTadeTypeStr:self.tadeType],
                      [self.cardInfo objectForKey:@"cardNumber"],
                      strRate,
                      self.tadeAmount];
        
    }else {
        self.btnTitles = @[@"交易类型",
                           @"交易卡号",
                           @"交易费率",
                           @"金       额"];
        self.tips = @[[POSManger getTadeTypeStr:self.tadeType],
                      [self.cardInfo objectForKey:@"cardNumber"],
                      strRate,
                      self.tadeAmount];
    }

    
    self.tableView = [[UITableView alloc] init];
    [self.tableView registerClass:[ConsumeResultCell class] forCellReuseIdentifier:LableIdenfity];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(8);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(CELL_HEIGHT * self.btnTitles.count);
    }];
    
    self.lineView = [[UIView alloc] init];
    [self.lineView setBackgroundColor:COLOR_LINE];
    [self.view addSubview:self.lineView];
    [self.lineView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.bottom).offset(HFixHeightBaseOn568(85));
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(LINE_HEIGTH);
    }];
    
    self.labSignTip = [[UILabel alloc] init];
    self.labSignTip.font = FONT_16;
    [self.labSignTip setTextAlignment:NSTextAlignmentLeft];
    self.labSignTip.text = @"持卡人签字";
    [self.view addSubview:self.labSignTip];
    [self.labSignTip makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.bottom).offset(HFixHeightBaseOn568(5));
        make.left.equalTo(self.view).offset(HFixWidthBaseOn320(10));
        make.width.equalTo(100);
        make.height.equalTo(self.labSignTip.font.lineHeight);
    }];
    
    self.labReSign = [[UILabel alloc] init];
    self.labReSign.font = FONT_16;
    [self.labReSign setTextAlignment:NSTextAlignmentRight];
    [self.labReSign setTextColor:COLOR_FONT_GRAY];
    self.labReSign.text = @"重写";
    [self.view addSubview:self.labReSign];
    CGSize size = [self.labReSign.text suggestedSizeWithFont:self.labReSign.font];
    [self.labReSign makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labSignTip);
        make.right.equalTo(self.view).equalTo(-HFixHeightBaseOn568(10));
        make.width.equalTo(size.width);
        make.height.equalTo(self.labSignTip.font.lineHeight);
    }];
    
    UIImage *image = [UIImage imageNamed:@"Backspace"];
    self.ivReSign = [[UIImageView alloc] initWithImage:image];
    self.ivReSign.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.ivReSign];
    [self.ivReSign makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labSignTip);
        make.right.equalTo(self.labReSign.left).offset(HFixWidthBaseOn320(-9));
        make.width.equalTo(image.size.width);
        make.height.equalTo(self.labSignTip);
    }];
    
    UIButton *btnClear = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnClear setBackgroundColor:[UIColor clearColor]];
    [btnClear addTarget:self action:@selector(clearAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnClear];
    [btnClear makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labReSign);
        make.left.equalTo(self.ivReSign);
        make.right.equalTo(self.labReSign);
        make.height.equalTo(self.labReSign);
    }];
    
    self.btnCancle = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:COLOR_FONT_GRAY];
        [btn.titleLabel setTextColor:COLOR_MY_WHITE];
        [btn setTitle:@"跳过" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    [self.view addSubview:self.btnCancle];
    [self.btnCancle makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(HFixHeightBaseOn568(-10));
        make.left.equalTo(self.view).offset(HFixWidthBaseOn320(10));
        make.width.equalTo(SCREEN_WIDTH / 2.f - HFixWidthBaseOn320(10));
        make.height.equalTo(BNT_HEIGHT);
    }];
    
    self.btnConfirm = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:COLOR_THEME];
        [btn.titleLabel setTextColor:COLOR_MY_WHITE];
        [btn setTitle:@"确认" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    [self.view addSubview:self.btnConfirm];
    [self.btnConfirm makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnCancle);
        make.left.equalTo(10);
        make.width.equalTo(SCREEN_WIDTH - 20);
        make.height.equalTo(self.btnCancle);
    }];


    self.lineThree = [[UIView alloc] init];
    [self.lineThree setBackgroundColor:COLOR_LINE];
    [self.view addSubview:self.lineThree];
    [self.lineThree makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.btnCancle.top).offset(HFixHeightBaseOn568(-10));
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(LINE_HEIGTH);
    }];
    
    self.labTip = [[TTTAttributedLabel alloc] init];
    self.labTip.font = FONT_13;
    [self.labTip setTextAlignment:NSTextAlignmentCenter];
    self.labTip.text = @"本人确认以上交易,同意将其记入本人账户";
    [self.view addSubview:self.labTip];
    [self.labTip makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.lineThree);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(HFixHeightBaseOn568(33));
    }];

    self.lineTwo = [[UIView alloc] init];
    [self.lineTwo setBackgroundColor:[UIColor clearColor]];
    self.lineTwo.layer.contents = (id)[UIImage imageNamed:@"dotLine"].CGImage;
    [self.view addSubview:self.lineTwo];
    [self.lineTwo makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.labTip.top);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(LINE_HEIGTH);
    }];
    
    self.signView = [[SignView alloc] init];
    [self.signView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.signView];
    [self.signView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labSignTip.bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.lineTwo.top).offset(-2);
    }];
}



- (void)clearAction
{
    [self.signView clearSreen];
}

- (void)cancleAction
{
    UIGraphicsBeginImageContext(CGSizeMake(5, 5));
    [self.signView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    AbstractItems *item = [[AbstractItems alloc] init];
    item.n3 = @"190968";
    item.n11 = self.absItem.n11;
    item.n37 = self.absItem.n37;
    item.n42 = [[NSUserDefaults standardUserDefaults] objectForKey:MerchantNo];
   
    item.n64 = [[NSString stringWithFormat:@"%@%@%@%@%@",item.n0, item.n3, item.n11, item.n37, item.n42] md5HexDigest];
    [[NetAPIManger sharedManger] request_UploadImageWithParrams:[item keyValues]
                                                   andImageInfo:@{@"image":image,@"name":@"10"}
                                                       andBlock:^(id data, NSError *error) {
                                                           AbstractItems *item = (AbstractItems *)data;
                                                           if(!error && [item.n39 isEqualToString:@"00"]){
                                                               ConsumeResultViewController *consumeResult = [[ConsumeResultViewController alloc] init];
                                                               consumeResult.tadeType = self.tadeType;
                                                               consumeResult.rate = self.rate;
                                                               consumeResult.tadeAmount = self.tadeAmount;
                                                               consumeResult.resultStatus = type_success;
                                                               consumeResult.signImage = image;
                                                               [self.navigationController pushViewController:consumeResult animated:YES];
                                                           }else {
                                                               NSError *error = [[NSError alloc] initWithDomain:@"上传签名失败" code:0 userInfo:@{@"NSLocalizedDescription":@"上传签名失败"}];
                                                               [self showStatusBarError:error];
                                                           }
                                                       }];
}

- (void)confirmAction
{
    if (self.signView.isSigned) {
        UIGraphicsBeginImageContext(self.signView.bounds.size);
        [self.signView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage* image=UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [self.btnConfirm setBackgroundColor:COLOR_FONT_GRAY];
        self.btnConfirm.enabled = NO;
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        AbstractItems *item = [[AbstractItems alloc] init];
        item.n3 = @"190968";
        item.n11 = self.absItem.n11;
        item.n37 = self.absItem.n37;
        //item.n39 = self.absItem.n39;
        item.n42 = [[NSUserDefaults standardUserDefaults] objectForKey:MerchantNo];
        
//        item.n59 = @"CHDS-1.0.0";
        item.n64 = [[NSString stringWithFormat:@"%@%@%@%@%@%@",item.n0, item.n3, item.n11, item.n37, item.n42,item.n59] md5HexDigest];
        [[NetAPIManger sharedManger] request_UploadImageWithParrams:[item keyValues]
                                                       andImageInfo:@{@"image":image,@"name":@"10"}
                                                           andBlock:^(id data, NSError *error) {
                                                               NSLog(@"data:%@",data);
                                                               //AbstractItems *item = (AbstractItems *)data;
                                                               
                                                               AbstractItems *item = [AbstractItems objectWithKeyValues:data];
                                                               
                                                               //NSDictionary *item = (NSDictionary *)data;
                                                               if(!error && [item.n39 isEqualToString:@"00"]){
                                                                   
                                                                   [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                                                   
                                                                   ConsumeResultViewController *consumeResult = [[ConsumeResultViewController alloc] init];
                                                                   consumeResult.tadeType = self.tadeType;
                                                                   consumeResult.tadeAmount = self.tadeAmount;
                                                                   consumeResult.resultStatus = type_success;
                                                                   //consumeResult.imagUrl = item.n11;
                                                                   consumeResult.imagUrl = item.n11;
                                                                   [self.navigationController pushViewController:consumeResult animated:YES];
                                                               }else {
                                                                   NSError *error = [[NSError alloc] initWithDomain:@"上传签名失败" code:0 userInfo:@{@"NSLocalizedDescription":@"上传签名失败"}];
                                                                   [self showStatusBarError:error];
                                                                   
                                                                   [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                                                   
                                                                   [self.btnConfirm setBackgroundColor:COLOR_THEME];
                                                                   self.btnConfirm.enabled = YES;
                                                               }
                                                           }];
    }else {
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"请签名" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alterView show];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.btnTitles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConsumeResultCell *cell = (ConsumeResultCell *)[tableView dequeueReusableCellWithIdentifier:LableIdenfity forIndexPath:indexPath];
    [cell setType:[self.btnTitles objectAtIndex:indexPath.row] andContent:[self.tips objectAtIndex:indexPath.row]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

@end
