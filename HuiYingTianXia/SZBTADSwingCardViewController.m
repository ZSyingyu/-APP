//
//  SZBTADSwingCardViewController.m
//  HuiYingTianXia
//
//  Created by liguo.chen on 16/5/19.
//  Copyright © 2016年 tsmc. All rights reserved.
//

#import "SZBTADSwingCardViewController.h"
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

#import "MF_POSManager.h"
#import "SDK2/MPosController.h"
#import "SVProgressHUD/SVProgressHUD.h"
#import "MLTableAlert/MLTableAlert.h"
#import "AbstractItems.h"
#import "NSString+MD5HexDigest.h"
#import "NetAPIManger.h"
#import "MJExtension.h"

#import "ResponseDictionaryTool.h"
#import "SignViewController.h"
#import "ConsumeResultViewController.h"
#import "HomePageViewController.h"
#import "QueryrRecordViewController.h"
#import "SZBTADEnterPSDViewController.h"


#define kDicKeyTerminalNo  @"1"
#define kDicKeyINITStatus  @"2"
#define kDicKeyKSN         @"3"

@interface SZBTADSwingCardViewController ()<AC_POSMangerDelegate,MF_POSMangerDelegate,MPosDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)TTTAttributedLabel *labTip;

@property (strong, nonatomic) MPosController *posCtrl;
@property (assign, nonatomic) EU_POS_CARDTYPE cardType;
@property (assign, nonatomic) MFEU_MSR_EMV_PIN emvPinReq;
@property(nonatomic)MFEU_MSR_OPENCARD_RESP *resp;
@property(nonatomic, weak)NSObject <MF_POSMangerDelegate> *deleagte;//代理
@property (strong, nonatomic) MLTableAlert *alert;

@property(strong,nonatomic)MF_POSManager *manager;

@property(strong,nonatomic)NSDictionary *BTDic;

@property(nonatomic, strong)NSDictionary *cardInfo;

@property(strong,nonatomic)UITableView *myTabelView;

@end

NSString * text;
int ctrlFlag;
//bool readOldFileForiTronDevice = TRUE;

typedef enum {
    ACTION_UNKNOWN = 0,
    ACTION_TEST,
    ACTION_QUERY,
    ACTION_SALE,
} MFEU_POS_ACTION;

@implementation SZBTADSwingCardViewController


{
    //    NSTimer *timer;
    NSMutableArray *m_arrayName;
    NSMutableArray *m_arrayUUID;
    
    MFEU_DRIVER_INTERFACE m_euDDI;
    MFEU_POS_ACTION m_euAction;
}


@synthesize getKsnBtn = _getKsnBtn;
@synthesize cardInfoView = _cardInfoView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [[MF_POSManager shareInstance] setDeleagte:self];
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
    
    //神州安付
    //初始化sdk
    blue = [AnFSwiperController shareInstance];
    //设置代理
    blue.delegate = self;
    
    deviceArrayList = [[NSMutableArray alloc] init];
    dicCurrect = [[NSMutableDictionary alloc] init];
    if( blue.isConnectBlue ) {
        
        [dicCurrect addEntriesFromDictionary:blue.dicCurrect];
        
        [self.myTabelView removeFromSuperview];
        
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

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if(!blue.isConnectBlue)
    {
        [blue stopScanBlueDevice];
    }
//    else {
//        [blue disConnectDevice];
//    }
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

-(void)endWaiting
{
    [waitView hide:YES afterDelay:.5];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [blue scanBlueDevice:@""];
    blue.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

/*
 -(void)back:(id)sender
 {
 [self.navigationController popViewControllerAnimated:YES];
 }
 */

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
                
                                [self.posCtrl loadWorkKey:str1
                                                   macKey:str2
                                                 trackKey:str3
                                                 keyIndex:MF_KEY_IND_0];
                
                [self actionSale];
                
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

-(void)actionSale {
     NSString *amount = [POSManger transformAmountFormatWithStr:self.tadeAmount];
    if (self.tadeType == type_consument) {
        [blue startSwiper:1 money:[amount doubleValue]];
    }else if (self.tadeType == type_balance) {
        [blue startSwiper:2 money:[amount doubleValue]];
    }else {
    
    }
    
    [MBProgressHUD showSuccess:@"请插卡/刷卡" toView:self.view];
}

//提示刷卡
-(void)onDetectCard
{
    [self beginWaiting:@"正在读取卡片信息，请稍等......"];
}

//磁条卡有随机数,芯片卡没有(需要添加)
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
            
            NSString *str = [_stringTrackTwoThreadData substringFromIndex:_stringTrackTwoThreadData.length - 1];
            NSLog(@"str:%@",str);
            if ([str isEqualToString:@"F"]) {
                _stringTrackTwoThreadData = [_stringTrackTwoThreadData substringToIndex:_stringTrackTwoThreadData.length - 1];
                NSLog(@"t2data:%@",_stringTrackTwoThreadData);
            }
            NSLog(@"t2data:%@,cardNO:%@,date:%@,random:%@",_stringTrackTwoThreadData,_stringCardNo,_stringExpired,_stringRandom);
//            if (self.tadeType == type_consument) {
                [self swingcardCallback:@{@"cardType":@"0",
                                          @"randomNumber":_stringRandom,
                                          @"expiryDate":_stringExpired,
                                          @"cardNumber":_stringCardNo,
                                          @"track2":_stringTrackTwoThreadData,
                                          }];
//            }else if (self.tadeType == type_balance) {
//                
//            }
            
            
        }
        //IC卡
        else{
            
//                        _stringRandom = [dic objectForKey:@"2"];//这个方法获取不到随机数
            _stringCardSN = [dic objectForKey:@"5F34"];
            _stringExpired = [dic objectForKey:@"5F24"];
            _stringTrackTwoData = [dic objectForKey:@"57"];
            _stringCardNo = [dic objectForKey:@"5A"];
            _stringICData = [dic objectForKey:@"55"];
//            if (self.tadeType == type_consument) {
            NSLog(@"t2data:%@,cardNO:%@,date:%@,serial:%@,date55:%@",_stringTrackTwoData,_stringCardNo,_stringExpired,_stringCardSN,_stringICData);
                [self swingcardCallback:@{@"data55":[_stringICData uppercaseString],
                                          @"cardSerial":_stringCardSN,
                                          @"cardNumber":_stringCardNo,
                                          @"track2":_stringTrackTwoData,
                                          @"expiryDate":[_stringExpired substringToIndex:4],
                                          @"cardType":@"1"
                                          }];
//            }else if (self.tadeType == type_balance) {
//                
//            }
            
        }

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

- (void)showAlertView:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)backAction:(id)sender
{
    if(self.tadeType == type_balance){
        [self.navigationController.navigationBar setHidden:YES];
    }
    self.posCtrl.delegate = nil;
    [super backAction:sender];
}



