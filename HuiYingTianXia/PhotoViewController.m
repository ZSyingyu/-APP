//
//  PhotoViewController.m
//  HuiYingTianXia
//
//  Created by 朱颖宇 on 15/7/18.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import "PhotoViewController.h"
#import "BusinessDetailViewController.h"
#import "HomePageViewController.h"
#import "PohtoDetailViewController.h"
#import "AbstractItems.h"
#import "NSString+MD5HexDigest.h"
#import "NetAPIManger.h"
#import "MJExtension.h"
#import "MBProgressHUD+Add.h"
#import "MBProgressHUD.h"
#import "OrderItem.h"

#import "UIImageView+WebCache.h"

#import "TabBarViewController.h"

static NSInteger flag;
@interface PhotoViewController ()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIPopoverControllerDelegate,UIScrollViewDelegate>
@property(strong,nonatomic)UIScrollView *baseView;//底层scrollView
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *homeItem;
@property (weak, nonatomic) IBOutlet UIImageView *handCard;
@property (weak, nonatomic) IBOutlet UIImageView *frontCard;
@property (weak, nonatomic) IBOutlet UIImageView *backCard;
@property (weak, nonatomic) IBOutlet UIImageView *frontbank;
@property (weak, nonatomic) IBOutlet UIImageView *backBank;
//图片2进制路径
@property(strong,nonatomic)NSString *filePath;

@property(strong,nonatomic)UIImage *image1;
@property(strong,nonatomic)UIImage *image2;
@property(strong,nonatomic)UIImage *image3;
@property(strong,nonatomic)UIImage *image4;
@property(strong,nonatomic)UIImage *image5;
@property(strong,nonatomic)UIImage *image;
@property(strong,nonatomic)NSString *imageName;

@property(strong,nonatomic)HomePageViewController *homePageVC;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;//详情按钮

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *uploadBtns;

@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;

- (IBAction)backItem:(UIBarButtonItem *)sender;
- (IBAction)homeItem:(UIBarButtonItem *)sender;
- (IBAction)uploadPhoto:(id)sender;

- (IBAction)confirm:(id)sender;
- (IBAction)photoDetail:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UIButton *btn5;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigation;

@property(strong,nonatomic)MBProgressHUD *hud;//加载框


@end

@implementation PhotoViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    
}


- (void)viewWillDisAppear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.baseView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.baseView.backgroundColor = [UIColor clearColor];
    self.baseView.delegate = self;
    [self.view addSubview:self.baseView];
    
    if (IPHONE4__4S) {
        self.baseView.contentSize = CGSizeMake(0, SCREEN_HEIGHT * 1.4);
    }else if (IPHONE5__5S) {
        self.baseView.contentSize = CGSizeMake(0, SCREEN_HEIGHT);
    }else if (IPHONE6) {
        self.baseView.contentSize = CGSizeMake(0, SCREEN_HEIGHT);
    }else {
        self.baseView.contentSize = CGSizeMake(0, SCREEN_HEIGHT);
    }
    
    self.navigation.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
    self.label1.frame = CGRectMake(10, 74, (SCREEN_WIDTH - 20 - 20)/3, 50);
    self.label2.frame = CGRectMake(CGRectGetMaxX(self.label1.frame) + 10, self.label1.frame.origin.y, self.label1.frame.size.width, self.label1.frame.size.height);
    self.label3.frame = CGRectMake(CGRectGetMaxX(self.label2.frame) + 10, self.label1.frame.origin.y, self.label1.frame.size.width, self.label1.frame.size.height);
    self.handCard.frame = CGRectMake(self.label1.frame.origin.x, CGRectGetMaxY(self.label1.frame) + 5, self.label1.frame.size.width, 100);
    self.frontCard.frame = CGRectMake(self.label2.frame.origin.x, CGRectGetMaxY(self.label2.frame) + 5, self.label2.frame.size.width, 100);
    self.backCard.frame = CGRectMake(self.label3.frame.origin.x, CGRectGetMaxY(self.label3.frame) + 5, self.label3.frame.size.width, 100);
    self.btn1.frame = CGRectMake(self.label1.frame.origin.x, CGRectGetMaxY(self.handCard.frame) + 5, self.label1.frame.size.width, 30);
    self.btn2.frame = CGRectMake(self.label2.frame.origin.x, CGRectGetMaxY(self.frontCard.frame) + 5, self.label2.frame.size.width, 30);
    self.btn3.frame = CGRectMake(self.label3.frame.origin.x, CGRectGetMaxY(self.backCard.frame) + 5, self.label3.frame.size.width, 30);
    self.label4.frame = CGRectMake(self.label1.frame.origin.x, CGRectGetMaxY(self.btn1.frame) + 5, self.label1.frame.size.width, self.label1.frame.size.height);
