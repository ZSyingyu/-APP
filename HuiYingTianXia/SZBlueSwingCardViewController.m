//
//  SZBlueSwingCardViewController.m
//  HuiYingTianXia
//
//  Created by liguo.chen on 16/9/8.
//  Copyright © 2016年 tsmc. All rights reserved.
//

#import "SZBlueSwingCardViewController.h"
#import "FLAnimatedImage.h"
#import "TTTAttributedLabel.h"
#import "NSString+Util.h"
#import "POSManger.h"
#import "AC_POSManger.h"
#import "MBProgressHUD+Add.h"
#import "CSwiperStateChangedListener.h"
#import "ItronCommunicationManagerBase.h"
#import "vcom.h"

#import "EnterPwdViewController.h"
#import "ConsumeViewController.h"


#import "LibXNComm.h"
#import "MsrResult.h"
#import "PosLib.h"
#import "MLTableAlert/MLTableAlert.h"
#import "SVProgressHUD/SVProgressHUD.h"
#import "NSString+MD5HexDigest.h"
#import "MJExtension.h"
#import "HomePageViewController.h"
#import "SignViewController.h"
#import "ResponseDictionaryTool.h"
#import "ConsumeResultViewController.h"
#import "QueryrRecordViewController.h"
#import "MBProgressHUD+Add.h"
#import "MBProgressHUD.h"

@interface SZBlueSwingCardViewController ()<AC_POSMangerDelegate>

{
    NSMutableArray *XNdevices;
    MPosInterface *manager;
    
}

@property(nonatomic, strong)TTTAttributedLabel *labTip;
@property (strong, nonatomic) MLTableAlert *alert;
@property(strong,nonatomic)MPosInterface *manager;
@property(strong,nonatomic)NSMutableArray *XNdevices;

@property(nonatomic, strong)NSDictionary *cardInfo;
@property(strong,nonatomic)UITableView *myTabelView;

@end

NSString * text;
int ctrlFlag;
//bool readOldFileForiTronDevice = TRUE;

@implementation SZBlueSwingCardViewController

@synthesize getKsnBtn = _getKsnBtn;
@synthesize cardInfoView = _cardInfoView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"检查刷卡器";
    [self setBackBarButtonItemWithTitle:@"返回"];
    
    [[AC_POSManger shareInstance] setDeleagte:self];
    
    UIView *bView = [[UIView alloc]init];
    bView.backgroundColor = COLOR_THE_WHITE;
    [self.view addSubview:bView];
    [bView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(self.view.frame.origin.y + 150);
    }];
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"温情提示"]];
    imageView1.backgroundColor = [UIColor redColor];
    [self.view addSubview:imageView1];
    [imageView1 makeConstraints:^(MASConstraintMaker *make) {
        if (IPHONE4__4S) {
            make.top.equalTo(self.view).offset(HFixHeightBaseOn568(10));
        }else {
            make.top.equalTo(self.view).offset(HFixHeightBaseOn568(16));
        }
        make.centerX.equalTo(self.view);
        make.width.equalTo(imageView1.frame.size.width * 0.6);
        make.height.equalTo(imageView1.frame.size.height * 0.6);
    }];
    
    self.labTip = [[TTTAttributedLabel alloc] init];
    self.labTip.font = FONT_16;
    self.labTip.numberOfLines = 0;
    [self.labTip setTextAlignment:NSTextAlignmentLeft];
    [self.labTip setTextColor:COLOR_FONT_RED];
    //    [self.labTip setTextColor:COLOR_FONT_BLACK];
    //    self.labTip.text = @"磁条面向自己\n紧贴卡槽底部匀速刷过";
    self.labTip.text = @"   1.芯片卡请进行插卡操作\n\n   2.磁条面向自己紧贴卡槽底部匀速刷过";
    self.labTip.backgroundColor = COLOR_THE_WHITE;
    [self.view addSubview:self.labTip];
    
    CGSize size = [self.labTip.text suggestedSizeWithFont:self.labTip.font  width:SCREEN_WIDTH];
    [self.labTip makeConstraints:^(MASConstraintMaker *make) {
        //        if (IPHONE4__4S) {
        //            make.top.equalTo(self.view).offset(HFixHeightBaseOn568(70));
        //        }else {
        //            make.top.equalTo(self.view).offset(HFixHeightBaseOn568(110));
        //        }
        make.top.equalTo(imageView1.bottom).offset(0);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(size.height + 10);
    }];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"刷卡提示" ofType:@"gif"];
    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfFile:path]];
    FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
    imageView.animatedImage = image;
    [self.view addSubview:imageView];
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(image.size.height / 2);
    }];
    
    self.myTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.myTabelView.backgroundColor = [UIColor whiteColor];
    self.myTabelView.delegate = self;
    self.myTabelView.dataSource = self;
    [self.view addSubview:self.myTabelView];
    
    deviceArrayList = [[NSMutableArray alloc] init];
    dicCurrect = [[NSMutableDictionary alloc] init];
    
    //初始化sdk
    blue = [AnFSwiperController shareInstance];
    //设置代理
    blue.delegate = self;
    
