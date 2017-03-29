
//
//  QueryrRecordViewController.m
//  HuiYingTianXia
//
//  Created by tsmc on 15-3-29.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import "QueryrRecordViewController.h"
#import "ConsumDetailsViewController.h"
#import "NSString+Util.h"
#import "NetAPIManger.h"
#import "AbstractItems.h"
#import "OrderItem.h"
#import "NSString+MD5HexDigest.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "HomePageViewController.h"
#import "POSManger.h"
#import "SwingCardViewController.h"
#import "AC_POSManger.h"
#import "POSManger.h"
#import "BalanceDetailViewController.h"
#import "UIView+AutoLayout.h"
#import "POSConsumeDetailViewController.h"


@interface SegmentView ()

@property(nonatomic, strong)UIButton *btnLeft;
@property(nonatomic, strong)UIButton *btnRight;
@property(nonatomic, strong)UIView *bottomLine;
@property(nonatomic, strong)UIView *selectLine;

@end
@implementation SegmentView
- (instancetype)init
{
    self =[super init];
    if (self) {
        self.btnLeft = ({
            UIButton *btn = [[UIButton alloc] init];
            [btn setBackgroundColor:COLOR_MY_WHITE];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, HFixWidthBaseOn320(30), 0, HFixWidthBaseOn320(-30))];
            [btn setTitleColor:COLOR_FONT_BLACK forState:UIControlStateNormal];
            btn.tag = 1;
            [btn addTarget:self action:@selector(segSelect:) forControlEvents:UIControlEventTouchUpInside];
            [btn.titleLabel setFont:FONT_16];
            [btn setTitle:@"消费" forState:UIControlStateNormal];
            btn;
        });
        [self addSubview:self.btnLeft];
        [self.btnLeft makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self);
            make.width.equalTo(SCREEN_WIDTH / 2.);
            make.height.equalTo(BNT_HEIGHT);
        }];
        
        self.btnRight = ({
            UIButton *btn = [[UIButton alloc] init];
            [btn setBackgroundColor:COLOR_MY_WHITE];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, HFixWidthBaseOn320(-30), 0, HFixWidthBaseOn320(30))];
            [btn setTitleColor:COLOR_FONT_BLACK forState:UIControlStateNormal];
            btn.tag = 2;
            [btn addTarget:self action:@selector(segSelect:) forControlEvents:UIControlEventTouchUpInside];
            [btn.titleLabel setFont:FONT_16];
            [btn setTitle:@"余额查询" forState:UIControlStateNormal];
            btn;
        });
        [self addSubview:self.btnRight];
        [self.btnRight makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self.btnLeft.right);
            make.width.equalTo(SCREEN_WIDTH / 2.);
            make.height.equalTo(BNT_HEIGHT);
        }];
        
        
        self.selectLine = ({
            UIView *line = [[UIView alloc] init];
            [line setBackgroundColor:COLOR_THEME];
            line;
        });
        [self addSubview:self.selectLine];
        [self.selectLine makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.btnLeft.bottom).offset(-1);
            make.left.equalTo(self).equalTo(HFixWidthBaseOn320(73));
            make.width.equalTo(HFixWidthBaseOn320(75));
            make.height.equalTo(2);
        }];
        
        self.bottomLine = ({
            UIView *line = [[UIView alloc] init];
            [line setBackgroundColor:COLOR_LINE];
            line;
        });
        [self addSubview:self.bottomLine];
        [self.bottomLine makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.selectLine.bottom);
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.width.equalTo(SCREEN_WIDTH);
            make.height.equalTo(LINE_HEIGTH);
        }];
        
        
    }
    return self;
}

- (void)segSelect:(UIButton *)btn
{
    [self setSelectLineAnimate:btn.tag];
}

- (void)setSelectLineAnimate:(NSInteger)type
{
    if (type == 1) {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.selectLine.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            NSLog(@"self.x:%f",self.selectLine.frame.origin.x);
        }];
    }else {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.selectLine.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, HFixWidthBaseOn320(75 + 24), 0);
            
        } completion:^(BOOL finished) {
            NSLog(@"self.x:%f",self.selectLine.frame.origin.x);
        }];
    }
}


