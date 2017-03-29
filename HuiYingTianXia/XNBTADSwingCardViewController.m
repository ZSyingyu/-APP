//
//  XNBTADSwingCardViewController.m
//  HuiYingTianXia
//
//  Created by liguo.chen on 15/11/18.
//  Copyright © 2015年 tsmc. All rights reserved.
//

#import "XNBTADSwingCardViewController.h"

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

#import "MLTableAlert/MLTableAlert.h"
#import "NSString+MD5HexDigest.h"
#import "NetAPIManger.h"
#import "NSObject+MJKeyValue.h"

@interface XNBTADSwingCardViewController ()<AC_POSMangerDelegate,BLEReaderDelegate,SwipeListener,UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong)TTTAttributedLabel *labTip;
@property (strong, nonatomic) MLTableAlert *alert;

@end

NSString * text;
int ctrlFlag;
//bool readOldFileForiTronDevice = TRUE;

@implementation XNBTADSwingCardViewController{
    BluetoothHandler *_handler;
    Settings *_setting;
    BOOL emvRuning;
    
    BOOL emvData;
    NSTimer *myTimer;
    BOOL showData;
    NSMutableString *_pin;
}


@synthesize getKsnBtn = _getKsnBtn;
@synthesize cardInfoView = _cardInfoView;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"检查刷卡器";
    [self setBackBarButtonItemWithTitle:@"返回"];
    
    //    [self performSelector:@selector(delegateAction) withObject:nil afterDelay:3.0f];
    
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
    
    //鑫诺最新刷卡头
    showData = NO;
    tip.hidden = YES;
    resShow.hidden = YES;
    resShow.editable = NO;
    //SDK初始化
    _handler = [[BluetoothHandler alloc]init];
    _handler.myDelegate = self;
//    _handler.mSwipeListener = self;
    [_handler setShowAPDU:YES];
    
    _setting = [[Settings alloc]init];
    [_setting setSwipeHandler:_handler];
    
    _myPeripherals = [NSMutableArray array];
    _pin = [[NSMutableString alloc]init];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [_handler scanPeripheral];
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_handler cancelConect];//APP退出断开连接
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



