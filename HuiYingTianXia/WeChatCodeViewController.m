//
//  WeChatCodeViewController.m
//  HuiYingTianXia
//
//  Created by liguo.chen on 16/9/20.
//  Copyright © 2016年 tsmc. All rights reserved.
//

#import "WeChatCodeViewController.h"
#import "POSManger.h"
#import "AC_POSManger.h"
#import "AbstractItems.h"
#import "MJExtension.h"
#import "NSString+MD5HexDigest.h"
#import "ResponseDictionaryTool.h"
#import "MBProgressHUD+Add.h"
#import "WeChatResultViewController.h"

@interface WeChatCodeViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) NSTimer *timer;
@property(strong,nonatomic)NSString *responseStr;
@property(nonatomic, assign)CGFloat count;

@end

@implementation WeChatCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.clickButtonStatus isEqualToString:@"微信"]) {
        self.navigationItem.title = @"微信支付";
    } else if ([self.clickButtonStatus isEqualToString:@"支付宝"]) {
        self.navigationItem.title = @"支付宝支付";
    } else {
        
    }
    [self setBackBarButtonItemWithTitle:@"返回"];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"f6f7f7"];
    
    self.count = 0;
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.7)];
    headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headView];
    
//    UIWebView *webView = [[UIWebView alloc] init];
//    CGRect frame = webView.frame;
//    frame.origin.y = SCREEN_WIDTH * 0.03;
//    frame.size.width = SCREEN_WIDTH * 0.65;
//    frame.size.height = SCREEN_WIDTH * 0.65;
//    webView.frame = frame;
//    CGPoint center = webView.center;
//    center.x = SCREEN_WIDTH/2;
//    webView.center = center;
//    webView.backgroundColor = [UIColor clearColor];
//    webView.delegate = self;
//    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.codeUrlStr]];
//    webView.scalesPageToFit = YES;//实现页面缩放
//    [webView loadRequest:request];
//    webView.userInteractionEnabled = NO;
//    webView.opaque = NO;
//    [headView addSubview:webView];
    
    // 1. 实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2. 恢复滤镜的默认属性
    [filter setDefaults];
    
    // 3. 将字符串转换成NSData
    NSData *data = [self.codeUrlStr dataUsingEncoding:NSUTF8StringEncoding];
    // 4. 通过KVO设置滤镜inputMessage数据
    [filter setValue:data forKey:@"inputMessage"];
    
    // 5. 获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    
    // 6. 将CIImage转换成UIImage，并放大显示 (此时获取到的二维码比较模糊,所以需要用下面的createNonInterpolatedUIImageFormCIImage方法重绘二维码)
    //    UIImage *codeImage = [UIImage imageWithCIImage:outputImage scale:1.0 orientation:UIImageOrientationUp];
    
    UIImageView *wechatImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 0, SCREEN_WIDTH - 100, headView.frame.size.height)];
    wechatImageView.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:200];//重绘二维码,使其显示清晰
    wechatImageView.userInteractionEnabled = YES;
    [headView addSubview:wechatImageView];
    //    self.wechatImageView = wechatImageView;
    
    
    self.timer = [NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(checkOrderData) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headView.frame), SCREEN_WIDTH, 154)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 10, 1)];
    line1.backgroundColor = [UIColor colorWithHexString:@"b4b4b5"];
    [backView addSubview:line1];
    
    UILabel *merchantNOLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(line1.frame), SCREEN_WIDTH - 30, 50)];
    merchantNOLabel.backgroundColor = [UIColor whiteColor];
    merchantNOLabel.text = [NSString stringWithFormat:@"商户编号:  %@",[[NSUserDefaults standardUserDefaults] objectForKey:MerchantNo]];
    merchantNOLabel.textColor = [UIColor blackColor];
    merchantNOLabel.font = FONT_15;
    [backView addSubview:merchantNOLabel];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(merchantNOLabel.frame), SCREEN_WIDTH - 10, 1)];
    line2.backgroundColor = [UIColor colorWithHexString:@"b4b4b5"];
    [backView addSubview:line2];
    
    UILabel *merchantNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(merchantNOLabel.frame.origin.x, CGRectGetMaxY(line2.frame), merchantNOLabel.frame.size.width, merchantNOLabel.frame.size.height)];
    merchantNameLabel.backgroundColor = [UIColor whiteColor];
    merchantNameLabel.text = [NSString stringWithFormat:@"商户名称:  %@",[[NSUserDefaults standardUserDefaults] objectForKey:MerchantName]];
    merchantNameLabel.textColor = [UIColor blackColor];
    merchantNameLabel.font = FONT_15;
    [backView addSubview:merchantNameLabel];
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(merchantNameLabel.frame), SCREEN_WIDTH - 10, 1)];
    line3.backgroundColor = [UIColor colorWithHexString:@"b4b4b5"];
    [backView addSubview:line3];
    
//    NSRange range = NSMakeRange(5, 3);
//    NSRange range1 = NSMakeRange(3, 2);
//    NSString *str = [self.rate substringWithRange:range];
//    NSString *str1 = [self.rate substringWithRange:range1];
//    NSString *str2 = [[NSString stringWithFormat:@"%f",[str floatValue]/100] substringToIndex:4];
//    NSString *str3 = [NSString stringWithFormat:@"%d",[str1 intValue]];
//    NSString *strRate = [NSString stringWithFormat:@"%@",self.rate];
    
    NSString *feetStr;