- (void)swipeICCardAction
{
    
    [m_vcom StopRec];
    
    //icBtn.userInteractionEnabled = NO;
    
    self.cardInfoView.text = @"ic卡刷";
    //ic卡刷卡命令
    
    //    NSString *str = @"123456";
    //    char *temp = HexToBin((char *)[str UTF8String]);
    //    char rom[100];
    //    memcpy(rom, temp, [str length]/2);//一定要拷贝否则会占用通一块内存
    
    
    //    NSString *appendData = @"49900003200015141399";
    //    char *temp1 = HexToBin((char*)[appendData UTF8String]);
    //    char appendDataChar[100];
    //    memcpy(appendDataChar, temp1, [appendData length]/2);//一定要拷贝否则会占用通一块内存
    //    int appendlen =[appendData length]/2;
    
    NSString *cash = @"100";//金额  单位为分
    int cashLen = [cash length];
    char cData[100];
    cData[0] = 0;
    strcpy(cData,((char*)[cash UTF8String]));
    
    Transactioninfo *tranInfo = [[Transactioninfo alloc] init];
    
    //    it6=0/1 55域数据是否加密1011
    NSString *ctrm = @"8E000000";
    //    8E000000
    //    NSString *ctrm = @"25000000";
    //    NSString *ctrm = @"5b600000";
    char *temp2 = HexToBin((char*)[ctrm UTF8String]);
    char ctr[4];
    memcpy(ctr, temp2, [ctrm length]/2);
    
    [m_vcom stat_EmvSwiper:0 PINKeyIndex:1 DESKeyInex:1 MACKeyIndex:1 CtrlMode:ctr ParameterRandom:nil ParameterRandomLen:0 cash:cData cashLen:cashLen appendData:nil appendDataLen:0 time:30 Transactioninfo:tranInfo];
    [m_vcom StartRec];
    
}

#pragma mark AC_POSMangerDelegate

- (void)EmvOperationWaitiing{
    [MBProgressHUD showSuccess:@"正在读取银行卡,请勿拔卡!" toView:self.view];
    NSLog(@"-----------");
}


- (void)swingcardCallback:(NSDictionary *)cardInfo
{
    
    SZBTADEnterPSDViewController *enterPwdVC =[[SZBTADEnterPSDViewController alloc] init];
    enterPwdVC.tadeType = self.tadeType;
    NSLog(@"tadetype:%u",self.tadeType);
    enterPwdVC.rate = self.rate;
    enterPwdVC.tadeAmount = self.tadeAmount;
    enterPwdVC.cardInfo = cardInfo;
    
    enterPwdVC.voucherNo = self.vouchNo;
    NSLog(@"voucherNo:%@",enterPwdVC.voucherNo);
    enterPwdVC.originalVoucherNo = self.originalVoucherNo;
    NSLog(@"originalVoucherNo:%@",enterPwdVC.originalVoucherNo);
    
    enterPwdVC.batchNo = self.batchNo;
    if (self.absItem) {
        enterPwdVC.absItem = self.absItem;
    }
    [self.navigationController pushViewController:enterPwdVC animated:YES];
}

- (void)errorWithInfo:(NSDictionary *)info
{
    NSError *error = [NSError errorWithDomain:@"error" code:0 userInfo:@{@"NSLocalizedDescription":@"刷卡器超时"}];
    [self showStatusBarError:error];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