- (void)swipeICCardAction
{
    
    [m_vcom StopRec];
    
    //icBtn.userInteractionEnabled = NO;
    
    self.cardInfoView.text = @"ic卡刷";
    
    NSString *cash = self.tadeAmount;
    NSLog(@"amount:%@",self.tadeAmount);
    int cashLen = [cash length];
    char cData[100];
    cData[0] = 0;
    strcpy(cData,((char*)[cash UTF8String]));
    //    NSLog(@"cash:%s",[cash UTF8String]);
    
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
    enterPwdVC.rate = self.rate;
    enterPwdVC.tadeAmount = self.tadeAmount;
    enterPwdVC.cardInfo = cardInfo;
    //    NSInteger voucherNo = [self.voucherNo integerValue];
    
    
    //    self.voucherNo = [NSString stringWithFormat:@"%06zd",++voucherNo];
    
    //    enterPwdVC.voucherNo = [NSString stringWithFormat:@"%06zd",++voucherNo];
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

-(void)prompt{
    [MBProgressHUD showSuccess:@"请刷卡/插卡!" toView:self.view];
}

//鑫诺最新刷卡头

//更新界面
- (void)updateTableView {
    
    // create the alert
    self.alert = [MLTableAlert tableAlertWithTitle:@"请选择设备" cancelButtonTitle:@"取消"
                                      numberOfRows:^NSInteger (NSInteger section) {
                                          return [_myPeripherals count];
                                      }
                                          andCells:^UITableViewCell* (MLTableAlert *anAlert, NSIndexPath *indexPath) {
                                              static NSString *CellIdentifier = @"CellIdentifier";
                                              CBPeripheral *peripher;
                                              UITableViewCell *cell = [anAlert.table dequeueReusableCellWithIdentifier:CellIdentifier];
                                              //                                              UITableViewCell *cell = nil;
                                              if (cell == nil)
                                                  cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                                              
                                              peripher = [_myPeripherals objectAtIndex:indexPath.row];
                                              
                                              cell.textLabel.text = peripher.name;
                                              
                                              return cell;
                                          }];
    
    // Setting custom alert height
    self.alert.height = 300;
    
    // configure actions to perform
    [self.alert configureSelectionBlock:^(NSIndexPath *selectedIndex){
        CBPeripheral *peripher = [_myPeripherals objectAtIndex:selectedIndex.row];
        [_handler conectDiscoverPeripheral:peripher];
        
    } andCompletionBlock:^{
        //self.navigationItem.title = @"Cancel Button Pressed\nNo Cells Selected";
    }];
    
    [self.alert show];
    [NSThread detachNewThreadSelector:@selector(connectClick) toTarget:self withObject:nil];
    
}


- (void)discoverPeripheralSuccess:(CBPeripheral *)peripheral RSSI:(NSNumber *)rssi//找到了有serveUUID服务的设备,可以从这个设备中获取设备相应的信息NAME,RSSI.....
{
    NSLog(@"===========name is%@",peripheral.name);
    resShow.text = [NSString stringWithFormat:@"Name is %@",peripheral.name];
    [_myPeripherals addObject:peripheral];
    NSSet *set =  [NSSet setWithArray:_myPeripherals];
    _myPeripherals = [[NSMutableArray alloc] initWithArray:[set allObjects]];
    [_tableView reloadData];
    [self updateTableView];
}
- (void)discoverPeripheralFail//没有找到有serveUUID的设备
{
    resShow.text = @"discoverPeripheralFail";
}

- (void)conectPeripheralFail
{
    resShow.text = @"conectPeripheralFail";
}

- (void)connect:(id)sender{
    if(_myPeripherals != nil){
        _myPeripherals = nil;
        _myPeripherals = [NSMutableArray array];
        [_tableView reloadData];
    }
    _tableView.hidden = NO;
    tip.hidden = YES;
    resShow.hidden = YES;
    [_handler scanPeripheral];
    myTimer = [NSTimer scheduledTimerWithTimeInterval:8.0 target:self selector:@selector(checkTimerOut) userInfo:nil repeats:NO];
    
   
}

-(void)checkTimerOut{
    [_handler stopScan];
    if ([_myPeripherals count]==0) {
        UIAlertView *tips = [[UIAlertView alloc]initWithTitle:@"提示" message:@"周边没有搜索到蓝牙设备!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [tips show];
    }
}

- (void)conectPeripheralSuccess//连接设备成功
{
    resShow.text = [NSString stringWithFormat:@"%@ 连接成功!",_myPeripheral.name];
    [myTimer invalidate];
    tip.hidden = NO;
    resShow.hidden = NO;
    //    [self sn];
    [self.alert setHidden:YES];
    [NSThread detachNewThreadSelector:@selector(sn) toTarget:self withObject:nil];
}

- (void)sn{
    while (![_handler sendDataEnable]) {
        sleep(1);
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        NSString *res = [_setting getSN];
//        NSString *res = @"bb201500001353ffffffffffffce0000";
        dispatch_async(dispatch_get_main_queue(), ^{
            resShow.text = res;
            NSLog(@"ksn:%@",res);
            NSString *ksnStr = [res stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSLog(@"ksnStr:%@",ksnStr);
            [self didGetKsnCompleted:ksnStr];
        });
        
    });
    
    
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
//                dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                    [NSThread sleepForTimeInterval:1];
//                   dispatch_async(dispatch_get_main_queue(), ^{
                       _handler.mSwipeListener = self;
//                   });
//                });
                [self prompt];
                
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



-(void)checkCard{
    while (![_handler sendDataEnable]) {
        sleep(0.1);
    }
    NSString *str = [_setting writeDetectCard];
    if (str!=nil && [str hasPrefix:@"00"]) {
        [self updateText:@"IC卡数据读取中..."];
        [self startEMV2];
    }else if(str!=nil){
        NSLog(@"请刷卡或插IC卡....");
    }else if(str==nil){
        NSLog(@"通信失败....");
    }
}

- (void)ver:(id)sender{
    showData = YES;
    [_setting writeVersion];
}


- (void)cancel:(id)sender{
    [_handler cancelConect];
    _tableView.hidden = NO;
    tip.hidden = YES;
    resShow.hidden = YES;
}

- (void)tmk:(id)sender{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        // BOOL res = [_setting writeTMK:DEFAULT :@"aaaaaaaabbbbbbbbccccccccdddddddd"];
        BOOL res = [_setting writeTMK:DEFAULT :@"11111111111111111111111111111111"];
        dispatch_async(dispatch_get_main_queue(), ^{
            resShow.text = [NSString stringWithFormat: @"下载主密钥:%d[1.成功 0.失败]",res];
            NSLog(@"111111111   %d",res);
        });
    });
}

- (void)twk:(id)sender{
    // PIK:11111111222222223333333344444444
    // acb00adc4a8107a6bc27ed7ea73b84119a67ade1
    // MAC:11223344556677881122334455667788
    // aeaefdf35eee6427aeaefdf35eee64276fb23ead
    // TDK:1234567890abcdef1234567890abcdef
    // 3adf89c14448e7543adf89c14448e754a502016b
    //acb00adc4a8107a6bc27ed7ea73b84119a67ade1aeaefdf35eee6427aeaefdf35eee64276fb23ead3adf89c14448e7543adf89c14448e754a502016b
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        //BOOL res = [_setting writeSignIn:DEFAULT :@"859F8290881157E8CF068D3F12EFE0A500CFE5F7F12FAE5359D96779F12FAE5359D967791A11518E"];
        BOOL res = [_setting writeSignIn:@"950973182317F80B950973182317F80B00962B60F679786E2411E3DEF679786E2411E3DEADC67D840000000000000000000000000000000000000000"];
        dispatch_async(dispatch_get_main_queue(), ^{
            resShow.text = [NSString stringWithFormat: @"签到:%d[1.成功 0.失败]",res];
        });
        
    });
}
- (void)mac:(id)sender{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *res = [NSString stringWithFormat:@"MAC加密数据:%@",[_setting getMacBlock:DEFAULT :@"31323334353637383941"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            resShow.text = res;
        });
    });
}
- (void)pin:(id)sender{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *res = @"";
        //如果使用含有蓝牙密码键盘的机型,可调用该接口输入PIN
        res = [_setting blePinOpen:@"6222024000070150269"];
        if (res!=NULL && [res hasPrefix:@"6f 6b"]) {
            _pin  = [[NSMutableString alloc]init];
            res = @"请输入PIN...";
        }else{
            res = [NSString stringWithFormat:@"PIN加密数据:%@",[_setting getEncryptedPIN:DEFAULT :@"6222024000070150269" :@"123456"]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            resShow.text = res;
        });
    });
}

