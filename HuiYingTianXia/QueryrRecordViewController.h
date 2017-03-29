//
//  QueryrRecordViewController.h
//  HuiYingTianXia
//
//  Created by tsmc on 15-3-29.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^ SegSelectedBlock)(BOOL type);

@interface SegmentView : UIView
@property(nonatomic, copy)SegSelectedBlock segSelectedBlock;
@end


@interface QueryrRecordTableCell : UITableViewCell

@end

@interface QueryrRecordViewController : BaseViewController
typedef enum{
    loadRefresh,
    loadMore
}LoadType;

- (void)setRightBarButtonItemWithTitle:(NSString *)title;

@property(nonatomic, strong)NSDictionary *cardInfo;



@end
