//
//  BandingListViewController.m
//  HuiYingTianXia
//
//  Created by 朱颖宇 on 15/10/21.
//  Copyright © 2015年 tsmc. All rights reserved.
//

#import "BandingListViewController.h"
#import "RaiseQuotaViewController.h"
#import "AbstractItems.h"
#import "NSString+MD5HexDigest.h"
#import "MJExtension.h"
#import "AddRaiseViewController.h"
#import "UIScrollView+MJRefresh.h"
#import "MJRefreshHeader.h"
#import "MJRefreshFooter.h"
#import "ResponseDictionaryTool.h"
#import "MBProgressHUD+Add.h"

@interface BandingListViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSInteger _tag;
}
@property(nonatomic, strong)UIScrollView *baseView;//底层scrollview
@property(strong,nonatomic)UIView *topImageView;//顶部图片
@property(strong,nonatomic)UIButton *successBtn;//提额成功btn
@property(strong,nonatomic)UIButton *checkingBtn;//审核中btn
@property(strong,nonatomic)UIButton *failBtn;//提额失败btn
@property(strong,nonatomic)UIButton *setupBtn;//创建btn
@property(strong,nonatomic)UITableView *cardListTableView;//卡片列表
@property(strong,nonatomic)UIView *cardView;//卡片view
@property(strong,nonatomic)UIImageView *cardImageView;//卡片背景
@property(nonatomic, strong)NSMutableArray *cardDatas;//卡片信息数组
@property(nonatomic, assign)NSInteger page;//分页
@property(strong,nonatomic)NSString *bankNum;
@property(strong,nonatomic)NSString *bankName;

@property(strong,nonatomic)UILabel *banknameLabel;
@property(strong,nonatomic)UILabel *cardNumLabel;
@property(strong,nonatomic)UILabel *quotaLabel;

@property(strong,nonatomic)NSMutableArray *successArray;//提额成功数组
@property(strong,nonatomic)NSMutableArray *checkingArray;//审核中数组
@property(strong,nonatomic)NSMutableArray *failArray;//提额拒绝数组
@property(strong,nonatomic)NSMutableArray *setupArray;//创建数组
@property(strong,nonatomic)NSMutableArray *cardDataArray;//数据源


@end

static NSString *cellIdenfity = @"cell";
static NSInteger tag;

@implementation BandingListViewController

typedef enum{
    loadRefresh,
    loadMore
}LoadType;

-(NSMutableArray *)cardDataArray {
    if (!_cardDataArray) {
        _cardDataArray = [[NSMutableArray alloc] init];
    }
    return _cardDataArray;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestListData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"绑定列表"];
    [self setBackBarButtonItemWithTitle:@"返回"];
    
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"添加卡片"] style:UIBarButtonItemStyleBordered target:self action:@selector(AddRaiseAction)];
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 40, 0, 40, 20)];
    [rightButton setImage:[UIImage imageNamed:@"添加卡片"] forState:UIControlStateNormal];
    rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -20);
    [rightButton addTarget:self action:@selector(AddRaiseAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    self.topImageView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 35)];
    self.topImageView.backgroundColor = [UIColor clearColor];
    self.topImageView.layer.cornerRadius = 10.0;
    self.topImageView.layer.masksToBounds = YES;
    [self.view addSubview:self.topImageView];
    
    self.successBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.successBtn.frame = CGRectMake(0, 0, self.topImageView.frame.size.width/2, self.topImageView.frame.size.height);
    [self.successBtn setTitle:@"认证成功" forState:UIControlStateNormal];
    [self.successBtn setFont:[UIFont systemFontOfSize:18]];
    [self.successBtn setTintColor:[UIColor whiteColor]];
    [self.successBtn setBackgroundColor:COLOR_THEME];
    [self.successBtn addTarget:self action:@selector(successAction) forControlEvents:UIControlEventTouchUpInside];
    [self.topImageView addSubview:self.successBtn];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.successBtn.frame), 0, 1, self.topImageView.frame.size.height)];
    line1.backgroundColor = COLOR_FONT_GRAY;
    [self.topImageView addSubview:line1];
    
    self.setupBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.setupBtn.frame = CGRectMake(CGRectGetMaxX(self.successBtn.frame), self.successBtn.frame.origin.y, self.topImageView.frame.size.width/2, self.topImageView.frame.size.height);
    [self.setupBtn setTitle:@"认证失败" forState:UIControlStateNormal];
    [self.setupBtn setFont:[UIFont systemFontOfSize:18]];
    [self.setupBtn setTintColor:[UIColor blackColor]];
    [self.setupBtn setBackgroundColor:[UIColor whiteColor]];
    [self.setupBtn addTarget:self action:@selector(setupBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.topImageView addSubview:self.setupBtn];
    
    self.cardListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topImageView.frame), SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.cardListTableView.backgroundColor = [UIColor clearColor];
    self.cardListTableView.delegate = self;
    self.cardListTableView.dataSource = self;
    self.cardListTableView.contentInset = UIEdgeInsetsMake(0, 0, 165, 0);
    self.cardListTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.cardListTableView];
    
