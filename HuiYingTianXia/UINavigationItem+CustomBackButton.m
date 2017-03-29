//
//  UINavigationItem+CustomBackButton.m
//  HuiYingTianXia
//
//  Created by tsmc on 15/5/8.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import "UINavigationItem+CustomBackButton.h"

@implementation UINavigationItem (CustomBackButton)

- (UIBarButtonItem *)backBarButtonItem
{
    return [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:NULL];
}
@end
