//
//  ScrollImage.h
//  ScrollViewTest
//
//  Created by Mac on 16/4/13.
//  Copyright © 2016年 jyb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>

@class ScrollImage;
@protocol ScrollImageDelegate <NSObject>

@optional
- (void)scrollImage:(ScrollImage *)scrollImage clickedAtIndex:(NSInteger)index;

@end

@interface ScrollImage : UIViewController

@property (nonatomic, weak) id<ScrollImageDelegate> delegate;

@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, strong) UIPageControl  *pageControl;
@property (nonatomic, strong) UIImage        *placeholderImage;

- (instancetype)initWithCurrentController:(UIViewController *)viewcontroller urlString:(NSArray *)urls viewFrame:(CGRect)frame placeholderImage:(UIImage *)image;
- (instancetype)initWithCurrentController:(UIViewController *)viewcontroller imageNames:(NSArray *)images viewFrame:(CGRect)frame placeholderImage:(UIImage *)image;

@end




@interface NSString (MD5)
- (id)MD5;
@end