//    [self.successBtn setBackgroundImage:[UIImage imageNamed:@"提额成功"] forState:UIControlStateNormal];
//    [self.checkingBtn setBackgroundImage:nil forState:UIControlStateNormal];
//    [self.failBtn setBackgroundImage:nil forState:UIControlStateNormal];
//    [self.successBtn setTintColor:[UIColor whiteColor]];
//    [self.checkingBtn setTintColor:[UIColor blackColor]];
//    [self.failBtn setTintColor:[UIColor blackColor]];
    
    
    //    [self requestData];
    //
    //    NSLog(@"%@",self.listArray);
    _tag = 1;
    [self requestListData];
}

- (void)AddRaiseAction {
    NSLog(@"添加提额");
    AddRaiseViewController *addVc = [[AddRaiseViewController alloc] init];
    [self.navigationController pushViewController:addVc animated:YES];
}

- (void)successAction {
    NSLog(@"提额成功");
    _tag = 1;
    [self requestListData];
    [self.successBtn setBackgroundColor:COLOR_THEME];
    [self.setupBtn setBackgroundColor:[UIColor whiteColor]];
    [self.successBtn setTintColor:[UIColor whiteColor]];
    [self.checkingBtn setTintColor:[UIColor blackColor]];
    [self.failBtn setTintColor:[UIColor blackColor]];
    [self.setupBtn setTintColor:[UIColor blackColor]];
}

- (void)setupBtnAction {
    NSLog(@"提额拒绝");
    _tag = 2;
    [self requestListData];
    [self.successBtn setBackgroundColor:[UIColor whiteColor]];
    [self.setupBtn setBackgroundColor:COLOR_THEME];
    [self.successBtn setTintColor:[UIColor blackColor]];
    [self.setupBtn setTintColor:[UIColor whiteColor]];
}

