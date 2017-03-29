//
//  SignView.h
//  draw
//
//  Created by tsmc on 13-8-27.
//  Copyright (c) 2013年 Tsmc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignView : UIView {
    NSMutableArray *allLineArray;
    
    BOOL isClear;
}
@property(nonatomic, assign)BOOL isSigned;      //判断用户是否进行了签名
@property(nonatomic, retain)NSMutableArray *allPiontArray;

- (void)clearSreen;
@end
