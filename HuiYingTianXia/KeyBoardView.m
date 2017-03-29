//
//  KeyBoardView.m
//  HuiYingTianXia
//
//  Created by tsmc on 15-3-20.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import "KeyBoardView.h"

@interface KeyBoardView ()
@property(nonatomic, strong)NSArray *btnTitles;
@end

#define BTN_WIDTH HFixWidthBaseOn320(107)
#define BTN_HEIGHT HFixHeightBaseOn568(58)

@implementation KeyBoardView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.btnTitles = @[@"pwd_1",@"pwd_2",@"pwd_3",@"pwd_4",@"pwd_5",@"pwd_6",@"pwd_7",@"pwd_8",@"pwd_9",@"pwd_clear",@"pwd_0",@"pwd_delete"];
        
        for (NSInteger i = 0; i < self.btnTitles.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            NSString *number = [self.btnTitles objectAtIndex:i];
            
            [btn setTag:number.integerValue];
            [btn setBackgroundColor:COLOR_MY_WHITE];
            [btn setContentMode:UIViewContentModeBottom];
            btn.tag = i+1;
            [btn setFrame:CGRectMake((i%3) * BTN_WIDTH, (i/3) * BTN_HEIGHT, BTN_WIDTH, BTN_HEIGHT)];
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",number]];
            UIView *view = [[UIView alloc] init];
            view.layer.contents = (id)image.CGImage;
            [view setUserInteractionEnabled:NO];
            [view setBounds:CGRectMake(0, 0, image.size.width, image.size.height)];
            view.center = CGPointMake(BTN_WIDTH/2.f, BTN_HEIGHT /2.f);
            [btn addSubview:view];
            
        }
        
        for (int i = 1; i < 3; i++) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(BTN_WIDTH * i, 0, LINE_HEIGTH, BTN_HEIGHT * 4)];
            [line setBackgroundColor:COLOR_LINE];
            [self addSubview:line];
        }
        for (int i = 0; i < 4; i++) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, BTN_HEIGHT * i, BTN_WIDTH * 3, LINE_HEIGTH)];
            [line setBackgroundColor:COLOR_LINE];
            [self addSubview:line];
        }

    }
    return self;
}

- (void)btnAction:(UIButton *)btn
{
    self.keyBoardClick(btn.tag);
}

+ (CGFloat)getHeight
{
    return BTN_HEIGHT * 4;
}
@end
