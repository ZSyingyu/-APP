//
//  BankViewController.m
//  HuiYingTianXia
//
//  Created by 朱颖宇 on 15/6/18.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import "BankViewController.h"

@interface BankViewController ()

@property(strong,nonatomic) UITableView *tableView;
@property (nonatomic, copy) selectedBankBlock block;

@end

@implementation BankViewController

- (instancetype)initWithSelectedBankBlock:(selectedBankBlock)block
{
    if (self = [super init]) {
        _block = block;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //NSLog(@"%@",self.navigationController.navigationBar);
    
    [self setBackBarButtonItemWithTitle:@"返回"];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"CELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.textLabel.text = [[self.dataArray[indexPath.row] allKeys] firstObject];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = _dataArray[indexPath.row];
    NSString *code = [[dic allValues] firstObject];
    NSString *key = [[dic allKeys] firstObject];
    if (_block) {
        _block(code,key);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = @[@{@"北京银行":@"313003"},@{@"光大银行":@"303"},@{@"广发银行":@"306"},@{@"建设银行":@"105"},@{@"交通银行":@"301"},@{@"民生银行":@"305"},@{@"农业银行":@"103"},@{@"平安银行":@"307"},@{@"浦发银行":@"310"},@{@"邮政储蓄银行":@"403"},@{@"招商银行":@"308"},@{@"中国工商银行":@"102"},@{@"中国银行":@"104"},@{@"中信银行":@"302"},@{@"上海银行":@"313062"},@{@"杭州银行":@"313027"}];
    }
    return _dataArray;
}

@end