#pragma mark - tableview
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    return 120;
    if (self.cardDataArray == self.successArray) {
        return 120;
    }else {
        return 125;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSLog(@"count:%lu",(unsigned long)self.listArray.count);
    return self.cardDataArray.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UITableViewCell *cell = nil;
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdenfity];
        
        self.cardView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 90)];
        self.cardView.backgroundColor = COLOR_THEME;
        
        self.cardImageView = [[UIImageView alloc] init];
        self.cardImageView.frame = CGRectMake(10, 10, SCREEN_WIDTH - 20, 90);
        self.cardImageView.backgroundColor = [UIColor clearColor];
        self.cardImageView.image = [UIImage imageNamed:@"卡片背景"];
        if (self.cardDataArray == self.failArray || self.cardDataArray == self.setupArray ) {
            self.cardImageView.image = [UIImage imageNamed:@"提额失败背景"];
        }
        
        if (self.cardDataArray == self.successArray) {
            self.cardImageView.frame = CGRectMake(10, 10, SCREEN_WIDTH - 20, 100);
        }
        
        self.banknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 140, 30)];
        self.banknameLabel.font = [UIFont systemFontOfSize:20];
        //        self.banknameLabel.textAlignment = NSTextAlignmentCenter;
        self.banknameLabel.textColor = [UIColor whiteColor];
        [self.cardImageView addSubview:self.banknameLabel];
        
        UILabel *cardTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.banknameLabel.frame) - 5, self.banknameLabel.frame.size.height/3 + 2, 60, self.banknameLabel.frame.size.height)];
        cardTypeLabel.textColor = [UIColor whiteColor];
        cardTypeLabel.text = @"信用卡";
        [self.cardImageView addSubview:cardTypeLabel];
        
        self.cardNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.banknameLabel.frame) + 10, self.cardView.frame.size.width, 30)];
        self.cardNumLabel.textAlignment = NSTextAlignmentCenter;
        self.cardNumLabel.textColor = [UIColor whiteColor];
        self.cardNumLabel.font = [UIFont systemFontOfSize:20];
        [self.cardImageView addSubview:self.cardNumLabel];
        
        if (self.cardDataArray == self.successArray) {
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.banknameLabel.frame.origin.x, CGRectGetMaxY(self.banknameLabel.frame) + 1, 80, self.banknameLabel.frame.size.height)];
            titleLabel.text = @"提额额度:";
            titleLabel.textColor = [UIColor whiteColor];
            [self.cardImageView addSubview:titleLabel];
            
            self.quotaLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame), titleLabel.frame.origin.y, self.cardImageView.frame.size.width - CGRectGetMaxX(titleLabel.frame), self.banknameLabel.frame.size.height)];
            self.quotaLabel.font = [UIFont systemFontOfSize:18];
            self.quotaLabel.textColor = [UIColor whiteColor];
            [self.cardImageView addSubview:self.quotaLabel];
            
            self.cardNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.quotaLabel.frame) + 1, self.cardView.frame.size.width, 30)];
            self.cardNumLabel.textAlignment = NSTextAlignmentCenter;
            self.cardNumLabel.textColor = [UIColor whiteColor];
            self.cardNumLabel.font = [UIFont systemFontOfSize:20];
            [self.cardImageView addSubview:self.cardNumLabel];
        }
        
        [cell.contentView addSubview:self.cardImageView];
    }
    
    OrderItem *order = self.cardDataArray[indexPath.row];
    //    if (order.bankName.length == 6) {
    //        self.banknameLabel.text = [order.bankName substringFromIndex:2];
    //    }else if (order.bankName.length == 4) {
    //        self.banknameLabel.text = order.bankName;
    //    }
    self.banknameLabel.text = order.bankName;
    if (order.bankAccount.length > 10) {
        self.cardNumLabel.text = [NSString stringWithFormat:@"%@********%@",[order.bankAccount substringToIndex:6],[order.bankAccount substringFromIndex:order.bankAccount.length - 4]];
    }else {
        self.cardNumLabel.text = order.bankAccount;
    }
    self.quotaLabel.text = order.singleLimit;
    
    NSLog(@"name:%@",self.banknameLabel.text);
    NSLog(@"num:%@",self.cardNumLabel.text);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    RaiseQuotaViewController *raiseVc = [[RaiseQuotaViewController alloc] init];
    OrderItem *order = self.cardDataArray[indexPath.row];
    raiseVc.name = order.bankAccountName;
    raiseVc.cardid = order.idCardNumber;
    raiseVc.bankname = order.bankName;
    raiseVc.banknumber = order.bankAccount;
    raiseVc.status = order.increaseLimitStatus;
    raiseVc.quota = order.singleLimit;
    raiseVc.checkview = order.examineResult;
    raiseVc.phoneNo = order.bankPhone;
    for (NSDictionary *dic in order.images) {
        NSLog(@"type:%@",dic[@"type"]);
        if ([dic[@"type"] isEqualToString:@"10A"]) {
            raiseVc.cardfronturl = dic[@"imageUrl"];
            NSLog(@"url:%@",raiseVc.cardfronturl);
        }else if ([dic[@"type"] isEqualToString:@"10B"]) {
            raiseVc.cardbackurl = dic[@"imageUrl"];
            NSLog(@"url:%@",raiseVc.cardbackurl);
        }else if ([dic[@"type"] isEqualToString:@"10D"]) {
            raiseVc.bankfronturl = dic[@"imageUrl"];
            NSLog(@"url:%@",raiseVc.bankfronturl);
        }else if ([dic[@"type"] isEqualToString:@"10E"]) {
            raiseVc.bankbackurl = dic[@"imageUrl"];
            NSLog(@"url:%@",raiseVc.bankbackurl);
        }else if ([dic[@"type"] isEqualToString:@"10F"]) {
            raiseVc.handcardurl = dic[@"imageUrl"];
            NSLog(@"url:%@",raiseVc.handcardurl);
        }
    }
    NSLog(@"idea:%@",raiseVc.checkview);
    NSLog(@"name:%@",raiseVc.name);
    NSLog(@"id:%@",raiseVc.cardid);
    NSLog(@"bankname:%@",raiseVc.bankname);
    NSLog(@"num:%@",raiseVc.banknumber);
    NSLog(@"status:%@",raiseVc.status);
    NSLog(@"quota:%@",raiseVc.quota);
    
    [self.navigationController pushViewController:raiseVc animated:YES];
    
    
}

