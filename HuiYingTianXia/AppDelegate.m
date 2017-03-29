//
//  AppDelegate.m
//  HuiYingTianXia
//
//  Created by tsmc on 15-3-17.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "NewLoginViewController.h"

#import "POSManger.h"
#import <JSPatch/JSPatch.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [NSThread sleepForTimeInterval:1.5];
    
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self customNavigationBar];
    NewLoginViewController *viewController = [[NewLoginViewController alloc] init];
    UINavigationController *rootViewController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [rootViewController.view setBackgroundColor:[UIColor colorWithHexString:@"#f8c119"]];
    self.window.rootViewController = rootViewController;
    
    [self.window makeKeyAndVisible];
    
    /**
     *  利用JSpatch热修复来下载修复补丁
     */
//    [JSPatch startWithAppKey:@"bc3efba46b1cca3b"];
//    
//    //用来检测回调的状态，是更新或者是执行脚本之类的，相关信息，会打印在你的控制台
//    [JSPatch setupCallback:^(JPCallbackType type, NSDictionary *data, NSError *error) {
//        
//    }];
//    [JSPatch setupDevelopment];
//    
////    [JSPatch setupRSAPublicKey:@"-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCuetjiM36rpeK8+1gDSNXeL2Eg\nk772z5Ul+Trh1xr5T4tUUn6oEdnyqKmpbcnt5AXPeI/KBfNP/N1kbU6Ckl9tBLO/\nBLJXqlugdWWFFyOjCeUSKyqQyKPwBRqaxVYWQa5yghxdBnIFmwCwIvBHnqmA3x07\nVPo7umnBTHqd1oZEWQIDAQAB\n-----END PUBLIC KEY-----"];
//    
//    [JSPatch sync];
    
    return YES;
}


#pragma mark custom UINavigationBar
- (void)customNavigationBar
{
    //NavigationBar 背景色
    [[UINavigationBar appearance] setBarTintColor:COLOR_THEME];
    if (SYSTEM_VERSION_LATER_THAN8) {
        //NavigationBar 不半透明
        [[UINavigationBar appearance] setTranslucent:NO];
    }
    //NavigationBar title
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           COLOR_MY_WHITE,
                                                           NSForegroundColorAttributeName,
                                                           [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:18],
                                                           NSFontAttributeName, nil]];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
