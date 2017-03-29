//
//  TerminalChooseViewController.m
//  HuiYingTianXia
//
//  Created by 朱颖宇 on 15/8/14.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import "TerminalChooseViewController.h"
#import "HomePageViewController.h"


@interface TerminalChooseViewCell ()
@property(nonatomic, strong)UILabel *labType;
@property(nonatomic, strong)UIView *bottomLine;
@property(nonatomic, strong)UIImageView *ivIcon;
@property(strong,nonatomic)UIButton *chooseBtn;
@property(strong,nonatomic)UIImageView *chooseView;

@end

@implementation TerminalChooseViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIView *superView = self.contentView;
        
        
//        self.ivIcon = ({
//            UIImageView *iv = [[UIImageView alloc] init];
//            [iv setBackgroundColor:COLOR_MY_WHITE];
//            iv;
//        });
//        [superView addSubview:self.ivIcon];
//        [self.ivIcon makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(superView);
//            make.left.equalTo(superView).offset(HFixWidthBaseOn320(10));
//            make.width.equalTo(24);
//            make.height.equalTo(24);
//        }];
        
        self.labType = ({
            UILabel *lab = [[UILabel alloc] init];
            lab.textAlignment = NSTextAlignmentLeft;
            lab.font = FONT_16;
            lab;
        });
        [self addSubview:self.labType];
        [self.labType makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(superView);
            make.left.equalTo(self.ivIcon.right).offset(HFixWidthBaseOn320(7));
            make.width.equalTo(HFixWidthBaseOn320(150));
            make.height.equalTo(self.ivIcon);
        }];
        
        self.labType = ({
            UILabel *lab = [[UILabel alloc] init];
            lab.textAlignment = NSTextAlignmentLeft;
            lab.font = FONT_16;
            lab;
        });
        [self addSubview:self.labType];
        [self.labType makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(superView);
            make.left.equalTo(superView).offset(HFixWidthBaseOn320(10));
            make.width.equalTo(HFixWidthBaseOn320(320));
            
        }];
        
        //右边的选择按钮
        
        self.chooseBtn = [[UIButton alloc]init];
        [self.chooseBtn setBackgroundImage:[UIImage imageNamed:@"radio_unselected"] forState:UIControlStateNormal];
        [self.chooseBtn addTarget:self action:@selector(choose) forControlEvents:UIControlEventTouchUpInside];
        [self.chooseView makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(superView);
            make.right.equalTo(self.labType.right).offset(HFixWidthBaseOn320(-30));
            make.width.equalTo(HFixWidthBaseOn320(30));
            make.height.equalTo(30);
        }];
        [self addSubview:self.chooseBtn];

        
        self.bottomLine = ({
            UIView *line = [[UIView alloc] init];
            [line setBackgroundColor:COLOR_LINE];
            line;
        });
        [superView addSubview:self.bottomLine];
        [self.bottomLine makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(superView.bottom).offset(-LINE_HEIGTH);
            make.left.equalTo(HFixWidthBaseOn320(10));
            make.right.equalTo(HFixWidthBaseOn320(-10));
            make.width.equalTo(SCREEN_WIDTH - 2*HFixWidthBaseOn320(10));
            make.height.equalTo(LINE_HEIGTH);
        }];
    }
    return self;
}

- (void)setTypes:(NSString *)type
{
    [self.labType setText:type];
}

-(void)choose {
    UIImage *image = [UIImage imageNamed:@"radio_selected"];
    [self.chooseBtn setBackgroundImage:image forState:UIControlStateNormal];
}

@end

@interface TerminalChooseViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, strong)NSArray *types;
@property(nonatomic, strong)NSArray *icons;
@property(nonatomic, strong)UITableView *tableView;
@property(strong,nonatomic)UIButton *confirmBtn;//确定保存
@property(strong,nonatomic)NSString *tag;

@end

static NSString *cellIdenfity = @"cellIdenfity";

@implementation TerminalChooseViewController

-(void)viewWillAppear:(BOOL)animated {
//    
//    TerminalChooseViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdenfity];
//    if ([[[NSUserDefaults standardUserDefaults] objectForKey:Tag] isEqualToString:@"艾创音频"]) {
//        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
//    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:Tag] isEqualToString:@"魔方音频"]) {
//        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
//    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:Tag] isEqualToString:@"魔方蓝牙"]) {
//        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
//    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:Tag] isEqualToString:@"魔方蓝牙无键盘"]) {
//        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
//    }

    
}