//    self.label5.frame = CGRectMake(self.label2.frame.origin.x, CGRectGetMaxY(self.btn2.frame) + 5, self.label2.frame.size.width, self.label2.frame.size.height);
    self.frontbank.frame = CGRectMake(self.label4.frame.origin.x, CGRectGetMaxY(self.label4.frame) + 5, self.label4.frame.size.width, 100);
//    self.backBank.frame = CGRectMake(self.label5.frame.origin.x, CGRectGetMaxY(self.label5.frame) + 5, self.label5.frame.size.width, 100);
    self.btn4.frame = CGRectMake(self.label4.frame.origin.x, CGRectGetMaxY(self.frontbank.frame) + 5, self.label4.frame.size.width, 30);
//    self.btn5.frame = CGRectMake(self.label5.frame.origin.x, CGRectGetMaxY(self.backBank.frame) + 5, self.label5.frame.size.width, 30);
    self.detailBtn.frame = CGRectMake(0, SCREEN_HEIGHT - 170, SCREEN_WIDTH, 30);
    self.uploadBtn.frame = CGRectMake(30, CGRectGetMaxY(self.detailBtn.frame) + 15, SCREEN_WIDTH - 60, 45);
    [self.view addSubview:self.navigation];
    [self.baseView addSubview:self.handCard];
    [self.baseView addSubview:self.frontCard];
    [self.baseView addSubview:self.backCard];
    [self.baseView addSubview:self.frontbank];
//    [self.baseView addSubview:self.backBank];
    [self.baseView addSubview:self.detailBtn];
    [self.baseView addSubview:self.btn1];
    [self.baseView addSubview:self.btn2];
    [self.baseView addSubview:self.btn3];
    [self.baseView addSubview:self.btn4];
//    [self.baseView addSubview:self.btn5];
    [self.baseView addSubview:self.label1];
    [self.baseView addSubview:self.label2];
    [self.baseView addSubview:self.label3];
    [self.baseView addSubview:self.label4];
//    [self.baseView addSubview:self.label5];
    [self.baseView addSubview:self.uploadBtn];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:HandUpload];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:CardFrontUpload];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:CardBackUpload];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:BankFrontUpload];
//    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:BankBackUpload];
    
    self.image1 = [UIImage imageNamed:@"手持证件"];
    self.image2 = [UIImage imageNamed:@"正面1"];
    self.image3 = [UIImage imageNamed:@"反面1"];
    self.image4 = [UIImage imageNamed:@"银行卡正面"];
//    self.image5 = [UIImage imageNamed:@"银行卡反面"];
    
    self.handCard.image = self.image1;
    self.frontCard.image = self.image2;
    self.backCard.image = self.image3;
    self.frontbank.image = self.image4;
