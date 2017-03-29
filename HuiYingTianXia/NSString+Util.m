//
//  NSString+Util.m
//  ZhongChou
//
//  Created by Jason on 14-1-2.
//  Copyright (c) 2014年 ZhongChou. All rights reserved.
//

#import "NSString+Util.h"

@implementation NSString (Util)


- (bool)isEmpty
{
    return self.length == 0;
}

- (BOOL)isPureInt
{
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

- (NSString *)trim
{
    NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
    return [self stringByTrimmingCharactersInSet:set];
}

- (CGSize)suggestedSizeWithFont:(UIFont *)font
{
    CGSize size = CGSizeZero;
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    if ([self respondsToSelector:@selector(sizeWithAttributes:)]) {
        size = [self sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,  nil]];
    } else {
#endif
        size = [self sizeWithFont:font];
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    }
#endif
    return size;
}

- (CGSize)suggestedSizeWithFont:(UIFont *)font size:(CGSize)size
{
    return [self suggestedSizeWithFont:font
                                 width:size.width];
}

- (CGSize)suggestedSizeWithFont:(UIFont *)font width:(CGFloat)width
{
    CGSize size = CGSizeZero;
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        CGRect bounds = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,  nil]
                                           context:nil];
        size = bounds.size;
    } else {
#endif
        size = [self sizeWithFont:font
                constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)];
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    }
#endif
    return size;
}
@end
