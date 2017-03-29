//
//  ScrollImage.m
//  ScrollViewTest
//
//  Created by Mac on 16/4/13.
//  Copyright © 2016年 jyb. All rights reserved.
//

#import "ScrollImage.h"

@interface ScrollImage ()<UIScrollViewDelegate>
{
    /**网络加载模式下存放url的MD5编码，本地加载模式下存放图片名字**/
    NSMutableArray        *_imageArray;
    /**存放MD5编码或名字对应的图片**/
    NSMutableDictionary   *_imageDic;
    /**图片总数**/
    NSInteger             _imageCount;
    CGRect                _frame;
    CGFloat               _imageWidth;
    CGFloat               _imageHeight;
    NSInteger             _scrollIndex;
    NSTimer               *_timer;
}
@property (nonatomic, strong) UIScrollView *scrollview;

@end

@implementation ScrollImage


#pragma mark - 网络图片

- (instancetype)initWithCurrentController:(UIViewController *)viewcontroller urlString:(NSArray *)urls viewFrame:(CGRect)frame placeholderImage:(UIImage *)image
{
    if (self = [super init]) {
        [viewcontroller addChildViewController:self];
        _timeInterval     = 1.0;
        _imageCount       = urls.count;
        _frame            = frame;
        _imageWidth       = frame.size.width;
        _imageHeight      = frame.size.height;
        _placeholderImage = image;
        self.view.frame   = frame;
        
        _imageArray = [NSMutableArray arrayWithCapacity:urls.count];
        for (int i = 0; i < urls.count; i ++) {
            
            NSURL    *url = [NSURL URLWithString:urls[i]];
            NSString *md5 = [url.absoluteString MD5];
            [_imageArray addObject:md5];
        }
        
        self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        self.pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
        
        [self.view addSubview:self.scrollview];
        [self.view addSubview:self.pageControl];
        
        
        _imageDic = [NSMutableDictionary dictionaryWithCapacity:urls.count];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            for (int i = 0; i < urls.count; i ++) {
                NSURL *url = [NSURL URLWithString:urls[i]];
                
                [self getImagesWithUrl:url completionBlock:^(UIImage *image) {
                    [self scrollViewLoadImages];
                }];
            }
        });
    }
    return self;
}

#pragma mark - 本地图片

- (instancetype)initWithCurrentController:(UIViewController *)viewcontroller imageNames:(NSArray *)images viewFrame:(CGRect)frame placeholderImage:(UIImage *)image
{
    if (self = [super init]) {
        [viewcontroller addChildViewController:self];
        _timeInterval     = 1.0;
        _imageArray       = [images copy];
        _imageCount       = images.count;
        _frame            = frame;
        _imageWidth       = frame.size.width;
        _imageHeight      = frame.size.height;
        _placeholderImage = image;
        self.view.frame   = frame;
        
        self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        self.pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
        
        [self.view addSubview:self.scrollview];
        [self.view addSubview:self.pageControl];
        [self getLocalImages];
        [self scrollViewLoadImages];
    }
    return self;
}

#pragma mark - ScrollView和PageControl

- (UIPageControl *)pageControl
{
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _frame.size.height-20, _frame.size.width, 20)];
        _pageControl.numberOfPages = _imageCount;
        _pageControl.currentPage = 0;
    }
    return _pageControl;
}

- (UIScrollView *)scrollview
{
    if (!_scrollview) {
        _scrollview = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollview.contentSize = CGSizeMake(_imageWidth*(_imageCount+2), 0);
        _scrollview.contentOffset = CGPointMake(_imageWidth, 0);
        _scrollview.showsHorizontalScrollIndicator = NO;
        _scrollview.showsVerticalScrollIndicator = NO;
        _scrollview.pagingEnabled = YES;
        _scrollview.delegate = self;
        _scrollIndex = 1;
        
        
        [self loadImageViews];
    }
    
    return _scrollview;
}

#pragma mark - ScrollView加载图片

- (void)loadImageViews
{
    for (int i = 0; i < _imageArray.count+2; i ++) {
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = _placeholderImage;
        imgView.userInteractionEnabled = YES;
        imgView.tag = i + 3000;
        
        if (i == 0) {
            imgView.frame = CGRectMake(0, 0, _imageWidth, _imageHeight);
            
        }else if (i == _imageArray.count+1){
            imgView.frame = CGRectMake((_imageArray.count+1)*_imageWidth, 0, _imageWidth, _imageHeight);
            
        }else{
            imgView.frame = CGRectMake(i*_imageWidth, 0, _imageWidth, _imageHeight);
            
        }
        
        [_scrollview addSubview:imgView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
        [imgView addGestureRecognizer:tap];
    }
}

// 为了兼容本地和网络加载图片，使用字典来存储图片（因为网络下载是异步的，图片顺序不确定，不能放到数组中使用）
- (void)scrollViewLoadImages
{
    for (int i = 0; i < _imageArray.count+2; i ++) {
        NSString *imgName = nil;
        
        UIImageView *imgView = (UIImageView *)[_scrollview viewWithTag:i+3000];
        
        if (i == 0) {
            imgName = [_imageArray objectAtIndex:_imageArray.count-1];
            
        }else if (i == _imageArray.count+1){
            imgName = [_imageArray objectAtIndex:0];
            
        }else{
            imgName = [_imageArray objectAtIndex:i-1];
            
        }
        UIImage *image = _imageDic[imgName];
        
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                imgView.image = image;
            });
        }
    }
}