//    if ([self.clickButtonStatus isEqualToString:@"微信"]) {
        if ([self.feetRate isEqualToString:@""]) {
            feetStr = @"0";
        }else {
            NSString *str;
            if ([[self.feetRate substringToIndex:1] isEqualToString:@"0"]) {
                //                        feetStr = [self.feetRate substringFromIndex:1];
                str = [self.feetRate substringFromIndex:1];
            }else {
                //            feetStr = self.feetRate;
                str = self.feetRate;
            }
            
            if ([str containsString:@"F"]) {
                feetStr = [str stringByReplacingOccurrencesOfString:@"F" withString:@"."];
            }else {
                feetStr = str;
            }
            
        }
//    } else if ([self.clickButtonStatus isEqualToString:@"支付宝"]) {
//        feetStr = self.feetRate;
//    } else {
//        
//    }
    
    UILabel *rateLabel = [[UILabel alloc] initWithFrame:CGRectMake(merchantNOLabel.frame.origin.x, CGRectGetMaxY(line3.frame), merchantNOLabel.frame.size.width, merchantNOLabel.frame.size.height)];
    rateLabel.backgroundColor = [UIColor whiteColor];
    rateLabel.text = [NSString stringWithFormat:@"费       率:  %@ + %@",self.rate,feetStr];
    rateLabel.textColor = [UIColor blackColor];
    rateLabel.font = FONT_15;
    [backView addSubview:rateLabel];
    
    UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(rateLabel.frame), SCREEN_WIDTH - 10, 1)];
    line4.backgroundColor = [UIColor colorWithHexString:@"b4b4b5"];
    [backView addSubview:line4];
    
    UILabel *noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(backView.frame) + 10, SCREEN_WIDTH, 25)];
    noticeLabel.text = @"温馨提示:  扫码即时到账";
    noticeLabel.textColor = [UIColor blackColor];
    noticeLabel.font = FONT_13;
    [self.view addSubview:noticeLabel];
}

/**
 * 根据CIImage生成指定大小的UIImage
 *
 * @param image CIImage
 * @param size 图片宽度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

-(void)checkOrderData {
    self.count += 1;
    
    if (self.count <= 20) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"查询订单" forKey:@"WeChatOrder"];
        
        AbstractItems *items = [[AbstractItems alloc] init];
        items.n0 = @"0700";
        items.n3 = @"190100";
        items.n61 = self.orderNumberStr;
//        items.n61 = @"123456789876";
        NSString *macStr = [NSString stringWithFormat:@"%@%@%@%@%@",items.n0,items.n3,items.n59,items.n61,MainKey];
        NSLog(@"macStr:%@",macStr);
        items.n64 = [[macStr md5HexDigest] uppercaseString];
        
        [[NetAPIManger sharedManger] request_RaiseQuotaListWithParams:[items keyValues] andBlock:^(id data, NSError *error) {
            AbstractItems *item = (AbstractItems *)data;
            //判断订单是否是初始化状态(依然是判断39域的值)
            if ([item.n39 isEqualToString:@"01"]) {
                
            }else {
                if ([item.n39 isEqualToString:@"00"]) {
                    NSLog(@"成功");
                    [self.timer invalidate];
                    self.timer = nil;
                    self.responseStr = @"";
                    
                    WeChatResultViewController *resultVc = [[WeChatResultViewController alloc] init];
                    resultVc.amountStr = self.amountStr;
                    [self.navigationController pushViewController:resultVc animated:YES];
                    
                }else {
                    NSLog(@"失败");
                    if ([[ResponseDictionaryTool responseDic] objectForKey:item.n39]) {
                        NSString *error = [[ResponseDictionaryTool responseDic] objectForKey:item.n39];
                        NSLog(@"error:%@",error);
                        [MBProgressHUD showSuccess:error toView:self.view];
                    }else {
                        [MBProgressHUD showSuccess:@"未知错误" toView:self.view];
                    }
                    
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        [NSThread sleepForTimeInterval:1.0];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.navigationController popViewControllerAnimated:YES];
                            [self.timer invalidate];
                            self.timer = nil;
                            self.responseStr = @"";
                        });
                    });
                }
            }
        }];

    }else if (self.count > 20) {
        
        [MBProgressHUD showSuccess:@"请求超时,请重新支付!" toView:self.view];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [NSThread sleepForTimeInterval:1.0];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
                [self.timer invalidate];
                self.timer = nil;
                self.responseStr = @"";
            });
        });
    }
    
}

-(void)webViewDidStartLoad:(UIWebView *)webView {
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"WeChatOrder"];
}

/**
 *  设置返回按钮标题
 */
- (void)setBackBarButtonItemWithTitle:(NSString *)title
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn setTitleColor:COLOR_MY_WHITE forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"NavBackSorrow"] forState:UIControlStateNormal];
    [btn setContentMode:UIViewContentModeScaleAspectFill];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -7, 0, 50)];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 10)];
    [btn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

/**
 *  返回按钮点击事件
 */
- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    [self.timer invalidate];
    self.timer = nil;
    self.responseStr = @"";
}

@end