//    if( blue.isConnectBlue ) {
//        
//        //if(![deviceArrayList containsObject:blue.dicCurrect]) {
//        //    [deviceArrayList addObject:blue.dicCurrect];
//        //}
//        
//        [dicCurrect addEntriesFromDictionary:blue.dicCurrect];
//        
//        [self.myTabelView reloadData];
//    }
//    else  {
//        [blue scanBlueDevice:@""];
//    }
    
    if(blue.isConnectBlue) {
        
        [dicCurrect addEntriesFromDictionary:blue.dicCurrect];
        
//        [self.myTabelView removeFromSuperview];
        
        [blue getKsn];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [NSThread sleepForTimeInterval:1];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showSuccess:@"请插卡/刷卡" toView:self.view];
            });
        });
    }
    else  {
        [blue scanBlueDevice:@""];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [blue stopScanBlueDevice];
    [blue disConnectDevice];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat
{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return deviceArrayList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *_Cell_ = @"_Cell_";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_Cell_];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:_Cell_];
    }
    
    NSDictionary *dic = [deviceArrayList objectAtIndex:indexPath.row];
    cell.textLabel.text = [dic objectForKey:@"Name"];
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
    [self beginWaiting:@"正在连接设备中。。。"];
    
    NSDictionary *dicSelect = [deviceArrayList objectAtIndex:indexPath.row];
    
    if (dicCurrect && [dicCurrect count] > 0 && ![[dicSelect objectForKey:@"identifier"] isEqualToString:[dicCurrect objectForKey:@"identifier"]]) {
        [deviceArrayList addObject:dicCurrect];
    }
    
    [blue connectDevice:dicSelect];
    [self.myTabelView removeFromSuperview];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    blue.delegate = self;
}

-(void)beginWaiting:(NSString *)message
{
    waitView = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:waitView];
    waitView.delegate = self;
    waitView.labelText = message;
    waitView.square = NO;
    [waitView show:YES];
}

-(void)endWaiting
{
    [waitView hide:YES afterDelay:.5];
}

-(void)search:(id)sender
{
    [dicCurrect removeAllObjects];
    [deviceArrayList removeAllObjects];
    [self.myTabelView reloadData];
    
    [blue stopScanBlueDevice];
    [blue scanBlueDevice:nil];
}

-(void)onFindBlueDevice:(NSDictionary *)dic
{
    if (![deviceArrayList containsObject:dic] && ![[dic objectForKey:@"identifier"] isEqualToString:[dicCurrect objectForKey:@"identifier"]]) {
        [deviceArrayList addObject:dic];
        [self.myTabelView reloadData];
    }
}

