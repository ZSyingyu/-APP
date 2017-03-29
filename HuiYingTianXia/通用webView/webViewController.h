//
//  webViewController.h
//  OptimalCar
//
//  Created by RoarRain on 15/5/26.
//  Copyright (c) 2015年 technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface webViewController : UIViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *titles;
@property (weak, nonatomic) IBOutlet UIProgressView *aProgressView;

@end
