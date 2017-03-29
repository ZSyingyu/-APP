//
//  XNBTSwingCardViewController.m
//  HuiYingTianXia
//
//  Created by 朱颖宇 on 15/8/19.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import "XNBTSwingCardViewController.h"
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


@interface XNBTSwingCardViewController ()<AC_POSMangerDelegate>

{
    NSMutableArray *XNdevices;
    MPosInterface *manager;

}

@property(nonatomic, strong)TTTAttributedLabel *labTip;
@property (strong, nonatomic) MLTableAlert *alert;
@property(strong,nonatomic)MPosInterface *manager;
@property(strong,nonatomic)NSMutableArray *XNdevices;

@property(nonatomic, strong)NSDictionary *cardInfo;


@end


NSString * text;
int ctrlFlag;
//bool readOldFileForiTronDevice = TRUE;

void AlertMsg (NSString *msg)
{
    UIAlertView * alter = [[UIAlertView alloc] initWithTitle:@"提示" message: msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alter show];
}


@implementation XNBTSwingCardViewController

@synthesize getKsnBtn = _getKsnBtn;
@synthesize cardInfoView = _cardInfoView;


- (void)viewDidLoad
{
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
    
    manager = [MPosInterface getInstance];
    self.manager = manager;
    XNdevices = [[NSMutableArray alloc]init];
    self.XNdevices = XNdevices;
    
    if (manager.connectState < 0) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            [NSThread sleepForTimeInterval:1];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [XNdevices removeAllObjects];
                
                [manager PosLib_Scan_EX:5 searchOneXNDevicesBlock:^(XNP_DEVICESINFO * Onedevice){
                    [XNdevices addObject:Onedevice];
                    [self performSelectorOnMainThread:@selector(updateTableView) withObject:self waitUntilDone:NO];
                } searchTimeOutBlock:^(){
                    NSLog(@"搜索完成");
                }];
            });
        });
    }else if (manager.connectState == 0) {
        [self readPOSInfo];
    }
    
    
    
}

//更新界面
- (void)updateTableView {
    
    // create the alert
    self.alert = [MLTableAlert tableAlertWithTitle:@"请选择设备" cancelButtonTitle:@"取消"
                                      numberOfRows:^NSInteger (NSInteger section) {
                                          return [XNdevices count];
                                      }
                                          andCells:^UITableViewCell* (MLTableAlert *anAlert, NSIndexPath *indexPath) {
                                              static NSString *CellIdentifier = @"CellIdentifier";
                                              XNP_DEVICESINFO *deviceInfo;
                                              UITableViewCell *cell = [anAlert.table dequeueReusableCellWithIdentifier:CellIdentifier];
//                                              UITableViewCell *cell = nil;
                                              if (cell == nil)
                                                  cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                                              
                                             deviceInfo = [XNdevices objectAtIndex:indexPath.row];
                                              
                                              cell.textLabel.text = deviceInfo.deviceName;
                                              
                                              return cell;
                                          }];
    
    // Setting custom alert height
    self.alert.height = 300;
    
    // configure actions to perform
    [self.alert configureSelectionBlock:^(NSIndexPath *selectedIndex){
        XNP_DEVICESINFO *deviceInfo = [XNdevices objectAtIndex:selectedIndex.row];
        [manager connectXnPos:deviceInfo.deviceUUID connectSuccessBlock:^(){
            NSLog(@"设备已连接");
            NSLog(@"currentThread: %d",[NSThread currentThread].isMainThread);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
            });
            
            [self readPOSInfo];
            
        } connectFailedBlock:^(EU_POS_RESULT errorCode, NSString *ErrorInfo) {
            NSLog(@"errorCode = %d ErrorInfo = %@",errorCode,ErrorInfo);
        }];
    } andCompletionBlock:^{
        //self.navigationItem.title = @"Cancel Button Pressed\nNo Cells Selected";
    }];
    
    [self.alert show];

}

