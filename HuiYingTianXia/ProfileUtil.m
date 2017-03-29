//
//  ProfileUtil.m
//  HuiYingTianXia
//
//  Created by tsmc on 15/5/4.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import "ProfileUtil.h"
#import "SSKeychain.h"

@implementation ProfileUtil
NSString *const PSAccount  = @"account";
NSString *const PSPassword  = @"password ";



#define PWD @"password"
#define ACCOUNT @"account"

+ (void)saveAccount:(NSString *)account password:(NSString *)password
{
    
    NSArray *accounts = [SSKeychain allAccounts];
    NSString *storeAccount = nil;
    if (accounts.count > 0){
        storeAccount = [accounts objectAtIndex:0];
    }

    if (storeAccount && ![storeAccount isEqualToString:account]) {
        for (NSString *str in [SSKeychain accountsForService:storeAccount]) {
            [SSKeychain deletePasswordForService:str account:storeAccount];
        }
    }
    [SSKeychain setPassword:password forService:PSPassword account:account];
//    [SSKeychain setPassword:account forService:PSAccount account:account];
}

+ (NSString *)getValueWithKey:(NSString *)key
{
    NSArray *accounts = [SSKeychain allAccounts];
    NSString *value = nil;
    if ([accounts count] > 0) {
        value = [SSKeychain passwordForService:key account:[accounts objectAtIndex:0]];
    }
    return value;
}
@end