#pragma mark - 获取本地图片

- (void)getLocalImages
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:_imageArray.count];
    
    for (int i = 0; i < _imageArray.count; i ++) {
        UIImage *image = [UIImage imageNamed:_imageArray[i]];
        [dic setObject:image forKey:_imageArray[i]];
    }
    _imageDic = dic;
}

#pragma mark - 缓存路径

- (NSString *)cachePath
{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/ScrollCache"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

#pragma mark - 获取网络图片

- (void)getImagesWithUrl:(NSURL *)url completionBlock:(void(^)(UIImage *image))block
{
    NSString *md5 = [url.absoluteString MD5];
    
    // 查看内存是否有缓存图片
    if ([_imageDic objectForKey:md5]) {
        
        if (block) {
            block([_imageDic objectForKey:md5]);
        }
        
    }else{
        
        // 查看磁盘是否有缓存图片
        NSString *filePath = [NSString stringWithFormat:@"%@/%@",[self cachePath],md5];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            
            // 磁盘有缓存，先读入内存，再使用
            NSData *data = [NSData dataWithContentsOfFile:filePath];
            UIImage *img = [UIImage imageWithData:data];
            [_imageDic setObject:img forKey:md5];
            if (block) {
                block(img);
            }
            
        }else{
            
            // 磁盘没有缓存，下载图片
            [self downloadImageWithURL:url completionBlock:^(UIImage *image) {
                if (image) {
                    // 存入内存
                    [_imageDic setObject:image forKey:md5];
                    
                    // 存入磁盘
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        NSData *data = UIImagePNGRepresentation(image);
                        [data writeToFile:filePath atomically:YES];
                    });
                    
                    if (block) {
                        block(image);
                    }
                }
            }];
        }
    }
}

#pragma mark - 下载图片

- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void(^)(UIImage *image))block
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        __block UIImage *image = nil;
        
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
        
        [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            image = [UIImage imageWithData:data];
            
            if (block) {
                block(image);
            }
        }] resume];
        
    });
}

#pragma mark - Timer

- (void)nextPage
{
    [self.scrollview setContentOffset:CGPointMake((_scrollIndex+1)*_imageWidth, 0) animated:YES];
}

- (void)startTimer
{
    _timer = [NSTimer timerWithTimeInterval:_timeInterval target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer
{
    [_timer invalidate];
    _timer = nil;
}

#pragma mark - TapGesture

- (void)tapImage:(UITapGestureRecognizer *)gesture
{
    if (gesture.view.tag == _imageCount+1) {
        gesture.view.tag = 1;
    }
    if ([self.delegate respondsToSelector:@selector(scrollImage:clickedAtIndex:)]) {
        [self.delegate scrollImage:self clickedAtIndex:gesture.view.tag];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _scrollIndex = scrollView.contentOffset.x / _imageWidth;
    
    // 开始显示最后一张图片的时候切换到第二个图
    if (scrollView.contentOffset.x > _imageWidth*(_imageCount+1)) {
        [scrollView setContentOffset:CGPointMake(_imageWidth+scrollView.contentOffset.x-_imageWidth*(_imageCount+1), 0) animated:NO];
        if (_timer) {
            [self nextPage];
        }
    }
    // 开始显示第一张图片的时候切换到倒数第二个图
    if (scrollView.contentOffset.x < _imageWidth) {
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x+_imageWidth*_imageCount, 0) animated:NO];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = _scrollIndex;
    if (_scrollIndex == _imageCount+1) {
        index = 1;
    }
    _pageControl.currentPage = index-1;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSInteger index = _scrollIndex;
    if (_scrollIndex == _imageCount+1) {
        index = 1;
    }
    _pageControl.currentPage = index-1;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startTimer];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTimer];
}

#pragma mark - viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 先刷新一次，把占位图放上
//    [self scrollViewLoadImages];
    
    [self startTimer];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self stopTimer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end




@implementation NSString (MD5)
- (id)MD5
{
    const char *cStr = [self UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}
@end