@end

@interface QueryrRecordTableCell()
@property(nonatomic, strong)UILabel *labTime;
@property(nonatomic, strong)UILabel *labType;
@property(nonatomic, strong)UILabel *labStatus;
@property(nonatomic, strong)UILabel *labCount;
@property(nonatomic, strong)UIView *bottomLine;
@property(nonatomic, strong)UIView *verticalLine;



@end

@implementation QueryrRecordTableCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.labTime = ({
            UILabel *lab = [[UILabel alloc] init];
            lab.font = FONT_12;
            lab;
        });
        [self.labTime setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.labTime];
        
        self.labType = ({
            UILabel *lab = [[UILabel alloc] init];
            lab.font = FONT_12;
            lab;
        });
        [self.labType setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.labType];
        
        self.labStatus = ({
            UILabel *lab = [[UILabel alloc] init];
            lab.font = FONT_12;
            lab;
        });
        [self.labStatus setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.labStatus];
        
        self.labCount = ({
            UILabel *lab = [[UILabel alloc] init];
            lab.textAlignment = NSTextAlignmentRight;
            lab.font = [UIFont systemFontOfSize:20];
            lab;
        });
        [self.labCount setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.labCount];
        
        self.verticalLine = ({
            UIView *line = [[UIView alloc] init];
            [line setBackgroundColor:COLOR_THEME];
            line;
        });
        [self.contentView addSubview:self.verticalLine];
        
        self.bottomLine = ({
            UIView *line = [[UIView alloc] init];
            [line setBackgroundColor:COLOR_LINE];
            line;
        });
        [self.contentView addSubview:self.bottomLine];
    }
    return self;
}

- (void)updateConstraints
{
    [super updateConstraints];
    UIView *superView = self.contentView;
    
    [self.labTime makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView).offset(15);
        make.left.equalTo(superView).offset(HFixWidthBaseOn320(10));
        make.width.equalTo(SCREEN_WIDTH/2. - HFixWidthBaseOn320(10));
        make.height.equalTo(self.labTime.font.lineHeight);
    }];
    
    CGSize size = [self.labType.text suggestedSizeWithFont:self.labType.font];
    [self.labType makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labTime.bottom).offset(5);
        make.left.equalTo(superView).offset(HFixWidthBaseOn320(10));
        make.width.equalTo(size.width + 30);
        make.height.equalTo(self.labTime.font.lineHeight);
    }];
    
    size = [self.labStatus.text suggestedSizeWithFont:self.labType.font];
    [self.labStatus makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labType);
        make.left.equalTo(self.labType.right).offset(HFixWidthBaseOn320(10));
        make.width.equalTo(size.width);
        make.height.equalTo(self.labStatus.font.lineHeight);
    }];
    
    [self.verticalLine makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView).offset(16);
        //make.left.equalTo(self.labStatus.right).equalTo(HFixWidthBaseOn320(21));
        make.left.equalTo(self.labTime.right).equalTo(HFixWidthBaseOn320(15));
        make.bottom.equalTo(superView).equalTo(-16);
        make.width.equalTo(1);
        make.height.equalTo(15);
    }];
    
    [self.labCount makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(superView);
        make.left.equalTo(self.verticalLine.right).offset(HFixWidthBaseOn320(21));
        make.right.equalTo(- HFixWidthBaseOn320(10));
        make.height.equalTo(superView);
    }];
    
    [self.bottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.bottom).offset(-LINE_HEIGTH);
        make.left.equalTo(superView).equalTo(10);
        make.width.equalTo(SCREEN_WIDTH - 2*10);
        make.height.equalTo(1);
    }];
    
}

- (void)setDataInfo:(OrderItem *)info
{
    self.labTime.text = info.completeTime;
    self.labType.text = info.tradeType;
    self.labStatus.text = info.status;
    self.labCount.text = info.strAmount;
    
//    self.labTime.text = info.completeTimeString;
//    self.labType.text = info.tradeTypeName;
//    self.labStatus.text = info.statusName;
//    self.labCount.text = info.trxAmt;
    
    [self updateConstraintsIfNeeded];
}


@end