- (void)plain:(id)sender{
    showData = YES;
    [_setting writeMode:TYPE_PLAINTEX];
}

-(void)disconectPeripheral{
    NSLog(@"disconectPeripheral.....");
    resShow.text = [NSString stringWithFormat:@"%@ 已断开连接!",_myPeripheral.name];
}

-(void)onCardDetected:(SwipeEvent *)event{
    if([event getType]==EVENT_TYPE_IC_INSERTED){
        [self updateText:@"检测到IC卡,开始读IC卡,请勿拔卡..."];
        NSLog(@"检测到IC卡,开始读IC卡,请勿拔卡...");
        sleep(0.5);
        [NSThread detachNewThreadSelector:@selector(startEMV2) toTarget:self withObject:nil];
        
    }
    if([event getType]==EVENT_TYPE_IC_REMOVED){
        NSLog(@"检测到IC卡拔出...");
        [self updateText:@"检测到IC卡拔出..."];
    }
    if ([event getType]==EVENT_TYPE_MAG_SWIPED) {
        NSMutableString *sb = [[NSMutableString alloc]init];
        [sb appendFormat:@"PAN:%@",[_handler getMagPan]];
        [sb appendFormat:@"\n1磁道:%@",[_handler getTrack1Data]];
        [sb appendFormat:@"\n2磁道:%@",[_handler getTrack2Data]];
        [sb appendFormat:@"\n3磁道:%@",[_handler getTrack3Data]];
        [sb appendFormat:@"\n有效期:%@",[_handler getMagExpDate]];
        NSLog(@"------PAN--------%@",[_handler getMagPan]);//主账号
        NSLog(@"-----1磁道------%@",[_handler getTrack1Data]);//1磁道
        NSLog(@"-----2磁道------%@",[_handler getTrack2Data]);//2磁道
        NSLog(@"-----3磁道------%@",[_handler getTrack3Data]);//3磁道
        NSLog(@"---------磁卡有效期(明文返回)---------%@",[_handler getMagExpDate]);
        NSLog(@"----磁道随机数:%@",[_handler getTrackRandom]);
        [self updateText:sb];
        
        [self swingcardCallback:@{@"cardType":@"0",
                                  @"randomNumber":@"",
                                  @"expiryDate":[[_handler getMagExpDate] substringToIndex:4],
                                  @"cardNumber":[_handler getMagPan],
                                  @"track2":[_handler getTrack2Data],
                                  @"track3":[_handler getTrack3Data]
                                  }];
    }
    if([event getType]==EVENT_TYPE_MAG_ERR){
        [self updateText:@"磁卡操作失败,请重试!"];
    }
}

