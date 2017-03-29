
//
//  SwingCardViewController.m
//  HuiYingTianXia
//
//  Created by tsmc on 15-3-21.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import "MFBTSwingCardViewController.h"
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


//static int pageNum = 0;




@interface MFBTSwingCardViewController()<AC_POSMangerDelegate,MF_POSMangerDelegate,MPosDelegate>
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

@implementation MFBTSwingCardViewController

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
    //    m_euDDI = MF_DDI_AUDIO;
    m_euDDI = MF_DDI_BLE;
    
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
    
//    if ([self.posCtrl getDeviceState] == 1) {
//        [self.posCtrl disconnectBtDevice];
//    }
//    [self connectPos];
    
    if ([self.posCtrl getDeviceState] == 1) {

        [self didSetDatetimeResp];
    }else {
        [self connectPos];
    }

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
    self.manager.deleagte = nil;
    [super backAction:sender];
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
    //    enterPwdVC.voucherNo = [AC_POSManger shareInstance].vouchNo;
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
//    [self traceMsg: [NSString stringWithFormat: @"didConnectedBtDevice = %@", devName]];
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
    
    NSString *amount = [POSManger transformAmountFormatWithStr:self.tadeAmount];
    
    [self.posCtrl openCardReader:nil aMount:[amount integerValue] timeOut:60 readType:MF_COMBINED showMsg:nil];
    
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
                    NSLog(@"n62:%@",item.n62);
                    
                    
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
                
                
//                [self.posCtrl loadWorkKey: str1
//                                   macKey: str2
//                                 trackKey: str3
//                                 keyIndex: MF_KEY_IND_0
//                                keyLength: MF_LEN_DOUBLE];
                [self.posCtrl loadWorkKey:str1
                                  macKey:str2
                                trackKey:str3
                                 keyIndex:MF_KEY_IND_0];
                
                
                
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
//    [self traceMsg: [NSString stringWithFormat: @"didConnectedBtDevice = %@", btDevice]];
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
    if (resp == MF_RESP_SUCC) {
        NSLog(@"resp:%d",resp);
        
        [self actionSale];
        
    }else {
        NSLog(@"--------");
//        [self alertMsg: [NSString stringWithFormat: @"didLoadWorkKeyResp = %x", resp]];
    }
    
    
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
                                  @"expiryDate":[date substringToIndex:4] ,
                                  @"cardType":@"1"
                                  };
                
            } else {
                
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
            [self requestTrade:text];
            
            
        } else if (self.cardType == USE_IC) {
            // IC卡处理
            /*
             * 根据返回数据组8583包，此处省略，pData8583假定为数据包
             */
            
            [self requestTrade:text];
            
            
            // 联机操作后，最后要调用EndEmv();
            [self.posCtrl endEmv];
        }
        return;
    }
    
    [self alertMsg: [NSString stringWithFormat: @"didInputPinResp type = %d\npwdLength = %d\n%@", (int)type, (int)len, text]];
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
    item.n53 = [[self.cardInfo objectForKey:@"randomNumber"] uppercaseString];
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
        item.n9 = self.rate;
        item.n3 = @"310000";            //交易处理码
        item.n60 = @"22000001003";//交易类型码
        //            item.n59 = @"RNS-1.1.0";
        if([[self.cardInfo objectForKey:@"cardType"] integerValue] == 1){
            NSString *n23 = [self.cardInfo objectForKey:@"cardSerial"];
            item.n23 = [NSString stringWithFormat:@"0%@",n23];
            NSLog(@"n23:%@",item.n23);
            item.n55 = [[self.cardInfo objectForKey:@"data55"] uppercaseString];
            NSLog(@"n55:%@",item.n55);
            
            str = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",item.n0,item.n3,item.n4,item.n9,item.n11,item.n14,item.n22,item.n23,item.n26,item.n35,item.n41,item.n42,item.n49,item.n52,item.n53,item.n55,item.n59,item.n60];
        }else{
            
            str = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",item.n0,item.n3,item.n4,item.n9,item.n11,item.n14,item.n22,item.n26,item.n35,item.n41,item.n42,item.n49,item.n52,item.n53,item.n59,item.n60];
            
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
                    [MBProgressHUD showSuccess:@"未知错误" toView:self.view];
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
            str = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",item.n0,item.n4,item.n9,item.n11,item.n14,item.n22,item.n23,item.n26,item.n35,item.n41,item.n42,item.n49,item.n52,item.n53,item.n55,item.n59,item.n60];
        }else {
            str = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",item.n0,item.n4,item.n9,item.n11,item.n14,item.n22,item.n26,item.n35,item.n41,item.n42,item.n49,item.n52,item.n53,item.n59,item.n60];
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
            str = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",item.n0,item.n4,item.n11,item.n14,item.n22,item.n26,item.n35,item.n41,item.n42,item.n49,item.n52,item.n53,item.n55,item.n59,item.n60,item.n61];
        }else {
            str = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",item.n0,item.n4,item.n11,item.n14,item.n22,item.n26,item.n35,item.n41,item.n42,item.n49,item.n52,item.n53,item.n59,item.n60,item.n61];
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

@end
