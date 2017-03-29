//
//  MyCodeViewController.m
//  HuiYingTianXia
//
//  Created by liguo.chen on 16/7/29.
//  Copyright © 2016年 tsmc. All rights reserved.
//

#import "MyCodeViewController.h"

#import "AbstractItems.h"
#import "NSString+MD5HexDigest.h"
#import "MJExtension.h"
#import "MBProgressHUD+Add.h"
#import "MBProgressHUD.h"
#import "ResponseDictionaryTool.h"

#import <AVFoundation/AVFoundation.h>

@interface MyCodeViewController ()
{
    SystemSoundID soundID;
}
@property(strong,nonatomic)UIImageView *codeImageView;
@property(strong,nonatomic) NSString *codeUrlStr;

@property(strong,nonatomic) NSTimer *timer;
@property(nonatomic, assign)CGFloat count;

@end

@implementation MyCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"收款码"];
    [self setBackBarButtonItemWithTitle:@"返回"];
    
    [self requestErWeiMa];
    
    self.count = 0;
    self.timer = [NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(checkOrder) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"OrderTime"]) {
        
    }else {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"OrderTime"];
    }
    
}

-(void)creatUI {
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
    
    UIImageView *wechatImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 0, SCREEN_WIDTH - 60, SCREEN_WIDTH - 50)];
    wechatImageView.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:200];//重绘二维码,使其显示清晰
    wechatImageView.userInteractionEnabled = YES;
    [self.view addSubview:wechatImageView];
    self.codeImageView = wechatImageView;
    
    //    UIImageView *codeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, SCREEN_WIDTH - 60, SCREEN_WIDTH - 50)];
    //    codeImageView.image = customQrcode;
    //    codeImageView.userInteractionEnabled = YES;
    //    [self.view addSubview:codeImageView];
    //    self.codeImageView = codeImageView;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(wechatImageView.frame) + 20, SCREEN_WIDTH, 30)];
    label.text = @"长按二维码保存到本地";
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = FONT_17;
    [self.view addSubview:label];
    
    // 新增添加长按手势
    UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(imglongTapClick:)];
    //    //设置当前长按最小的时长
    //    longTap.minimumPressDuration=2;
    //    //设置允许的移动范围
    //    [longTap setAllowableMovement:2];
    [wechatImageView addGestureRecognizer:longTap];
}

#pragma mark - InterpolatedUIImage
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // create a bitmap image that we'll draw into a bitmap context at the desired size;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // Create an image with the contents of our bitmap
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    // Cleanup
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

#pragma mark - QRCodeGenerator
- (CIImage *)createQRForString:(NSString *)qrString {
    // Need to convert the string to a UTF-8 encoded NSData object
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    // Create the filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // Set the message content and error-correction level
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    // Send the image back
    return qrFilter.outputImage;
}

#pragma mark - imageToTransparent
void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void*)data);
}

