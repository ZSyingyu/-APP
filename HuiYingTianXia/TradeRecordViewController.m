//
//  TradeRecordViewController.m
//  HuiYingTianXia
//
//  Created by 朱颖宇 on 15/8/24.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import "TradeRecordViewController.h"
#import "AbstractItems.h"
#import "NSString+MD5HexDigest.h"
#import "NSString+Util.h"
#import "UIScrollView+MJRefresh.h"
#import "MJRefreshHeader.h"
#import "MJRefreshFooter.h"
#import "MJExtension.h"
#import "TradeDetailViewController.h"
#import "POSManger.h"
#import "TradeDetailInfoViewController.h"

@interface TradeRecordViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *totalAmount;
@property (weak, nonatomic) IBOutlet UILabel *cashLabel;
@property (weak, nonatomic) IBOutlet UILabel *overLabel;
@property (weak, nonatomic) IBOutlet UIButton *cashButton;
- (IBAction)cashAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *overButton;
- (IBAction)overAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *cashImage;
@property (weak, nonatomic) IBOutlet UIImageView *overImage;
@property (weak, nonatomic) IBOutlet UIView *seperateView;//分隔View

@property (weak, nonatomic) IBOutlet UITableView *tabelView;

@property(nonatomic, strong)UILabel *labTime;
@property(nonatomic, strong)UILabel *labType;
@property(nonatomic, strong)UILabel *labStatus;
@property(nonatomic, strong)UILabel *labCount;
@property(nonatomic, assign)NSInteger page;//分页
@property(nonatomic)int settleCycle;
@property(strong,nonatomic)NSString *cashStatus;
@property(nonatomic, strong)NSMutableArray *consumDatas;    //消费
@property(strong,nonatomic)NSString *completeTime;//交易时间

@property(strong,nonatomic)NSString *time;//交易时间
@property(strong,nonatomic)NSString *type;//交易类型
@property(strong,nonatomic)NSString *status;//提现状态
@property(strong,nonatomic)NSString *amount;//交易金额

@property(strong,nonatomic)UILabel *headLabel;
@property (weak, nonatomic) IBOutlet UIButton *cashHelpBtn;//提现笔数帮助按钮
@property (weak, nonatomic) IBOutlet UIButton *overHelpBtn;//提现剩余额度帮助按钮
- (IBAction)cashHelpAction:(id)sender;
- (IBAction)overHelpAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *marketConsume;//超市消费
- (IBAction)marketAction:(id)sender;
- (IBAction)generalAction:(id)sender;
- (IBAction)foodAction:(id)sender;
- (IBAction)wholesaleAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *foodConsume;//餐饮消费
@property (weak, nonatomic) IBOutlet UIButton *wholesaleConsume;//批发消费
@property (weak, nonatomic) IBOutlet UIButton *generalConsume;//百货消费

@property (weak, nonatomic) IBOutlet UIView *selecteLine1;
@property (weak, nonatomic) IBOutlet UIView *selecteLine2;
@property (weak, nonatomic) IBOutlet UIView *selecteLine3;
@property (weak, nonatomic) IBOutlet UIView *selecteLine4;

@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UIView *backView;

@end

static NSString *cellIdenfity = @"cellIdenfity";
static NSInteger flag;
static NSInteger tag;

@implementation TradeRecordViewController

