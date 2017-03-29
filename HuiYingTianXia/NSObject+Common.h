//
//  NSObject+Common.h
//  HuiYingTianXia
//
//  Created by tsmc on 15-4-9.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Common)
#pragma mark Tip M
- (void)showError:(NSError *)error;

- (void)showStatusBarQueryStr:(NSString *)tipStr;
- (void)showStatusBarSuccessStr:(NSString *)tipStr;
- (void)showStatusBarError:(NSError *)error;


#pragma mark NetError
-(id)handleResponse:(id)responseJSON;
@end
