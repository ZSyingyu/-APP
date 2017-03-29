//
//  ConsumDetailsViewController.m
//  HuiYingTianXia
//
//  Created by tsmc on 15/5/6.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import "ConsumDetailsViewController.h"
#import "SwingCardViewController.h"
#import "ConsumeResultCell.h"
#import "KeyBoardView.h"
#import "NetAPIManger.h"
#import "POSManger.h"
#import "UIImageView+WebCache.h"
#import "BalanceDetailViewController.h"
#import "AC_POSManger.h"
#import "AbstractItems.h"
#import "NSString+MD5HexDigest.h"
#import "MJExtension.h"
#import "QueryrRecordViewController.h"
#import "MBProgressHUD+Add.h"
#import "OrderItem.h"
#import "CashDictionary.h"
#import "ResponseDictionaryTool.h"

@interface ConsumDetailsViewController()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

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

//提现,撤销按钮
@property(strong,nonatomic)UIButton *revokeBtn;
@property(strong,nonatomic)UIButton *cashBtn;

//提现状态显示
@property(strong,nonatomic)UILabel *cashLabel;

@end

@implementation ConsumDetailsViewController
static NSString *LableIdenfity = @"Lable";
static NSString *LableAndImageViewIdenfity = @"LableAndImageView";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"交易详情";
    [self setBackBarButtonItemWithTitle:@"返回"];
    
    self.baseView = [[UIScrollView alloc] init];
    [self.baseView setBackgroundColor:[UIColor clearColor]];
    [self.baseView setBounces:YES];
    self.baseView.scrollEnabled = YES;
    
    [self.view addSubview:self.baseView];
    self.baseView.contentSize = CGSizeMake(SCREEN_WIDTH, 1000);
    [self.baseView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.width.equalTo(SCREEN_WIDTH);
//        make.height.equalTo(800);
    }];
    
    if (IPHONE4__4S) {
        self.ivSign = [[UIImageView alloc] init];
        [self.baseView addSubview:self.ivSign];
        //    self.ivSign.contentMode = UIViewContentModeScaleAspectFit;
        [self.ivSign makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.baseView).offset(HFixHeightBaseOn568(0));
            //        make.centerX.equalTo(self.view);
            make.left.equalTo(self.view).offset(0);
            make.right.equalTo(self.view).offset(0);
            make.height.equalTo(340);
            make.width.equalTo(SCREEN_WIDTH);
        }];
    }else{
        self.ivSign = [[UIImageView alloc] init];
        [self.baseView addSubview:self.ivSign];
            self.ivSign.contentMode = UIViewContentModeScaleAspectFit;
        [self.ivSign makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.baseView).offset(HFixHeightBaseOn568(0));
            //        make.centerX.equalTo(self.view);
            make.left.equalTo(self.view).offset(0);
            make.right.equalTo(self.view).offset(0);
            make.height.equalTo(400);
            make.width.equalTo(SCREEN_WIDTH);
        }];
    }
    
    
    NSLog(@"%f", self.baseView.frame.size.height);
    NSLog(@"tadetype:%u",self.tadeType);
    NSLog(@"status:%@",self.orderItem.status);
    NSLog(@"settlecycle:%d",self.orderItem.settleCycle);
    
    
    if (self.tadeType == type_consument && [self.orderItem.status isEqualToString:@"交易成功"] && self.orderItem.settleCycle == 1) {
        self.cashBtn = [[UIButton alloc] init];
        [self.cashBtn setBackgroundColor:COLOR_THEME];
        [self.cashBtn setTitle:@"提现" forState:UIControlStateNormal];
        [self.cashBtn setTitleColor:COLOR_MY_WHITE forState:UIControlStateNormal];
        [self.cashBtn addTarget:self action:@selector(cashAction) forControlEvents:UIControlEventTouchUpInside];
        [self.cashBtn setHidden:YES];
        [self.baseView addSubview:self.cashBtn];
        [self.cashBtn makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.ivSign.bottom).offset(20);
            make.left.equalTo(self.view).offset(20);
            make.right.equalTo(self.view).offset(-20);
            make.height.equalTo(40);
        }];
    }else if (self.tadeType == type_consument && [self.orderItem.status isEqualToString:@"交易成功"] && self.orderItem.settleCycle == 0) {
        self.cashLabel = [[UILabel alloc] init];
        [self.cashLabel setBackgroundColor:[UIColor clearColor]];
        self.cashLabel.font = [UIFont systemFontOfSize:25];
        self.cashLabel.text = [[CashDictionary cashDic] valueForKey:self.orderItem.payStatus];
        [self.baseView addSubview:self.cashLabel];
        [self.cashLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.ivSign.bottom).offset(20);
            make.left.equalTo(self.view).offset(20);
            make.right.equalTo(self.view).offset(-20);
            make.height.equalTo(40);
        }];

    }
   
    