-(void)onDidConnectBlueDevice:(NSDictionary *)dic
{
    if (dic && [dic count] > 0)
    {
        [dicCurrect removeAllObjects];
        dicCurrect = [NSMutableDictionary dictionaryWithDictionary:dic];
    }
    
    [self endWaiting];
    
    //    deviceParams.terminalNo = _dicInfo[@"1"];
    //    deviceParams.SN = _dicInfo[@"6"];
    //    deviceParams.transectionNo = _dicInfo[@"B"];
    
    for (NSDictionary *dictionary in deviceArrayList)
    {
        dicInfo = [NSDictionary dictionaryWithDictionary:dic];
        
        if ([[dicCurrect objectForKey:@"identifier"] isEqualToString:[dictionary objectForKey:@"identifier"]])
        {
            [deviceArrayList removeObject:dictionary];
            break;
        }
    }
    [blue getKsn];
    
}

-(void)onDisconnectBlueDevice:(NSDictionary *)dic
{
    NSLog(@"onDisconnectBlueDevice");
    [self endWaiting];
    
    if(![deviceArrayList containsObject:dic]) {
        [deviceArrayList addObject:dic];
    }
    
    if ([dicCurrect isEqual:dic]) {
        [dicCurrect removeAllObjects];
    }
    
    [self.myTabelView reloadData];
}

-(void)onDidGetDeviceKsn:(NSDictionary *)_dicInfo
{
    [self endWaiting];
    NSString *ksnStr = _dicInfo[@"6"];
    NSLog(@"ksn:%@",ksnStr);
    [self didGetKsnCompleted:ksnStr];
}

- (void)didGetKsnCompleted:(NSString *)ksn{
    NSLog(@"ksn:%@",ksn);
    if (ksn.length > 0) {
        AbstractItems *item = [[AbstractItems alloc] init];
        item.n1 = [[NSUserDefaults standardUserDefaults] objectForKey:Account];
        item.n3 = @"190958";
        //        item.n59 = @"CHDS-1.0.0";
        item.n62 = [ksn  uppercaseString];
        
        NSString *macStr = [NSString stringWithFormat:@"%@%@%@%@%@%@",item.n0,item.n1,item.n3,item.n59,item.n62,MainKey];
        NSLog(@"mac:%@",macStr);
        item.n64 = [[macStr md5HexDigest] uppercaseString];
        [[NetAPIManger sharedManger] request_BindingPosWithParams:[item keyValues] andBlock:^(id data, NSError *error) {
            
            AbstractItems *item = (AbstractItems *)data;
            if(!error && ([item.n39 isEqualToString:@"00"] || [item.n39 isEqualToString:@"94"]) && item.n41.length > 0 && item.n62.length > 0 && item.n62.length > 0){
                [self showStatusBarSuccessStr: @"设备已连接"];
                
                [[NSUserDefaults standardUserDefaults] setValue:item.n41 forKey:TerminalNo];
                if(item.n62.length > 0) {
                    [[NSUserDefaults standardUserDefaults] setValue:item.n62 forKey:WokeKey];
                    NSLog(@"WokeKey:%@",WokeKey);
                    NSLog(@"VoucherNo:%@",item.n11);
                    NSInteger voucherNo = [item.n11 integerValue];
                    
                    self.vouchNo = [NSString stringWithFormat:@"%06zd",++voucherNo];
                    NSLog(@"voucherNo:%@",self.vouchNo);
                }
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                NSRange range1 = NSMakeRange(0, 40);
                NSRange range2 = NSMakeRange(40, 40);
                NSRange range3 = NSMakeRange(80, 40);
                
                NSString *str1 = [[[NSUserDefaults standardUserDefaults] objectForKey:WokeKey] substringWithRange:range1];
                NSLog(@"str1:%@",str1);
                NSString *str2 = [[[NSUserDefaults standardUserDefaults] objectForKey:WokeKey] substringWithRange:range2];
                NSLog(@"str2:%@",str2);
                NSString *str3 = [[[NSUserDefaults standardUserDefaults] objectForKey:WokeKey]  substringWithRange:range3];
                NSLog(@"str3:%@",str3);
                
                NSDictionary *keyDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        str1, @"PINKey",
                                        nil];

                [blue writeSessionKey:keyDic];
//                [self actionSale];
//                dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                    [NSThread sleepForTimeInterval:1];
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [self actionSale];
//                    });
//                });
                
            }else {
                NSError *error = [NSError errorWithDomain:@"error" code:0 userInfo:@{@"NSLocalizedDescription":@"绑定终端失败"}];
                [self showStatusBarError:error];
            }
        }];
    }else {
        NSError *error = [NSError errorWithDomain:@"error" code:0 userInfo:@{@"NSLocalizedDescription":@"读取终端号失败"}];
        [self showStatusBarError:error];
    }
}