//    self.backBank.image = self.image5;
    
    for (NSUInteger i = 1; i <= [self.uploadBtns count]; i++) {
        NSLog(@"count:%lu",(unsigned long)self.uploadBtns.count);
        UIButton *btn = self.uploadBtns[i-1];
        btn.tag = i;
    }
    
    self.uploadBtn.enabled = NO;
    [self.uploadBtn setBackgroundColor:COLOR_FONT_GRAY];
    
    NSLog(@"w8:%@",[[NSUserDefaults standardUserDefaults] objectForKey:W8Str]);
    NSLog(@"front:%@",[[NSUserDefaults standardUserDefaults] objectForKey:FrontBank]);
    NSLog(@"back:%@",[[NSUserDefaults standardUserDefaults] objectForKey:BackBank]);
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:HandCard] length] > 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:FrontCard] length] > 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:BackCard] length] > 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:ShopPhoto] length] > 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:W8Str] isEqualToString:@""]) {
        
        NSString *str1 = [[NSUserDefaults standardUserDefaults] objectForKey:HandCard];
        NSURL *url1 = [NSURL URLWithString:str1];
        
        NSString *str2 = [[NSUserDefaults standardUserDefaults] objectForKey:FrontCard];
        NSURL *url2 = [NSURL URLWithString:str2];
        
        NSString *str3 = [[NSUserDefaults standardUserDefaults] objectForKey:BackCard];
        NSURL *url3 = [NSURL URLWithString:str3];
        
        NSString *str4 = [[NSUserDefaults standardUserDefaults] objectForKey:FrontBank];
        NSURL *url4 = [NSURL URLWithString:str4];
        //
        //                NSString *str5 = [[NSUserDefaults standardUserDefaults] objectForKey:BackBank];
        //                NSURL *url5 = [NSURL URLWithString:str5];
        
        //改写加载图片代码
        [self.handCard sd_setImageWithURL:url1];
        [self.frontCard sd_setImageWithURL:url2];
        [self.backCard sd_setImageWithURL:url3];
        [self.frontbank sd_setImageWithURL:url4];
        
        for (UIButton *btn in self.uploadBtns) {
            NSLog(@"tag:%ld",(long)btn.tag);
            btn.enabled = NO;
            btn.userInteractionEnabled = NO;
            btn.backgroundColor = COLOR_FONT_GRAY;
            
        }
        //            [self.detailBtn setHidden:YES];
        [self.uploadBtn setHidden:YES];
        
        
        //初始化进度框，置于当前的View当中
        self.hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:self.hud];
        
        //如果设置此属性则当前的view置于后台
        //            self.hud.dimBackground = YES;
        
        //设置对话框文字
        self.hud.labelText = @"请稍等";
        
        //显示对话框
        [self.hud showAnimated:YES whileExecutingBlock:^{
            //对话框显示时需要执行的操作
            sleep(2);
            
            self.backItem.enabled = YES;
            self.homeItem.enabled = YES;
            
        } completionBlock:^{
            //操作执行完后取消对话框
            [self.hud removeFromSuperview];
            self.hud = nil;
            
            self.backItem.enabled = YES;
            self.homeItem.enabled = YES;
        }];
        
    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:HandCard] length] > 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:FrontCard] length] > 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:BackCard] length] > 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:ShopPhoto] length] > 0 && ![[[NSUserDefaults standardUserDefaults] objectForKey:W8Str] isEqualToString:@""]) {
        for (UIButton *button in self.uploadBtns) {
            button.enabled = YES;
            [button setTitle:@"重新选择" forState:UIControlStateNormal];
            [button setTintColor:[UIColor whiteColor]];
            button.userInteractionEnabled = YES;
            button.backgroundColor = COLOR_THEME;
        }
        
        self.homeItem.enabled = NO;
        
        NSString *str1 = [[NSUserDefaults standardUserDefaults] objectForKey:HandCard];
        NSURL *url1 = [NSURL URLWithString:str1];
        
        NSString *str2 = [[NSUserDefaults standardUserDefaults] objectForKey:FrontCard];
        NSURL *url2 = [NSURL URLWithString:str2];
        
        NSString *str3 = [[NSUserDefaults standardUserDefaults] objectForKey:BackCard];
        NSURL *url3 = [NSURL URLWithString:str3];
        
        NSString *str4 = [[NSUserDefaults standardUserDefaults] objectForKey:FrontBank];
        NSURL *url4 = [NSURL URLWithString:str4];
        //
        //                NSString *str5 = [[NSUserDefaults standardUserDefaults] objectForKey:BackBank];
        //                NSURL *url5 = [NSURL URLWithString:str5];
        
        //改写加载图片代码
        [self.handCard sd_setImageWithURL:url1];
        [self.frontCard sd_setImageWithURL:url2];
        [self.backCard sd_setImageWithURL:url3];
        [self.frontbank sd_setImageWithURL:url4];
        //
        self.image1 = self.handCard.image;
        self.image2 = self.frontCard.image;
        self.image3 = self.backCard.image;
        self.image4 = self.frontbank.image;
        //               self.image5 = self.backBank.image;
        
        //初始化进度框，置于当前的View当中
        self.hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:self.hud];
        
        //如果设置此属性则当前的view置于后台
        //            self.hud.dimBackground = YES;
        
        //设置对话框文字
        self.hud.labelText = @"请稍等";
        
        //显示对话框
        [self.hud showAnimated:YES whileExecutingBlock:^{
            //对话框显示时需要执行的操作
            sleep(2);
            
            self.backItem.enabled = YES;
            self.homeItem.enabled = YES;
            
        } completionBlock:^{
            //操作执行完后取消对话框
            [self.hud removeFromSuperview];
            self.hud = nil;
            
            self.backItem.enabled = YES;
            self.homeItem.enabled = YES;
        }];
        
        
    }else{
        
        self.homeItem.enabled = NO;
        [self.homeItem setTintColor:COLOR_THEME];
    }
    
}

