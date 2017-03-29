//
//  SwingCardViewController.m
//  HuiYingTianXia
//
//  Created by tsmc on 15-3-21.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import "SwingCardViewController.h"
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


//static int pageNum = 0;




@interface SwingCardViewController()<AC_POSMangerDelegate,MF_POSMangerDelegate,MPosDelegate>
@property(nonatomic, strong)TTTAttributedLabel *labTip;

@property (strong, nonatomic) MPosController *posCtrl;
@property (assign, nonatomic) EU_POS_CARDTYPE cardType;
@property (assign, nonatomic) MFEU_MSR_EMV_PIN emvPinReq;
@property(nonatomic)MFEU_MSR_OPENCARD_RESP *resp;
@property(nonatomic, weak)NSObject <MF_POSMangerDelegate> *deleagte;//代理
@property (strong, nonatomic) MLTableAlert *alert;

@property(strong,nonatomic)MF_POSManager *manager;

@property(strong,nonatomic)NSDictionary *cardInfo;

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

@implementation SwingCardViewController

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
    
    //魔方
    
    // 初始化MPosController对象
    self.posCtrl = [MPosController sharedInstance];
    self.posCtrl.delegate = self;
    
    m_arrayName = [[NSMutableArray alloc] init];
    m_arrayUUID = [[NSMutableArray alloc] init];
    m_euAction = ACTION_UNKNOWN;
    m_euDDI = MF_DDI_AUDIO;
    //    m_euDDI = MF_DDI_BLE;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:SVProgressHUDWillAppearNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:SVProgressHUDDidAppearNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:SVProgressHUDWillDisappearNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:SVProgressHUDDidDisappearNotification
                                               object:nil];
    
    self.manager = [MF_POSManager shareInstance];
    self.manager.deleagte = self;
    
    if ([self.posCtrl getDeviceState] == 1) {
        [self.posCtrl close];
    }
        [self connectPos];

    
    
    
}

