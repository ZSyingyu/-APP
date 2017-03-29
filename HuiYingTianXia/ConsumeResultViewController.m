//
//  ConsumeResultViewController.m
//  HuiYingTianXia
//
//  Created by tsmc on 15-3-19.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import "ConsumeResultViewController.h"
#import "ApplyWithdrawViewController.h"
#import "ConsumeResultCell.h"
#import "KeyBoardView.h"
#import "UIImageView+WebCache.h"
#import "AbstractItems.h"


@interface ConsumeResultViewController()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong)UIScrollView *baseView;
@property(nonatomic, strong)UILabel *labTitle;
@property(nonatomic, strong)UILabel *labNumber;
@property(nonatomic, strong)UIView *lineView;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSArray *btnTitles;
@property(nonatomic, strong)UIButton *btnConfirm;
//ConsumeSuccess
@property(nonatomic, strong)UIImageView *ivSign;
@property(nonatomic, strong)UITextField *tfPhone;
@property(nonatomic, strong)UIButton *btnSend;
@property(nonatomic, strong)KeyBoardView *keyBoardView;
@property(nonatomic, strong)UIButton *btnMaskLayer;
    //ra
    @property(nonatomic, strong)UIButton *btnRealTime;

@property(strong,nonatomic)AbstractItems *item;
@end
static NSString *LableIdenfity = @"Lable";
static NSString *TextFielddenfity = @"TextField";
static NSString *LableAndImageViewIdenfity = @"LableAndImageView";

@implementation ConsumeResultViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if(self.tadeType == type_consument || self.tadeType == type_revoke){
        self.navigationItem.title = @"交易收据";
    }else if(self.tadeType == type_balance){
        self.navigationItem.title = @"账户余额";
    }
    //[self setBackBarButtonItemWithTitle:@"返回"];
    [self setHomeBackBarButtonItemWithTitle:@"返回"];
    

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
    
//    if (self.resultStatus == type_success) {
//        if(self.tadeType == type_consument || self.tadeType == type_realTime) {
//            self.btnTitles = @[@"交易时间",
//                               @"发  卡  行",
//                               @"卡       号",
//                               @"交易编号",
//                               @"授  权  码",
//                               @"交易类型",
//                               @"交易状态",
//                               @"持卡人签字"];
//
//        }else if (self.tadeType == type_balance) {
//            self.btnTitles = @[@"商户名称",
//                               @"交易类型",
//                               @"交易卡号",
//                               @"交易状态"];
//        }
//    }else if (self.resultStatus == type_fail && self.tadeType == type_consument) {
//        self.btnTitles = @[@"交易时间",
//                           @"发  卡  行",
//                           @"卡       号",
//                           @"交易编号",
//                           @"授  权  码",
//                           @"交易类型",
//                           @"交易状态",
//                           @"失败原因"];
//    }
    __unsafe_unretained UIScrollView *superView = self.baseView;
//    self.labTitle = [[UILabel alloc] init];
//    self.labTitle.font = FONT_15;
//    [self.labTitle setTextAlignment:NSTextAlignmentLeft];
//    [self.labTitle setTextColor:COLOR_FONT_GRAY];
//    if(self.tadeType == type_consument || self.tadeType == type_realTime){
//        self.labTitle.text = @"交易金额";
//    }else if(self.tadeType == type_balance){
//        self.labTitle.text = @"账户余额";
//    }
//    [self.baseView addSubview:self.labTitle];
//    [self.labTitle makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(superView).offset(HFixHeightBaseOn568(15));
//        make.left.equalTo(superView.left).offset(10);
//        make.right.equalTo(superView.right).offset(-10);
//        make.height.equalTo(self.labTitle.font.lineHeight);
//    }];
//    
//    self.labNumber = [[UILabel alloc] init];
//    self.labNumber.font = [UIFont systemFontOfSize:25];
//    [self.labNumber setTextAlignment:NSTextAlignmentRight];
//    self.labNumber.text = self.tadeAmount;
//    [self.baseView addSubview:self.labNumber];
//    [self.labNumber makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.labTitle.bottom);
//        make.left.equalTo(superView.left).offset(10);
//        make.right.equalTo(superView.right).offset(-10);
//        make.height.equalTo(self.labNumber.font.lineHeight + HFixHeightBaseOn568(3));
//    }];
    
