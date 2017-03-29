//
//  ConsumeResultCell.h
//  HuiYingTianXia
//
//  Created by tsmc on 15-3-19.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^TapTfContentBlock)();

@interface ConsumeResultCell : UITableViewCell
@property(nonatomic , strong)UILabel *labContent;
@property(nonatomic , strong)UITextField *tfContent;
@property(nonatomic , copy)TapTfContentBlock tapTfContentBlock;

- (void)setType:(NSString *)type andContent:(NSString *)content;
- (void)setStatus:(BOOL)success;

- (CGFloat)getCellHeight;
@end
