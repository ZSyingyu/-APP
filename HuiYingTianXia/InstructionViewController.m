//
//  InstructionViewController.m
//  HuiYingTianXia
//
//  Created by 朱颖宇 on 15/10/29.
//  Copyright © 2015年 tsmc. All rights reserved.
//

#import "InstructionViewController.h"
#import "OperateViewController.h"
#import "RateInstructionViewController.h"
#import "CashInstructionViewController.h"
#import "MistakeViewController.h"
#import "CardCertifyViewController.h"
#import "CommonBreakdownViewController.h"

@interface InstructionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic)UITableView *instructionTableView;//说明列表

@end

static NSString *cellIdenfity = @"cell";

@implementation InstructionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"说明书"];
    [self setBackBarButtonItemWithTitle:@"返回"];
    
    self.instructionTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.instructionTableView.backgroundColor = [UIColor whiteColor];
    self.instructionTableView.delegate = self;
    self.instructionTableView.dataSource = self;
    self.instructionTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.instructionTableView];
    
}

#pragma mark - tableview
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdenfity];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row == 0) {
            cell.imageView.image = [UIImage imageNamed:@"操作说明-图标"];
            cell.textLabel.text = @"操作说明";
        }else if (indexPath.row == 1) {
            cell.imageView.image = [UIImage imageNamed:@"费率说明-图标"];
            cell.textLabel.text = @"费率说明";
        }else if (indexPath.row == 2) {
            cell.imageView.image = [UIImage imageNamed:@"提现说明-图标"];
            cell.textLabel.text = @"提现说明";
        }else if (indexPath.row == 3) {
            cell.imageView.image = [UIImage imageNamed:@"错误提示-图标"];
            cell.textLabel.text = @"错误提示";
        }else if (indexPath.row == 4) {
            cell.imageView.image = [UIImage imageNamed:@"银行卡认证说明-图标"];
            cell.textLabel.text = @"银行卡认证说明";
        }else if (indexPath.row == 5) {
            cell.imageView.image = [UIImage imageNamed:@"常见故障(1)"];
            cell.textLabel.text = @"常见故障";
        }
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.row == 0) {
        OperateViewController *operateVc = [[OperateViewController alloc] init];
        [self.navigationController pushViewController:operateVc animated:YES];
    }else if (indexPath.row == 1) {
        RateInstructionViewController *rateVc = [[RateInstructionViewController alloc] init];
        [self.navigationController pushViewController:rateVc animated:YES];
    }else if (indexPath.row == 2) {
        CashInstructionViewController *cashVc = [[CashInstructionViewController alloc] init];
        [self.navigationController pushViewController:cashVc animated:YES];
    }else if (indexPath.row == 3) {
        MistakeViewController *misVc = [[MistakeViewController alloc] init];
        [self.navigationController pushViewController:misVc animated:YES];
    }else if (indexPath.row == 4) {
        CardCertifyViewController *cardVc = [[CardCertifyViewController alloc] init];
        [self.navigationController pushViewController:cardVc animated:YES];
    }else if (indexPath.row == 5) {
        CommonBreakdownViewController *commonVc = [[CommonBreakdownViewController alloc] init];
        [self.navigationController pushViewController:commonVc animated:YES];
    }
}

//使cell的分割线顶到屏幕最左边
-(void)viewDidLayoutSubviews
{
    if ([self.instructionTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.instructionTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.instructionTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.instructionTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
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