typedef enum{
    loadRefresh,
    loadMore
}LoadType;

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = COLOR_THEME;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    [self.navigationController.navigationBar setTitleTextAttributes:
//     
//     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
//       
//       NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self dismissLine];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = 1;
    self.backView.backgroundColor = COLOR_THEME;
    [self.navigationController.navigationBar setTitleTextAttributes:
    
    @{NSFontAttributeName:[UIFont systemFontOfSize:18],
      
      NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor = COLOR_THEME;
    self.navigationItem.title = @"实时查询";
    [self setBackBarButtonItemWithRealTitle:@"返回"];
    self.buttonView.hidden = YES;
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:MerchantSource] isEqualToString:@"APP"]) {
        self.selecteLine1.backgroundColor = COLOR_THE_RED;
        self.selecteLine2.backgroundColor = COLOR_THE_WHITE;
        self.selecteLine3.backgroundColor = COLOR_THE_WHITE;
        self.selecteLine4.backgroundColor = COLOR_THE_WHITE;
        
        self.cashImage.image = [UIImage imageNamed:@"选中"];
        self.overImage.image = [UIImage imageNamed:@"未选中"];
        
        tag = 1;
        
        flag = 1;
    }else {
        self.buttonView.hidden = YES;
        self.selecteLine1.hidden = YES;
        self.selecteLine2.hidden = YES;
        self.selecteLine3.hidden = YES;
        self.selecteLine4.hidden = YES;
        self.tabelView.frame = CGRectMake(0, CGRectGetMaxY(self.seperateView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.seperateView.frame));
    }
    
    
    
    [self tableViewRefresh];
    
}

- (void)tableViewRefresh {
    //     设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    [self.tabelView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refrestNewData1)];
    // 设置文字
    [self.tabelView.header setTitle:@"下拉刷新" forState:MJRefreshHeaderStateIdle];
    [self.tabelView.header setTitle:@"释放立即刷新" forState:MJRefreshHeaderStatePulling];
    [self.tabelView.header setTitle:@"正在刷新..." forState:MJRefreshHeaderStateRefreshing];
    // 设置字体
    self.tabelView.header.font = [UIFont systemFontOfSize:15];
    //        设置颜色
    //        tableView.header.textColor = [UIColor redColor];
    
    // 添加传统的上拉刷新
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    [self.tabelView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData1)];
    // 禁止自动加载
    self.tabelView.footer.automaticallyRefresh = NO;
    
    // 马上进入刷新状态
    [self.tabelView.header beginRefreshing];
    
    
    //    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    //    headView.backgroundColor = [UIColor whiteColor];
    //    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 1)];
    //    lineView.backgroundColor = [UIColor lightLightGrayTextColor];
    //    [headView addSubview:lineView];
    //    self.headLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 20)];
    //    [headView addSubview:self.headLabel];
    ////    self.tabelView.tableHeaderView = headView;
    //    self.tabelView.tableFooterView.frame = CGRectZero;
    
    self.overButton.enabled = NO;
}

- (void)refrestNewData1
{
    NSLog(@"flag:%ld",(long)flag);
    //    if (flag == 1) {
    [self loadDataWithType:loadRefresh];
    //    }else if (flag == 2) {
    //        [self loadDataWithType1:loadRefresh];
    //    }else {
    //        [self loadDataWithType:loadRefresh];
    //    }
    
}

- (void)loadMoreData1
{
    NSLog(@"flag:%ld",(long)flag);
    //    if (flag == 1) {
    [self loadDataWithType:loadMore];
    //    }else if (flag == 2) {
    //        [self loadDataWithType1:loadMore];
    //    }else {
    //        [self loadDataWithType:loadMore];
    //    }
}

