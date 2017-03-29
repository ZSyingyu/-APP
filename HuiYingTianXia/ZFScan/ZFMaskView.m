//
//  ZFMaskView.m
//  ScanBarCode
//
//  Created by apple on 16/3/8.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZFMaskView.h"
#import "ZFConst.h"

@interface ZFMaskView()

@property (nonatomic, strong) UIImageView * scanLineImg;
@end

@implementation ZFMaskView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addUI];
    }
    
    return self;
}

/**
 *  添加UI
 */
- (void)addUI{
    //遮罩层
    UIView * maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    maskView.backgroundColor = [UIColor blackColor];
    maskView.alpha = 0.5;
    maskView.layer.mask = [self maskLayer];
    [self addSubview:maskView];
    
    //提示框
    UILabel * hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - 120, 60)];
    hintLabel.text = @"将 二维码/条形码 放入框内中央，即可自动扫描";
    hintLabel.center = CGPointMake(maskView.center.x, maskView.center.y + (self.frame.size.width - 120) * 0.5 - 40);
    hintLabel.textColor = [UIColor lightGrayColor];
    hintLabel.numberOfLines = 0;
    hintLabel.font = FONT_15;
    hintLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:hintLabel];
    
    //边框
    UIImage * topLeft = [UIImage imageNamed:@"ScanQR1"];
    UIImage * topRight = [UIImage imageNamed:@"ScanQR2"];
    UIImage * bottomLeft = [UIImage imageNamed:@"ScanQR3"];
    UIImage * bottomRight = [UIImage imageNamed:@"ScanQR4"];
    
    //左上
    UIImageView * topLeftImg = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - (self.frame.size.width - 120)) * 0.5, 100, topLeft.size.width, topLeft.size.height)];
    topLeftImg.image = topLeft;
    [self addSubview:topLeftImg];
    
    //右上
    UIImageView * topRightImg = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - (self.frame.size.width - 120)) * 0.5 - topRight.size.width + self.frame.size.width - 120, 100, topRight.size.width, topRight.size.height)];
    topRightImg.image = topRight;
    [self addSubview:topRightImg];
    
    //左下
    UIImageView * bottomLeftImg = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - (self.frame.size.width - 120)) * 0.5, 100 - bottomLeft.size.height + self.frame.size.width - 120, bottomLeft.size.width, bottomLeft.size.height)];
    bottomLeftImg.image = bottomLeft;
    [self addSubview:bottomLeftImg];
    
    //右下
    UIImageView * bottomRightImg = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - (self.frame.size.width - 120)) * 0.5 - bottomRight.size.width + self.frame.size.width - 120, 100 - bottomRight.size.width + self.frame.size.width - 120, bottomRight.size.width, bottomRight.size.height)];
    bottomRightImg.image = bottomRight;
    [self addSubview:bottomRightImg];
    
    //扫描线
    UIImage * scanLine = [UIImage imageNamed:@"QRCodeScanLine"];
    self.scanLineImg = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - (self.frame.size.width - 120)) * 0.5, 100, self.frame.size.width - 120, scanLine.size.height)];
    self.scanLineImg.image = scanLine;
    self.scanLineImg.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.scanLineImg];
    [self.scanLineImg.layer addAnimation:[self animation] forKey:nil];
}

- (CABasicAnimation *)animation{
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.duration = 3;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.repeatCount = MAXFLOAT;
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x, 100)];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.scanLineImg.frame.origin.y + self.frame.size.width - 120 - self.scanLineImg.frame.size.height * 0.5)];
    
    return animation;
}

/**
 *  遮罩层bezierPath
 *
 *  @return UIBezierPath
 */
- (UIBezierPath *)maskPath{
    UIBezierPath * bezier = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [bezier appendPath:[[UIBezierPath bezierPathWithRect:CGRectMake((self.frame.size.width - (self.frame.size.width - 120)) * 0.5, 100, self.frame.size.width - 120, self.frame.size.width - 120)] bezierPathByReversingPath]];
    
    return bezier;
}

/**
 *  遮罩层ShapeLayer
 *
 *  @return CAShapeLayer
 */
- (CAShapeLayer *)maskLayer{
    CAShapeLayer * layer = [CAShapeLayer layer];
    layer.path = [self maskPath].CGPath;
    
    return layer;
}

/**
 *  移除动画
 */
- (void)removeAnimation{
    [self.scanLineImg.layer removeAllAnimations];
}

@end