- (UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue{
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    // create context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // traverse pixe
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900){
            // change color
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }else{
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    // context to image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // release
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}

-(void)imglongTapClick:(UILongPressGestureRecognizer *)gesture {
    if(gesture.state == UIGestureRecognizerStateBegan) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存图片到手机",nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [actionSheet showInView:self.view];
        UIImageView *img = (UIImageView *)[gesture view];
        self.codeImageView = img;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        UIImageWriteToSavedPhotosAlbum(self.codeImageView.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    }
}

#pragma mark --- UIActionSheetDelegate---
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *message = @"保存失败";
    if (!error) {
        message = @"成功保存到相册";
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    } else {
        //        message = [error description];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请到设置中允许APP访问照片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}

-(void)requestErWeiMa {
    AbstractItems *item = [[AbstractItems alloc] init];
    item.n0 = @"0700";
    item.n3 = @"190107";
    item.n42 = [[NSUserDefaults standardUserDefaults] objectForKey:MerchantNo];
    NSString *macStr = [NSString stringWithFormat:@"%@%@%@%@%@",item.n0,item.n3,item.n42,item.n59,MainKey];
    NSLog(@"macStr:%@",macStr);
    item.n64 = [macStr md5HexDigest];
    
    [[NetAPIManger sharedManger] request_NoticeListWithParams:[item keyValues] andBlock:^(id data, NSError *error) {
        AbstractItems *item = (AbstractItems *)data;
        if ([item.n39 isEqualToString:@"00"]) {
            NSLog(@"成功");
            self.codeUrlStr = [NSString stringWithFormat:@"%@",item.n61];
            [self creatUI];
            
        }else {
            NSLog(@"失败");
            
            if ([[ResponseDictionaryTool responseDic] objectForKey:item.n39]) {
                NSString *error = [[ResponseDictionaryTool responseDic] objectForKey:item.n39];
                NSLog(@"error:%@",error);
                [MBProgressHUD showSuccess:error toView:self.view];
            }else {
                [MBProgressHUD showSuccess:@"未知错误" toView:self.view];
            }
        }
        
    }];
}

-(void)checkOrder {
        
    [[NSUserDefaults standardUserDefaults] setObject:@"查询订单" forKey:@"WeChatOrder"];
    
    AbstractItems *items = [[AbstractItems alloc] init];
    items.n0 = @"0700";
    items.n1 = [[NSUserDefaults standardUserDefaults] objectForKey:Account];
    items.n3 = @"190097";
    items.n42 = [[NSUserDefaults standardUserDefaults] objectForKey:MerchantNo];
    NSString *macStr = [NSString stringWithFormat:@"%@%@%@%@%@%@",items.n0,items.n1,items.n3,items.n42,items.n59,MainKey];
    NSLog(@"macStr:%@",macStr);
    items.n64 = [macStr md5HexDigest];
    
    [[NetAPIManger sharedManger] request_RaiseQuotaListWithParams:[items keyValues] andBlock:^(id data, NSError *error) {
        AbstractItems *item = (AbstractItems *)data;
        //判断订单是否是初始化状态(依然是判断39域的值)
        if ([item.n39 isEqualToString:@"00"]) {
            NSLog(@"成功");
            NSLog(@"OrderTime:%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"OrderTime"]);
            //获取当前时间
            NSDate *date = [NSDate date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"YYYYMMddHHmmss"];
            NSString *dateStr = [formatter stringFromDate:date];
            NSLog(@"dateStr:%@",dateStr);
            if (![item.n2 isEqualToString:@""]) {//判断2域是否为空
                
//                if ([item.n2 integerValue] > [dateStr integerValue] - 500 && [item.n2 integerValue] < [dateStr integerValue]) {//判断时间是否在5分钟内
                
                    if ([item.n2 isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"OrderTime"]]) {//判断2域的值是否与存的标示相等
                        NSLog(@"不播放声音");
                    }else {
                        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",item.n2] forKey:@"OrderTime"];
                        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"IsOpenVoice"] isEqualToString:@"打开提示音"]) {//判断是否打开提示音
                            [self playBeep];//播放音效
                            [self.timer invalidate];
                            self.timer = nil;
                        }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"IsOpenVoice"] isEqualToString:@"关闭提示音"]) {
                            
                        }
                    }
                    
//                }
            }
            
        
        }else {
            NSLog(@"失败");
            if ([[ResponseDictionaryTool responseDic] objectForKey:item.n39]) {
                NSString *error = [[ResponseDictionaryTool responseDic] objectForKey:item.n39];
                NSLog(@"error:%@",error);
                [MBProgressHUD showSuccess:error toView:self.view];
            }else {
                [MBProgressHUD showSuccess:@"未知错误" toView:self.view];
            }
            [self.timer invalidate];
            self.timer = nil;
        }
    }];
    
}

//扫码完成后的声音
- (void)playBeep{

    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"收款成功"ofType:@"wav"]], &soundID);
    AudioServicesPlaySystemSound(soundID);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    AudioServicesDisposeSystemSoundID(soundID);//界面消失停止播放音效
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
}

@end
