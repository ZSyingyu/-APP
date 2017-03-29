//
//  BaseViewController.m
//  HuiYingTianXia
//
//  Created by tsmc on 15-3-18.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import "BaseViewController.h"
#import "MBProgressHUD.h"
#import "HomePageViewController.h"

@interface BaseViewController()
@property(nonatomic, retain)UIAlertView *alterView;
@end


@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:COLOR_MY_WHITE];
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}
/**
 *  设置返回按钮标题
 */
- (void)setBackBarButtonItemWithTitle:(NSString *)title
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn setTitleColor:COLOR_MY_WHITE forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"NavBackSorrow"] forState:UIControlStateNormal];
    [btn setContentMode:UIViewContentModeScaleAspectFill];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -7, 0, 50)];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 10)];
    [btn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

/**
 *  POS交易明细界面返回
 */
- (void)setPOSBackBarButtonItemWithTitle:(NSString *)title
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"31"] forState:UIControlStateNormal];
    [btn setContentMode:UIViewContentModeScaleAspectFill];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -7, 0, 50)];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 10)];
    [btn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

/**
 *  设置实时结算界面返回按钮标题
 */
- (void)setBackBarButtonItemWithRealTitle:(NSString *)title
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"NavBackSorrow"] forState:UIControlStateNormal];
    [btn setContentMode:UIViewContentModeScaleAspectFill];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -7, 0, 50)];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 10)];
    [btn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

/**
 *  设置返回首页按钮
 */

- (void)setHomeBackBarButtonItemWithTitle:(NSString *)title
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn setTitleColor:COLOR_MY_WHITE forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"NavBackSorrow"] forState:UIControlStateNormal];
    [btn setContentMode:UIViewContentModeScaleAspectFill];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -7, 0, 50)];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 10)];
    [btn addTarget:self action:@selector(backAction1:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

/**
 *  设置右边按钮标题
 */
- (void)setRightBarButtonItemWithTitle:(NSString *)title
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn setTitleColor:COLOR_MY_WHITE forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = barButtonItem;
}


/**
 *  导航栏标题
 */
- (void)setNavTitle:(NSString *)title
{
    self.navigationItem.title = title;
}
/**
 *  返回按钮点击事件
 */
- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  小票返回按钮直接返回Home首页
 */

- (void)backAction1:(id)sender
{
    HomePageViewController *homeVc = [[HomePageViewController alloc]init];
    //[self presentViewController:homeVc animated:YES completion:nil];
    [self.navigationController pushViewController:homeVc animated:YES];
    
}


- (void)rightAction:(id)sender
{
    
}

#pragma mark UIKeyboardNotification
/**
 *  增加键盘通知
 */
- (void)addKeyboardNotification {
    //给键盘注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputKeyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputKeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}
/**
 *  移除键盘通知
 */
- (void)removeKeyboardNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)inputKeyboardWillShow:(NSNotification *)notification{}
- (void)inputKeyboardWillHide:(NSNotification *)notification{}


#pragma mark 
/**
 *  设置警告框
 *
 *  @param title     标题
 *  @param message   消息
 *  @param btnTitles 按钮标题
 */
- (void)showAlterViewWithTitle:(NSString *)title message:(NSString *)message btnTitles:(NSArray *)btnTitles
{
    self.alterView = [[UIAlertView alloc] initWithTitle:@"" message:@"\n \n \n " delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    [self.alterView show];
    UIView *baseView = [[UIView alloc] init];
    [baseView setBounds:CGRectMake(0, 0, 250, 250)];
    [baseView setCenter:self.view.window.center];
    [self.alterView addSubview:baseView];
    [baseView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view);
        make.left.equalTo((SCREEN_WIDTH - 250) / 2.);
        make.width.equalTo(250);
        make.height.equalTo(110);
    }];
    
    UILabel *labMessage = [[UILabel alloc] init];
    [labMessage setFont:[UIFont systemFontOfSize:17]];
    [labMessage setTextColor:COLOR_FONT_BLACK];
    [labMessage setText:message];
    [baseView addSubview:labMessage];
    [labMessage makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(baseView);
        make.left.equalTo(baseView).offset(10);
        make.right.equalTo(baseView).offset(-10);
        make.height.equalTo(150);
    }];
    
    for (int i = 0; i < btnTitles.count; i++) {
        UIButton *btn = [[UIButton alloc] init];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn setTitleColor:COLOR_LINE forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btn setTitle:[btnTitles objectAtIndex:i] forState:UIControlStateNormal];
        [btn setBackgroundColor:COLOR_THEME];
        [btn addTarget:self action:@selector(alterBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [baseView addSubview:btn];
        [btn makeConstraints:^(MASConstraintMaker *make) {
            if (btnTitles.count == 1) {
                make.left.equalTo(baseView);
                make.right.equalTo(baseView);
                make.width.equalTo(baseView);
            }else if(btnTitles.count == 2) {
                if (i == 0) {
                    make.left.equalTo(baseView);
                    make.right.equalTo(250 / 2.);
                }else {
                    make.left.equalTo(250 / 2.);
                    make.right.equalTo(baseView);
                }
                make.width.equalTo(250 / 2.);
            }
            make.height.equalTo(70);
        }];
    }
}

- (void)alterBtnAction:(UIButton *)btn{
    [self.alterView dismissWithClickedButtonIndex:0 animated:YES];
}

//去掉导航栏下面的黑线
-(void)dismissLine {
    for (UIView *view in self.navigationController.navigationBar.subviews) {
        for (UIView *subview in view.subviews) {
            if (subview.bounds.size.height <= 1 ) {
                NSLog(@"%f", subview.bounds.size.height);
                [subview removeFromSuperview];
            }
        }
    }
}

@end
