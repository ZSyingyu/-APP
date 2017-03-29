//
//  ConsumeResultCell.m
//  HuiYingTianXia
//
//  Created by tsmc on 15-3-19.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import "ConsumeResultCell.h"
#import "NSString+Util.h"

@interface ConsumeResultCell()
@property(nonatomic , strong)UILabel *labType;
@property(nonatomic , strong)UIImageView *ivStatus;
@property(nonatomic , strong)UIButton *btnMaskLayer;
@end

@implementation ConsumeResultCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.labType = [[UILabel alloc] init];
        self.labType.font = FONT_16;
        [self.labType setTextAlignment:NSTextAlignmentLeft];
        [self.labType setTextColor:COLOR_FONT_GRAY];
        [self.contentView addSubview:self.labType];
        
        if ([reuseIdentifier isEqualToString:@"Lable"]) {
            
            self.labContent = [[UILabel alloc] init];
            self.labContent.font = FONT_16;
            [self.labContent setTextAlignment:NSTextAlignmentLeft];
            [self.contentView addSubview:self.labContent];
        }else if([reuseIdentifier isEqualToString:@"TextField"]){
            
            self.tfContent = [[UITextField alloc] init];
            self.tfContent.font = FONT_16;
            self.tfContent.layer.borderColor = COLOR_LINE.CGColor;
            self.tfContent.layer.borderWidth = 1;
            self.tfContent.placeholder = @"请输入密码";
            self.tfContent.secureTextEntry = YES;
            self.tfContent.userInteractionEnabled = NO;
            [self.tfContent setTextAlignment:NSTextAlignmentCenter];
            [self.tfContent setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            
            [self.contentView addSubview:self.tfContent];
            
            self.btnMaskLayer = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.btnMaskLayer setBackgroundColor:[UIColor clearColor]];
            [self.btnMaskLayer addTarget:self action:@selector(tapTfContentAction) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:self.btnMaskLayer];
            
        }else if([reuseIdentifier isEqualToString:@"LableAndImageView"]){
            
            self.labContent = [[UILabel alloc] init];
            self.labContent.font = FONT_16;
            [self.labContent setTextAlignment:NSTextAlignmentLeft];
            [self.contentView addSubview:self.labContent];
            
            self.ivStatus = [[UIImageView alloc] init];
            [self.ivStatus setImage:[UIImage imageNamed:@"success"]];
            [self.contentView addSubview:self.ivStatus];
        }
        
    }
    return self;
}

- (void)tapTfContentAction
{
    self.tapTfContentBlock();
}

- (void)setType:(NSString *)type andContent:(NSString *)content
{
    self.labType.text = type;
    self.labContent.text = content;
    
    CGSize size = [self.labType sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    CGFloat height = size.height > CELL_HEIGHT? size.height :CELL_HEIGHT;
    [self.labType setFrame:CGRectMake(10, 0, size.width, height)];
    
    if (self.labContent) {
        size = [self.labContent sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        height = size.height > CELL_HEIGHT? size.height :CELL_HEIGHT;
        [self.labContent setFrame:CGRectMake(CGRectGetMaxX(self.labType.frame) +16, 0, size.width, height)];
    }else if (self.tfContent) {
        [self.tfContent setFrame:CGRectMake(CGRectGetMaxX(self.labType.frame) +16, 0, 120, height)];
        [self.btnMaskLayer setFrame:self.tfContent.frame];
    }
}

- (void)setStatus:(BOOL)success
{
    if (success) {
        self.labContent.text = @"交易成功";
        [self.labContent setTextColor:[UIColor colorWithHexString:@"#009944"]];
        self.ivStatus.image = [UIImage imageNamed:@"success"];
    }else {
        self.labContent.text = @"交易失败";
        [self.labContent setTextColor:COLOR_FONT_RED];
        self.ivStatus.image = [UIImage imageNamed:@"fail"];
    }
    
}

- (CGFloat)getCellHeight
{
//    CGSize size = CGSizeMake(0, 0);
//    if (self.labContent) {
//       size = [self.labContent.text suggestedSizeWithFont:self.labContent.font width:100];
//       size.height += (CELL_HEIGHT - self.labContent.font.lineHeight);
//    }
//
//    return size.height > CELL_HEIGHT? size.height :CELL_HEIGHT;
    return CELL_HEIGHT;
}
@end