@interface QueryrRecordViewController()<UITableViewDataSource, UITableViewDelegate,AC_POSMangerDelegate>
@property(nonatomic, strong)UITableView *tableConsum;  //消费
//@property(nonatomic, strong)UITableView *tableWithDraw;//提现
@property(strong,nonatomic)UITableView *tableBalance;//余额
@property(nonatomic, strong)NSMutableArray *consumDatas;    //消费
//@property(nonatomic, strong)NSMutableArray *withDrawDatas;  //提现
@property(strong,nonatomic)NSMutableArray *balanceDatas;//余额
@property(nonatomic, assign)NSInteger page;                 //分页

@property(strong,nonatomic)UIImageView *noDataView;//没有交易的时候显示的图片

@property(strong,nonatomic)NSString *cashStatus;

@property(nonatomic)int settleCycle;

@end

static NSString *cellIdenfity = @"cellIdenfity";
@implementation QueryrRecordViewController

-(UIImageView *)noDataView{
    if (!_noDataView) {
        UIImageView *noDataView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"交易查询"]];
        [self.view addSubview:noDataView];
        [noDataView autoCenterInSuperview];
        self.noDataView = noDataView;
    }
    return _noDataView;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar setHidden:YES];
    self.navigationController.navigationBar.barTintColor = COLOR_THEME;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = COLOR_THEME;
    //    self.navigationController.navigationBar.barTintColor = COLOR_THEME;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //    [self setBackBarButtonItemWithTitle:@"返回"];
    [self setHomeBackBarButtonItemWithTitle:@"返回"];
    //    [self setRightBarButtonItemWithTitle:@"完成"];
    self.navigationItem.title = @"交易明细";
    _page = 1;
    
    __unsafe_unretained QueryrRecordViewController *weakSelf = self;
    //    SegmentView *segmentView = [[SegmentView alloc] init];
    //    segmentView.segSelectedBlock = ^(BOOL type){
    //        [weakSelf segSelectWithType:type];
    //    };
    //    [self.view addSubview:segmentView];
    //    [segmentView makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self.view);
    //        make.left.equalTo(self.view);
    //        make.right.equalTo(self.view);
    //        make.height.equalTo(38);
    //        make.width.equalTo(SCREEN_WIDTH);
    //    }];
    
    self.tableConsum = ({
        UITableView *tableView = [[UITableView alloc] init];
        tableView.backgroundColor = COLOR_MY_WHITE;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:[QueryrRecordTableCell class] forCellReuseIdentifier:cellIdenfity];
        // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
        [tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refrestNewData)];
        // 设置文字
        [tableView.header setTitle:@"下拉刷新" forState:MJRefreshHeaderStateIdle];
        [tableView.header setTitle:@"释放立即刷新" forState:MJRefreshHeaderStatePulling];
        [tableView.header setTitle:@"正在刷新..." forState:MJRefreshHeaderStateRefreshing];
        // 设置字体
        tableView.header.font = [UIFont systemFontOfSize:15];
        //        设置颜色
        //        tableView.header.textColor = [UIColor redColor];
        
        // 添加传统的上拉刷新
        // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
        [tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        // 禁止自动加载
        tableView.footer.automaticallyRefresh = NO;
        
        // 马上进入刷新状态
        [tableView.header beginRefreshing];
        tableView;
    });
    [self.view addSubview:self.tableConsum];
    [self.tableConsum makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(self.view.frame.size.height - 64);
        make.width.equalTo(SCREEN_WIDTH);
    }];
    
    //    self.tableWithDraw = ({
    //        UITableView *tableView = [[UITableView alloc] init];
    //        tableView.dataSource = self;
    //        tableView.delegate = self;
    //        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //        [tableView registerClass:[QueryrRecordTableCell class] forCellReuseIdentifier:cellIdenfity];
    //        tableView;
    //    });
    //    [self.tableWithDraw setHidden:YES];
    //    [self.view addSubview:self.tableWithDraw];
    //    [self.tableWithDraw makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(segmentView.bottom);
    //        make.left.equalTo(self.view);
    //        make.right.equalTo(self.view);
    //        make.height.equalTo(self.view.frame.size.height - 38 - 64);
    //        make.width.equalTo(SCREEN_WIDTH);
    //    }];
    //    [self.view addSubview:self.tableWithDraw];
    
    //    self.tableBalance = ({
    //        UITableView *tableView = [[UITableView alloc] init];
    //        tableView.dataSource = self;
    //        tableView.delegate = self;
    //        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //        [tableView registerClass:[QueryrRecordTableCell class] forCellReuseIdentifier:cellIdenfity];
    //        tableView;
    //    });
    //    [self.tableBalance setHidden:YES];
    //    [self.view addSubview:self.tableBalance];
    //    [self.tableBalance makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(segmentView.bottom);
    //        make.left.equalTo(self.view);
    //        make.right.equalTo(self.view);
    //        make.height.equalTo(self.view.frame.size.height - 38 - 64);
    //        make.width.equalTo(SCREEN_WIDTH);
    //    }];
    //    [self.view addSubview:self.tableBalance];
    
    
}

