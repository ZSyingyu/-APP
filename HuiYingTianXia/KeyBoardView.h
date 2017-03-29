//
//  KeyBoardView.h
//  HuiYingTianXia
//
//  Created by tsmc on 15-3-20.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^KeyBoardClick)(NSInteger number);

@interface KeyBoardView : UIView
@property(nonatomic, copy)KeyBoardClick keyBoardClick;

+ (CGFloat)getHeight;
@end
