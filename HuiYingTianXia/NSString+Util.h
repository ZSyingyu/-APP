//
//  NSString+Util.h
//  ZhongChou
//
//  Created by Jason on 14-1-2.
//  Copyright (c) 2014年 ZhongChou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Util)
- (bool)isEmpty;
- (BOOL)isPureInt;
- (NSString *)trim;
- (CGSize)suggestedSizeWithFont:(UIFont *)font;
- (CGSize)suggestedSizeWithFont:(UIFont *)font width:(CGFloat)width;
- (CGSize)suggestedSizeWithFont:(UIFont *)font size:(CGSize)size;
@end