-(void)readPOSInfo {

    [manager getDeviceInfo:^(XNP_READDEVICERESPINFO *deviceInfoString){
        NSString *mag = [NSString stringWithFormat:@"设备序列号:%@\n设备的版本信息:%@\n厂商信息%@",deviceInfoString.XNDeviceSNString,deviceInfoString.VersionInfoString,deviceInfoString.XNDefineInfoString];
        NSLog(@"mag:%@",mag);
        //        AlertMsg(mag);
        
        NSString *ksn = [NSString stringWithFormat:@"%@",deviceInfoString.XNDeviceSNString];
        NSLog(@"sn:%@",ksn);
        
        [self didGetKsn:ksn];
        
    } failedBlock:^(EU_POS_RESULT errorCode,NSString *ErrorInfo){
        AlertMsg(ErrorInfo);
    }];
    
}

-(void)didGetKsn:(NSString *)ksn {

    NSLog(@"ksn:%@",ksn);
    
    if (ksn.length > 0) {
        AbstractItems *item = [[AbstractItems alloc] init];
        item.n1 = [[NSUserDefaults standardUserDefaults] objectForKey:Account];
        item.n3 = @"190958";
        //        item.n59 = @"CHDS-1.0.0";
        item.n62 = [ksn uppercaseString];

        NSString *macStr = [NSString stringWithFormat:@"%@%@%@%@%@%@",item.n0,item.n1,item.n3,item.n59,item.n62,MainKey];
        
        NSLog(@"str:%@",macStr);
        
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
                
                NSRange range1 = NSMakeRange(0, 32);
                NSRange range2 = NSMakeRange(32, 8);
                NSRange range3 = NSMakeRange(40, 32);
                NSRange range4 = NSMakeRange(72, 8);
//                NSRange range5 = NSMakeRange(80, 32);
//                NSRange range6 = NSMakeRange(112, 8);
                
                NSLog(@"%lu",(unsigned long)range1.length);
                
                NSString *str1 = [[[NSUserDefaults standardUserDefaults] objectForKey:WokeKey] substringWithRange:range1];
                NSLog(@"str1:%@",str1);
                NSString *str2 = [[[NSUserDefaults standardUserDefaults] objectForKey:WokeKey] substringWithRange:range2];
                NSLog(@"str2:%@",str2);
                NSString *str3 = [[[NSUserDefaults standardUserDefaults] objectForKey:WokeKey]  substringWithRange:range3];
                NSLog(@"str3:%@",str3);
                NSString *str4 = [[[NSUserDefaults standardUserDefaults] objectForKey:WokeKey]  substringWithRange:range4];
                NSLog(@"str4:%@",str4);
//                NSString *str5 = [[[NSUserDefaults standardUserDefaults] objectForKey:WokeKey]  substringWithRange:range5];
//                NSLog(@"str5:%@",str5);
//                NSString *str6 = [[[NSUserDefaults standardUserDefaults] objectForKey:WokeKey]  substringWithRange:range6];
//                NSLog(@"str6:%@",str6);
                NSString *str5 = @"00000000000000000000000000000000";
                NSString *str6 = @"00000000";
                
                
                //主密钥下载
                
//                XNP_MKEYINFO *mkeyinfo = [[XNP_MKEYINFO alloc]init];
//                mkeyinfo.mkeyString = @"94A33C50392D45E394A33C50392D45E3";
//                mkeyinfo.mkeyCheckValueString = @"00962B60";
//                mkeyinfo.bEncryType = ENCRYPT_KEK;
//                mkeyinfo.iMKeyIndex = KEY_IND_0;
//                [manager LoadMainKey:mkeyinfo loadSuccessBlock:^(){
////                    AlertMsg(@"下载成功");
//                    
//                    
//                } loadFailedBlock:^(EU_POS_RESULT errorCode,NSString *ErrorInfo){
////                    AlertMsg(ErrorInfo);
//                }];
                
                //工作密钥下载
                XNP_WKEYINFO *wkeyinfo =[[XNP_WKEYINFO alloc]init];
                wkeyinfo.iWKeyIndex = KEY_IND_0;
                wkeyinfo.pinKeyString = str1;
                wkeyinfo.pinKeyCheckValueString = str2;
                wkeyinfo.macKeyString = str3;
                wkeyinfo.macKeyCheckValueString = str4;
                wkeyinfo.magKeyString = str5;
                wkeyinfo.magKeyCheckValueString = str6;
                [manager LoadWorkKey:wkeyinfo loadSuccessBlock:^(){
//                    AlertMsg(@"下载成功");
                    NSLog(@"下载成功");
                    
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        [NSThread sleepForTimeInterval:1];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self consum];
                        });
                    });
                    
                    
                } loadFailedBlock:^(EU_POS_RESULT errorCode,NSString *ErrorInfo){
                    AlertMsg(ErrorInfo);
                }];
                
                
                
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