- (void)loadDataWithType:(LoadType)loadType
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:MerchantSource] isEqualToString:@"APP"]) {
        if (flag == 1) {
            AbstractItems *item = [[AbstractItems alloc] init];
            item.n0 = @"0700";
            item.n3 = @"190978";
            item.n9 = @"00000000";
            item.n42 = [[NSUserDefaults standardUserDefaults] objectForKey:MerchantNo];
            NSLog(@"%@",item.n42);
            if (loadType == loadRefresh) {
                item.n60 = @"03000001010";
            }else if (loadType == loadMore) {
                item.n60 = [NSString stringWithFormat:@"030000%02zd010",_page];
            }
            NSString *str = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",item.n0, item.n3, item.n9,item.n42, item.n59,item.n60, MainKey];
            NSLog(@"str:%@",str);
            item.n64 = [[str md5HexDigest] uppercaseString];
            
            __weak typeof(self) weakSelf = self;
            [[NetAPIManger sharedManger] request_RecordWithParams:[item keyValues] andBlock:^(id data, NSError *error) {
                AbstractItems *item = (AbstractItems *)data;
                if ([item.n39 isEqual:@"00"] && !error) {
                    
                    if (item.n57.count != 0) {
                        NSLog(@"n57:%@",item.n57);
                        for (OrderItem *order in item.n57) {
                            NSLog(@"order:%@",order);
                            self.settleCycle = order.settleCycle;
                            self.cashStatus = order.payStatus;
                            NSString *str = [NSString stringWithFormat:@"%@",order.todayAmount];
                            NSString *moneyStr = [POSManger transformAmountWithPoint:str];
                            NSLog(@"str:%@",str);
                            NSLog(@"amount:%@",self.totalAmount.text);
                            self.cashLabel.text = [NSString stringWithFormat:@"%@",order.todayWithDraw];
                            NSLog(@"num:%@",self.cashLabel.text);
                            self.overLabel.text = [POSManger transformAmountWithPoint:[NSString stringWithFormat:@"%@",order.todayWithDrawSurplus]];
                            NSLog(@"over:%@",self.overLabel.text);
                        }
                    }
                    
                    
                    NSInteger index = [[item.n60 substringWithRange:NSMakeRange(6, 2)] integerValue];
                    NSLog(@"index:%ld",(long)index);
                    if (!_consumDatas) {
                        _consumDatas = [[NSMutableArray alloc] init];
                    }
                    if (index == 1) {
                        @synchronized(_consumDatas){
                            [_consumDatas removeAllObjects];
                        }
                        _page = 1;
                    }
                    _page++;
                    
                    @synchronized(_consumDatas){
                        for (OrderItem *order in item.n57) {
                            
                            [weakSelf.consumDatas addObjectsFromArray:order.appPayment];
                        }
                    }
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.tabelView reloadData];
                        if (loadType == loadRefresh) {
                            // 拿到当前的下拉刷新控件，结束刷新状态
                            [weakSelf.tabelView.header endRefreshing];
                        }else if (loadType == loadMore) {
                            [weakSelf.tabelView.footer endRefreshing];
                        }
                    });
                }else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (loadType == loadRefresh) {
                            // 拿到当前的下拉刷新控件，结束刷新状态
                            [weakSelf.tabelView.header endRefreshing];
                        }else if (loadType == loadMore) {
                            [weakSelf.tabelView.footer endRefreshing];
                        }
                    });
                }
                
                
            }];
            
            flag = 2;
        }else {
            AbstractItems *item = [[AbstractItems alloc] init];
            item.n0 = @"0700";
            item.n3 = @"190978";
            item.n9 = @"00000000";
            item.n42 = [[NSUserDefaults standardUserDefaults] objectForKey:MerchantNo];
            NSLog(@"%@",item.n42);
            if (loadType == loadRefresh) {
                item.n60 = @"04000001010";
            }else if (loadType == loadMore) {
                item.n60 = [NSString stringWithFormat:@"040000%02zd010",_page];
            }
            NSString *str = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",item.n0, item.n3, item.n9,item.n42, item.n59,item.n60, MainKey];
            NSLog(@"str:%@",str);
            item.n64 = [[str md5HexDigest] uppercaseString];
            
            __weak typeof(self) weakSelf = self;
            [[NetAPIManger sharedManger] request_RecordWithParams:[item keyValues] andBlock:^(id data, NSError *error) {
                AbstractItems *item = (AbstractItems *)data;
                if ([item.n39 isEqual:@"00"] && !error) {
                    
                    if (item.n57.count != 0) {
                        NSLog(@"n57:%@",item.n57);
                        for (OrderItem *order in item.n57) {
                            //                        NSLog(@"order:%@",order);
                            //                        self.settleCycle = order.settleCycle;
                            //                        self.cashStatus = order.payStatus;
                            //                        NSString *str = [NSString stringWithFormat:@"%@",order.todayAmount];
                            //                        self.totalAmount.text = [POSManger transformAmountWithPoint:str];
                            //                        NSLog(@"str:%@",str);
                            //                        NSLog(@"amount:%@",self.totalAmount.text);
                            //                        self.cashLabel.text = [NSString stringWithFormat:@"%@",order.todayWithDraw];
                            //                        NSLog(@"num:%@",self.cashLabel.text);
                            //                        self.overLabel.text = [POSManger transformAmountWithPoint:[NSString stringWithFormat:@"%@",order.todayWithDrawSurplus]];
                            //                        NSLog(@"over:%@",self.overLabel.text);
                        }
                    }
                    
                    
                    NSInteger index = [[item.n60 substringWithRange:NSMakeRange(6, 2)] integerValue];
                    NSLog(@"index:%ld",(long)index);
                    if (!_consumDatas) {
                        _consumDatas = [[NSMutableArray alloc] init];
                    }
                    if (index == 1) {
                        @synchronized(_consumDatas){
                            [_consumDatas removeAllObjects];
                        }
                        _page = 1;
                    }
                    _page++;
                    
                    @synchronized(_consumDatas){
                        for (OrderItem *order in item.n57) {
                            for (NSDictionary *dic in order.appPayment) {
                                NSLog(@"status:%@",dic[@"status"]);
                                if ([dic[@"status"] isEqualToString:@"10B"]) {
                                    [weakSelf.consumDatas addObject:dic];
                                }
                            }
                        }
                    }
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.tabelView reloadData];
                        if (loadType == loadRefresh) {
                            // 拿到当前的下拉刷新控件，结束刷新状态
                            [weakSelf.tabelView.header endRefreshing];
                        }else if (loadType == loadMore) {
                            [weakSelf.tabelView.footer endRefreshing];
                        }
                    });
                }else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (loadType == loadRefresh) {
                            // 拿到当前的下拉刷新控件，结束刷新状态
                            [weakSelf.tabelView.header endRefreshing];
                        }else if (loadType == loadMore) {
                            [weakSelf.tabelView.footer endRefreshing];
                        }
                    });
                }
                
                
            }];
            
            flag = 1;
        }
    }else {
        
        AbstractItems *item = [[AbstractItems alloc] init];
        item.n0 = @"0700";
        item.n3 = @"190978";
        item.n9 = @"00000000";
        item.n42 = [[NSUserDefaults standardUserDefaults] objectForKey:MerchantNo];
        NSLog(@"%@",item.n42);
        if (loadType == loadRefresh) {
            item.n60 = @"03000001010";
        }else if (loadType == loadMore) {
            item.n60 = [NSString stringWithFormat:@"030000%02zd010",_page];
        }
        NSString *str = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",item.n0, item.n3, item.n9,item.n42, item.n59,item.n60, MainKey];
        NSLog(@"str:%@",str);
        item.n64 = [[str md5HexDigest] uppercaseString];
        
        __weak typeof(self) weakSelf = self;
        [[NetAPIManger sharedManger] request_RecordWithParams:[item keyValues] andBlock:^(id data, NSError *error) {
            AbstractItems *item = (AbstractItems *)data;
            if ([item.n39 isEqual:@"00"] && !error) {
                
                if (item.n57.count != 0) {
                    NSLog(@"n57:%@",item.n57);
                    for (OrderItem *order in item.n57) {
                        NSLog(@"order:%@",order);
                        self.settleCycle = order.settleCycle;
                        self.cashStatus = order.payStatus;
                        NSString *str = [NSString stringWithFormat:@"%@",order.todayAmount];
                        self.totalAmount.text = [POSManger transformAmountWithPoint:str];
                        NSLog(@"str:%@",str);
                        NSLog(@"amount:%@",self.totalAmount.text);
                        self.cashLabel.text = [NSString stringWithFormat:@"%@",order.todayWithDraw];
                        NSLog(@"num:%@",self.cashLabel.text);
                        self.overLabel.text = [POSManger transformAmountWithPoint:[NSString stringWithFormat:@"%@",order.todayWithDrawSurplus]];
                        NSLog(@"over:%@",self.overLabel.text);
                    }
                }
                
                
                NSInteger index = [[item.n60 substringWithRange:NSMakeRange(6, 2)] integerValue];
                NSLog(@"index:%ld",(long)index);
                if (!_consumDatas) {
                    _consumDatas = [[NSMutableArray alloc] init];
                }
                if (index == 1) {
                    @synchronized(_consumDatas){
                        [_consumDatas removeAllObjects];
                    }
                    _page = 1;
                }
                _page++;
                
                @synchronized(_consumDatas){
                    for (OrderItem *order in item.n57) {
                        
                        [weakSelf.consumDatas addObjectsFromArray:order.appPayment];
                    }
                }
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tabelView reloadData];
                    if (loadType == loadRefresh) {
                        // 拿到当前的下拉刷新控件，结束刷新状态
                        [weakSelf.tabelView.header endRefreshing];
                    }else if (loadType == loadMore) {
                        [weakSelf.tabelView.footer endRefreshing];
                    }
                });
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (loadType == loadRefresh) {
                        // 拿到当前的下拉刷新控件，结束刷新状态
                        [weakSelf.tabelView.header endRefreshing];
                    }else if (loadType == loadMore) {
                        [weakSelf.tabelView.footer endRefreshing];
                    }
                });
            }
            
            
        }];
        
    }
    
    
    
    
}