-(void)onDidSecondIssuance:(int)retCode
{
    [self endWaiting];
    
    if (retCode == 1 ) {
        [self showAlertView:@"交易允许"];
    }
    else
    {
        [self showAlertView:@"交易拒绝"];
    }
}

-(void)onDidUpdateKey:(int)retCode
{
    [self endWaiting];
    
    if (retCode == 0 ) {
        [self showAlertView:@"写入工作密钥成功"];
        [self actionSale];
    }
    else
    {
        [self showAlertView:@"写入工作密钥失败"];
    }
}

-(void)actionSale {
    NSString *amount = [POSManger transformAmountFormatWithStr:self.tadeAmount];
    if (self.tadeType == type_consument) {
        [blue startSwiper:1 money:[amount doubleValue]/100];
    }else if (self.tadeType == type_balance) {
        [blue startSwiper:2 money:[amount doubleValue]/100];
    }else {
        
    }
    
    [MBProgressHUD showSuccess:@"请插卡/刷卡" toView:self.view];
}

- (void)showAlertView:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}

-(void)onDetectCard
{
    NSLog(@"检测到卡片插入 或者已 刷卡");
    [self beginWaiting:@"正在读取卡片信息，请稍等......"];
}

#pragma mark
-(void)onDidReadCardInfo:(NSDictionary *)dic
{
    
    [self endWaiting];
    /*
     //磁条卡
     #define kMCRandom @"4"                 //随机数
     #define kMCCount  @"5"                 //主账户
     #define kMCExpired  @"6"                 //失效日期
     #define kMCTrackTwoLen  @"8"          //二磁道数据长度
     #define kMCTrackTwoLen  @"9"          //三磁道数据长度
     #define kMCTrackTwoData  @"A"    //二磁道加密数据
     #define kMCTrackTwoData  @"B"    //三磁道加密数据
     //IC卡
     #define kICCount  @"5A" //  主账户
     #define kICTrackTwoData  @"57"   //二磁道信息
     #define kICCardSN  @"5F34" //  卡序列号
     #define kICExpired  @"5F24" //  失效日期
     #define kICData  @"55"            //ICData
     */
    
    if (dic)
    {
        //[dicInfo addEntriesFromDictionary:dic];
        //NSLog(@"dicInfo=%@", dicInfo);
        
        //_stringIsICCard = [dic objectForKey:@"00"]; //00:磁条 01:IC
        
        //磁条卡
        if(blue.currentCardType == AF_card_mc)
        {
            _stringRandom = [dic objectForKey:@"4"];
            _stringCardNo = [dic objectForKey:@"5"];
            _stringExpired = [dic objectForKey:@"6"];
            _stringTrackTwoThreadData = [dic objectForKey:@"A"];
            
            self.cardInfo = @{@"cardType":@"0",
                              @"expiryDate":_stringExpired,
                              @"cardNumber":_stringCardNo,
                              @"track2":_stringTrackTwoThreadData,
                              @"track3":[dic objectForKey:@"B"]
                              };
            
        }
        //IC卡
        else{
            
            //_stringRandom = [dic objectForKey:@"2"];
            _stringCardSN = [dic objectForKey:@"5F34"];
            _stringExpired = [dic objectForKey:@"5F24"];
            _stringTrackTwoData = [dic objectForKey:@"57"];
            _stringCardNo = [dic objectForKey:@"5A"];
            _stringICData = [dic objectForKey:@"55"];
            
            self.cardInfo = @{@"data55":_stringICData,
                              @"cardNumber":_stringCardNo,
                              @"track2":_stringTrackTwoData,
                              @"expiryDate":_stringExpired,
                              @"cardType":@"1",
                              @"cardSerial":_stringCardSN
                              };
            
        }
        [blue getPinBlockFromKB:60];
    }
    
}



