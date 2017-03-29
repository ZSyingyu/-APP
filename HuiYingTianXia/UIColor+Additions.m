//
//  UIColor+Additions.m
//  ZhongChou
//
//  Created by LCL on 4/22/13.
//  Copyright (c) 2013 ZhongChou. All rights reserved.
//

#import "UIColor+Additions.h"

@implementation UIColor (Additions)

+ (UIColor *)colorWithHex:(int)hex
{
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0
                           green:((float)((hex & 0xFF00) >> 8))/255.0
                            blue:((float)(hex & 0xFF))/255.0 alpha:1.0];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString
{
    const char *cString = [hexString cStringUsingEncoding: NSASCIIStringEncoding];
    int hex;
    
    // if the string contains hash tag (#) then remove
    // hash tag and convert the C string to a base-16 int
    if ( cString[0] == '#' )
    {
        hex = strtol(cString + 1, NULL, 16);
    }
    else
    {
        hex = strtol(cString, NULL, 16);
    }
    
    UIColor *color = [self colorWithHex: hex];
    return color;
}

+ (UIColor *)UIColorFromRGBAColorWithRed:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b alpha:(CGFloat)a
{
    return [UIColor colorWithRed: r/255.0 green: g/255.0 blue: b/255.0 alpha:a];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Custom Color

+ (UIColor *)themeColor
{
    return [UIColor colorWithRed:184/255.0 green:78/255.0 blue:66/255.0 alpha:1.0];
}

+ (UIColor *)themeTextColor
{
    return [UIColor colorWithRed:190/255.0 green:81/255.0 blue:66/255.0 alpha:1.0];
}

+ (UIColor *)darkThemeTextColor
{
    return [UIColor colorWithRed:188/255.0 green:81/255.0 blue:63/255.0 alpha:1.0];
}

+ (UIColor *)tableBackgroundColor
{
    return [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1.0];
}

+ (UIColor *)grayTextColor
{
    return [UIColor colorWithRed:87/255.0 green:87/255.0 blue:87/255.0 alpha:1.0];
}

+ (UIColor *)grayShadowColor
{
    return [UIColor colorWithRed:75/255.0 green:75/255.0 blue:75/255.0 alpha:0.75];
}

+ (UIColor *)deepGrayTextColor
{
    return [UIColor colorWithRed:54/255.0 green:54/255.0 blue:54/255.0 alpha:1.0];
}

+ (UIColor *)lightGrayTextColor
{
    return [UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:1.0];
}

+ (UIColor *)blackTextColor
{
    return [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1.0];
}

+ (UIColor *)lightGrayTableBackgroundColor
{
    return [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
}

+ (UIColor *)lightGrayBorderColor
{
    return [UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1.0];
}

+ (UIColor *)grayProgressBarColor
{
    return [UIColor colorWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:1.0];
}

+ (UIColor *)themeProgressBarColor
{
    return [UIColor colorWithRed:200/255.0 green:83/255.0 blue:81/255.0 alpha:1.0];
}

+ (UIColor *)grayBorderColor
{
    return [UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1.0];
}

+ (UIColor *)darkGrayBackgroundColor
{
    return [UIColor colorWithRed:194/255.0 green:194/255.0 blue:194/255.0 alpha:1.0];
}

+ (UIColor *)lightLightGrayTextColor
{
    return [UIColor colorWithRed:146/255.0 green:146/255.0 blue:146/255.0 alpha:1.0];
}

+ (UIColor *)grayTableBackgroundColor
{
    return [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
}


@end
