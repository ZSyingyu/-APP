//
//  SZBlueConsumeViewController.h
//  HuiYingTianXia
//
//  Created by liguo.chen on 16/9/8.
//  Copyright © 2016年 tsmc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

#import "AnFSwiperController.h"
#import "MBProgressHUD.h"
#import "DeviceParams.h"

@interface SZBlueConsumeViewController : BaseViewController<UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,AnFSwiperControllerDelegate, UIActionSheetDelegate,MBProgressHUDDelegate>
{
    AnFSwiperController *blue;
}

@end
