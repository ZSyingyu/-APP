//
//  MF_POSManager.m
//  HuiYingTianXia
//
//  Created by 朱颖宇 on 15/7/31.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import "MF_POSManager.h"

#import "SVProgressHUD/SVProgressHUD.h"
#import "MLTableAlert/MLTableAlert.h"
#import "AbstractItems.h"
#import "NSString+MD5HexDigest.h"
#import "NetAPIManger.h"
#import "MJExtension.h"
#import "SwingCardViewController.h"

typedef enum {
    ACTION_UNKNOWN = 0,
    ACTION_TEST,
    ACTION_QUERY,
    ACTION_SALE,
} MFEU_POS_ACTION;

@implementation MF_POSManager

{
    NSTimer *timer;
    NSMutableArray *m_arrayName;
    NSMutableArray *m_arrayUUID;
    
    MFEU_DRIVER_INTERFACE m_euDDI;
    MFEU_POS_ACTION m_euAction;
}


+ (instancetype)shareInstance
{
    static MF_POSManager *_instance = nil;
    static dispatch_once_t once_t;
    
    if(!_instance) {
        dispatch_once(&once_t, ^{
            _instance = [[MF_POSManager alloc] init];
        });
    }
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if(self) {
//        // 初始化MPosController对象
//        self.posCtrl = [MPosController sharedInstance];
//        self.posCtrl.delegate = self;
//        
//        m_arrayName = [[NSMutableArray alloc] init];
//        m_arrayUUID = [[NSMutableArray alloc] init];
//        m_euAction = ACTION_UNKNOWN;
//        m_euDDI = MF_DDI_AUDIO;
//
//        
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(handleNotification:)
//                                                     name:SVProgressHUDWillAppearNotification
//                                                   object:nil];
//        
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(handleNotification:)
//                                                     name:SVProgressHUDDidAppearNotification
//                                                   object:nil];
//        
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(handleNotification:)
//                                                     name:SVProgressHUDWillDisappearNotification
//                                                   object:nil];
//        
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(handleNotification:)
//                                                     name:SVProgressHUDDidDisappearNotification
//                                                   object:nil];
        
    }
    return self;
}

//- (void)handleNotification:(NSNotification *)notif
//{
//    NSLog(@"Notification recieved: %@", notif.name);
//    NSLog(@"Status user info key: %@", [notif.userInfo objectForKey:SVProgressHUDStatusUserInfoKey]);
//}

//-(void)scanBtDevice
//{
//    m_euDDI = MF_DDI_BLE;
//    
//    [m_arrayName removeAllObjects];
//    [m_arrayUUID removeAllObjects];
//    [SVProgressHUD showWithStatus:@"正在扫描设备"];
//    [self.posCtrl scanBtDevice: 5];
//}