- (void)loadDataWithType1:(LoadType)loadType
{
    AbstractItems *item = [[AbstractItems alloc] init];
    item.n0 = @"0700";
    item.n3 = @"190978";
    item.n9 = @"00000000";
    item.n42 = [[NSUserDefaults standardUserDefaults] objectForKey:MerchantNo];
    NSLog(@"%@",item.n42);
    if (loadType == loadRefresh) {
        item.n60 = @"04000001010";
    }else if (loadType == loadMore) {
        item.n60 = [NSString stringWithFormat:@"040000%02zd010",_page];
    }
    NSString *str = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",item.n0, item.n3, item.n9,item.n42, item.n59,item.n60, MainKey];
    NSLog(@"str:%@",str);
    item.n64 = [[str md5HexDigest] uppercaseString];
    
    __weak typeof(self) weakSelf = self;
    [[NetAPIManger sharedManger] request_RecordWithParams:[item keyValues] andBlock:^(id data, NSError *error) {
        AbstractItems *item = (AbstractItems *)data;
        if ([item.n39 isEqual:@"00"] && !error) {
            
            if (item.n57.count != 0) {
                NSLog(@"n57:%@",item.n57);
                for (OrderItem *order in item.n57) {
                    NSLog(@"order:%@",order);
                    self.settleCycle = order.settleCycle;
                    self.cashStatus = order.payStatus;
                    NSString *str = [NSString stringWithFormat:@"%@",order.todayAmount];
                    self.totalAmount.text = [POSManger transformAmountWithPoint:str];
                    NSLog(@"str:%@",str);
                    NSLog(@"amount:%@",self.totalAmount.text);
                    self.cashLabel.text = [NSString stringWithFormat:@"%@",order.todayWithDraw];
                    NSLog(@"num:%@",self.cashLabel.text);
                    self.overLabel.text = [POSManger transformAmountWithPoint:[NSString stringWithFormat:@"%@",order.todayWithDrawSurplus]];
                    NSLog(@"over:%@",self.overLabel.text);
                }
            }
            
            
            NSInteger index = [[item.n60 substringWithRange:NSMakeRange(6, 2)] integerValue];
            NSLog(@"index:%ld",(long)index);
            if (!_consumDatas) {
                _consumDatas = [[NSMutableArray alloc] init];
            }
            if (index == 1) {
                @synchronized(_consumDatas){
                    [_consumDatas removeAllObjects];
                }
                _page = 1;
            }
            _page++;
            
            @synchronized(_consumDatas){
                for (OrderItem *order in item.n57) {
                    for (NSDictionary *dic in order.appPayment) {
                        NSLog(@"status:%@",dic[@"status"]);
                        if ([dic[@"status"] isEqualToString:@"10B"]) {
                            [weakSelf.consumDatas addObject:dic];
                        }
                    }
                }
            }
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tabelView reloadData];
                if (loadType == loadRefresh) {
                    // 拿到当前的下拉刷新控件，结束刷新状态
                    [weakSelf.tabelView.header endRefreshing];
                }else if (loadType == loadMore) {
                    [weakSelf.tabelView.footer endRefreshing];
                }
            });
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (loadType == loadRefresh) {
                    // 拿到当前的下拉刷新控件，结束刷新状态
                    [weakSelf.tabelView.header endRefreshing];
                }else if (loadType == loadMore) {
                    [weakSelf.tabelView.footer endRefreshing];
                }
            });
        }
        
        
    }];
    
    
}