- (void)startEMV2
{
    NSString *atr = [_setting icReset];
    if(atr==nil || [atr hasPrefix:@"ff 3f"] || [atr hasPrefix:@"32 ff"]){
        [self updateText:@"IC操作失败!"];
        return;
    }
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
    [dateformatter setDateStyle:NSDateFormatterMediumStyle];
    [dateformatter setTimeStyle:NSDateFormatterShortStyle];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    NSLog(@"date = %@",[dateformatter stringFromDate:[NSDate date]]);
    //2.参数设置
    EMVConfigure *configure = [[EMVConfigure alloc]init];
    NSLog(@"amount:%@",self.tadeAmount);
    NSString *amount = [POSManger transformAmountFormatWithStr:self.tadeAmount];
//    [configure setAuthAmnt:1000];//金额,已分为单位
    [configure setAuthAmnt:[amount integerValue]];
    //3.EMV流程
    [_handler icReset];
    [_handler emvProcess:[configure getEmvConfig]];
    //4.IC下电
    [_handler icOff];
    NSLog(@"date = %@",[dateformatter stringFromDate:[NSDate date]]);
    
    //2.IC卡
    NSMutableString *result = [[NSMutableString alloc]init];
    NSLog(@"55域:%@", [_handler getIcField55]);//返回55域
    
    if ([[_handler getIcPan] length] != 0) {
        [result appendFormat:@"IC PAN:%@\n", [_handler getIcPan]];
        NSLog(@"IC PAN:%@", [_handler getIcPan]);//返回IC Pan
        [result appendFormat:@"2磁道:%@\n",[_handler getICTrack2Data]];
        NSLog(@"2磁道:%@",[_handler getICTrack2Data]);//返回IC 2磁道
        [result appendFormat:@"IC序列号:%@\n",[_handler getIcSeq]];
        NSLog(@"IC序列号:%@",[_handler getIcSeq]);//返回Ic 序列号
        [result appendFormat:@"IC应用失效日期:%@\n",[_handler getIcExpDate]];
        NSLog(@"IC应用生效日期:%@",[_handler getIcEffDate]);//生效日期
        NSLog(@"IC应用失效日期:%@",[_handler getIcExpDate]);//失效日期
        [result appendFormat:@"55域:%@",[_handler getIcField55]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self swingcardCallback:@{@"data55":[_handler getIcField55],
                                      @"randomNumber":@"",
                                      @"cardSerial":[[_handler getIcSeq] substringFromIndex:1],
                                      @"cardNumber":[_handler getIcPan],
                                      @"track2":[_handler getICTrack2Data],
                                      @"expiryDate":[[_handler getIcExpDate] substringToIndex:4],
                                      @"cardType":@"1"
                                      }];
        });
        
//        _handler.mSwipeListener = NULL;
        
    }else{
        [result appendFormat:@"IC卡卡操作异常"];
    }
    
    [self updateText:result];
    //[_handler getICEncryptedTrack2Data:DEFAULT];
    //sleep(1);
    //[_handler cancelConect];
}

/**
 * fire after parsed the read data.
 */
-(void)onParseData:(SwipeEvent*)event{
    //NSLog(@"onParseData -> %@",[event getValue]);
    if ([[event getValue] hasSuffix:@"3f 4d 41 47 54"]) {//DUKPT加密
        showData = YES;
    }
    if (showData) {
        NSMutableString *ss = [[NSMutableString alloc]init];
        [ss appendString:@"final(16)=> "];
        [ss appendString:[event getValue]];
        [ss appendString:@"\n"];
        [ss appendString:@"final(10)=> "];
        [ss appendString:[StringUtils hex_to_str:[event getValue]]];
        resShow.text = ss;
    }
    showData = NO;
}

-(void)onReaderHere:(BOOL)isHere{
    
}

