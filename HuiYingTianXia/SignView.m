//
//  SignView.m
//  draw
//
//  Created by tsmc on 13-8-27.
//  Copyright (c) 2013年 Tsmc. All rights reserved.
//

#import "SignView.h"
#import <QuartzCore/QuartzCore.h>

@implementation SignView
@synthesize isSigned;
@synthesize allPiontArray;

#define DRAW_COLOR_LINE [[UIColor blackColor]CGColor]
#define DRAW_LINE_WIDTH 2.0


- (instancetype)init
{
    self = [super init];
    if(self) {
        allLineArray = [[NSMutableArray alloc] init];
        isSigned = NO;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    //获取上下文
	CGContextRef context=UIGraphicsGetCurrentContext();
	//设置笔冒
	CGContextSetLineCap(context, kCGLineCapRound);
	//设置画线的连接处　拐点圆滑
	CGContextSetLineJoin(context, kCGLineJoinRound);
    
    if ([allLineArray count] > 0) {
        for (int i=0; i<[allLineArray count]; i++) {
			NSArray* tempArray=[NSArray arrayWithArray:[allLineArray objectAtIndex:i]];

			if ([tempArray count]>1) {
				CGContextBeginPath(context);
				CGPoint myStartPoint=[[tempArray objectAtIndex:0] CGPointValue];
				CGContextMoveToPoint(context, myStartPoint.x, myStartPoint.y);
				
				for (int j=0; j<[tempArray count]-1; j++) {
					CGPoint myEndPoint=[[tempArray objectAtIndex:j+1] CGPointValue];
					//--------------------------------------------------------
					CGContextAddLineToPoint(context, myEndPoint.x,myEndPoint.y);
				}
				CGContextSetStrokeColorWithColor(context, DRAW_COLOR_LINE);
				//-------------------------------------------------------
				CGContextSetLineWidth(context, DRAW_LINE_WIDTH);
				CGContextStrokePath(context);
			}
		}
	}
    if (!isClear) {
        if ([self.allPiontArray count] > 1) {
            CGPoint startPoint = [[self.allPiontArray objectAtIndex:0] CGPointValue];
            CGContextBeginPath(context);
            CGContextMoveToPoint(context, startPoint.x, startPoint.y);
            for (int j=1; j < [self.allPiontArray count]; j++) {
                CGPoint endPoint = [[self.allPiontArray objectAtIndex:j] CGPointValue];
                CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
            }
            CGContextSetStrokeColorWithColor(context, DRAW_COLOR_LINE);
            CGContextSetLineWidth(context, DRAW_LINE_WIDTH);
            CGContextStrokePath(context);
        }
    }   
}



- (void)clearSreen {
    isSigned = NO;

    isClear = YES;
    [self.allPiontArray removeAllObjects];
    [allLineArray removeAllObjects];
    [self setNeedsDisplay];
}




- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    isSigned = YES;
    isClear = NO;
    
    UITouch* touch=[touches anyObject];
	CGPoint startPoint=[touch locationInView:self];
    self.allPiontArray = [NSMutableArray array];
	[self.allPiontArray addObject:[NSValue valueWithCGPoint:startPoint]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSArray* MovePointArray=[touches allObjects];
	CGPoint point=[[MovePointArray objectAtIndex:0] locationInView:self];
    [self.allPiontArray addObject:[NSValue  valueWithCGPoint:point]];
	[self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [allLineArray addObject:self.allPiontArray];
	[self setNeedsDisplay];
}
@end