- (IBAction)cashAction:(UIButton *)sender {
    
    sender.tag = 1;
    flag = sender.tag;
    
    self.cashImage.image = [UIImage imageNamed:@"选中"];
    self.overImage.image = [UIImage imageNamed:@"未选中"];
    
    //     设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    [self.tabelView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refrestNewData1)];
    // 设置文字
    [self.tabelView.header setTitle:@"下拉刷新" forState:MJRefreshHeaderStateIdle];
    [self.tabelView.header setTitle:@"释放立即刷新" forState:MJRefreshHeaderStatePulling];
    [self.tabelView.header setTitle:@"正在刷新..." forState:MJRefreshHeaderStateRefreshing];
    // 设置字体
    self.tabelView.header.font = [UIFont systemFontOfSize:15];
    //        设置颜色
    //        tableView.header.textColor = [UIColor redColor];
    
    // 添加传统的上拉刷新
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    [self.tabelView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData1)];
    // 禁止自动加载
    self.tabelView.footer.automaticallyRefresh = NO;
    
    // 马上进入刷新状态
    [self.tabelView.header beginRefreshing];
    
    
//    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
//    headView.backgroundColor = [UIColor whiteColor];
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 1)];
//    lineView.backgroundColor = [UIColor lightLightGrayTextColor];
//    [headView addSubview:lineView];
//    self.headLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 20)];
//    [headView addSubview:self.headLabel];
//    self.tabelView.tableHeaderView = headView;
//    
//    self.tabelView.tableFooterView.frame = CGRectZero;