-(void)onPinPad:(SwipeEvent *)event{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([event getType]==EVENT_TYPE_PAD_KEY) {
            [_pin appendString:@"*"];
            [resShow setText:_pin];
        }else if([event getType]==EVENT_TYPE_PAD_ENTER){
            [resShow setText:[event getValue]];
            if ([_pin length]>0) {
                _pin  = [[NSMutableString alloc]init];
            }
        }else if([event getType]==EVENT_TYPE_PAD_CANCEL){
            [resShow setText:@"取消输入..."];
            if ([_pin length]>0) {
                _pin  = [[NSMutableString alloc]init];
            }
        }
    });
}


-(void)updateText:(NSString*)title {
    dispatch_async(dispatch_get_main_queue(), ^{
        [resShow setText:title];
    });
}

//连接
- (void)connectClick{
    [_handler stopScan];
    while ([_handler sendDataEnable]) {
        sleep(0.1);
    }
    //    CBService * SER = _myPeripheral.services[0];
    //    NSLog(@"%@",SER.UUID);
    [_handler conectDiscoverPeripheral:_myPeripheral];
}

-(BOOL)hasConnected{
    if (_handler!=nil && _handler.isConnected) {
        return YES;
    }
    return NO;
}

-(EMVApp *)loadVisaAIDs1{
    EMVApp* app;
    // Visa Credit/Debit
    app = [[EMVApp alloc] init];
    [app setAppName:@""];
    [app setAID:@"A0000000031010"];
    [app setSelFlag:PART_MATCH];
    [app setPriority:0x00];
    [app setTargetPer:0x00];
    [app setMaxTargetPer:0x00];
    [app setFloorLimitCheck:0x01];
    //    [app setRandTransSel:0x01];
    //    [app setVelocityCheck:0x01];
    [app setFloorLimit:2000];
    [app setThreshold:0x00];
    [app setTACDenial:@"0000000000"];
    [app setTACOnline:@"0000001000"];
    [app setTACDefault:@"0000000000"];
    [app setAcquierId:@"000000123456"];
    [app setDDOL:@"039F3704"];
    [app setTDOL:@"0F9F02065F2A029A039C0195059F3704"];
    [app setVersion:@"0096"];
    return app;
}

-(EMVApp *)loadVisaAIDs2{
    EMVApp* app;
    // Visa Electron
    app = [[EMVApp alloc] init];
    [app setAppName:@""];
    [app setAID:@"A0000000032010"];
    [app setSelFlag:PART_MATCH];
    [app setPriority:0x00];
    [app setTargetPer:0x00];
    [app setMaxTargetPer:0x00];
    [app setFloorLimitCheck:0x01];
    //    [app setRandTransSel:0x01];
    //    [app setVelocityCheck:0x01];
    [app setFloorLimit:2000];
    [app setThreshold:0x00];
    [app setTACDenial:@"0000000000"];
    [app setTACOnline:@"0000001000"];
    [app setTACDefault:@"0000000000"];
    [app setAcquierId:@"000000123456"];
    [app setDDOL:@"039F3704"];
    [app setTDOL:@"0F9F02065F2A029A039C0195059F3704"];
    [app setVersion:@"0096"];
    return app;
}
-(EMVApp *)loadVisaAIDs3{
    EMVApp* app;
    // Visa Credit/Debit
    
    // V Pay
    app = [[EMVApp alloc] init];
    [app setAppName:@""];
    [app setAID:@"A0000000032020"];
    [app setSelFlag:PART_MATCH];
    [app setPriority:0x00];
    [app setTargetPer:0x00];
    [app setMaxTargetPer:0x00];
    [app setFloorLimitCheck:0x01];
    //    [app setRandTransSel:0x01];
    //    [app setVelocityCheck:0x01];
    [app setFloorLimit:2000];
    [app setThreshold:0x00];
    [app setTACDenial:@"0000000000"];
    [app setTACOnline:@"0000001000"];
    [app setTACDefault:@"0000000000"];
    [app setAcquierId:@"000000123456"];
    [app setDDOL:@"039F3704"];
    [app setTDOL:@"0F9F02065F2A029A039C0195059F3704"];
    [app setVersion:@"0096"];
    return app;
}
-(EMVApp *)loadVisaAIDs4{
    EMVApp* app;
    // Visa Credit/Debit
    // Plus
    app = [[EMVApp alloc] init];
    [app setAppName:@""];
    [app setAID:@"A0000000038010"];
    [app setSelFlag:PART_MATCH];
    [app setPriority:0x00];
    [app setTargetPer:0x00];
    [app setMaxTargetPer:0x00];
    [app setFloorLimitCheck:0x01];
    //    [app setRandTransSel:0x01];
    //    [app setVelocityCheck:0x01];
    [app setFloorLimit:2000];
    [app setThreshold:0x00];
    [app setTACDenial:@"0000000000"];
    [app setTACOnline:@"0000001000"];
    [app setTACDefault:@"0000000000"];
    [app setAcquierId:@"000000123456"];
    [app setDDOL:@"039F3704"];
    [app setTDOL:@"0F9F02065F2A029A039C0195059F3704"];
    [app setVersion:@"0096"];
    return app;
}