- (IBAction)backItem:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)uploadPhoto:(UIButton *)sender {
    UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打开相机", nil];
    [action showInView:self.view];
    
    flag = sender.tag;
    NSLog(@"flag:%ld",(long)flag);
    NSLog(@"tag:%ld",(long)sender.tag);

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {//相机
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            //设置拍照后的图片可被编辑
            picker.allowsEditing = YES;
            picker.sourceType = sourceType;
//            [picker release];
            [self presentModalViewController:picker animated:YES];
        }
    }
//    else if (buttonIndex ==1) {//相册
//        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//        
//        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        picker.delegate = self;
//        //设置选择后的图片可被编辑
//        picker.allowsEditing = YES;
//        [self presentModalViewController:picker animated:YES];
////        [picker release];
//    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:(NSString*)kUTTypeImage])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        //设置image的尺寸
        CGSize imagesize = image.size;
        imagesize.height =550;
        imagesize.width =367;
        //对图片大小进行压缩--
        image = [self imageWithImage:image scaledToSize:imagesize];
        
        UIImageOrientation *imageOrientation = image.imageOrientation;
        if (imageOrientation != UIImageOrientationUp) {
            // 原始图片可以根据照相时的角度来显示，但UIImage无法判定，于是出现获取的图片会向左转９０度的现象。
            // 以下为调整图片角度的部分
            UIGraphicsBeginImageContext(image.size);
            [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
            image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            // 调整图片角度完毕
        }
        
        NSData *data;
        
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 0.6);
            
            NSInteger length = [data length]/1000;
            NSLog(@"length:%ld",(long)length);
        }
        else
        {
            data = UIImagePNGRepresentation(image);
            
            NSInteger length = [data length]/1000;
            NSLog(@"length:%ld",(long)length);
        }
        
        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
        
        //得到选择后沙盒中图片的完整路径
        self.filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
        
        //关闭相册界面
        [picker dismissModalViewControllerAnimated:YES];
        
        //显示图片
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = image;
        imageView.frame = self.handCard.frame;
        NSLog(@"self.image1:%@",self.image1);
        NSLog(@"self.handCard.image:%@",self.handCard.image);
        NSLog(@"flag:%ld",(long)flag);
        
        if (flag == 1) {
            imageView.frame = self.handCard.frame;
            [self.handCard setImage:[UIImage imageNamed:@""]];
            self.handCard.image = imageView.image;
        }else if (flag == 2) {
            imageView.frame = self.frontCard.frame;
            [self.frontCard setImage:[UIImage imageNamed:@""]];
            self.frontCard.image = imageView.image;
        }else if (flag == 3) {
            imageView.frame = self.backCard.frame;
            [self.backCard setImage:[UIImage imageNamed:@""]];
            self.backCard.image = imageView.image;
        }else if (flag == 4) {
            imageView.frame = self.frontbank.frame;
            [self.frontbank setImage:[UIImage imageNamed:@""]];
            self.frontbank.image = imageView.image;
        }
//        else if (flag == 5) {
//            imageView.frame = self.backBank.frame;
//            [self.backBank setImage:[UIImage imageNamed:@""]];
//            self.backBank.image = imageView.image;
//        }
        
//        加在视图中
        [self.view addSubview:imageView];
        
        if ((self.handCard.image != self.image1 && self.frontCard.image != self.image2 && self.backCard.image != self.image3 && self.frontbank.image != self.image4) || (self.frontbank.image != self.image4 && self.backCard.image != self.image3)) {
            self.uploadBtn.enabled = YES;
            self.uploadBtn.hidden = NO;
            [self.uploadBtn setBackgroundColor:COLOR_THEME];
        }
    }
}

//对图片尺寸进行压缩--
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