//    [self.tabelView reloadData];
}
- (IBAction)overAction:(UIButton *)sender {
    
    sender.tag = 2;
    flag = sender.tag;
    
    self.cashImage.image = [UIImage imageNamed:@"未选中"];
    self.overImage.image = [UIImage imageNamed:@"选中"];
    
//    [self.tabelView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdenfity];
    
    //     设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    [self.tabelView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refrestNewData1)];
    // 设置文字
    [self.tabelView.header setTitle:@"下拉刷新" forState:MJRefreshHeaderStateIdle];
    [self.tabelView.header setTitle:@"释放立即刷新" forState:MJRefreshHeaderStatePulling];
    [self.tabelView.header setTitle:@"正在刷新..." forState:MJRefreshHeaderStateRefreshing];
    // 设置字体
    self.tabelView.header.font = [UIFont systemFontOfSize:15];
    //        设置颜色
    //        tableView.header.textColor = [UIColor redColor];
    
    // 添加传统的上拉刷新
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    [self.tabelView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData1)];
    // 禁止自动加载
    self.tabelView.footer.automaticallyRefresh = NO;
    
    // 马上进入刷新状态
    [self.tabelView.header beginRefreshing];
    
//    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
//    headView.backgroundColor = [UIColor whiteColor];
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 1)];
//    lineView.backgroundColor = [UIColor lightLightGrayTextColor];
//    [headView addSubview:lineView];
//    self.headLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 20)];
//    [headView addSubview:self.headLabel];
//    self.tabelView.tableHeaderView = headView;
//    self.tabelView.tableFooterView.frame = CGRectZero;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSLog(@"count:%lu",(unsigned long)self.consumDatas.count);

    return self.consumDatas.count;
   
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic = self.consumDatas[indexPath.row];
    self.time = dic[@"completeTimeString"];
    self.type = dic[@"tradeTypeName"];
    self.status = dic[@"statusName"];
    self.amount = [NSString stringWithFormat:@"%@",dic[@"trxAmt"]];
    
    [self headLabelMonth];
    
    UITableViewCell *cell = nil;
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdenfity];
        
        self.labTime = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 70, 25)];
        self.labTime.font = FONT_12;
        
        self.labType = [[UILabel alloc] initWithFrame:CGRectMake(100, 5, 50, 25)];
        self.labType.font = FONT_12;
        
        self.labStatus = [[UILabel alloc] initWithFrame:CGRectMake(155, 5, 70, 25)];
        self.labStatus.font = FONT_12;
        
        self.labCount = [[UILabel alloc] initWithFrame:CGRectMake(230, 5, SCREEN_WIDTH - CGRectGetMaxX(self.labStatus.frame) - 20, 25)];
        self.labCount.font = FONT_12;
        self.labCount.textAlignment = NSTextAlignmentRight;
        
        [cell.contentView addSubview:self.labTime];
        [cell.contentView addSubview:self.labType];
        [cell.contentView addSubview:self.labStatus];
        [cell.contentView addSubview:self.labCount];
    }

    NSRange range = NSMakeRange(5, 2);
    NSString *timeStr = [self.time substringWithRange:range];
    if ([timeStr intValue] < 10) {
        self.labTime.text = [self.time substringToIndex:9];
    }else if ([timeStr intValue] > 9) {
        self.labTime.text = [self.time substringToIndex:10];
    }
    self.labType.text = self.type;
    self.labStatus.text = self.status;
    self.labCount.text = [POSManger transformAmountWithPoint:self.amount];

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    TradeDetailViewController *tradeVc = [[TradeDetailViewController alloc] initWithNibName:@"TradeDetailViewController" bundle:nil];
    
    TradeDetailInfoViewController *tradeVc = [[TradeDetailInfoViewController alloc] init];
    
    NSDictionary *dic = self.consumDatas[indexPath.row];
    
    if ([dic[@"tradeTypeName"] isEqualToString:@"消费"] || [dic[@"tradeTypeName"] isEqualToString:@"微信支付"] || [dic[@"tradeTypeName"] isEqualToString:@"支付宝支付"]) {
        if ([dic[@"statusName"] isEqualToString:@"交易成功"]) {
            tradeVc.type = dic[@"tradeTypeName"];
            tradeVc.strRate = [NSString stringWithFormat:@"%@",dic[@"rate"]];
            tradeVc.time = dic[@"completeTimeString"];
            tradeVc.status = dic[@"statusName"];
            tradeVc.amount = [NSString stringWithFormat:@"%@",dic[@"trxAmt"]];
            tradeVc.name = dic[@"merchantCnName"];
            tradeVc.originalVoucherNo = dic[@"terminalVoucherNo"];
            tradeVc.tradeNum = dic[@"orderNo"];
            tradeVc.maxFee = [NSString stringWithFormat:@"%@",dic[@"maxFee"]];
            tradeVc.cardNum = dic[@"cardNo"];
            tradeVc.authorizeNum = dic[@"acqAuthNo"];
            tradeVc.imageUrl = dic[@"signUrl"];
        }else{
            
        }
        
    }
    
    [self.navigationController pushViewController:tradeVc animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)headLabelMonth {
    NSLog(@"time:%@",self.time);
    if ([[self.time substringWithRange:NSMakeRange(5, 1)] isEqualToString:@"1"]) {
        self.headLabel.text = @"一月";
    }else if ([[self.time substringWithRange:NSMakeRange(5, 1)] isEqualToString:@"2"]) {
        self.headLabel.text = @"二月";
    }else if ([[self.time substringWithRange:NSMakeRange(5, 1)] isEqualToString:@"3"]) {
        self.headLabel.text = @"三月";
    }else if ([[self.time substringWithRange:NSMakeRange(5, 1)] isEqualToString:@"4"]) {
        self.headLabel.text = @"四月";
    }else if ([[self.time substringWithRange:NSMakeRange(5, 1)] isEqualToString:@"5"]) {
        self.headLabel.text = @"五月";
    }else if ([[self.time substringWithRange:NSMakeRange(5, 1)] isEqualToString:@"6"]) {
        self.headLabel.text = @"六月";
    }else if ([[self.time substringWithRange:NSMakeRange(5, 1)] isEqualToString:@"7"]) {
        self.headLabel.text = @"七月";
    }else if ([[self.time substringWithRange:NSMakeRange(5, 1)] isEqualToString:@"8"]) {
        self.headLabel.text = @"八月";
    }else if ([[self.time substringWithRange:NSMakeRange(5, 1)] isEqualToString:@"9"]) {
        self.headLabel.text = @"九月";
    }else if ([[self.time substringWithRange:NSMakeRange(5, 1)] isEqualToString:@"10"]) {
        self.headLabel.text = @"十月";
    }else if ([[self.time substringWithRange:NSMakeRange(5, 1)] isEqualToString:@"11"]) {
        self.headLabel.text = @"十一月";
    }else if ([[self.time substringWithRange:NSMakeRange(5, 1)] isEqualToString:@"12"]) {
        self.headLabel.text = @"十二月";
    }
}