-(void)onError:(int)errorCode
{
    
    [self endWaiting];
    
    //if(type == 0xD122)
    //{
    //    {
    [self showAlertView:@"获取数据失败,请重新刷卡"];
    //    }
    //}
    
    if(errorCode == AF_ERROR_FAIL_NOT_SWIPER) {
        [self showAlertView:@"需要先刷卡"];
    }
    else if(errorCode == AF_ERROR_FAIL_TIMEOUT) {
        [self showAlertView:@"通信超时"];
        
    }else {
        [self showAlertView:@"获得按键信息失败"];
    }
    
}

-(void)onNeedInsertICCard
{
    [self endWaiting];
    
    [self showAlertView:@"发现复合卡，请插IC卡"];
}


-(void)onDidPressCancleKey
{
    [self endWaiting];
    
    [self showAlertView:@"用户按下取消键"];
}

#pragma delegate
-(void)onEncryptPinBlock:(NSDictionary *)dic
{
    [self endWaiting];
    //_encResult.text = [NSString stringWithFormat:@"pinBlock: %@, random: %@", dic[@"1"], dic[@"2"]];
    NSString *psdStr = [NSString stringWithFormat:@"%@", dic[@"1"]];
    [self requestTrade:psdStr];
}

-(void)onDidGetMoney:(NSString *)strMoney
{
    [self endWaiting];
//    _encResult.text = strMoney;
}