//#pragma mark MPosDelegate
//
//- (void)didFoundBtDevice:(NSString *)btDevice
//{
//    NSRange rrr = [btDevice rangeOfString: @","];
//    if (rrr.length > 0) {
//        NSString *name = [btDevice substringToIndex: rrr.location];
//        NSString *uuid = [btDevice substringFromIndex: rrr.location + 1];
//        
//        NSLog(@"%@:%@", name, uuid);
//        
//        [m_arrayName addObject: name];
//        [m_arrayUUID addObject: uuid];
//    }
//}
//
//-(void) didStopScanBtDevice
//{
//    [SVProgressHUD dismiss];
//    [self performSelectorOnMainThread:@selector(showTableAlert) withObject:nil waitUntilDone:NO];
//}
//
//- (void)didConnectedBtDevice:(NSString *)btDevice
//{
//    [SVProgressHUD dismiss];
//    [self traceMsg: [NSString stringWithFormat: @"didConnectedBtDevice = %@", btDevice]];
//    [self showStatusBarSuccessStr: @"设备已连接"];
//}
//
////检测到音频插入
//- (void)didDevicePlugged
//{
//    [self showStatusBarSuccessStr: @"设备已连接"];
////    [self openAudioDevice];
//}
//
//// 检测到音频拔出
//- (void)didDeviceUnplugged
//{
//    [self showStatusBarSuccessStr: @"设备未连接"];
//}
//
//- (void)didInterrupted
//{
//    [self showStatusBarSuccessStr: @"操作中断"];
//}
//
//-(void) didSessionResponse: (MFEU_POS_SESSION) sessionType returnCode: (MFEU_POS_RESULT) responceCode
//{
//    [self traceMsg: [NSString stringWithFormat: @"sessionType: %d, responseCode: %d", sessionType, responceCode]];
//}
//
//-(void)showTableAlert
//{
//    // create the alert
//    self.alert = [MLTableAlert tableAlertWithTitle:@"请选择设备" cancelButtonTitle:@"取消"
//                                      numberOfRows:^NSInteger (NSInteger section) {
//                                          return [m_arrayName count];
//                                      }
//                                          andCells:^UITableViewCell* (MLTableAlert *anAlert, NSIndexPath *indexPath) {
//                                              static NSString *CellIdentifier = @"CellIdentifier";
//                                              UITableViewCell *cell = [anAlert.table dequeueReusableCellWithIdentifier:CellIdentifier];
//                                              if (cell == nil)
//                                                  cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//                                              
//                                              cell.textLabel.text = [NSString stringWithFormat:@"%@", [m_arrayName objectAtIndex: indexPath.row]];
//                                              
//                                              return cell;
//                                          }];
//    
//    // Setting custom alert height
//    self.alert.height = 300;
//    
//    // configure actions to perform
//    [self.alert configureSelectionBlock:^(NSIndexPath *selectedIndex){
//        [self.posCtrl connectBtDevice: [m_arrayUUID objectAtIndex: selectedIndex.row] ];
//        [SVProgressHUD showWithStatus: @"正在连接设备"];
//    } andCompletionBlock:^{
//        //self.navigationItem.title = @"Cancel Button Pressed\nNo Cells Selected";
//    }];
//    
//    // show the alert
//    [self.alert show];
//    
//}

//-(void)openAudioDevice
//{
//    m_euDDI = MF_DDI_AUDIO;
////    [self.posCtrl resetPos];
//    [self.posCtrl open];
//}
//
//-(void)connectPos {
//    
//    if (m_euDDI == MF_DDI_BLE) {
//        [self scanBtDevice];
//    } else if (m_euDDI == MF_DDI_AUDIO) {
//        [self openAudioDevice];
//    }
//    
//}

