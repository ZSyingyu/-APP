//
//  SettingViewController.m
//  HuiYingTianXia
//
//  Created by tsmc on 15-3-30.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import "SettingViewController.h"
#import "AppDelegate.h"
#import "ChangePasswordViewController.h"
#import "TerminalChooseViewController.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"
#import "VersionInfoViewController.h"

@interface SettingTableCell ()
@property(nonatomic, strong)UIImageView *ivIcon;
@property(nonatomic, strong)UILabel *labType;
@property(strong,nonatomic)UILabel *labDetail;
@property(nonatomic, strong)UIImageView *ivSorrow;
@property(nonatomic, strong)UIView *bottomLine;
@end

@implementation SettingTableCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIView *superView = self.contentView;
        
        self.ivIcon = ({
            UIImageView *iv = [[UIImageView alloc] init];
            [iv setBackgroundColor:COLOR_MY_WHITE];
            iv;
        });
        [superView addSubview:self.ivIcon];
        [self.ivIcon makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(superView);
            make.left.equalTo(superView).offset(HFixWidthBaseOn320(10));
            make.width.equalTo(24);
            make.height.equalTo(24);
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
            make.left.equalTo(self.ivIcon.right).offset(HFixWidthBaseOn320(7));
            make.width.equalTo(HFixWidthBaseOn320(150));
            make.height.equalTo(self.ivIcon);
        }];
        
        //右边的详细信息
        self.labDetail = [[UILabel alloc]init];
        self.labDetail.textAlignment = NSTextAlignmentRight;
        self.labDetail.textColor = [UIColor grayColor];
        self.labDetail.font = FONT_15;
        [self addSubview:self.labDetail];
        [self.labDetail makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(superView);
            make.left.equalTo(self.labType.right).offset(HFixWidthBaseOn320(10));
            make.width.equalTo(HFixWidthBaseOn320(100));
            make.height.equalTo(self.labType);
        }];

        self.ivSorrow = ({
            UIImage *image = [UIImage imageNamed:@"Sorrow"];
            UIImageView *iv = [[UIImageView alloc] initWithImage:image];
            iv;
        });
        [superView addSubview:self.ivSorrow];
        [self.ivSorrow makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(superView);
            make.right.equalTo(superView).offset(-HFixWidthBaseOn320(10));
            make.width.equalTo(self.ivSorrow.image.size.width);
            make.height.equalTo(self.ivSorrow.image.size.height);
        }];
        
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

- (void)setIcons:(NSString *)icon
{
    [self.ivIcon setImage:[UIImage imageNamed:icon]];
}

- (void)setLabDetail
{
    AbstractItems *item = [[AbstractItems alloc]init];
    self.labDetail.text = item.n59;
}

@end


@interface SettingViewController()<UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate>
@property(nonatomic, strong)UIImageView *headerView;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)UIButton *btnLogout;
@property(nonatomic, strong)NSArray *types;
@property(nonatomic, strong)NSArray *icons;
@property(strong,nonatomic)NSArray *details;
@end

static NSString *cellIdenfity = @"cellIdenfity";
@implementation SettingViewController

