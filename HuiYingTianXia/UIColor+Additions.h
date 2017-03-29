//
//  UIColor+Additions.h
//  ZhongChou
//
//  Created by LCL on 4/22/13.
//  Copyright (c) 2013 ZhongChou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Additions)

+ (UIColor *)UIColorFromRGBAColorWithRed:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b alpha:(CGFloat)a;
+ (UIColor *)colorWithHex:(int)hex;
+ (UIColor *)colorWithHexString:(NSString *)hexString;

+ (UIColor *)tableBackgroundColor;
+ (UIColor *)themeColor;
+ (UIColor *)themeTextColor;
+ (UIColor *)darkThemeTextColor;
+ (UIColor *)grayTextColor;
+ (UIColor *)grayShadowColor;
+ (UIColor *)deepGrayTextColor;
+ (UIColor *)lightGrayTextColor;
+ (UIColor *)blackTextColor;
+ (UIColor *)lightGrayTableBackgroundColor;
+ (UIColor *)lightGrayBorderColor;
+ (UIColor *)grayProgressBarColor;
+ (UIColor *)themeProgressBarColor;
+ (UIColor *)grayBorderColor;
+ (UIColor *)darkGrayBackgroundColor;
+ (UIColor *)lightLightGrayTextColor;
+ (UIColor *)grayTableBackgroundColor;

@end
