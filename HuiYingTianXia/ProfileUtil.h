//
//  ProfileUtil.h
//  HuiYingTianXia
//
//  Created by tsmc on 15/5/4.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProfileUtil : NSObject
+ (void)saveAccount:(NSString *)account password:(NSString *)password;
+ (NSString *)getValueWithKey:(NSString *)key;
@end