//    self.lineView = [[UIView alloc] init];
//    [self.lineView setBackgroundColor:COLOR_LINE];
//    [self.baseView addSubview:self.lineView];
//
//    [self.lineView makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.labNumber.bottom).offset(HFixHeightBaseOn568(8));
//        make.left.equalTo(superView);
//        make.right.equalTo(superView);
//        make.height.equalTo(LINE_HEIGTH);
//        make.width.equalTo(SCREEN_WIDTH);
//    }];
    
//    self.tableView = [[UITableView alloc] init];
//    [self.tableView setScrollEnabled:NO];
//    if (self.tadeType == type_consument || self.tadeType == type_realTime) {
//        
//        [self.tableView registerClass:[ConsumeResultCell class] forCellReuseIdentifier:LableIdenfity];
//        [self.tableView registerClass:[ConsumeResultCell class] forCellReuseIdentifier:LableAndImageViewIdenfity];
//
//    }else if ((self.resultStatus == type_fail && self.tadeType == type_consument)) {
//        [self.tableView registerClass:[ConsumeResultCell class] forCellReuseIdentifier:LableIdenfity];
//    }
//    [self.tableView registerClass:[ConsumeResultCell class] forCellReuseIdentifier:LableIdenfity];
//    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    [self.baseView addSubview:self.tableView];
//    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.lineView.bottom).offset(HFixHeightBaseOn568(5));
//        make.left.equalTo(superView);
//        make.right.equalTo(superView);
//        make.width.equalTo(SCREEN_WIDTH);
//        make.height.equalTo(CELL_HEIGHT * self.btnTitles.count);
//    }];
    
    if (self.resultStatus == type_success &&
        (self.tadeType == type_consument || self.tadeType == type_realTime || self.tadeType == type_revoke)) {
        self.ivSign = [[UIImageView alloc] init];
        [self.baseView addSubview:self.ivSign];
        self.ivSign.contentMode = UIViewContentModeScaleAspectFit;
        [self.ivSign makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(superView).offset(HFixHeightBaseOn568(-20));
            make.centerX.equalTo(superView);
            make.height.equalTo(superView);
            make.width.equalTo(SCREEN_WIDTH);
        }];

//        NSLog(@"imageUrl:%@",self.imagUrl);
        [self.ivSign sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:self.imagUrl]
                                           andPlaceholderImage:nil
                                                       options:SDWebImageRetryFailed
                                                      progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                          
                                                      } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                          
                                                      }];
        
