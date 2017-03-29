//
//  Common.h
//  HuiYingTianXia
//
//  Created by tsmc on 15-3-18.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#ifndef TestTweet_Common_h
#define TestTweet_Common_h

//屏幕宽
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
//屏幕高
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
//navigation bar高度
#define NAVIGATIONBAT_HEIGTH 64
//状态栏高度
#define STATUS_BAR_HEIGHT 20

//系统大于8.0
#define SYSTEM_VERSION_LATER_THAN8 [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0



#define LINE_HEIGTH             .5
#define BNT_HEIGHT              HFixWidthBaseOn320(37)
#define CELL_HEIGHT             HFixWidthBaseOn320(25)
#define LEFT_PAD                HFixWidthBaseOn320(10)
#define RIGHT_PAD               HFixWidthBaseOn320(10)


#define COLOR_LINE              [UIColor colorWithHexString:@"#ebebeb"]
#define COLOR_FONT_GRAY         [UIColor colorWithHexString:@"#c2c4cb"]
#define COLOR_THEME             [UIColor colorWithHexString:@"#1e81d2"]
#define COLOR_MY_WHITE          [UIColor colorWithHexString:@"#ffffff"]
#define COLOR_FONT_RED          [UIColor colorWithHexString:@"#a40000"]
#define COLOR_FONT_BLACK        [UIColor colorWithHexString:@"#000000"]
#define COLOR_FONT_BLUE         [UIColor colorWithHexString:@"#208ede"]
#define COLOR_FONT_YELLOW       [UIColor colorWithHexString:@"#f3fa8a"]
#define COLOR_THE_WHITE             [UIColor colorWithHexString:@"#f3f3f3"]
#define COLOR_THE_RED             [UIColor colorWithHexString:@"#e66814"]

#define FONT_25                 [UIFont systemFontOfSize:25]
#define FONT_22                 [UIFont systemFontOfSize:22]
#define FONT_23                 [UIFont systemFontOfSize:23]
#define FONT_20                 [UIFont systemFontOfSize:20]
#define FONT_18                 [UIFont systemFontOfSize:18]
#define FONT_17                 [UIFont systemFontOfSize:17]
#define FONT_16                 [UIFont systemFontOfSize:16]
#define FONT_15                 [UIFont systemFontOfSize:15]
#define FONT_14                 [UIFont systemFontOfSize:14]
#define FONT_13                 [UIFont systemFontOfSize:13]
#define FONT_12                 [UIFont systemFontOfSize:12]


#define SUCCESS                 1
#define FAIL                    0
//适配以320屏幕宽度的Frame参数
CG_INLINE CGFloat HFixWidthBaseOn320(CGFloat width)
{
//    return width;
        return (SCREEN_WIDTH * width) / 320.;
}

CG_INLINE CGFloat HFixHeightBaseOn568(CGFloat height)
{
    return (SCREEN_HEIGHT-64) * height / (568.-64);
}


typedef enum TRADE_YTPE{
    type_consument,//消费
    type_balance,//余额
    type_revoke,//取消
    type_realTime//实时
}TRADE_YTPE;


typedef enum RESULT_STATUS{
    type_success,
    type_fail
}RESULT_STATUS;


//判断终端是否是iphone4/4s
#define IPHONE4__4S ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? [[UIScreen mainScreen] currentMode].size.height == 960 : NO)
#endif

//判断终端是否是iphone5/5s
#define IPHONE5__5S ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? [[UIScreen mainScreen] currentMode].size.height == 1136 : NO)

//判断终端是否是iphone6
#define IPHONE6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? [[UIScreen mainScreen] currentMode].size.height == 1334 : NO)