- (void)handleNotification:(NSNotification *)notif
{
    NSLog(@"Notification recieved: %@", notif.name);
    NSLog(@"Status user info key: %@", [notif.userInfo objectForKey:SVProgressHUDStatusUserInfoKey]);
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    
    
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
    
    EnterPwdViewController *enterPwdVC =[[EnterPwdViewController alloc] init];
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


////魔方刷卡头

-(void)openAudioDevice
{
    m_euDDI = MF_DDI_AUDIO;
    //    [self.posCtrl resetPos];
    [self.posCtrl open];
}

-(void)connectPos {
    
    if (m_euDDI == MF_DDI_BLE) {
        [self scanBtDevice];
    } else if (m_euDDI == MF_DDI_AUDIO) {
        [self openAudioDevice];
    }

}

-(void)scanBtDevice
{
    m_euDDI = MF_DDI_BLE;
    
    [m_arrayName removeAllObjects];
    [m_arrayUUID removeAllObjects];
//    [SVProgressHUD showWithStatus:@"正在扫描设备"];
    [self.posCtrl scanBtDevice: 5];
}

-(void) setCurrentDatetime
{
    NSLog(@"set Current Datetime.");
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *currentTime = [formatter stringFromDate:[NSDate date]];
    
    [self.posCtrl setDatetime: currentTime factoryId: 0];
}

- (void)didConnected:(NSString *)devName
{
    [SVProgressHUD dismiss];
    [self traceMsg: [NSString stringWithFormat: @"didConnectedBtDevice = %@", devName]];
    [self showStatusBarSuccessStr: @"设备已连接"];
    
    [self.posCtrl setFactoryCode: 0];   // 默认为0,具体ID分配请与我们联系
    
}

// 获取设备版本信息
-(void) didReadPosInfoResp:(NSString *)ksn status: (MFEU_MSR_DEVSTAT)status battery: (MFEU_MSR_BATTERY)battery app_ver: (NSString *)app_ver data_ver: (NSString *)data_ver custom_info: (NSString *)custom_info
{
    
    ksn = [NSString stringWithFormat:@"%@",ksn];
    NSLog(@"ksn:%@",ksn);
    
    [self didGetKsnCompleted:ksn];
    
}

-(void)actionSale
{
    
    m_euAction = ACTION_SALE;
    self.cardType = USE_UNKNOWN;
    [self.posCtrl openCardReader:nil aMount:[self.tadeAmount integerValue] timeOut:60 readType:MF_COMBINED showMsg:nil];
    
}

- (void)didGetKsnCompleted:(NSString *)ksn{
    NSLog(@"ksn:%@",ksn);
    if (ksn.length > 0) {
        AbstractItems *item = [[AbstractItems alloc] init];
        item.n1 = [[NSUserDefaults standardUserDefaults] objectForKey:Account];
        item.n3 = @"190958";
        //        item.n59 = @"CHDS-1.0.0";
        item.n62 = [ksn uppercaseString];
        
        NSString *macStr = [NSString stringWithFormat:@"%@%@%@%@%@%@",item.n0,item.n1,item.n3,item.n59,item.n62,MainKey];
        item.n64 = [[macStr md5HexDigest] uppercaseString];
        [[NetAPIManger sharedManger] request_BindingPosWithParams:[item keyValues] andBlock:^(id data, NSError *error) {
            
            
            AbstractItems *item = (AbstractItems *)data;
            if(!error && ([item.n39 isEqualToString:@"00"] || [item.n39 isEqualToString:@"94"]) && item.n41.length > 0 && item.n62.length > 0 && item.n62.length > 0){
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

-(void) didSetDatetimeResp
{
    // 获取设备信息
    [self.posCtrl readPosInfo];
}

-(void)alertMsg: (NSString *)msg
{
    [SVProgressHUD dismiss];
    
    UIAlertView * alter = [[UIAlertView alloc] initWithTitle:@"提示" message: msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alter show];
}

-(void) traceMsg: (NSString *) msg
{
    NSLog(@"%@", msg);
}

-(void)didOpenCardResp:(MFEU_MSR_OPENCARD_RESP)resp{
    
    if (ACTION_SALE) {
        if (resp == MF_RESP_OPENCARD_INSERT) {
            // IC卡插入
            //            [SVProgressHUD showWithStatus: @"准备读取IC卡"];
            [MBProgressHUD showSuccess:@"正在读取银行卡,请勿拔卡!" toView:self.view];
            self.cardType = USE_IC;
            [self.posCtrl startEmv: [self.tadeAmount integerValue] otherAmount: 0 tradeType: MF_FUNC_SALE ecashTrade: MF_ECASH_FORBIT pbocFlow: MF_PBOC_FULL icOnline:MF_ONLINE_YES];
        } else if (resp == MF_RESP_OPENCARD_USERCANCEL){
            [self alertMsg: @"用户取消"];
        } else if (resp == MF_RESP_OPENCARD_ICFORCE) {
            [self alertMsg: @"强制IC卡"];
        } else if (resp == MF_RESP_OPENCARD_FINISH) {
            //            [SVProgressHUD showWithStatus: @"准备读磁条卡"];
            self.cardType = USE_MARCARD;
            [self.posCtrl readMagcard: MF_READ_TRACK_COMBINED_TEXT panMask: MF_READ_NOMASK];
        } else {
            [self alertMsg: [NSString stringWithFormat: @"刷卡失败(%02x)", resp]];
        }
        return;
    }
    
    [self alertMsg: [NSString stringWithFormat: @"didOpenCardResp = %d", resp]];
}

-(void) didReadMagcardResp: (MFEU_MSR_READCARD_RESP)resp
                 maskedPAN: (NSString *)pan
                expiryDate: (NSString *)exdate
               serivceCode: (NSString *)sCode
              track2Length: (NSInteger)t2Size
              track3Length: (NSInteger)t3Size
                 encTrack2: (NSString *)t2data
                 encTrack3: (NSString *)t3data
              randomNumber: (NSString *)randNum
{
    
    if (m_euAction == ACTION_SALE) {
        if (m_euDDI == MF_DDI_BLE) {
            [self.posCtrl inputPin: 8 timeOut: 60 maskedPAN: pan];
            
            self.cardInfo = @{@"cardType":@"0",
                              @"randomNumber":randNum,
                              @"expiryDate":exdate,
                              @"cardNumber":pan,
                              @"track2":t2data,
                              @"track3":t3data
                              };
            
        } else {
            //            [self.posCtrl pinEncrypt: @"123456" maskedPAN: pan];
            
            [self swingcardCallback:@{@"cardType":@"0",
                                      @"randomNumber":randNum,
                                      @"expiryDate":exdate,
                                      @"cardNumber":pan,
                                      @"track2":t2data,
                                      @"track3":t3data
                                      }];
            
        }
        
    }
    
    NSString *string = [[NSString alloc] initWithFormat:@"didReadMagcardResp resp=%d\n主账号: %@\n有效日期: %@\n服务代码: %@\n二磁道数据: %@\n三磁道数据: %@", resp, pan, exdate, sCode, t2data, t3data];
    NSLog(@"string:%@",string);
    
}


#pragma mark MPosDelegate

- (void)didFoundBtDevice:(NSString *)btDevice
{
    NSRange rrr = [btDevice rangeOfString: @","];
    if (rrr.length > 0) {
        NSString *name = [btDevice substringToIndex: rrr.location];
        NSString *uuid = [btDevice substringFromIndex: rrr.location + 1];
        
        NSLog(@"%@:%@", name, uuid);
        
        [m_arrayName addObject: name];
        [m_arrayUUID addObject: uuid];
    }
}

-(void) didStopScanBtDevice
{
    [SVProgressHUD dismiss];
    [self performSelectorOnMainThread:@selector(showTableAlert) withObject:nil waitUntilDone:NO];
}

- (void)didConnectedBtDevice:(NSString *)btDevice
{
    [SVProgressHUD dismiss];
    [self traceMsg: [NSString stringWithFormat: @"didConnectedBtDevice = %@", btDevice]];
    [self showStatusBarSuccessStr: @"设备已连接"];
}

//检测到音频插入
- (void)didDevicePlugged
{
    [self showStatusBarSuccessStr: @"设备已连接"];
    //    [self openAudioDevice];
}

// 检测到音频拔出
- (void)didDeviceUnplugged
{
    [self showStatusBarSuccessStr: @"设备未连接"];
}

- (void)didInterrupted
{
    [self showStatusBarSuccessStr: @"操作中断"];
}

-(void) didSessionResponse: (MFEU_POS_SESSION) sessionType returnCode: (MFEU_POS_RESULT) responceCode
{
    [self traceMsg: [NSString stringWithFormat: @"sessionType: %d, responseCode: %d", sessionType, responceCode]];
}

-(void)showTableAlert
{
    // create the alert
    self.alert = [MLTableAlert tableAlertWithTitle:@"请选择设备" cancelButtonTitle:@"取消"
                                      numberOfRows:^NSInteger (NSInteger section) {
                                          return [m_arrayName count];
                                      }
                                          andCells:^UITableViewCell* (MLTableAlert *anAlert, NSIndexPath *indexPath) {
                                              static NSString *CellIdentifier = @"CellIdentifier";
                                              UITableViewCell *cell = [anAlert.table dequeueReusableCellWithIdentifier:CellIdentifier];
                                              if (cell == nil)
                                                  cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                                              
                                              cell.textLabel.text = [NSString stringWithFormat:@"%@", [m_arrayName objectAtIndex: indexPath.row]];
                                              
                                              return cell;
                                          }];
    
    // Setting custom alert height
    self.alert.height = 300;
    
    // configure actions to perform
    [self.alert configureSelectionBlock:^(NSIndexPath *selectedIndex){
        [self.posCtrl connectBtDevice: [m_arrayUUID objectAtIndex: selectedIndex.row] ];
        [SVProgressHUD showWithStatus: @"正在连接设备"];
    } andCompletionBlock:^{
        //self.navigationItem.title = @"Cancel Button Pressed\nNo Cells Selected";
    }];
    
    // show the alert
    [self.alert show];
    
}

/// 下载工作密钥回调
-(void) didLoadWorkKeyResp: (MFEU_MSR_RESP)resp
{
    [self alertMsg: [NSString stringWithFormat: @"didLoadWorkKeyResp = %x", resp]];
}

-(void) didStartEmvResp: (MFEU_MSR_EMV_RESP)resp pinReq: (MFEU_MSR_EMV_PIN)req
{
    if (m_euAction == ACTION_SALE) {
        if ( resp == MF_RESP_EMV_SUCC
            || resp == MF_RESP_EMV_ACCEPT
            || resp == MF_RESP_EMV_ONLINE ) {
            
            self.emvPinReq = req;
            [self.posCtrl getEmvDataEx2: MF_FUNC_SALE];
            
        } else {
            [self alertMsg: @"IC卡处理失败"];
        }
        return;
    }
    [self alertMsg: [NSString stringWithFormat: @"didStartEmvResp resp=%d, pinReq=%d", resp, req]];
}

-(void) didGetEmvDataExResp: (NSString *)data55 beforeLength: (NSInteger)len55 randomNumber: (NSString *)randNum serialNumber: (NSString *)serial maskedPAN: (NSString *)pan encTrack: (NSString *)track expiryDate: (NSString *)date
{
    
    NSString *string = [[NSString alloc] initWithFormat:@"didGetEmvDataExResp\n(%d)%@\n随机数: %@\n序列号: %@\n主账号: %@\n磁道数据: %@, 有效日期: %@"
                        , (int)len55, data55, randNum, serial, pan, track, date];
    NSLog(@"string:%@",string);
    
    
    
    
    if (m_euAction == ACTION_SALE) {
        if (self.emvPinReq == MF_PIN_EMV_REQ) {
            
            if (m_euDDI == MF_DDI_BLE) {
                [self.posCtrl inputPin: 8 timeOut: 60 maskedPAN: pan];
                
                self.cardInfo = @{@"len55":[NSNumber numberWithInt:len55],
                                  @"data55":[data55 uppercaseString],
                                  @"randomNumber":randNum,
                                  @"cardSerial":serial,
                                  @"cardNumber":pan,
                                  @"track2":track,
                                  @"expiryDate":[date substringToIndex:4],
                                  @"cardType":@"1"
                                  };
                
            } else {
                //[self alertMsg: @"请输入密码，获取余额信息"];
                //                [self.posCtrl pinEncrypt: @"123456" maskedPAN: pan];
                //加一些联机操作  看输入密码后与后台交互会不会回调   如果回调  必须要将[self.posCtrl endEmv];写入回调方法中
                
                
                [self swingcardCallback:@{@"len55":[NSNumber numberWithInt:len55],
                                          @"data55":[data55 uppercaseString],
                                          @"randomNumber":randNum,
                                          @"cardSerial":serial,
                                          @"cardNumber":pan,
                                          @"track2":track,
                                          @"expiryDate":[date substringToIndex:4],
                                          @"cardType":@"1"
                                          }];
                [self.posCtrl endEmv];
                
            }
        } else {
            // 联机操作后，最后要调用EndEmv();
            [self.posCtrl endEmv];
        }
        return;
    }
    
    
}

-(void) didIcDealOnlineResp: (MFEU_MSR_REAUTH_RESP) resp
{
    [self alertMsg: [NSString stringWithFormat: @"didIcDealOnlineResp = %x", resp]];
}

-(void) didEndEmvResp
{
    if (m_euAction == ACTION_SALE) {
        //        [self alertMsg: @"IC卡消费完成"];
        return;
    }
    [self alertMsg: @"完成EMV流程"];
}

/// 密码输入回调
-(void) didInputPinResp: (MFEU_MSR_KEYTYPE) type pwdLength: (NSInteger) len pwdText: (NSString *)text;
{
    if (m_euAction == ACTION_SALE) {
        if (self.cardType == USE_MARCARD) {
            // 磁条卡处理
            /**
             根据返回数据组8583包与POSP通讯, 此处省略...
             */
//            [self alertMsg: @"IC卡片余额为：1000"];
        } else if (self.cardType == USE_IC) {
            // IC卡处理
            /*
             * 根据返回数据组8583包，此处省略，pData8583假定为数据包
             */
            
            [self swingcardCallback:@{@"pwdText":text
                                      }];
            
            
            // 联机操作后，最后要调用EndEmv();
            [self.posCtrl endEmv];
        }
        return;
    }
    
    [self alertMsg: [NSString stringWithFormat: @"didInputPinResp type = %d\npwdLength = %d\n%@", (int)type, (int)len, text]];
}


@end