-(void)viewWillDisappear:(BOOL)animated {
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"终端选择";
    [self setBackBarButtonItemWithTitle:@"返回"];
    
    //,@"BBPOS刷卡头",@"BBPOS_M368"
//    self.types = @[@"艾创刷卡头" ,@"艾创点付宝" ,@"魔方刷卡头",@"魔方M60",@"鑫诺XIN80"];
    self.types = @[@"MPOS ZY168(有键盘)",@"MPOS ZY268(有键盘)",@"ZY-1(蓝牙)"];
//    self.icons = @[@"radio_unselected"];
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] init];
        [tableView setBackgroundColor:COLOR_MY_WHITE];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.tableHeaderView.frame = CGRectMake(0, 0, 320, 0);
        tableView.tableFooterView.frame = CGRectMake(0, 0, 320, 0);
//        tableView.tableFooterView = footView;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:[TerminalChooseViewCell class] forCellReuseIdentifier:cellIdenfity];
        tableView;
    });
    [self.view addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(HFixWidthBaseOn320(40), SCREEN_HEIGHT - HFixHeightBaseOn568(180), SCREEN_WIDTH - HFixWidthBaseOn320(80), HFixWidthBaseOn320(40))];
    [self.confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [self.confirmBtn setBackgroundColor:COLOR_THEME];
    [self.confirmBtn setTitleColor:COLOR_MY_WHITE forState:UIControlStateNormal];
    [self.confirmBtn setTitle:@"确定保存" forState:UIControlStateNormal];
    [self.tableView addSubview:self.confirmBtn];
    
}

//确定保存

-(void)confirmAction{
    
//    [[NSUserDefaults standardUserDefaults] setObject:self.flag forKey:Tag];
    NSLog(@"flag:%@",[[NSUserDefaults standardUserDefaults] objectForKey:Tag]);
//    HomePageViewController *homgVc = [[HomePageViewController alloc] init];
//    homgVc.flag = self.flag;
//    [self.navigationController pushViewController:homgVc animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  返回
 */
- (void)backAction:(id)sender
{
    [self.navigationController.navigationBar setHidden:YES];
    [super backAction:sender];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.types count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TerminalChooseViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfity forIndexPath:indexPath];
    [cell setTypes:[self.types objectAtIndex:indexPath.row]];
    
    NSLog(@"tag:%@",[[NSUserDefaults standardUserDefaults] objectForKey:Tag]);
    
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:Tag] isEqualToString:@"神州安付蓝牙有键盘(带非接)"] && indexPath.row == 0) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:Tag] isEqualToString:@"神州安付蓝牙有键盘(不带非接)"] && indexPath.row == 1) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:Tag] isEqualToString:@"神州安付蓝牙"] && indexPath.row == 1) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *array = [tableView visibleCells];
    for (TerminalChooseViewCell *cell in array) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
//        cell.textLabel.textColor=[UIColor blackColor];
        
    }
    TerminalChooseViewCell *cell=[self.tableView cellForRowAtIndexPath:indexPath];
//    cell.textLabel.textColor=[UIColor redColor];
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    if (indexPath.row == 0 ) {//带非接
        self.flag = @"神州安付蓝牙有键盘(带非接)";
        [[NSUserDefaults standardUserDefaults] setObject:self.flag forKey:Tag];
        
    }else if (indexPath.row == 1){//不带非接
        self.flag = @"神州安付蓝牙有键盘(不带非接)";
        [[NSUserDefaults standardUserDefaults] setObject:self.flag forKey:Tag];
        
    }else if (indexPath.row == 2){//蓝牙无键盘
        self.flag = @"神州安付蓝牙";
        [[NSUserDefaults standardUserDefaults] setObject:self.flag forKey:Tag];
        
    }
    
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *index=[tableView indexPathForSelectedRow];
    
    if (index.row==indexPath.row&& index!=nil)
    {
        cell.backgroundColor=[UIColor clearColor];
        cell.textLabel.textColor=[UIColor clearColor];
    }
    else
    {
        cell.backgroundColor=[UIColor clearColor];
        cell.textLabel.textColor=[UIColor blackColor];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

@end
