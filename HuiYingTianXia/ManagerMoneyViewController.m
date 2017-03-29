//
//  ManagerMoneyViewController.m
//  HuiYingTianXia
//
//  Created by liguo.chen on 16/2/29.
//  Copyright © 2016年 tsmc. All rights reserved.
//

#import "ManagerMoneyViewController.h"
#import "Common.h"
#import "PublicNoticeViewController.h"
#import "AbstractItems.h"
#import "NSString+MD5HexDigest.h"
#import "NSString+Util.h"
#import "UIScrollView+MJRefresh.h"
#import "MJExtension.h"
#import "POSManger.h"
#import "OrderItem.h"
#import "ResponseDictionaryTool.h"
#import "MBProgressHUD+Add.h"
#import "MBProgressHUD.h"

@interface ManagerMoneyViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(strong,nonatomic)UITableView *noticeTableView;//公告列表
@property(strong,nonatomic)UIImageView *imageView;
@property(strong,nonatomic)UILabel *titleLabel;
@property(strong,nonatomic)UILabel *timeLabel;
@property(strong,nonatomic)UILabel *contentLabel;

@property(strong,nonatomic)NSString *titleStr;
@property(strong,nonatomic)NSString *contentStr;
@property(strong,nonatomic)NSString *timeStr;

@property(strong,nonatomic)NSMutableArray *dataArray;

@end

static NSString *cellIdenfity = @"cell";

@implementation ManagerMoneyViewController

-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

-(instancetype)init {
    self=[super init];
    if (self) {
        self.tabBarItem.title = @"公告";
        self.tabBarController.tabBar.barTintColor = COLOR_THEME;
        self.tabBarItem.image = [[UIImage imageNamed:@"消息2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem.selectedImage=[[UIImage imageNamed:@"消息1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestNoticeList];
}

-(void)requestNoticeList {
    AbstractItems *item = [[AbstractItems alloc] init];
    item.n0 = @"0700";
    item.n3 = @"190103";
    item.n42 = [[NSUserDefaults standardUserDefaults] objectForKey:MerchantNo];
    NSString *macStr = [NSString stringWithFormat:@"%@%@%@%@%@",item.n0,item.n3,item.n42,item.n59,MainKey];
    NSLog(@"macStr:%@",macStr);
    item.n64 = [macStr md5HexDigest];
    
    [[NetAPIManger sharedManger] request_NoticeListWithParams:[item keyValues] andBlock:^(id data, NSError *error) {
        AbstractItems *item = (AbstractItems *)data;
        if ([item.n39 isEqualToString:@"00"]) {
            NSLog(@"成功");
            [self creatUI];
            if ([item.n60 length] > 0) {
                NSString *n60 = item.n60;
                NSData *data = [n60 dataUsingEncoding:NSUTF8StringEncoding];
                NSMutableArray *infoArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                self.dataArray = infoArray;
            }
            [self.noticeTableView reloadData];
            
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

-(void)creatUI {
    self.noticeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.noticeTableView.backgroundColor = [UIColor whiteColor];
    self.noticeTableView.delegate = self;
    self.noticeTableView.dataSource = self;
    self.noticeTableView.tableFooterView = [[UIView alloc] init];
    self.noticeTableView.contentInset = UIEdgeInsetsMake(0, 0, 165, 0);
    [self.view addSubview:self.noticeTableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"公告列表"];

}

#pragma mark - tableview
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdenfity];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
        [cell.contentView addSubview:self.imageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imageView.frame) + 10, self.imageView.frame.origin.y, cell.contentView.frame.size.width - CGRectGetMaxX(self.imageView.frame) - 80, 25)];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [cell.contentView addSubview:self.titleLabel];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + 5, self.titleLabel.frame.origin.y, 50, 25)];
        self.timeLabel.textColor = [UIColor blackColor];
        self.timeLabel.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:self.timeLabel];
        
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.frame.origin.x, CGRectGetMaxY(self.imageView.frame) - 25, cell.contentView.frame.size.width - CGRectGetMidX(self.imageView.frame) - 10, 25)];
        self.contentLabel.textColor = [UIColor lightGrayBorderColor];
        self.contentLabel.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:self.contentLabel];
        
    }
    
    NSSortDescriptor *nameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"updateDateStr" ascending:NO];
    NSArray *array3 = @[nameDescriptor];
    NSArray *array4 = [self.dataArray sortedArrayUsingDescriptors:array3];
    NSDictionary *dic = array4[indexPath.row];
    self.titleLabel.text = dic[@"title"];
    NSString *str = dic[@"updateDateStr"];
    NSLog(@"str:%@",str);
    NSRange range = NSMakeRange(5, 5);
    self.timeLabel.text = [str substringWithRange:range];
    self.contentLabel.text = dic[@"content"];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:NoticeId] isEqualToString:dic[@"id"]] && [[[NSUserDefaults standardUserDefaults] objectForKey:NewImage] isEqualToString:@"new"]) {
        self.imageView.image = [UIImage imageNamed:@"有新消息"];
        
    }else {
        self.imageView.image = [UIImage imageNamed:@"列表图标"];
        //        [[NSUserDefaults standardUserDefaults] setObject:@"old" forKey:NewImage];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    PublicNoticeViewController *publicVc = [[PublicNoticeViewController alloc] init];
    NSSortDescriptor *nameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"updateDateStr" ascending:NO];
    NSArray *array3 = @[nameDescriptor];
    NSArray *array4 = [self.dataArray sortedArrayUsingDescriptors:array3];
    NSDictionary *dic = array4[indexPath.row];
    //    NSDictionary *dic = self.listArray[indexPath.row];
    NSLog(@"dic:%@",dic);
    publicVc.titleStr = dic[@"title"];
    publicVc.contentStr = dic[@"content"];
    publicVc.noticeId = dic[@"id"];
    NSLog(@"id:%@",publicVc.noticeId);
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:NoticeId] isEqualToString:dic[@"id"]] && [[[NSUserDefaults standardUserDefaults] objectForKey:NewImage] isEqualToString:@"new"]) {
        self.imageView.image = [UIImage imageNamed:@"列表图标"];
        [[NSUserDefaults standardUserDefaults] setObject:@"old" forKey:NewImage];
    }else {
        self.imageView.image = [UIImage imageNamed:@"列表图标"];
    }
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:Isread];
    
    publicVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:publicVc animated:YES];
}

//按时间排序


//使cell的分割线顶到屏幕最左边
-(void)viewDidLayoutSubviews
{
    if ([self.noticeTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.noticeTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.noticeTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.noticeTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