-(EMVApp *)loadMasterCardAIDs1 {
    EMVApp* app;
    // MasterCard Credit/Debit
    app = [[EMVApp alloc] init];
    [app setAppName:@""];
    [app setAID:@"A0000000041010"];
    [app setSelFlag:PART_MATCH];
    [app setPriority:0x00];
    [app setTargetPer:0x00];
    [app setMaxTargetPer:0x00];
    [app setFloorLimitCheck:0x01];
    //    [app setRandTransSel:0x01];
    //    [app setVelocityCheck:0x01];
    [app setFloorLimit:2000];
    [app setThreshold:0x00];
    [app setTACDenial:@"0000000000"];
    [app setTACOnline:@"0000001000"];
    [app setTACDefault:@"0000000000"];
    [app setAcquierId:@"000000123456"];
    [app setDDOL:@"039F3704"];
    [app setTDOL:@"0F9F02065F2A029A039C0195059F3704"];
    [app setVersion:@"0002"];
    return app;
}

-(EMVApp *)loadMasterCardAIDs5 {
    EMVApp* app;
    // MasterCard
    app = [[EMVApp alloc] init];
    [app setAppName:@""];
    [app setAID:@"A0000000049999"];
    [app setSelFlag:PART_MATCH];
    [app setPriority:0x00];
    [app setTargetPer:0x00];
    [app setMaxTargetPer:0x00];
    [app setFloorLimitCheck:0x01];
    //    [app setRandTransSel:0x01];
    //    [app setVelocityCheck:0x01];
    [app setFloorLimit:2000];
    [app setThreshold:0x00];
    [app setTACDenial:@"0000000000"];
    [app setTACOnline:@"0000001000"];
    [app setTACDefault:@"0000000000"];
    [app setAcquierId:@"000000123456"];
    [app setDDOL:@"039F3704"];
    [app setTDOL:@"0F9F02065F2A029A039C0195059F3704"];
    [app setVersion:@"0002"];
    return app;
}

-(EMVApp *)loadMasterCardAIDs2 {
    EMVApp* app;
    // MasterCard Credit/Debit
    // Maestro
    app = [[EMVApp alloc] init];
    [app setAppName:@""];
    [app setAID:@"A0000000043060"];
    [app setSelFlag:PART_MATCH];
    [app setPriority:0x00];
    [app setTargetPer:0x00];
    [app setMaxTargetPer:0x00];
    [app setFloorLimitCheck:0x01];
    //    [app setRandTransSel:0x01];
    //    [app setVelocityCheck:0x01];
    [app setFloorLimit:2000];
    [app setThreshold:0x00];
    [app setTACDenial:@"0000000000"];
    [app setTACOnline:@"0000001000"];
    [app setTACDefault:@"0000000000"];
    [app setAcquierId:@"000000123456"];
    [app setDDOL:@"039F3704"];
    [app setTDOL:@"0F9F02065F2A029A039C0195059F3704"];
    [app setVersion:@"0002"];
    return app;
}

-(EMVApp *)loadMasterCardAIDs3 {
    EMVApp* app;
    // MasterCard Credit/Debit
    // Cirrus
    app = [[EMVApp alloc] init];
    [app setAppName:@""];
    [app setAID:@"A0000000046000"];
    [app setSelFlag:PART_MATCH];
    [app setPriority:0x00];
    [app setTargetPer:0x00];
    [app setMaxTargetPer:0x00];
    [app setFloorLimitCheck:0x01];
    //    [app setRandTransSel:0x01];
    //    [app setVelocityCheck:0x01];
    [app setFloorLimit:2000];
    [app setThreshold:0x00];
    [app setTACDenial:@"0000000000"];
    [app setTACOnline:@"0000001000"];
    [app setTACDefault:@"0000000000"];
    [app setAcquierId:@"000000123456"];
    [app setDDOL:@"039F3704"];
    [app setTDOL:@"0F9F02065F2A029A039C0195059F3704"];
    [app setVersion:@"0002"];
    return app;
}