-(void)requestListData {
    AbstractItems *items = [[AbstractItems alloc] init];
    items.n0 = @"0700";
    items.n3 = @"190932";
    items.n42 = [[NSUserDefaults standardUserDefaults] objectForKey:MerchantNo];
    NSString *macStr = [NSString stringWithFormat:@"%@%@%@%@%@",items.n0,items.n3,items.n42,items.n59, MainKey];
    NSLog(@"macStr:%@",macStr);
    items.n64 = [[macStr md5HexDigest] uppercaseString];
    
    [self.successArray removeAllObjects];
    [self.failArray removeAllObjects];
    
    [[NetAPIManger sharedManger] request_RaiseQuotaListWithParams:[items keyValues] andBlock:^(id data, NSError *error) {
        AbstractItems *item = (AbstractItems *)data;
        if ([item.n39 isEqualToString:@"00"]) {
            NSLog(@"成功");
            NSLog(@"count:%lu",(unsigned long)item.n57.count);
            if (item.n57.count != 0) {
                for (OrderItem *order in item.n57) {
                    self.listArray = item.n57;
                    NSLog(@"%@",self.listArray);
                }
                
                self.successArray = [NSMutableArray array];
                self.checkingArray = [NSMutableArray array];
                self.failArray = [NSMutableArray array];
                self.setupArray = [NSMutableArray array];
                for (OrderItem *order in self.listArray) {
                    NSLog(@"order:%@",order);
                    NSLog(@"status:%@",order.increaseLimitStatus);
                    if ([order.increaseLimitStatus isEqualToString:@"审核通过"]) {
                        [self.successArray addObject:order];
                        
                    }else if ([order.increaseLimitStatus isEqualToString:@"审核拒绝"]) {
                        [self.failArray addObject:order];
                        
                    }else if ([order.increaseLimitStatus isEqualToString:@"等待审核"] || [order.increaseLimitStatus isEqualToString:@"重新审核"]) {
                        [self.checkingArray addObject:order];
                        
                    }else if ([order.increaseLimitStatus isEqualToString:@"创建"]) {
                        [self.setupArray addObject:order];
                        
                    }
                }
                if (_tag == 1) {
                    self.cardDataArray = self.successArray;
                }else if (_tag == 2) {
                    self.cardDataArray = self.failArray;
                }
                [self.cardListTableView reloadData];
            }
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
}

@end