- (IBAction)confirm:(id)sender {
    self.uploadBtn.enabled = NO;
    self.uploadBtn.backgroundColor = COLOR_FONT_GRAY;
    
    AbstractItems *item = [[AbstractItems alloc] init];
    
    NSArray *typeArray = @[@"10M",@"10E",@"10K",@"10G"];
    for (NSString *str in typeArray) {
        NSLog(@"str:%@",str);
        item.n9 = str;
        
        item.n0 = @"0700";
        item.n3 = @"190948";
        item.n42 = [[NSUserDefaults standardUserDefaults] objectForKey:MerchantNo];
        //            item.n9 = @"10A";
        NSString *str = [NSString stringWithFormat:@"%@%@%@%@%@",item.n0,item.n3,item.n9,item.n42,item.n59];
        item.n64 = [[str md5HexDigest] uppercaseString];
        
        if ([item.n9 isEqualToString:@"10M"]) {
            self.imageName = @"手持";
            self.image = self.handCard.image;
        }else if ([item.n9 isEqualToString:@"10E"]) {
            self.imageName = @"正面";
            self.image = self.frontCard.image;
        }else if ([item.n9 isEqualToString:@"10K"]) {
            self.imageName = @"反面";
            self.image = self.backCard.image;
        }else if ([item.n9 isEqualToString:@"10G"]) {
            self.imageName = @"门头";
            self.image = self.frontbank.image;
        }
//        else if ([item.n9 isEqualToString:@"10L"]) {
//            self.imageName = @"卡反面";
//            self.image = self.backBank.image;
//        }
        
        [[NetAPIManger sharedManger] request_UploadImageWithParrams:[item keyValues] andImageInfo:@{@"image":self.image,@"name":self.imageName} andBlock:^(id data, NSError *error) {
            AbstractItems *item = [AbstractItems objectWithKeyValues:data];
            if (!error && [item.n39 isEqualToString:@"00"]) {
                
                NSLog(@"n9:%@",item.n9);
                NSLog(@"n39:%@",item.n39);
                NSLog(@"n42:%@",item.n42);
                NSLog(@"n64:%@",item.n64);
                item.n57 = [data objectForKey:@"57"];
                NSLog(@"n57:%@",item.n57);
                //                    [[NSUserDefaults standardUserDefaults] setObject:item.n57 forKey:RaiseCardFrontCard];
                //                                        [[NSUserDefaults standardUserDefaults] setObject:item.n9 forKey:RaiseImageType];
                if ([item.n9 isEqualToString:@"10M"]) {
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:HandUpload];
                    [[NSUserDefaults standardUserDefaults] setObject:item.n57 forKey:HandCard];
                    [[NSUserDefaults standardUserDefaults] setObject:item.n9 forKey:ImageType];
                }else if ([item.n9 isEqualToString:@"10E"]) {
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:CardFrontUpload];
                    [[NSUserDefaults standardUserDefaults] setObject:item.n57 forKey:FrontCard];
                    [[NSUserDefaults standardUserDefaults] setObject:item.n9 forKey:ImageType];
                }else if ([item.n9 isEqualToString:@"10K"]) {
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:CardBackUpload];
                    [[NSUserDefaults standardUserDefaults] setObject:item.n57 forKey:BackCard];
                    [[NSUserDefaults standardUserDefaults] setObject:item.n9 forKey:ImageType];
                }else if ([item.n9 isEqualToString:@"10G"]) {
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:BankFrontUpload];
                    [[NSUserDefaults standardUserDefaults] setObject:item.n57 forKey:FrontBank];
                    [[NSUserDefaults standardUserDefaults] setObject:item.n9 forKey:ImageType];
                }
//                else if ([item.n9 isEqualToString:@"10L"]) {
//                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:BankBackUpload];
//                    [[NSUserDefaults standardUserDefaults] setObject:item.n57 forKey:BackBank];
//                    [[NSUserDefaults standardUserDefaults] setObject:item.n9 forKey:ImageType];
//                }
                
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:CardFrontUpload] isEqualToString:@"1"] && [[[NSUserDefaults standardUserDefaults] objectForKey:CardBackUpload] isEqualToString:@"1"] && [[[NSUserDefaults standardUserDefaults] objectForKey:BankFrontUpload] isEqualToString:@"1"] && [[[NSUserDefaults standardUserDefaults] objectForKey:HandUpload] isEqualToString:@"1"]) {
                    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:W8Str];
                    NSLog(@"w8:%@",[[NSUserDefaults standardUserDefaults] objectForKey:W8Str]);
                    
                    TabBarViewController *tabBarVc = [[TabBarViewController alloc] init];
                    [MBProgressHUD showSuccess:@"提交成功" toView:tabBarVc.view];
                    [self presentViewController:tabBarVc animated:YES completion:nil];
                }
            }else {
                self.uploadBtn.enabled = YES;
                self.uploadBtn.backgroundColor = COLOR_THEME;
                
            }
            
        }];
        
    }
    
    
    
}

- (IBAction)photoDetail:(id)sender {
    
    PohtoDetailViewController *detailVc = [[PohtoDetailViewController alloc]init];
    [self.navigationController pushViewController:detailVc animated:YES];
    [[NSUserDefaults standardUserDefaults] setObject:@"资质认证" forKey:Certify];
}
@end