-(EMVApp *)loadMasterCardAIDs4 {
    EMVApp* app;
    // MasterCard Credit/Debit
    // Maestro UK
    app = [[EMVApp alloc] init];
    [app setAppName:@""];
    [app setAID:@"A0000000050001"];
    [app setSelFlag:PART_MATCH];
    [app setPriority:0x00];
    [app setTargetPer:0x00];
    [app setMaxTargetPer:0x00];
    [app setFloorLimitCheck:0x01];
    //    [app setRandTransSel:0x01];
    //    [app setVelocityCheck:0x01];
    [app setFloorLimit:2000];
    [app setThreshold:0x00];
    [app setTACDenial:@"0000000000"];
    [app setTACOnline:@"0000001000"];
    [app setTACDefault:@"0000000000"];
    [app setAcquierId:@"000000123456"];
    [app setDDOL:@"039F3704"];
    [app setTDOL:@"0F9F02065F2A029A039C0195059F3704"];
    [app setVersion:@"0002"];
    return app;
}

-(EMVApp *)loadAmericanExpressAIDs {
    EMVApp* app = [[EMVApp alloc] init];
    [app setAppName:@""];
    [app setAID:@"A00000002501"];
    [app setSelFlag:PART_MATCH];
    [app setPriority:0x00];
    [app setTargetPer:0x00];
    [app setMaxTargetPer:0x00];
    [app setFloorLimitCheck:0x01];
    //    [app setRandTransSel:0x01];
    //    [app setVelocityCheck:0x01];
    [app setFloorLimit:2000];
    [app setThreshold:0x00];
    [app setTACDenial:@"0000000000"];
    [app setTACOnline:@"0000001000"];
    [app setTACDefault:@"0000000000"];
    [app setAcquierId:@"000000123456"];
    [app setDDOL:@"039F3704"];
    [app setTDOL:@"0F9F02065F2A029A039C0195059F3704"];
    [app setVersion:@"0002"];
    return app;
}

-(EMVApp *)loadATMCardAIDs1 {
    EMVApp* app = [[EMVApp alloc] init];
    [app setAppName:@""];
    [app setAID:@"A0000000291010"];
    [app setSelFlag:PART_MATCH];
    [app setPriority:0x00];
    [app setTargetPer:0x00];
    [app setMaxTargetPer:0x00];
    [app setFloorLimitCheck:0x01];
    //    [app setRandTransSel:0x01];
    //    [app setVelocityCheck:0x01];
    [app setFloorLimit:2000];
    [app setThreshold:0x00];
    [app setTACDenial:@"0000000000"];
    [app setTACOnline:@"0000001000"];
    [app setTACDefault:@"0000000000"];
    [app setAcquierId:@"000000123456"];
    [app setDDOL:@"039F3704"];
    [app setTDOL:@"0F9F02065F2A029A039C0195059F3704"];
    [app setVersion:@"0001"];
    return app;
}

-(EMVApp *)loadATMCardAIDs2 {
    EMVApp* app = [[EMVApp alloc] init];
    app = [[EMVApp alloc] init];
    [app setAppName:@""];
    [app setAID:@"A0000004391010"];
    [app setSelFlag:PART_MATCH];
    [app setPriority:0x00];
    [app setTargetPer:0x00];
    [app setMaxTargetPer:0x00];
    [app setFloorLimitCheck:0x01];
    //    [app setRandTransSel:0x01];
    //    [app setVelocityCheck:0x01];
    [app setFloorLimit:2000];
    [app setThreshold:0x00];
    [app setTACDenial:@"0000000000"];
    [app setTACOnline:@"0000001000"];
    [app setTACDefault:@"0000000000"];
    [app setAcquierId:@"000000123456"];
    [app setDDOL:@"039F3704"];
    [app setTDOL:@"0F9F02065F2A029A039C0195059F3704"];
    [app setVersion:@"0001"];
    return app;
}