//// 获取设备版本信息
//-(void) didReadPosInfoResp:(NSString *)ksn status: (MFEU_MSR_DEVSTAT)status battery: (MFEU_MSR_BATTERY)battery app_ver: (NSString *)app_ver data_ver: (NSString *)data_ver custom_info: (NSString *)custom_info
//{
////    [self.posCtrl loadWorkKey: @"83E42EB7629FD6009A09D49F5FF7F38103654A69"
////                       macKey: @"83E42EB7629FD6009A09D49F5FF7F38103654A69"
////                     trackKey: @"83E42EB7629FD6009A09D49F5FF7F38103654A69"
////                     keyIndex: MF_KEY_IND_0
////                    keyLength: MF_LEN_DOUBLE];
//    
//    ksn = [NSString stringWithFormat:@"%@",ksn];
//    NSLog(@"ksn:%@",ksn);
//    
//    [self didGetKsnCompleted:ksn];
//    
//}
//
//-(void)actionSale
//{
////    if ([self.deleagte respondsToSelector:@selector(waitingForCardSwipe:)]) {
////        [self.deleagte waitingForCardSwipe:SUCCESS];
////    }
//    
//    m_euAction = ACTION_SALE;
//    self.cardType = USE_UNKNOWN;
//    
//}
//
//- (void)didGetKsnCompleted:(NSString *)ksn{
//    NSLog(@"ksn:%@",ksn);
//    if (ksn.length > 0) {
//        AbstractItems *item = [[AbstractItems alloc] init];
//        item.n1 = [[NSUserDefaults standardUserDefaults] objectForKey:Account];
//        item.n3 = @"190958";
//        //        item.n59 = @"CHDS-1.0.0";
//        item.n62 = [ksn uppercaseString];
//        
//        NSString *macStr = [NSString stringWithFormat:@"%@%@%@%@%@%@",item.n0,item.n1,item.n3,item.n59,item.n62,MainKey];
//        item.n64 = [[macStr md5HexDigest] uppercaseString];
//        [[NetAPIManger sharedManger] request_BindingPosWithParams:[item keyValues] andBlock:^(id data, NSError *error) {
//            AbstractItems *item = (AbstractItems *)data;
//            if(!error && ([item.n39 isEqualToString:@"00"] || [item.n39 isEqualToString:@"94"]) && item.n41.length > 0 && item.n62.length > 0 && item.n62.length > 0){
//                [[NSUserDefaults standardUserDefaults] setValue:item.n41 forKey:TerminalNo];
//                if(item.n62.length > 0) {
//                    [[NSUserDefaults standardUserDefaults] setValue:item.n62 forKey:WokeKey];
//                    NSLog(@"WokeKey:%@",WokeKey);
//                    NSLog(@"VoucherNo:%@",item.n11);
//                    NSInteger voucherNo = [item.n11 integerValue];
//                    
//                    self.vouchNo = [NSString stringWithFormat:@"%06zd",++voucherNo];
//                    NSLog(@"voucherNo:%@",self.vouchNo);
//                }
//                [[NSUserDefaults standardUserDefaults] synchronize];
//                
//                [self actionSale];
//                
//            }else {
//                NSError *error = [NSError errorWithDomain:@"error" code:0 userInfo:@{@"NSLocalizedDescription":@"绑定终端失败"}];
//                [self showStatusBarError:error];
//            }
//        }];
//    }else {
//        NSError *error = [NSError errorWithDomain:@"error" code:0 userInfo:@{@"NSLocalizedDescription":@"读取终端号失败"}];
//        [self showStatusBarError:error];
//    }
//}