//        self.tfPhone = [[UITextField alloc] init];
//        self.tfPhone.font = FONT_16;
//        self.tfPhone.layer.borderColor = COLOR_LINE.CGColor;
//        self.tfPhone.layer.borderWidth = 1;
//        self.tfPhone.placeholder = @"输入手机号码发送收据";
//        self.tfPhone.userInteractionEnabled = NO;
//        [self.tfPhone setTextAlignment:NSTextAlignmentCenter];
//        [self.baseView addSubview:self.tfPhone];
//        [self.tfPhone makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.ivSign.bottom).offset(5);
//            make.left.equalTo(superView).offset(HFixWidthBaseOn320(10));
//            make.width.equalTo(HFixWidthBaseOn320(190));
//            make.height.equalTo(BNT_HEIGHT);
//        }];
//        
//        UIButton *btn = [[UIButton alloc] init];
//        [btn setBackgroundColor:[UIColor clearColor]];
//        [btn addTarget:self action:@selector(tapTfphone) forControlEvents:UIControlEventTouchUpInside];
//        [self.baseView addSubview:btn];
//        [btn makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self.tfPhone);
//        }];
//        
//        self.btnSend = ({
//            UIButton *btn = [[UIButton alloc] init];
//            [btn setBackgroundColor:COLOR_THEME];
//            [btn setTitleColor:COLOR_MY_WHITE forState:UIControlStateNormal];
//            [btn addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
//            [btn setTitle:@"发送" forState:UIControlStateNormal];
//            btn;
//        });
//        [self.baseView addSubview:self.btnSend];
//        [self.btnSend makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.tfPhone);
//            make.left.equalTo(self.tfPhone.right).offset(HFixWidthBaseOn320(10));
//            make.right.equalTo(superView).offset(HFixWidthBaseOn320(-10));
//            make.height.equalTo(self.tfPhone);
//        }];
//        
//        self.btnMaskLayer = ({
//            UIButton *btn = [[UIButton alloc] initWithFrame:self.view.bounds];
//            [btn setBackgroundColor:[UIColor clearColor]];
//            [btn setTitleColor:COLOR_MY_WHITE forState:UIControlStateNormal];
//            [btn addTarget:self action:@selector(hideKeyboardAction) forControlEvents:UIControlEventTouchUpInside];
//            btn;
//        });
//        [self.view addSubview:self.btnMaskLayer];
//        [self.btnMaskLayer setHidden:YES];
//        
//        [self getKeyBoardView];
    }else if (self.resultStatus == type_success && self.tadeType == type_balance) {
        AbstractItems *item = [[AbstractItems alloc]init];
        
        UILabel *labIndicate = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, SCREEN_WIDTH, 35)];
        [labIndicate setText:@"账户余额"];
        [labIndicate setFont:[UIFont systemFontOfSize:20]];
        [labIndicate setTextColor:[UIColor blackColor]];
        [self.baseView addSubview:labIndicate];
        
        UILabel *labBalance = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, SCREEN_WIDTH, 70)];
        [labBalance setText:self.tadeAmount];
        [labBalance setFont:[UIFont systemFontOfSize:30]];
        [labBalance setTextColor:[UIColor blackColor]];
        [self.baseView addSubview:labBalance];
        
        UIView *intervalView = [[UIView alloc]initWithFrame:CGRectMake(0, 120, SCREEN_WIDTH, 1)];
        [intervalView setBackgroundColor:[UIColor lightGrayColor]];
        [self.baseView addSubview:intervalView];
        
        UILabel *labBusiness = [[UILabel alloc]initWithFrame:CGRectMake(10, 140, 100, 35)];
        [labBusiness setText:@"商户名称"];
        [labBusiness setFont:[UIFont systemFontOfSize:20]];
        [labBusiness setTextColor:[UIColor lightGrayColor]];
        [self.baseView addSubview:labBusiness];
        
        UILabel *labName = [[UILabel alloc]initWithFrame:CGRectMake(100, 140, SCREEN_WIDTH - 100, 35)];
        item.n5 = [[NSUserDefaults standardUserDefaults] objectForKey:MerchantName];
        [labName setText:item.n5];
        [labName setFont:[UIFont systemFontOfSize:20]];
        [labName setTextColor:[UIColor blackColor]];
        [self.baseView addSubview:labName];
        
        UILabel *labType = [[UILabel alloc]initWithFrame:CGRectMake(10, 180, 100, 35)];
        [labType setText:@"交易类型"];
        [labType setFont:[UIFont systemFontOfSize:20]];
        [labType setTextColor:[UIColor lightGrayColor]];
        [self.baseView addSubview:labType];
        
        UILabel *labTypeName = [[UILabel alloc]initWithFrame:CGRectMake(100, 180, SCREEN_WIDTH - 100, 35)];
        [labTypeName setText:@"余额查询"];
        [labTypeName setFont:[UIFont systemFontOfSize:20]];
        [labTypeName setTextColor:[UIColor blackColor]];
        [self.baseView addSubview:labTypeName];
        
        UILabel *labCardNumber = [[UILabel alloc]initWithFrame:CGRectMake(10, 220, 100, 35)];
        [labCardNumber setText:@"交易卡号"];
        [labCardNumber setFont:[UIFont systemFontOfSize:20]];
        [labCardNumber setTextColor:[UIColor lightGrayColor]];
        [self.baseView addSubview:labCardNumber];
        
        
        UILabel *labNumber = [[UILabel alloc]initWithFrame:CGRectMake(100, 220, SCREEN_WIDTH - 100, 35)];
        item.n2 = [self.cardInfo objectForKey:@"cardNumber"];
        [labNumber setText:item.n2];
        [labNumber setFont:[UIFont systemFontOfSize:20]];
        [labNumber setTextColor:[UIColor blackColor]];
        [self.baseView addSubview:labNumber];
        
    }