- (IBAction)cashHelpAction:(id)sender {
}

- (IBAction)overHelpAction:(id)sender {
}
- (IBAction)marketAction:(id)sender {
    
    tag = 1;
    
    self.selecteLine1.backgroundColor = COLOR_THE_RED;
    self.selecteLine2.backgroundColor = COLOR_THE_WHITE;
    self.selecteLine3.backgroundColor = COLOR_THE_WHITE;
    self.selecteLine4.backgroundColor = COLOR_THE_WHITE;
    
    AbstractItems *item = [[AbstractItems alloc] init];
    item.n9 = @"00000049";
    //
    [self tableViewRefresh];
    [self.tabelView reloadData];
    [self loadDataWithType:loadRefresh];
    
}

- (IBAction)generalAction:(id)sender {
    
    tag = 2;
    
    self.selecteLine2.backgroundColor = COLOR_THE_RED;
    self.selecteLine1.backgroundColor = COLOR_THE_WHITE;
    self.selecteLine3.backgroundColor = COLOR_THE_WHITE;
    self.selecteLine4.backgroundColor = COLOR_THE_WHITE;
    
    AbstractItems *item = [[AbstractItems alloc] init];
    item.n9 = @"00000078";
    //
    [self tableViewRefresh];
    [self.tabelView reloadData];
    [self loadDataWithType:loadRefresh];
    
}

- (IBAction)foodAction:(id)sender {
    
    tag = 3;
    
    self.selecteLine3.backgroundColor = COLOR_THE_RED;
    self.selecteLine1.backgroundColor = COLOR_THE_WHITE;
    self.selecteLine2.backgroundColor = COLOR_THE_WHITE;
    self.selecteLine4.backgroundColor = COLOR_THE_WHITE;
    
    AbstractItems *item = [[AbstractItems alloc] init];
    item.n9 = @"00000125";
    //
    [self tableViewRefresh];
    [self.tabelView reloadData];
    [self loadDataWithType:loadRefresh];
    
}

- (IBAction)wholesaleAction:(id)sender {
    
    tag = 4;
    
    self.selecteLine4.backgroundColor = COLOR_THE_RED;
    self.selecteLine1.backgroundColor = COLOR_THE_WHITE;
    self.selecteLine2.backgroundColor = COLOR_THE_WHITE;
    self.selecteLine3.backgroundColor = COLOR_THE_WHITE;
    
    AbstractItems *item = [[AbstractItems alloc] init];
    item.n9 = @"00035078";
    //
    [self tableViewRefresh];
    [self.tabelView reloadData];
    [self loadDataWithType:loadRefresh];

    
}
@end