-(EMVApp *)loadCBAIDs{
    EMVApp* app;
    // CB Credit/Debit
    app = [[EMVApp alloc] init];
    [app setAppName:@""];
    [app setAID:@"A0000000421010"];
    [app setSelFlag:PART_MATCH];
    [app setPriority:0x00];
    [app setTargetPer:0x00];
    [app setMaxTargetPer:0x00];
    [app setFloorLimitCheck:0x01];
    //    [app setRandTransSel:0x01];
    //    [app setVelocityCheck:0x01];
    [app setFloorLimit:2000];
    [app setThreshold:0x00];
    [app setTACDenial:@"0000000000"];
    [app setTACOnline:@"0000001000"];
    [app setTACDefault:@"0000000000"];
    [app setAcquierId:@"000000123456"];
    [app setDDOL:@"039F3704"];
    [app setTDOL:@"0F9F02065F2A029A039C0195059F3704"];
    [app setVersion:@"0001"];
    return app;
}
-(EMVApp *)loadCBAIDs2{
    EMVApp* app;
    // CB Debit
    app = [[EMVApp alloc] init];
    [app setAppName:@""];
    [app setAID:@"A0000000422010"];
    [app setSelFlag:PART_MATCH];
    [app setPriority:0x00];
    [app setTargetPer:0x00];
    [app setMaxTargetPer:0x00];
    [app setFloorLimitCheck:0x01];
    //    [app setRandTransSel:0x01];
    //    [app setVelocityCheck:0x01];
    [app setFloorLimit:2000];
    [app setThreshold:0x00];
    [app setTACDenial:@"0000000000"];
    [app setTACOnline:@"0000001000"];
    [app setTACDefault:@"0000000000"];
    [app setAcquierId:@"000000123456"];
    [app setDDOL:@"039F3704"];
    [app setTDOL:@"0F9F02065F2A029A039C0195059F3704"];
    [app setVersion:@"0001"];
    return app;
}

-(EMVApp *)loadInteracAIDs {
    EMVApp* app = [[EMVApp alloc] init];
    [app setAppName:@""];
    [app setAID:@"A0000002771010"];
    [app setSelFlag:PART_MATCH];
    [app setPriority:0x00];
    [app setTargetPer:0x00];
    [app setMaxTargetPer:0x00];
    [app setFloorLimitCheck:0x01];
    //    [app setRandTransSel:0x01];
    //    [app setVelocityCheck:0x01];
    [app setFloorLimit:2000];
    [app setThreshold:0x00];
    [app setTACDenial:@"0000000000"];
    [app setTACOnline:@"0000001000"];
    [app setTACDefault:@"0000000000"];
    [app setAcquierId:@"000000123456"];
    [app setDDOL:@"039F3704"];
    [app setTDOL:@"0F9F02065F2A029A039C0195059F3704"];
    [app setVersion:@"0001"];
    return app;
}

-(EMVApp *)loadDiscoverAIDs {
    EMVApp* app = [[EMVApp alloc] init];
    [app setAppName:@""];
    [app setAID:@"A0000001523010"];
    [app setSelFlag:PART_MATCH];
    [app setPriority:0x00];
    [app setTargetPer:0x00];
    [app setMaxTargetPer:0x00];
    [app setFloorLimitCheck:0x01];
    //    [app setRandTransSel:0x01];
    //    [app setVelocityCheck:0x01];
    [app setFloorLimit:2000];
    [app setThreshold:0x00];
    [app setTACDenial:@"0000000000"];
    [app setTACOnline:@"0000001000"];
    [app setTACDefault:@"0000000000"];
    [app setAcquierId:@"000000123456"];
    [app setDDOL:@"039F3704"];
    [app setTDOL:@"0F9F02065F2A029A039C0195059F3704"];
    [app setVersion:@"0001"];
    return app;
}

-(EMVApp *)loadJCBAIDs {
    EMVApp* app = [[EMVApp alloc] init];
    [app setAppName:@""];
    [app setAID:@"A0000000651010"];
    [app setSelFlag:PART_MATCH];
    [app setPriority:0x00];
    [app setTargetPer:0x00];
    [app setMaxTargetPer:0x00];
    [app setFloorLimitCheck:0x01];
    //    [app setRandTransSel:0x01];
    //    [app setVelocityCheck:0x01];
    [app setFloorLimit:2000];
    [app setThreshold:0x00];
    [app setTACDenial:@"0000000000"];
    [app setTACOnline:@"0000001000"];
    [app setTACDefault:@"0000000000"];
    [app setAcquierId:@"000000123456"];
    [app setDDOL:@"039F3704"];
    [app setTDOL:@"0F9F02065F2A029A039C0195059F3704"];
    [app setVersion:@"0001"];
    return app;
}

@end