//    if (self.tadeType == type_consument ||
//        self.tadeType == type_balance ||
//        self.tadeType == type_realTime){
//        self.btnConfirm = ({
//            UIButton *btn = [[UIButton alloc] init];
//            [btn setBackgroundColor:COLOR_THEME];
//            [btn setTitleColor:COLOR_MY_WHITE forState:UIControlStateNormal];
//            [btn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
//            [btn setTitle:@"确定" forState:UIControlStateNormal];
//            btn;
//        });
//        [self.baseView addSubview:self.btnConfirm];
//        [self.btnConfirm makeConstraints:^(MASConstraintMaker *make) {
//            if (self.resultStatus == type_success && (self.tadeType == type_consument || self.tadeType == type_realTime)) {
//                make.top.equalTo(self.ivSign.bottom).offset(HFixHeightBaseOn568(9));
//            }else {
//                make.top.equalTo(self.tableView.bottom).offset(HFixHeightBaseOn568(52));
//            }
//            make.left.equalTo(superView).offset(HFixWidthBaseOn320(10));
//            //make.left.equalTo(superView.left).offset(HFixWidthBaseOn320(10));
//            if(self.tadeType == type_consument){
//                //make.right.equalTo(superView.right).offset(HFixWidthBaseOn320(-10));
//                make.right.equalTo(superView).offset(HFixWidthBaseOn320(-10));
//            }else if (self.tadeType == type_realTime) {
//                make.width.equalTo(SCREEN_WIDTH / 2. - HFixHeightBaseOn568(10));
//            }
//            make.height.equalTo(BNT_HEIGHT);
//        }];
//
//        [self.baseView updateConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self.btnConfirm).offset(10);
//        }];
//    }
    
    if(self.tadeType == type_realTime) {
        self.btnRealTime = [[UIButton alloc] init];
        [self.btnRealTime setBackgroundColor:COLOR_FONT_GRAY];
        [self.btnRealTime setTitleColor:COLOR_MY_WHITE forState:UIControlStateNormal];
        [self.btnRealTime addTarget:self action:@selector(withdrawAction) forControlEvents:UIControlEventTouchUpInside];
        [self.btnRealTime setTitle:@"申请提现" forState:UIControlStateNormal];
        [self.baseView addSubview:self.btnRealTime];
        [self.btnRealTime makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.btnConfirm);
            make.left.equalTo(self.btnConfirm.right);
            make.width.equalTo(self.btnConfirm);
            make.height.equalTo(BNT_HEIGHT);
        }];
//        [self.baseView updateConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self.btnRealTime).offset(10);
//        }];

    }
    
    [self.view updateConstraintsIfNeeded];
}


- (void)getKeyBoardView
{
    
    __unsafe_unretained ConsumeResultViewController *weakSelf = self;
    self.keyBoardView = [[KeyBoardView alloc] init];
    self.keyBoardView.keyBoardClick = ^(NSInteger number){
        NSMutableString *content = [NSMutableString stringWithString:weakSelf.tfPhone.text];
        switch (number) {
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
            case 7:
            case 8:
            case 9:
                if (content.length < 11) {
                    [content appendString:[NSString stringWithFormat:@"%zd",number]];
                }
                break;
            case 11:
                if (content.length < 11) {
                    [content appendString:@"0"];
                }
                break;
            case 10://clear
                content = [NSMutableString stringWithString:@""];
                break;
            case 12://delete
                if (content.length > 0) {
                    [content deleteCharactersInRange:NSMakeRange(content.length-1, 1)];
                }
                break;
            default:
                break;
        }
        weakSelf.tfPhone.text = content;
    };
    [self.view addSubview:self.keyBoardView];
    [self.keyBoardView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view.bottom);
        make.height.equalTo([KeyBoardView getHeight]);
    }];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    if((self.tadeType == type_consument || self.tadeType == type_realTime) && self.resultStatus == type_success){
        [self.baseView setContentSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+20)];
    }
}