///// 下载工作密钥回调
//-(void) didLoadWorkKeyResp: (MFEU_MSR_RESP)resp
//{
//    [self alertMsg: [NSString stringWithFormat: @"didLoadWorkKeyResp = %x", resp]];
//}
//
//-(void) didStartEmvResp: (MFEU_MSR_EMV_RESP)resp pinReq: (MFEU_MSR_EMV_PIN)req
//{
//    if (m_euAction == ACTION_SALE) {
//        if ( resp == MF_RESP_EMV_SUCC
//            || resp == MF_RESP_EMV_ACCEPT
//            || resp == MF_RESP_EMV_ONLINE ) {
//            
//            self.emvPinReq = req;
//            [self.posCtrl getEmvDataEx: MF_FUNC_SALE];
//            
//        } else {
//            [self alertMsg: @"IC卡处理失败"];
//        }
//        return;
//    }
//    [self alertMsg: [NSString stringWithFormat: @"didStartEmvResp resp=%d, pinReq=%d", resp, req]];
//}
//
//-(void) didGetEmvDataExResp: (NSString *)data55 beforeLength: (NSInteger)len55 randomNumber: (NSString *)randNum serialNumber: (NSString *)serial maskedPAN: (NSString *)pan encTrack: (NSString *)track expiryDate: (NSString *)date
//{
//    [self traceMsg: [NSString stringWithFormat: @"didGetEmvDataExResp\n(%d)%@\n随机数: %@\n序列号: %@\n主账号: %@\n磁道数据: %@, 有效日期: %@"
//                     , (int)len55, data55, randNum, serial, pan, track, date] ];
//    
//    if (m_euAction == ACTION_SALE) {
//        if (self.emvPinReq == MF_PIN_EMV_REQ) {
//            
//            if (m_euDDI == MF_DDI_BLE) {
//                [self.posCtrl inputPin: 8 timeOut: 60 maskedPAN: pan];
//            } else {
//                //[self alertMsg: @"请输入密码，获取余额信息"];
////                [self.posCtrl pinEncrypt: @"123456" maskedPAN: pan];
//                //加一些联机操作  看输入密码后与后台交互会不会回调   如果回调  必须要将[self.posCtrl endEmv];写入回调方法中
//                [self.posCtrl endEmv];
//            }
//        } else {
//            // 联机操作后，最后要调用EndEmv();
//            [self.posCtrl endEmv];
//        }
//        return;
//    }
//    [self alertMsg: [NSString stringWithFormat: @"didGetEmvDataExResp\n(%d)%@\n随机数: %@\n序列号: %@\n主账号: %@\n磁道数据: %@, 有效日期: %@"
//                     , (int)len55, data55, randNum, serial, pan, track, date] ];
//}
//
//-(void) didIcDealOnlineResp: (MFEU_MSR_REAUTH_RESP) resp
//{
//    [self alertMsg: [NSString stringWithFormat: @"didIcDealOnlineResp = %x", resp]];
//}
//
//-(void) didEndEmvResp
//{
//    if (m_euAction == ACTION_SALE) {
//        [self alertMsg: @"IC卡消费完成"];
//        return;
//    }
//    [self alertMsg: @"完成EMV流程"];
//}
//
///// 密码输入回调
//-(void) didInputPinResp: (MFEU_MSR_KEYTYPE) type pwdLength: (NSInteger) len pwdText: (NSString *)text;
//{
//    if (m_euAction == ACTION_SALE) {
//        if (self.cardType == USE_MARCARD) {
//            // 磁条卡处理
//            /**
//             根据返回数据组8583包与POSP通讯, 此处省略...
//             */
//            [self alertMsg: @"IC卡片余额为：1000"];
//        } else if (self.cardType == USE_IC) {
//            // IC卡处理
//            /*
//             * 根据返回数据组8583包，此处省略，pData8583假定为数据包
//             */
//            
//            // 联机操作后，最后要调用EndEmv();
//            [self.posCtrl endEmv];
//        }
//        return;
//    }
//    
//    [self alertMsg: [NSString stringWithFormat: @"didInputPinResp type = %d\npwdLength = %d\n%@", (int)type, (int)len, text]];
//}

//-(void) setCurrentDatetime
//{
//    NSLog(@"set Current Datetime.");
//    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyyMMddHHmmss"];
//    NSString *currentTime = [formatter stringFromDate:[NSDate date]];
//    
//    [self.posCtrl setDatetime: currentTime factoryId: 0];
//}
//
//- (void)didConnected:(NSString *)devName
//{
//    [SVProgressHUD dismiss];
//    [self traceMsg: [NSString stringWithFormat: @"didConnectedBtDevice = %@", devName]];
//    [self showStatusBarSuccessStr: @"设备已连接"];
//    
//    [self.posCtrl setFactoryCode: 0];   // 默认为0,具体ID分配请与我们联系
//
//}
//
//-(void) didSetDatetimeResp
//{
//    // 获取设备信息
//    [self.posCtrl readPosInfo];
//}
//
//-(void)alertMsg: (NSString *)msg
//{
//    [SVProgressHUD dismiss];
//    
//    UIAlertView * alter = [[UIAlertView alloc] initWithTitle:@"提示" message: msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [alter show];
//}
//
//-(void) traceMsg: (NSString *) msg
//{
//    NSLog(@"%@", msg);
//}

+ (NSString *)getTadeTypeStr:(TRADE_YTPE)tadeType
{
    switch (tadeType) {
        case type_consument:
            return @"消费";
            break;
        case type_balance:
            return @"余额查询";
            break;
        case type_revoke:
            return @"撤销";
            break;
        case type_realTime:
            return @"实时";
            break;
        default:
            break;
    }
}


@end