- (void)refrestNewData
{
    [self loadDataWithType:loadRefresh];
}

- (void)loadMoreData
{
    [self loadDataWithType:loadMore];
}

- (void)loadDataWithType:(LoadType)loadType
{
    AbstractItems *item = [[AbstractItems alloc] init];
    item.n0 = @"0700";
    item.n3 = @"190978";
//    item.n9 = @"00000000";
    item.n42 = [[NSUserDefaults standardUserDefaults] objectForKey:MerchantNo];
    NSLog(@"%@",item.n42);
    if (loadType == loadRefresh) {
        item.n60 = @"22000001010";
    }else if (loadType == loadMore) {
        item.n60 = [NSString stringWithFormat:@"22%06zd010",_page];
    }
    NSString *str = [NSString stringWithFormat:@"%@%@%@%@%@%@",item.n0, item.n3,item.n42, item.n59,item.n60, MainKey];
    NSLog(@"str:%@",str);
    item.n64 = [[str md5HexDigest] uppercaseString];
    
    __weak typeof(self) weakSelf = self;
    [[NetAPIManger sharedManger] request_RecordWithParams:[item keyValues] andBlock:^(id data, NSError *error) {
        AbstractItems *item = (AbstractItems *)data;
        if ([item.n39 isEqual:@"00"] && !error) {
            
            NSLog(@"count:%lu",(unsigned long)item.n57.count);
            
            if (item.n57.count != 0) {
                NSLog(@"n57:%@",item.n57);
                for (OrderItem *order in item.n57) {
                    NSLog(@"order:%@",order);
                    self.settleCycle = order.settleCycle;
                    self.cashStatus = order.payStatus;
                   
                }
            }
            
            
            NSInteger index = [[item.n60 substringWithRange:NSMakeRange(2, 6)] integerValue];
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
                
                [weakSelf.consumDatas addObjectsFromArray:item.n57];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableConsum reloadData];
                if (loadType == loadRefresh) {
                    // 拿到当前的下拉刷新控件，结束刷新状态
                    [weakSelf.tableConsum.header endRefreshing];
                }else if (loadType == loadMore) {
                    [weakSelf.tableConsum.footer endRefreshing];
                }
            });
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (loadType == loadRefresh) {
                    // 拿到当前的下拉刷新控件，结束刷新状态
                    [weakSelf.tableConsum.header endRefreshing];
                }else if (loadType == loadMore) {
                    [weakSelf.tableConsum.footer endRefreshing];
                }
            });
        }
        
        
    }];
    
    
}

- (void)backAction:(id)sender
{
    [self.navigationController.navigationBar setHidden:YES];
    
    [super backAction:sender];
    
}