-(instancetype)init {
    self=[super init];
    if (self) {
        self.tabBarItem.title = @"我的";
        self.tabBarController.tabBar.barTintColor = COLOR_THEME;
        self.tabBarItem.image = [[UIImage imageNamed:@"我的2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem.selectedImage=[[UIImage imageNamed:@"我的1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
//    [self setBackBarButtonItemWithTitle:@"返回"];

    
    self.types = @[@"用户须知",@"修改密码" ,@"联系客服" ,@"关于我们",@"提示音"];
    self.icons = @[@"用户须知",@"修改密码" ,@"联系客服" ,@"关于我们",@"关于我们"];
    
    
//    self.headerView = ({
//        UIImage *image = [UIImage imageNamed:@"logo_set"];
//        UIImageView *iv = [[UIImageView alloc] initWithImage:image];
//        [iv setContentMode:UIViewContentModeBottom];
//        [iv setBackgroundColor:COLOR_MY_WHITE];
//        [iv setFrame:CGRectMake(0, 0, SCREEN_WIDTH, image.size.height + 40)];
//        iv;
//        
//    });
    
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, BNT_HEIGHT + 32)];
    [footView setBackgroundColor:COLOR_MY_WHITE];
    self.btnLogout = [[UIButton alloc] initWithFrame:CGRectMake(HFixWidthBaseOn320(10), 32, SCREEN_WIDTH - 2*HFixWidthBaseOn320(10), BNT_HEIGHT)];
    [self.btnLogout addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
    [self.btnLogout setBackgroundColor:COLOR_THEME];
    [self.btnLogout setTitleColor:COLOR_MY_WHITE forState:UIControlStateNormal];
    [self.btnLogout setTitle:@"安全退出" forState:UIControlStateNormal];
    [footView addSubview:self.btnLogout];
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] init];
        [tableView setBackgroundColor:COLOR_MY_WHITE];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.tableHeaderView = self.headerView;
        tableView.tableFooterView = footView;
//        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:[SettingTableCell class] forCellReuseIdentifier:cellIdenfity];
        tableView;
    });
    [self.view addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}

/**
 *  返回
 */
- (void)backAction:(id)sender
{
    [self.navigationController.navigationBar setHidden:YES];
    [super backAction:sender];
}

/**
 *  退出APP
 */
- (void)logoutAction
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    UIWindow *window = app.window;
    
    [UIView animateWithDuration:.5f animations:^{
        window.alpha = 0;
        window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
    } completion:^(BOOL finished) {
        exit(0);
    }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.types count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    SettingTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfity forIndexPath:indexPath];//再ios8.1上会崩溃
    SettingTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfity];
    [cell setIcons:[self.icons objectAtIndex:indexPath.row]];
    [cell setTypes:[self.types objectAtIndex:indexPath.row]];
//    if (indexPath.row == 3) {
//        [cell setLabDetail];
//    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {//用户须知
        [MBProgressHUD showError:@"即将上线" toView:self.view];
    }else if (indexPath.row == 1 ) {//修改密码
        ChangePasswordViewController *cpVC = [[ChangePasswordViewController alloc]initWithNibName:@"ChangePasswordViewController" bundle:nil];
        [self presentViewController:cpVC animated:YES completion:nil];

        
    }else if (indexPath.row == 2){//联系客服
        
        NSString *phoneNumber = @"400-858-8818";
        NSString *cleanedString =[[phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
        NSString *escapedPhoneNumber = [cleanedString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", escapedPhoneNumber]];
        UIWebView *mCallWebview = [[UIWebView alloc] init] ;
        [self.view addSubview:mCallWebview];
        [mCallWebview loadRequest:[NSURLRequest requestWithURL:telURL]];

    }
//    else if (indexPath.row == 3){//版本信息
//        VersionInfoViewController *versionVc = [[VersionInfoViewController alloc] init];
//        versionVc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:versionVc animated:YES];
//    }
//    else if (indexPath.row == 3){//终端设置
//        TerminalChooseViewController *tcVc = [[TerminalChooseViewController alloc] init];
//        tcVc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:tcVc animated:YES];
//    }
    else if (indexPath.row == 3) {//关于我们
//        [MBProgressHUD showError:@"即将上线" toView:self.view];
        VersionInfoViewController *versionVc = [[VersionInfoViewController alloc] init];
        versionVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:versionVc animated:YES];
    }
    else if (indexPath.row == 4) {//是否关闭提示音?
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"提示音设置" delegate:self cancelButtonTitle:@"关闭提示音" otherButtonTitles:@"打开提示音", nil];
        [alert show];
    }
    
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [[NSUserDefaults standardUserDefaults] setObject:@"关闭提示音" forKey:@"IsOpenVoice"];
    }else if (buttonIndex == 1) {
        NSLog(@"打开提示音");
        [[NSUserDefaults standardUserDefaults] setObject:@"打开提示音" forKey:@"IsOpenVoice"];
    }
    [alertView setHidden:YES];
}

@end