//确认按键
//- (void)confirmAction
//{
//
//}

- (void)sendAction
{
    
}

//提现
- (void)withdrawAction
{
    ApplyWithdrawViewController *applyWithdrawViewController = [[ApplyWithdrawViewController alloc] init];
    [self.navigationController pushViewController:applyWithdrawViewController animated:YES];
}

- (void)hideKeyboardAction
{
    [UIView animateKeyframesWithDuration:0.25 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        CGFloat keyboardH  = [KeyBoardView getHeight];
        self.keyBoardView.transform = CGAffineTransformMakeTranslation(0, keyboardH);
        [self.baseView setContentOffset:CGPointMake(0, 0)];
    } completion:^(BOOL finished) {
        [self.btnMaskLayer setHidden:YES];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];
}

- (void)tapTfphone
{
    CGFloat y = CGRectGetMaxY(self.btnConfirm.frame);
    [UIView animateKeyframesWithDuration:0.25 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        CGFloat keyboardH  = [KeyBoardView getHeight];
        self.keyBoardView.transform = CGAffineTransformMakeTranslation(0, -keyboardH);
        [self.baseView setContentOffset:CGPointMake(0, keyboardH - SCREEN_HEIGHT + y + 20 + HFixHeightBaseOn568(9) + BNT_HEIGHT)];
    } completion:^(BOOL finished) {
        [self.btnMaskLayer setHidden:NO];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.btnTitles count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if ([self.resultType isEqualToString:@"ConsumeFail"]) {
//        if (indexPath.row == self.btnTitles.count - 1) {
//            ConsumeResultCell *cell = (ConsumeResultCell *)[[ConsumeResultCell alloc]  initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LableIdenfity];
//            [cell setType:[self.btnTitles objectAtIndex:indexPath.row] andContent:@""];
//            return [cell getCellHeight];
//        }
//    }
    return CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConsumeResultCell *cell = nil;
    if ((self.resultStatus == type_fail && self.tadeType == type_consument)) {
        if (indexPath.row == self.btnTitles.count - 1) {
            cell = (ConsumeResultCell *)[tableView dequeueReusableCellWithIdentifier:LableIdenfity forIndexPath:indexPath];
            cell.labContent.textColor = COLOR_FONT_RED;
        }else if (indexPath.row == self.btnTitles.count - 2) {
            cell = (ConsumeResultCell *)[tableView dequeueReusableCellWithIdentifier:LableAndImageViewIdenfity forIndexPath:indexPath];
            [cell setStatus:NO];
        }else {
            cell = (ConsumeResultCell *)[tableView dequeueReusableCellWithIdentifier:LableIdenfity forIndexPath:indexPath];
        }
    
    }else if ((self.resultStatus == type_success && self.tadeType == type_consument)) {
        if(indexPath.row == self.btnTitles.count - 2) {
            cell = (ConsumeResultCell *)[tableView dequeueReusableCellWithIdentifier:LableAndImageViewIdenfity forIndexPath:indexPath];
            [cell setStatus:YES];
        }else {
            cell = (ConsumeResultCell *)[tableView dequeueReusableCellWithIdentifier:LableIdenfity forIndexPath:indexPath];
        }
    }else {
        cell = (ConsumeResultCell *)[tableView dequeueReusableCellWithIdentifier:LableIdenfity forIndexPath:indexPath];
    }
    
    [cell setType:[self.btnTitles objectAtIndex:indexPath.row] andContent:@"交通银行"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

@end