-(void) consum
{
    //消费 输入金额 ---------流程说明如下
    //读卡
    //1.打开读卡器
    //2磁条卡
    //2.1 读取磁条卡信息
    //2.2 输入密码
    //上送8583
    //3IC卡
    //3.1 执行emv流程
    //3.2 获取55域数据
    //3.3 获取IC卡卡号 服务代码 有效期 2磁道
    //3.4 输入密码
    //3.5 上送8583
    
    
    XNP_OPENCARDINFO *cardinfo = [[XNP_OPENCARDINFO alloc]init];
    cardinfo.ReadCardType = COMBINED;
    cardinfo.iReadCardTimeOut = 60;
    cardinfo.ConsumTypeString = [POSManger getTadeTypeStr:self.tadeType];
    NSString *amount = [POSManger transformAmountFormatWithStr:self.tadeAmount];
    cardinfo.ConsumMoneyString = amount;
    NSLog(@"amount:%@",cardinfo.ConsumMoneyString);
    [manager openCardReader:cardinfo icsucessBlock:^(){//IC卡
        //3.1 执行emv流程--------------------------------
        XNP_RUNEMVSTATEINFO *emvinfo = [[XNP_RUNEMVSTATEINFO alloc]init];
        emvinfo.TransactionAmountString = cardinfo.ConsumMoneyString;
        emvinfo.TransactionType = FUNC_SALE;
        emvinfo.ECCashSupport = ECASH_FORBIT;
        emvinfo.PbocCourse = PBOC_PART;
        emvinfo.bOnLineReq = ONLINE_YES;
        [manager startEmv:emvinfo successBlock:^(){
            //3.2 获取55域数据---------------------------
            [manager getIcTransactionData:@"" successBlock:^(NSString *tag55String){
                //3.3 获取IC卡卡号 服务代码 有效期 2磁道-------
             
                    NSLog(@"data55:%@",tag55String);
//                    AlertMsg(mag);
                
                
                [manager getIcTransBasicData:^(XNP_READICCARDRESPINFO *cardinfo){
                    //3.4 输入密码--------------------------
                    XNP_PININPUTINFO *pininfo = [[XNP_PININPUTINFO alloc]init];
                    pininfo.iMaxKeyLength = 0x0C;
                    pininfo.iPinInputTimeOut = 60;
                    pininfo.CardNumberString = cardinfo.PanString;//卡号
                    
                    self.cardInfo = @{@"data55":[tag55String uppercaseString],
                                      @"cardNumber":cardinfo.PanString,
                                      @"track2":cardinfo.Track2String,
                                      @"expiryDate":[cardinfo.periodString substringToIndex:4] ,
                                      @"cardType":@"1",
                                      @"cardSerial":cardinfo.bServiceCode
                                      };
                    
                    [manager inputPin:pininfo inputpinsuccessBlock:^(NSString *pinBlock){
                        
                        [self requestTrade:pinBlock];
                        
                        [manager endEmv:^(){
//                            AlertMsg(@"结束EMV流程成功");
                            [manager resetPos:^(){}];
                        } failedBlock:^(EU_POS_RESULT errorCode,NSString *ErrorInfo){
                            AlertMsg(ErrorInfo);
                        }];
                        
                        
//                        AlertMsg(@"IC卡交易\r\n上送8583包\r\n...\r\n...\r\n...\r\n消费成功");
                    } failedBlock:^(EU_POS_RESULT errorCode,NSString *ErrorInfo){
                        AlertMsg(ErrorInfo);
                    }];
                } failedBlock:^(EU_POS_RESULT errorCode,NSString *ErrorInfo){
                    AlertMsg(ErrorInfo);
                }];
            } failedBlock:^(EU_POS_RESULT errorCode,NSString *ErrorInfo){
                AlertMsg(ErrorInfo);
            }];
        } failedBlock:^(EU_POS_RESULT errorCode,NSString *ErrorInfo){
            AlertMsg(ErrorInfo);
        }];
    } magsuccessBlock:^(){//磁条卡
        XNP_READMAGCARDINFO *readmode = [[XNP_READMAGCARDINFO alloc]init];
        readmode.ReadCardMode = READ_TRACK_COMBINED;
        readmode.ReadCardMask = READ_NOMASK;
        //读取磁条卡数据--------------------------------2.1 读取磁条卡信息
        [manager readMagCardInfo:readmode readsucessBlock:^(XNP_READMAGCARDRESPINFO *cardinfo){
            XNP_PININPUTINFO *pininfo = [[XNP_PININPUTINFO alloc]init];
            pininfo.iMaxKeyLength = 0x0C;
            pininfo.iPinInputTimeOut = 60;
            pininfo.CardNumberString = cardinfo.PanString;//卡号
            
            XNP_READMAGCARDINFO *readmode = [[XNP_READMAGCARDINFO alloc]init];
            readmode.ReadCardMode = READ_TRACK_COMBINED;
            readmode.ReadCardMask = READ_NOMASK;
            [manager readMagCardInfo:readmode readsucessBlock:^(XNP_READMAGCARDRESPINFO *cardinfo){
                NSString *mag = [NSString stringWithFormat:@"主账号:%@\n服务代码:%@\n有效期%@\n2磁道数据:%@\n3磁道数据:%@",cardinfo.PanString,cardinfo.bServiceCode,cardinfo.periodString,cardinfo.Track2String,cardinfo.Track3String];
                NSLog(@"mag:%@",mag);
                
                self.cardInfo = @{@"cardType":@"0",
                                  @"cardSerial":cardinfo.bServiceCode,
                                  @"expiryDate":cardinfo.periodString,
                                  @"cardNumber":cardinfo.PanString,
                                  @"track2":cardinfo.Track2String,
                                  @"track3":cardinfo.Track3String
                                  };
                
                
                //2.2 输入密码
                    
                XNP_PININPUTINFO *pininfo = [[XNP_PININPUTINFO alloc]init];
                pininfo.iMaxKeyLength = 0x0C;
                pininfo.iPinInputTimeOut = 60;
                pininfo.CardNumberString = cardinfo.PanString;
                [manager inputPin:pininfo inputpinsuccessBlock:^(NSString *pinBlock){
                    NSString *mag = [NSString stringWithFormat:@"pinblock:%@",pinBlock];
//                        AlertMsg(mag);
                    [self requestTrade:pinBlock];
             
                } failedBlock:^(EU_POS_RESULT errorCode,NSString *ErrorInfo){
                    AlertMsg(ErrorInfo);
                }];
                
                
//                AlertMsg(mag);
            }failedBlock:^(EU_POS_RESULT errorCode,NSString *ErrorInfo){
                AlertMsg(ErrorInfo);
            }];
            
        }failedBlock:^(EU_POS_RESULT errorCode,NSString *ErrorInfo){
            AlertMsg(ErrorInfo);
        }];
    } failedBlock:^(EU_POS_RESULT errorCode,NSString *ErrorInfo){
        AlertMsg(ErrorInfo);
    }];
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


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}

- (void)backAction:(id)sender
{
    if(self.tadeType == type_balance){
        [self.navigationController.navigationBar setHidden:YES];
    }
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