- (void)segSelectWithType:(int)type
{
    if (type == 1) {
        [self.tableConsum setHidden:NO];
        [self.tableBalance setHidden:YES];
        
    }else{
        
        [self.tableConsum setHidden:YES];
        [self.tableBalance setHidden:NO];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 62;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //设置隐藏交易查询的图片
    self.noDataView.hidden = (self.consumDatas.count != 0);
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.tableConsum){
        return self.consumDatas.count;
    }else{
        return self.balanceDatas.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QueryrRecordTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfity forIndexPath:indexPath];
    
    if(tableView == self.tableConsum){
        OrderItem *item = [self.consumDatas objectAtIndex:indexPath.row];
        [cell setDataInfo:item];
        
    }else{
        OrderItem *item = [self.balanceDatas objectAtIndex:indexPath.row];
        [cell setDataInfo:item];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    POSConsumeDetailViewController *controller = [[POSConsumeDetailViewController alloc] init];
    
    if (tableView == self.tableConsum) {
        controller.orderItem = [self.consumDatas objectAtIndex:indexPath.row];
    }else{
        
        controller.orderItem = [self.balanceDatas objectAtIndex:indexPath.row];
    }
    OrderItem *item = [self.consumDatas objectAtIndex:indexPath.row];
    controller.amount = item.trxAmt;
    controller.type = item.tradeType;
    controller.strRate = item.strRate;
    controller.time = item.completeTime;
    controller.cardNum = item.cardNo;
    controller.tradeNum = item.orderNo;
    controller.status = item.status;
    controller.maxFee = item.strMaxFee;
    controller.cStatus = item.payStatus;
    
//    OrderItem *order = [self.consumDatas objectAtIndex:indexPath.row];
//    if ([order.tradeType isEqualToString:@"消费"]) {
//        if ([order.status isEqualToString:@"交易成功"]) {
//            self.originalVoucherNo = order.termianlVoucherNo;
//            self.orderNo = order.orderNo;
//            [self.navigationController pushViewController:controller animated:YES];
//            controller.orderNo = self.orderNo;
//            controller.originalVoucherNo = self.originalVoucherNo;
//            controller.tadeType = type_consument;
//            controller.orderItem.status = order.status;
//            controller.orderItem.settleCycle = order.settleCycle;
//            NSLog(@"settlecycle:%d",order.settleCycle);
//            controller.orderItem.payResMsg = order.payResMsg;
//            NSLog(@"paumsg:%@",order.payResMsg);
//            controller.orderItem.payStatus = order.payStatus;
//            NSLog(@"paystatus:%@",order.payStatus);
//        }else{
//            
//        }
//        
//    }else if ([order.tradeType isEqualToString:@"余额查询"]){
//        
//        
//    }else if ([order.tradeType isEqualToString:@"消费撤销"]){
//        [self.navigationController pushViewController:controller animated:YES];
//    }
    
        [self.navigationController pushViewController:controller animated:YES];
    
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

////设置Cell可编辑
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    OrderItem *order = [self.consumDatas objectAtIndex:indexPath.row];
//    if ([order.tradeType isEqualToString:@"余额查询"] || [order.tradeType isEqualToString:@"消费撤销"] || [order.status isEqualToString:@"交易失败"]) {
//        return NO;
//    }
//    return YES;
//}

////定义编辑样式
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
////    [tableView setEditing:YES animated:YES];//这一句写上的话会出现向左滑动所有行都出现删除按钮的效果
//    return UITableViewCellEditingStyleDelete;
//}

//进入编辑模式，按下出现的编辑按钮后
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    [[AC_POSManger shareInstance] setDeleagte:self];
//    [[AC_POSManger shareInstance] openAndBanding];
//
//    OrderItem *item = [self.consumDatas objectAtIndex:indexPath.row];
//    self.tadeAmount = item.strAmount;
//    self.originalVoucherNo = item.termianlVoucherNo;
//    NSLog(@"voucherNo:%@",self.originalVoucherNo);
//    self.batchNo = item.terminalBatchNo;
//
//}

////修改编辑按钮文字
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return @"撤销";
//}



//等待刷卡
- (void)waitingForCardSwipe:(BOOL)status
{
    if(status == SUCCESS) {
        SwingCardViewController *swingCardVC = [[SwingCardViewController alloc] init];
        swingCardVC.tadeType = type_revoke;
        swingCardVC.tadeAmount = self.tadeAmount;
        swingCardVC.originalVoucherNo = self.originalVoucherNo;
        swingCardVC.batchNo = self.batchNo;
        //NSLog(@"voucherNo:%@",swingCardVC.voucherNo);
        swingCardVC.orderItem = self.orderItem;
        [self.navigationController pushViewController:swingCardVC animated:YES];
    }
}

@end




