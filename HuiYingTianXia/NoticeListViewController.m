//
//  NoticeListViewController.m
//  HuiYingTianXia
//
//  Created by 朱颖宇 on 15/10/30.
//  Copyright © 2015年 tsmc. All rights reserved.
//

#import "NoticeListViewController.h"
#import "PublicNoticeViewController.h"

@interface NoticeListViewController ()<UITableViewDataSource,UITableViewDelegate>

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

@implementation NoticeListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.noticeTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"公告列表"];
    [self setBackBarButtonItemWithTitle:@"返回"];
    
    self.noticeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.noticeTableView.backgroundColor = [UIColor whiteColor];
    self.noticeTableView.delegate = self;
    self.noticeTableView.dataSource = self;
    self.noticeTableView.tableFooterView = [[UIView alloc] init];
    self.noticeTableView.contentInset = UIEdgeInsetsMake(0, 0, 165, 0);
    [self.view addSubview:self.noticeTableView];
    
    
    
}

#pragma mark - tableview
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArray.count;
    
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
    NSArray *array4 = [self.listArray sortedArrayUsingDescriptors:array3];
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
    NSArray *array4 = [self.listArray sortedArrayUsingDescriptors:array3];
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