//    self.revokeBtn = [[UIButton alloc] init];
//    [self.revokeBtn setBackgroundColor:COLOR_THEME];
//    [self.revokeBtn setTitle:@"撤销" forState:UIControlStateNormal];
//    [self.revokeBtn setTitleColor:COLOR_MY_WHITE forState:UIControlStateNormal];
//    [self.revokeBtn addTarget:self action:@selector(revokeAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.baseView addSubview:self.revokeBtn];
//    [self.revokeBtn makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.ivSign.bottom).offset(20);
//        make.right.equalTo(self.view).offset(-20);
//        make.height.equalTo(self.cashBtn);
//        make.width.equalTo(self.cashBtn);
//    }];
    
    NSLog(@"url:%@",self.orderItem.imageUrl);
    [self.ivSign sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:self.orderItem.imageUrl]
                                           andPlaceholderImage:nil
                                                       options:SDWebImageRetryFailed
                                                      progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                          
                                                      } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                          
                                                      }];
    

    
    [self.view updateConstraintsIfNeeded];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

-(void)cashAction{
    
    AbstractItems *item = [[AbstractItems alloc]init];
    item.n0 = @"0200";
    item.n3 = @"190989";
    item.n11 = self.originalVoucherNo;
    NSLog(@"n11:%@",item.n11);
    item.n60 = self.orderNo;
    NSLog(@"n60:%@",item.n60);
    NSString *str = [NSString stringWithFormat:@"%@%@%@%@%@%@",item.n0,item.n3,item.n11,item.n59,item.n60,MainKey];
    NSLog(@"str:%@",str);
    item.n64 = [[str md5HexDigest] uppercaseString];
    
    [[NetAPIManger sharedManger] request_CashWithParams:[item keyValues] andBlock:^(id data, NSError *error) {
        AbstractItems *item = (AbstractItems *)data;
        if (!error && [item.n39 isEqualToString:@"00"]) {
            QueryrRecordViewController *queryVc = [[QueryrRecordViewController alloc] init];
            [MBProgressHUD showSuccess:@"提现受理中" toView:queryVc.view];
            [self.navigationController pushViewController:queryVc animated:YES];
        
        }else{
            NSString *error = [[ResponseDictionaryTool responseDic] objectForKey:item.n39];
            //NSLog(@"error:%@",error);
            [MBProgressHUD showSuccess:error toView:self.view];
        }
    }];
    
}

- (void)getKeyBoardView
{
    
    __unsafe_unretained ConsumDetailsViewController *weakSelf = self;
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
    [self.baseView setContentSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+20)];
}

//确认按键
- (void)confirmAction
{
    
}

- (void)sendAction
{
    [[POSManger shareInstance] openAndBandingWithBolck:^(BOOL result, NSString *message) {
        if (result == SUCCESS) {
            SwingCardViewController *swingCardVC = [[SwingCardViewController alloc] init];
            swingCardVC.tadeType = type_revoke;
            swingCardVC.tadeAmount = self.orderItem.strAmount;
            swingCardVC.orderItem = self.orderItem;
            [self.navigationController pushViewController:swingCardVC animated:YES];
        }else {
            NSLog(@"%@",message);
        }
    }];
}

//提现
//- (void)withdrawAction
//{
//    ApplyWithdrawViewController *applyWithdrawViewController = [[ApplyWithdrawViewController alloc] init];
//    [self.navigationController pushViewController:applyWithdrawViewController animated:YES];
//}

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
    if ([self.orderItem.tradeType isEqualToString:@"消费"]) {
        if([self.orderItem.status isEqualToString:@"交易成功"]) {
            if(indexPath.row == self.btnTitles.count - 2) {
                cell = (ConsumeResultCell *)[tableView dequeueReusableCellWithIdentifier:LableAndImageViewIdenfity forIndexPath:indexPath];
                [cell setStatus:YES];
            }else {
                cell = (ConsumeResultCell *)[tableView dequeueReusableCellWithIdentifier:LableIdenfity forIndexPath:indexPath];
            }
        }else if([self.orderItem.status isEqualToString:@"交易失败"]) {
            if (indexPath.row == self.btnTitles.count - 1) {
                cell = (ConsumeResultCell *)[tableView dequeueReusableCellWithIdentifier:LableIdenfity forIndexPath:indexPath];
                cell.labContent.textColor = COLOR_FONT_RED;
            }else if (indexPath.row == self.btnTitles.count - 2) {
                cell = (ConsumeResultCell *)[tableView dequeueReusableCellWithIdentifier:LableAndImageViewIdenfity forIndexPath:indexPath];
                [cell setStatus:NO];
            }else {
                cell = (ConsumeResultCell *)[tableView dequeueReusableCellWithIdentifier:LableIdenfity forIndexPath:indexPath];
            }
        }
    }
    [cell setType:[self.btnTitles objectAtIndex:indexPath.row] andContent:@"交通银行"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
@end