- (void) requestTrade:(NSString *)text {
    AbstractItems *item = [[AbstractItems alloc] init];
    item.n0 = @"0200";              //消息类型
    item.n4 = [POSManger transformAmountFormatWithStr:self.tadeAmount];     //交易金额12位
    item.n11 = self.vouchNo;
    NSLog(@"n11:%@",item.n11);
    item.n14 = [self.cardInfo objectForKey:@"expiryDate"];//卡有效期
    item.n35 = [[self.cardInfo objectForKey:@"track2"] uppercaseString];//磁道数据
    item.n41 = [[NSUserDefaults standardUserDefaults] valueForKey:TerminalNo];//终端号
    
    item.n42 = [[NSUserDefaults standardUserDefaults] valueForKey:MerchantNo];
    
    item.n49 = @"156";//交易货币代码
    NSString *workKey = [[NSUserDefaults standardUserDefaults] objectForKey:WokeKey];
    
    //NSLog(@"workKey:%@",workKey);
    
    item.n52 = [text uppercaseString];
    //    item.n53 = [[self.cardInfo objectForKey:@"randomNumber"] uppercaseString];
    if ([item.n52 length] > 0) {
        item.n26 = @"12";
    }
    NSString *str = nil;
    if([[self.cardInfo objectForKey:@"cardType"] integerValue] == 1){
        item.n22 = @"051";           //芯片
    }else{
        item.n22 = @"021";          //磁条
        //item.n2 = [self.cardInfo objectForKey:@"cardNumber"];//卡号
    }
    if(self.tadeType == type_consument || self.tadeType == type_realTime){
        item.n9 = [[NSUserDefaults standardUserDefaults] objectForKey:Rate];
        item.n3 = @"310000";            //交易处理码
        item.n60 = @"22000001003";//交易类型码
        //            item.n59 = @"RNS-1.1.0";
        if([[self.cardInfo objectForKey:@"cardType"] integerValue] == 1){
            NSString *n23 = [self.cardInfo objectForKey:@"cardSerial"];
            item.n23 = [NSString stringWithFormat:@"0%@",n23];
            NSLog(@"n23:%@",item.n23);
            item.n55 = [[self.cardInfo objectForKey:@"data55"] uppercaseString];
            NSLog(@"n55:%@",item.n55);
            
            str = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",item.n0,item.n3,item.n4,item.n9,item.n11,item.n14,item.n22,item.n23,item.n26,item.n35,item.n41,item.n42,item.n49,item.n52,item.n55,item.n59,item.n60];
        }else{
            
            str = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",item.n0,item.n3,item.n4,item.n9,item.n11,item.n14,item.n22,item.n26,item.n35,item.n41,item.n42,item.n49,item.n52,item.n59,item.n60];
            
        }
        str = [[str stringByAppendingString:MainKey] uppercaseString];
        NSLog(@"str:%@",str);
        item.n64 = [[str md5HexDigest] uppercaseString];//MAC
        
        
        [[NetAPIManger sharedManger] request_TranceWithParams:[item keyValues] andBlock:^(id data, NSError *error) {
            
            [[NSUserDefaults standardUserDefaults] setObject:self.voucherNo forKey:VoucherNo];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            AbstractItems *item = (AbstractItems *)data;
            if(!error && [item.n39 isEqualToString:@"00"]){
                SignViewController *signViewController = [[SignViewController alloc] init];
                signViewController.tadeType = self.tadeType;
                signViewController.absItem = item;
                signViewController.cardInfo = self.cardInfo;
                signViewController.tadeAmount = self.tadeAmount;
                [self.navigationController pushViewController:signViewController animated:YES];
            }else {
                //                    NSError *error = [[NSError alloc] initWithDomain:@"交易失败" code:0 userInfo:@{@"NSLocalizedDescription":@"交易失败"}];
                //                    [self showStatusBarError:error];
                if ([[ResponseDictionaryTool responseDic] objectForKey:item.n39]) {
                    NSString *error = [[ResponseDictionaryTool responseDic] objectForKey:item.n39];
                    HomePageViewController *homeVc = [[HomePageViewController alloc] init];
                    [MBProgressHUD showSuccess:error toView:homeVc.view];
                    [self.navigationController pushViewController:homeVc animated:YES];
                }else {
                    HomePageViewController *homeVc = [[HomePageViewController alloc] init];
                    homeVc.rate = self.rate;
                    [MBProgressHUD showSuccess:@"未知错误" toView:homeVc.view];
                    [[NSUserDefaults standardUserDefaults] setObject:@"00000000" forKey:Amount];
                    [self.navigationController pushViewController:homeVc animated:YES];
                }
                
            }
        }];
    }else if(self.tadeType == type_balance) {
        //            item.n59 = @"RNS-1.1.0";
        item.n60 = @"01000001003";//交易类型码
        item.n9 = [[NSUserDefaults standardUserDefaults] objectForKey:Rate];
        if([[self.cardInfo objectForKey:@"cardType"] integerValue] == 1){
            NSString *n23 = [self.cardInfo objectForKey:@"cardSerial"];
            item.n23 = [NSString stringWithFormat:@"0%@",n23];
            NSLog(@"n23:%@",item.n23);
            item.n55 = [[self.cardInfo objectForKey:@"data55"] uppercaseString];
            NSLog(@"n55:%@",item.n55);
            str = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",item.n0,item.n4,item.n9,item.n11,item.n14,item.n22,item.n23,item.n26,item.n35,item.n41,item.n42,item.n49,item.n52,item.n55,item.n59,item.n60];
        }else {
            str = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@",item.n0,item.n4,item.n9,item.n11,item.n14,item.n22,item.n26,item.n35,item.n41,item.n42,item.n49,item.n52,item.n59,item.n60];
        }
        
        str = [[str stringByAppendingString:MainKey] uppercaseString];
        NSLog(@"str:%@",str);
        item.n64 = [[str md5HexDigest] uppercaseString];//MAC
        
        
        [[NetAPIManger sharedManger] request_BalanceWithParams:[item keyValues] andBlock:^(id data, NSError *error) {
            //            orderItem.voucherNo = [NSString stringWithFormat:@"%zd",voucherNo];
            //            self.voucherNo = orderItem.voucherNo;
            //NSLog(@"voucherNo:%@",orderItem.voucherNo);
            //            [[NSUserDefaults standardUserDefaults] setObject:self.voucherNo forKey:VoucherNo];
            //                [[NSUserDefaults standardUserDefaults] setObject:item.n42 forKey:MerchantNo];
            //            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:infos] forKey:TranceInfo];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            AbstractItems *item = (AbstractItems *)data;
            if(!error && [item.n39 isEqualToString:@"00"]){
                NSString *banlanceStr = @"";
                if([item.n54 length] > 11){
                    banlanceStr = [item.n54 substringFromIndex:item.n54.length - 12];
                    NSLog(@"%@",banlanceStr);
                    banlanceStr = [POSManger transformAmountFormatWithStr:banlanceStr];
                    NSLog(@"%@",banlanceStr);
                    
                }
                ConsumeResultViewController *consumeResultViewController = [[ConsumeResultViewController alloc] init];
                consumeResultViewController.tadeType = self.tadeType;
                consumeResultViewController.tadeAmount = banlanceStr;
                consumeResultViewController.cardInfo = self.cardInfo;
                [self.navigationController pushViewController:consumeResultViewController animated:YES];
            }else {
                if ([[ResponseDictionaryTool responseDic] objectForKey:item.n39]) {
                    NSString *error = [[ResponseDictionaryTool responseDic] objectForKey:item.n39];
                    HomePageViewController *homeVc = [[HomePageViewController alloc] init];
                    [MBProgressHUD showSuccess:error toView:homeVc.view];
                    [self.navigationController pushViewController:homeVc animated:YES];
                }else {
                    [MBProgressHUD showSuccess:@"未知错误" toView:self.view];
                }
            }
        }];
    }else if(self.tadeType == type_revoke) {
        //item.n60 = @"23000001003";//交易类型码
        item.n601 = @"23";
        item.n602 = [NSString stringWithFormat:@"%@",self.batchNo];
        item.n603 = @"003";
        item.n60 = [NSString stringWithFormat:@"%@%@%@",item.n601,item.n602,item.n603];
        NSLog(@"n60:%@",item.n60);
        item.n61 = [NSString stringWithFormat:@"%@%@",self.batchNo, self.originalVoucherNo];
        if([[self.cardInfo objectForKey:@"cardType"] integerValue] == 1){
            item.n55 = [[self.cardInfo objectForKey:@"data55"] uppercaseString];
            str = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",item.n0,item.n4,item.n11,item.n14,item.n22,item.n26,item.n35,item.n41,item.n42,item.n49,item.n52,item.n55,item.n59,item.n60,item.n61];
        }else {
            str = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@",item.n0,item.n4,item.n11,item.n14,item.n22,item.n26,item.n35,item.n41,item.n42,item.n49,item.n52,item.n59,item.n60,item.n61];
        }
        
        str = [[str stringByAppendingString:MainKey] uppercaseString];
        NSLog(@"str:%@",str);
        item.n64 = [[str md5HexDigest] uppercaseString];//MAC
        
        [[NetAPIManger sharedManger] request_BalanceWithParams:[item keyValues] andBlock:^(id data, NSError *error) {
            //orderItem.voucherNo = [NSString stringWithFormat:@"%zd",voucherNo];
            //                [[NSUserDefaults standardUserDefaults] setObject:item.n42 forKey:MerchantNo];
            //            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:infos] forKey:TranceInfo];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            AbstractItems *item = (AbstractItems *)data;
            if(!error && [item.n39 isEqualToString:@"00"]){
                SignViewController *signViewController = [[SignViewController alloc] init];
                signViewController.tadeType = self.tadeType;
                signViewController.absItem = item;
                signViewController.cardInfo = self.cardInfo;
                signViewController.tadeAmount = self.tadeAmount;
                [self.navigationController pushViewController:signViewController animated:YES];
            }else {
                if ([[ResponseDictionaryTool responseDic] objectForKey:item.n39]) {
                    NSString *error = [[ResponseDictionaryTool responseDic] objectForKey:item.n39];
                    QueryrRecordViewController *queryVc = [[QueryrRecordViewController alloc]init];
                    [MBProgressHUD showSuccess:error toView:queryVc.view];
                    [self.navigationController pushViewController:queryVc animated:YES];
                }else {
                    [MBProgressHUD showSuccess:@"未知错误" toView:self.view];
                }
            }
        }];
    }
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
    [blue stopScanBlueDevice];
    [blue disConnectDevice];
}

@end
