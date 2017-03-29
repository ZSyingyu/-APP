//
//  BBBTSwingCardViewController.m
//  HuiYingTianXia
//
//  Created by 朱颖宇 on 15/8/31.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import "BBBTSwingCardViewController.h"
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

#import "WisePadController.h"
#import <QuartzCore/QuartzCore.h>
#import <sys/utsname.h>

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

#define kNumberOfBtnView 10
#define kScanBTv4Timeout 120
#define kConnectBTv4Timeout 120

static NSString *kLastConnectedBTv4DeviceUUID = @"kLastConnectedBTv4DeviceUUID";
static NSString *kLastConnectedBTv4DeviceName = @"kLastConnectedBTv4DeviceName";

//----- 加密方案 61 -----
static NSString *FID61_orderID = @"30303030303030303030303030303030"; //Hardcode for testing
static NSString *FID61_randomNumber = @"000782";
static NSString *FID46_randomNumber = @"0001020304050607";

//----- 加密方案 65 -----
//FID 65 的 encPinKey, encDataKey, encMacKey, KCV 都是由後台加密再下发至APP
//KCV: 密钥校验值，用 明文工作密钥 加密(3DES ECB) 0000000000000000

//如果只得一条key就把 encPinKey, encDataKey, encMacKey都设定一样

//下例的encKey只是BBPOS内部测试用途，客户收到样品机后必须更改才能正常使用
static NSString *FID65_encPinKey = @"12042B145F8516D74F0B96AAA5A8B548C257CC0FD286CDC4";
static NSString *FID65_encDataKey = @"12042B145F8516D74F0B96AAA5A8B548C257CC0FD286CDC4";
static NSString *FID65_encMacKey = @"12042B145F8516D74F0B96AAA5A8B548C257CC0FD286CDC4";

//----- Printer command (M361) -----
static NSString *printCmd_INIT = @"1B40";
static NSString *printCmd_POWER_ON = @"1B3D01";
static NSString *printCmd_POWER_OFF = @"1B3D02";
static NSString *printCmd_NEW_LINE = @"0A";
static NSString *printCmd_ALIGN_LEFT = @"1B6100";
static NSString *printCmd_ALIGN_CENTER = @"1B6101";
//static NSString *printCmd_ALIGN_RIGHT = @"1B6102";
static NSString *printCmd_EMPHASIZE_ON = @"1B4501";
static NSString *printCmd_EMPHASIZE_OFF = @"1B4500";
//static NSString *printCmd_FONT_5X8 = @"1B4D00";
static NSString *printCmd_FONT_5X12 = @"1B4D01";
static NSString *printCmd_FONT_8X12 = @"1B4D02";
static NSString *printCmd_FONT_10X18 = @"1B4D03";
static NSString *printCmd_FONT_SIZE_0 = @"1D2100";
static NSString *printCmd_FONT_SIZE_1 = @"1D2111";
static NSString *printCmd_CHAR_SPACING_0 = @"1B2000";


@interface BBBTSwingCardViewController ()<AC_POSMangerDelegate>
@property(nonatomic, strong)TTTAttributedLabel *labTip;
@property (strong, nonatomic) MLTableAlert *alert;
@property(strong,nonatomic)NSDictionary *cardInfo;

@end

NSString * text;
int ctrlFlag;
//bool readOldFileForiTronDevice = TRUE;
@implementation BBBTSwingCardViewController


@synthesize getKsnBtn = _getKsnBtn;
@synthesize cardInfoView = _cardInfoView;

#pragma mark - @synthesize
@synthesize WisePadControllerDelegate;
@synthesize scrollView;
@synthesize pageControl;
@synthesize lblCallbackData;
@synthesize viewBtnPage0;
@synthesize viewBtnPage1;
@synthesize viewBtnPage2;
@synthesize viewBtnPage3;
@synthesize viewBtnPage4;
@synthesize viewBtnPage5;
@synthesize viewBtnPage9;
@synthesize viewBtnPage11;
@synthesize viewBtnPage12;
@synthesize viewTerminalSetting;
@synthesize lblWisePadControllerState;
@synthesize lblError;
@synthesize viewTrackDataPanel;
@synthesize viewTLVData;
@synthesize txtTLVData;
@synthesize pickerSelectValue;
@synthesize lblGeneralData;
@synthesize lblApiVersionNumber;
@synthesize viewGeneralData;
@synthesize txtGeneralData;
@synthesize viewGeneralDataPanel;
@synthesize viewAmount;
@synthesize viewStatePanel;
@synthesize pickerDataSourceArray;
@synthesize pickerDataSourceArray_Currency;
@synthesize pickerType;
@synthesize alertType;
@synthesize genericAlert;
@synthesize currConnectingBTv4DeviceName;
@synthesize productModel;
@synthesize BluetoothDeviceDict;
@synthesize apduKsn;

//NSString *machineName(){
//    struct utsname systemInfo;
//    uname(&systemInfo);
//    return [NSString stringWithCString:systemInfo.machine  encoding:NSUTF8StringEncoding];
//}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self disconnectPOS];
}

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
    
//    [self updateStatusBar];
    
    [[WisePadController sharedController] setDelegate:self];
    
    if ([[WisePadController sharedController] isDevicePresent] == YES){
        lblGeneralData.text = NSLocalizedString(@"DevicePlugged", @"");
    } else {
        lblGeneralData.text = NSLocalizedString(@"DeviceUnplugged", @"");
    }
    
    _lblSelectFormatID.text = NSLocalizedString(@"SelectFormatID", @"");
    
    [self clearAllLabelAndTextbox];
    
    if ([self getNSUserDefaultsObject:kLastConnectedBTv4DeviceUUID] != nil &&
        [(NSString *)[self getNSUserDefaultsObject:kLastConnectedBTv4DeviceUUID] length] > 0){
        _lbLastConnectedBTv4DeviceName.text = (NSString *)[self getNSUserDefaultsObject:kLastConnectedBTv4DeviceName];
        _lbLastConnectedBTv4DeviceUUID.text = (NSString *)[self getNSUserDefaultsObject:kLastConnectedBTv4DeviceUUID];
    }else{
        _lbLastConnectedBTv4DeviceName.text = @"Not connect before";
    }
    self.currConnectingBTv4DeviceName = @"";
    self.productModel = @"";
    self.apduKsn = @"";
    self.BluetoothDeviceDict = [NSMutableDictionary dictionary];
    
    if ([[[WisePadController sharedController] getIntegratedApiVersion] count] > 1){
        NSLog(@"[[WisePadController sharedController] getIntegratedApiVersion]: %@", [[WisePadController sharedController] getIntegratedApiVersion]);
        NSLog(@"[[WisePadController sharedController] getIntegratedApiBuildNumber]: %@", [[WisePadController sharedController] getIntegratedApiBuildNumber]);
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:1];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self scanBTv4Device];
        });
    });
    
    self.pickerDataSourceArray_Currency = [self getCurrencyCharacterStrings];
    
    [self updateDefaultCurrencyCode];
    
}

- (void)updateDefaultCurrencyCode{
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    //NSLog(@"Current language: %@", language);
    BOOL isChineseLanguage = NO;
    if ([language length] >= 2){
        if ([[[language substringWithRange:NSMakeRange(0, 2)] lowercaseString] isEqualToString:@"zh"]){
            isChineseLanguage = YES;
        }
    }
    
    if (isChineseLanguage){
        [_txtCurrencyCode setText:@"156"]; //CNY
        [_pickerCurrencyCharacter selectRow:38 inComponent:0 animated:NO]; // Yuan
        [_pickerCurrencyCharacter selectRow:([[self getCurrencyCharacterStrings] count]-1) inComponent:1 animated:NO];
        [_pickerCurrencyCharacter selectRow:([[self getCurrencyCharacterStrings] count]-1) inComponent:2 animated:NO];
        [_pickerCurrencyCharacter reloadAllComponents];
    }else{
        [_txtCurrencyCode setText:@"840"]; //USD
        [_pickerCurrencyCharacter selectRow:28 inComponent:0 animated:NO]; // $
        [_pickerCurrencyCharacter selectRow:([[self getCurrencyCharacterStrings] count]-1) inComponent:1 animated:NO];
        [_pickerCurrencyCharacter selectRow:([[self getCurrencyCharacterStrings] count]-1) inComponent:2 animated:NO];
        [_pickerCurrencyCharacter reloadAllComponents];
    }
}

- (void)updateStatusBar{
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        // normal
    } else {
        for (UIView *v in self.view.subviews) {
            CGRect oldFrame = v.frame;
            v.frame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y + 20.0f, oldFrame.size.width, oldFrame.size.height);
        }
//        UIView *statusBarBgView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)] autorelease];
        UIView *statusBarBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
        
        [statusBarBgView setBackgroundColor:[UIColor blackColor]];
        [self.view addSubview:statusBarBgView];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
}

- (void)localizeButtonText:(int)tagID localizedText:(NSString *)localizedText{
    UIButton *tempButton = (UIButton *)[self.view viewWithTag:tagID];
    if (tempButton == nil){
        tempButton = (UIButton *)[viewBtnPage1 viewWithTag:tagID];
    }
    
    if (tempButton != nil){
        [tempButton setTitle:NSLocalizedString(localizedText, @"") forState: UIControlStateNormal];
        [tempButton setTitle:NSLocalizedString(localizedText, @"") forState: UIControlStateApplication];
        [tempButton setTitle:NSLocalizedString(localizedText, @"") forState: UIControlStateHighlighted];
        [tempButton setTitle:NSLocalizedString(localizedText, @"") forState: UIControlStateReserved];
        [tempButton setTitle:NSLocalizedString(localizedText, @"") forState: UIControlStateSelected];
        [tempButton setTitle:NSLocalizedString(localizedText, @"") forState: UIControlStateDisabled];
    }
}

#pragma mark - WisePad Detection
- (void)onWisePadNoAudioDeviceDetected {
    NSLog(@"onWisePadNoAudioDeviceDetected");
    [self resetUI];
    lblGeneralData.text = NSLocalizedString(@"NoDeviceDetected", @"");
}

#pragma mark - WisePad Transaction Flow

#pragma mark -- Transaction Flow -- Get Device Info

- (IBAction)btnAction_GetDeviceInfo:(id)sender{
    NSLog(@"btnAction_GetDeviceInfo");
    lblError.text = @"";
    lblGeneralData.text = @"Getting device info ...";
    [[WisePadController sharedController] getDeviceInfo];
}

- (void)onWisePadReturnDeviceInfo:(NSDictionary *)deviceInfoDict{
    NSLog(@"onWisePadReturnDeviceInfo - deviceInfoDict: %@", deviceInfoDict);
    
    lblGeneralData.text = @"onReturnDeviceInfo";
    
    NSString *tempDisplayString = @"";
    NSArray *keys = [[deviceInfoDict allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    for (NSString *loopKey in keys) {
        if ([loopKey isEqualToString:@"isUsbConnected"] ||
            [loopKey isEqualToString:@"isCharging"] ||
            [loopKey isEqualToString:@"isSupportedNfc"] ||
            [loopKey isEqualToString:@"isSupportedTrack1"] ||
            [loopKey isEqualToString:@"isSupportedTrack2"] ||
            [loopKey isEqualToString:@"isSupportedTrack3"]){
            tempDisplayString = [NSString stringWithFormat:@"%@\n%@: %d", tempDisplayString, loopKey, [[deviceInfoDict objectForKey:loopKey] boolValue]];
        }else if ([loopKey isEqualToString:@"batteryLevel"]){
            tempDisplayString = [NSString stringWithFormat:@"%@\n%@: %@ V", tempDisplayString, loopKey, [deviceInfoDict objectForKey:loopKey]];
        }else{
            tempDisplayString = [NSString stringWithFormat:@"%@\n%@: %@", tempDisplayString, loopKey, [deviceInfoDict objectForKey:loopKey]];
        }
    }
    [_txtDisplayData setText:tempDisplayString];
    
    [self showDisplayDataView];
    
    NSString *ksn = [deviceInfoDict objectForKey:@"emvKsn"];
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
                
                
                NSRange range1 = NSMakeRange(0, 40);
                NSRange range2 = NSMakeRange(40, 40);
                NSRange range3 = NSMakeRange(80, 40);
                
                NSString *str1 = [[[NSUserDefaults standardUserDefaults] objectForKey:WokeKey] substringWithRange:range1];
                NSLog(@"str1:%@",str1);
                FID65_encPinKey = str1;
                
                NSString *str2 = [[[NSUserDefaults standardUserDefaults] objectForKey:WokeKey] substringWithRange:range2];
                NSLog(@"str2:%@",str2);
                FID65_encDataKey = str2;
                
                NSString *str3 = [[[NSUserDefaults standardUserDefaults] objectForKey:WokeKey]  substringWithRange:range3];
                NSLog(@"str3:%@",str3);
                FID65_encMacKey = str3;
                
                [self checkCardWithData];
                
                
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

#pragma mark -- Transaction Flow -- Terminal Time
- (void)onWisePadRequestTerminalTime{
    NSLog(@"onWisePadRequestTerminalTime");
    
    NSString *terminalTime = @""; //e.g. 130108152010 (YYMMddHHmmss)
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYMMddHHmmss"];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    terminalTime = [formatter stringFromDate:[NSDate date]];
//    [formatter release];
    
    NSLog(@"[[WisePadController sharedController] sendTerminalTime:%@];", terminalTime);
    [[WisePadController sharedController] sendTerminalTime:terminalTime];
}

#pragma mark -- Transaction Flow -- Set Amount or Cashback

- (IBAction)btnAction_SetAmount:(id)sender{
    NSLog(@"btnAction_SetAmount");
    self.alertType = @"SetAmount";
    [self popUpAlertView_SetAmount:nil];
}

- (IBAction)btnAction_EnableSetAmount:(id)sender{
    NSLog(@"btnAction_EnableSetAmount");
    
    //    //Require Firmware 3.34.xxxxxx or above to support amountInputType
    //    WisePadAmountInputType amountInputType = WisePadAmountInputType_AmountOnly;
    //    switch ([_segmentedControlAmountInputType selectedSegmentIndex]) {
    //        case 0:{ amountInputType = WisePadAmountInputType_AmountOnly; break; }
    //        case 1:{ amountInputType = WisePadAmountInputType_AmountAndCashback; break; }
    //        case 2:{ amountInputType = WisePadAmountInputType_CashbackOnly; break; }
    //        default:{ break; }
    //    }
    //    [[WisePadController sharedController] enableInputAmount:[NSDictionary dictionaryWithObjectsAndKeys:
    //                                                             [self getCurrencyCodeForSetAmount], @"currencyCode",
    //                                                             [self getCurrencyCharacterArray], @"currencyCharacters",
    //                                                             [NSNumber numberWithInt:(int)amountInputType], @"amountInputType",
    //                                                             nil]];
    
    [[WisePadController sharedController] enableInputAmount:@"156" currencyCharacters:[self getCurrencyCharacterArray]];
}

- (void)onWisePadRequestSetAmount{
    NSLog(@"onWisePadRequestSetAmount");
    lblGeneralData.text = NSLocalizedString(@"onRequestSetAmount", @"");
    
    [self hideStartButton];
    
//    if (isAutoSetAmount){
        // Goods    - 商品
        // Services - 服务
        // Cashback - 返现
        // Inquiry  - 查询
        // Transfer - 转账
        // Payment  - 付款
        // Refund   - 退款
        
        [[WisePadController sharedController] setAmount:self.tadeAmount
                                         cashbackAmount:@""
                                           currencyCode:@"156"
                                        transactionType:WisePadTransactionType_Goods
                                     currencyCharacters: [NSArray arrayWithObjects:
                                                          [NSNumber numberWithInt:(int)CurrencyCharacter_Yuan], nil]];
//    }
//    else{
//        self.alertType = @"SetAmount";
//        [self popUpAlertView_SetAmount:nil];
//    }
}

- (NSString *)getCurrencyCodeForSetAmount{
    //CNY: 156
    //EUR: 978
    //USD: 840
    //0 decimal places: 392
    //3 decimal places: 400
    
    NSLog(@"currencyCode: %@", _txtCurrencyCode.text);
//    return _txtCurrencyCode.text;
    return @"156";
}

- (NSArray *)getCurrencyCharacterArray{
    //Maximum 3 characters
    
    //CurrencyCharacter 是显示屏上的金额符号，最多3个最少1个
    
    /*
     //Sample 1 - Display $:
     [NSArray arrayWithObjects:
     [NSNumber numberWithInt:(int)CurrencyCharacter_Dollar], nil];
     
     //Sample 2 - Display USD:
     [NSArray arrayWithObjects:
     [NSNumber numberWithInt:(int)CurrencyCharacter_U],
     [NSNumber numberWithInt:(int)CurrencyCharacter_S],
     [NSNumber numberWithInt:(int)CurrencyCharacter_D], nil];
     
     //Sample 3 - Display US$:
     [NSArray arrayWithObjects:
     [NSNumber numberWithInt:(int)CurrencyCharacter_U],
     [NSNumber numberWithInt:(int)CurrencyCharacter_S],
     [NSNumber numberWithInt:(int)CurrencyCharacter_Dollar], nil];
     */
    
    NSMutableArray *tempArray = [NSMutableArray array];
    if (![[self.pickerDataSourceArray_Currency objectAtIndex:[_pickerCurrencyCharacter selectedRowInComponent:0]] isEqualToString:@"NULL"]){
        [tempArray addObject:[NSNumber numberWithInt:(int)[_pickerCurrencyCharacter selectedRowInComponent:0]]];
    }
    if (![[self.pickerDataSourceArray_Currency objectAtIndex:[_pickerCurrencyCharacter selectedRowInComponent:1]] isEqualToString:@"NULL"]){
        [tempArray addObject:[NSNumber numberWithInt:(int)[_pickerCurrencyCharacter selectedRowInComponent:1]]];
    }
    if (![[self.pickerDataSourceArray_Currency objectAtIndex:[_pickerCurrencyCharacter selectedRowInComponent:2]] isEqualToString:@"NULL"]){
        [tempArray addObject:[NSNumber numberWithInt:(int)[_pickerCurrencyCharacter selectedRowInComponent:2]]];
    }
    return [NSArray arrayWithArray:tempArray];
}

- (void)onWisePadReturnAmountConfirmResult:(BOOL)isConfirmed{
    NSLog(@"onWisePadReturnAmountConfirmResult - isConfirmed: %d", isConfirmed);
    if (isConfirmed){
        lblGeneralData.text = [NSString stringWithFormat:@"onReturnAmountConfirmResult - isConfirmed: YES"];
    }else{
        lblGeneralData.text = [NSString stringWithFormat:@"onReturnAmountConfirmResult - isConfirmed: NO"];
    }
}

//- (void)onWisePadReturnAmount:(NSString *)amount currencyCode:(NSString *)currencyCode{
//    NSLog(@"onWisePadReturnAmount - amount: %@, currencyCode: %@", amount, currencyCode);
//    lblGeneralData.text = [NSString stringWithFormat:@"onWisePadReturnAmount\namount: %@, currencyCode: %@", amount, currencyCode];
//}

- (void)onWisePadReturnAmount:(NSDictionary *)data{
    NSLog(@"onWisePadReturnAmount - data: %@", data);
    NSString *currencyCode = [data objectForKey:@"currencyCode"];
    NSString *amount = [data objectForKey:@"amount"];
    NSString *cashback = [data objectForKey:@"cashback"];
    
    lblGeneralData.text = [NSString stringWithFormat:@"onWisePadReturnAmount\namount: %@, cashback: %@\ncurrencyCode: %@", amount, cashback, currencyCode];
}

- (void)onWisePadReturnEnableInputAmountResult:(BOOL)isSuccess{
    NSLog(@"onWisePadReturnEnableInputAmountResult - isSuccess: %d", isSuccess);
    lblGeneralData.text = [NSString stringWithFormat:@"onWisePadReturnEnableInputAmountResult - isSuccess: %d", isSuccess];
}

- (void)onWisePadReturnDisableInputAmountResult:(BOOL)isSuccess{
    NSLog(@"onWisePadReturnDisableInputAmountResult - isSuccess: %d", isSuccess);
    lblGeneralData.text = [NSString stringWithFormat:@"onWisePadReturnDisableInputAmountResult - isSuccess: %d", isSuccess];
    
}

#pragma mark -- Transaction Flow -- Check Card Status
- (IBAction)btnAction_StartTransaction:(id)sender {
    NSLog(@"btnAction_StartTransaction");
    
    if ([[WisePadController sharedController] isDevicePresent] == NO){
        [self btnAction_DetectDevice:nil];
        return;
    }
    
    isCheckCardOnly = NO;
    isBadSwiped = NO;
    lblError.text = @"";
    self.pickerType = @"";
    
    [self clearCardDataLabel];
    [self hideStartButton];
    //[self hideAmountView];
    [self hideTrackDataPanel];
    [self hideTlvPanel];
    
    lblGeneralData.text = NSLocalizedString(@"Processing", @"");
    
    [self checkCardWithData];
}

//Different firmware require different input for card data encryption
- (BOOL)isFormatID46{
    if ([_segmentedControlFormatID selectedSegmentIndex] == 1){
        return YES;
    }else{
        return NO;
    }
}
- (BOOL)isFormatID61{
    if ([_segmentedControlFormatID selectedSegmentIndex] == 2){
        return YES;
    }else{
        return NO;
    }
}
- (BOOL)isFormatID65{
    if ([_segmentedControlFormatID selectedSegmentIndex] == 3){
        return YES;
    }else{
        return NO;
    }
}

- (void)checkCardWithData{
    self.alertType = @"";
    NSMutableDictionary *inputDict = [NSMutableDictionary dictionary];
    [inputDict setObject:[NSNumber numberWithInt:[self getTimeoutValue_checkCardTimeout]] forKey:@"checkCardTimeout"];
    if ([self isFormatID46]){
        [inputDict setObject:FID46_randomNumber forKey:@"randomNumber"];
    }
    if ([self isFormatID61]){
        [inputDict setObject:FID61_orderID forKey:@"orderID"];
        [inputDict setObject:FID61_randomNumber forKey:@"randomNumber"];
    }
    if ([self isFormatID65]){
        [inputDict setObject:FID65_encPinKey forKey:@"encPinKey"];
        [inputDict setObject:FID65_encDataKey forKey:@"encDataKey"];
        [inputDict setObject:FID65_encMacKey forKey:@"encMacKey"];
        [inputDict setObject:@"123.45" forKey:@"amount"]; //For MAC calculation
    }
    
    WisePadCheckCardMode tempCheckCardMode = WisePadCheckCardMode_SwipeOrInsert;
//    switch ([_segmentedControlCheckCardMode selectedSegmentIndex]) {
    switch (tempCheckCardMode) {
        case 0:{ tempCheckCardMode = WisePadCheckCardMode_Swipe; break; }
        case 1:{ tempCheckCardMode = WisePadCheckCardMode_Insert; break; }
        case 2:{ tempCheckCardMode = WisePadCheckCardMode_Tap; break; }
        case 3:{ tempCheckCardMode = WisePadCheckCardMode_SwipeOrInsert; break;}
        default:{ break; }
    }
    [inputDict setObject:[NSNumber numberWithInt:tempCheckCardMode] forKey:@"checkCardMode"];
    NSLog(@"Selected checkCardMode: %@", [self getCheckCardModeString:tempCheckCardMode]);
    
    NSLog(@"[[WisePadController sharedController] checkCard: %@", inputDict);
    [[WisePadController sharedController] checkCard:[NSDictionary dictionaryWithDictionary:inputDict]];
}

- (IBAction)btnAction_StartEMV:(id)sender{
    NSLog(@"btnAction_StartEMV");
    
    [self clearCardDataLabel];
    [self hideStartButton];
    //[self hideAmountView];
    [self hideTrackDataPanel];
    [self hideTlvPanel];
    
    lblGeneralData.text = NSLocalizedString(@"Processing", @"");
    
    [self startEmvWithData];
    
    //[self.scrollView scrollRectToVisible:CGRectMake(320*1, 0, 320, 240) animated:YES];
}

- (void)startEmvWithData{
    self.alertType = @"";
    NSMutableDictionary *inputDict = [NSMutableDictionary dictionary];
    [inputDict setObject:[NSNumber numberWithInt:[self getTimeoutValue_checkCardTimeout]] forKey:@"checkCardTimeout"];
    [inputDict setObject:[NSNumber numberWithInt:[self getTimeoutValue_setAmountTimeout]] forKey:@"setAmountTimeout"];
    [inputDict setObject:[NSNumber numberWithInt:[self getTimeoutValue_selectApplicationTimeout]] forKey:@"selectApplicationTimeout"];
    [inputDict setObject:[NSNumber numberWithInt:[self getTimeoutValue_pinEntryTimeout]] forKey:@"pinEntryTimeout"];
    [inputDict setObject:[NSNumber numberWithInt:[self getTimeoutValue_onlineProcessTimeout]] forKey:@"onlineProcessTimeout"];
    [inputDict setObject:[NSNumber numberWithInt:[self getTimeoutValue_finalConfirmTimeout]] forKey:@"finalConfirmTimeout"];
    
    [inputDict setObject:[NSNumber numberWithInt:WisePadEmvOption_StartWithForceOnline] forKey:@"emvOption"];
    
    //Input for different MK/SK encryption (Format 46, 61)
    if ([self isFormatID46]){
        [inputDict setObject:FID46_randomNumber forKey:@"randomNumber"];
    }
    if ([self isFormatID61]){
        [inputDict setObject:FID61_orderID forKey:@"orderID"];
        [inputDict setObject:FID61_randomNumber forKey:@"randomNumber"];
    }
    if ([self isFormatID65]){
        [inputDict setObject:FID65_encPinKey forKey:@"encPinKey"];
        [inputDict setObject:FID65_encDataKey forKey:@"encDataKey"];
        [inputDict setObject:FID65_encMacKey forKey:@"encMacKey"];
    }
    
//    if (isStartEmvWithTerminalTime){
        //M360 and M368 product require terminalTime input
        NSString *terminalTime = @""; //e.g. 130108152010 (YYMMddHHmmss)
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYMMddHHmmss"];
        [formatter setTimeZone:[NSTimeZone localTimeZone]];
        terminalTime = [formatter stringFromDate:[NSDate date]];
//        [formatter release];
        [inputDict setObject:terminalTime forKey:@"terminalTime"];
//    }
    
    WisePadCheckCardMode tempCheckCardMode = WisePadCheckCardMode_SwipeOrInsert;
//    switch ([_segmentedControlCheckCardMode selectedSegmentIndex]) {
    switch (tempCheckCardMode) {
        case 0:{ tempCheckCardMode = WisePadCheckCardMode_Swipe; break; }
        case 1:{ tempCheckCardMode = WisePadCheckCardMode_Insert; break; }
        case 2:{ tempCheckCardMode = WisePadCheckCardMode_Tap; break; }
        case 3:{ tempCheckCardMode = WisePadCheckCardMode_SwipeOrInsert; break;}
        default:{ break; }
    }
    [inputDict setObject:[NSNumber numberWithInt:tempCheckCardMode] forKey:@"checkCardMode"];
    NSLog(@"Selected checkCardMode: %@", [self getCheckCardModeString:tempCheckCardMode]);
    
    if (isStartEmvWithDisabledDisplayText){
        [inputDict setObject:[NSNumber numberWithInt:NO] forKey:@"enableDisplayText"];
    }
    
    NSLog(@"[[WisePadController sharedController] startEmvWithData: %@", inputDict);
    [[WisePadController sharedController] startEmvWithData:[NSDictionary dictionaryWithDictionary:inputDict]];
    
    [self hideStartButton];
}

- (IBAction)btnAction_CheckCard:(id)sender{
    NSLog(@"btnAction_CheckCard");
    isCheckCardOnly = YES;
    isSwipeCardOnly = NO;
    lblGeneralData.text = @"Check Card ...";
    
    [self checkCardWithData];
}

- (IBAction)btnAction_SwipeCard:(id)sender{
    NSLog(@"btnAction_SwipeCard");
    isCheckCardOnly = YES;
    isSwipeCardOnly = YES;
    lblGeneralData.text = @"Swipe Card ...";
    //[[WisePadController sharedController] startSwipe];
    
    NSMutableDictionary *inputDict = [NSMutableDictionary dictionary];
    [inputDict setObject:[NSNumber numberWithInt:[self getTimeoutValue_checkCardTimeout]] forKey:@"checkCardTimeout"];
    [inputDict setObject:[NSNumber numberWithInt:WisePadCheckCardMode_Swipe] forKey:@"checkCardMode"];
    if ([self isFormatID46]){
        [inputDict setObject:FID46_randomNumber forKey:@"randomNumber"];
    }
    if ([self isFormatID61]){
        [inputDict setObject:FID61_orderID forKey:@"orderID"];
        [inputDict setObject:FID61_randomNumber forKey:@"randomNumber"];
    }
    if ([self isFormatID65]){
        [inputDict setObject:FID65_encPinKey forKey:@"encPinKey"];
        [inputDict setObject:FID65_encDataKey forKey:@"encDataKey"];
        [inputDict setObject:FID65_encMacKey forKey:@"encMacKey"];
    }
    NSLog(@"[[WisePadController sharedController] checkCard: %@", inputDict);
    [[WisePadController sharedController] checkCard:inputDict];
}

- (IBAction)btnAction_CancelCheckCard:(id)sender{
    NSLog(@"btnAction_CancelCheckCard");
    
    lblGeneralData.text = NSLocalizedString(@"CancelCheckCard", @"");
    [[WisePadController sharedController] cancelCheckCard];
    [self showStartButton];
}

- (void)onWisePadReturnCancelCheckCardResult:(BOOL)isSuccess{
    NSLog(@"onWisePadReturnCancelCheckCardResult - isSuccess: %d", isSuccess);
    lblGeneralData.text = [NSString stringWithFormat:@"onWisePadReturnCancelCheckCardResult - isSuccess: %d", isSuccess];
    [self showStartButton];
}

//- (void)onWisePadRequestInsertCard{ //Deprecated in 2.6.0-Beta16, please use onWisePadWaitingForCard:checkCardMode
//    NSLog(@"onWisePadRequestInsertCard");
//    lblGeneralData.text = @"onWisePadRequestInsertCard";
//}

//- (void)onWisePadWaitingForCard{ //Deprecated in 2.6.0-Beta16, please use onWisePadWaitingForCard:checkCardMode
//    NSLog(@"onWisePadWaitingForCard");
//    lblGeneralData.text = @"onWisePadWaitingForCard";
//}

- (void)onWisePadWaitingForCard:(WisePadCheckCardMode)checkCardMode{
    NSLog(@"onWaitingForCard - checkCardMode: %@", [self getCheckCardModeString:checkCardMode]);
    lblGeneralData.text = [NSString stringWithFormat:@"onWaitingForCard ...\n(%@)", [self getCheckCardModeString:checkCardMode]];
}

- (NSString *)getCheckCardModeString:(WisePadCheckCardMode)checkCardMode{
    NSString *returnString = @"";
    switch (checkCardMode) {
        case WisePadCheckCardMode_Swipe:{ returnString = @"CheckCardMode_Swipe"; break; }
        case WisePadCheckCardMode_Insert:{ returnString = @"CheckCardMode_Insert"; break; }
        case WisePadCheckCardMode_Tap:{ returnString = @"CheckCardMode_Tap"; break; }
        case WisePadCheckCardMode_SwipeOrInsert:{ returnString = @"CheckCardMode_SwipeOrInsert"; break; }
        default:{ returnString = @"Unknown CheckCardMode"; break; }
    }
    return returnString;
}

- (void)onWisePadReturnCheckCardResult:(WisePadCheckCardResult)result cardDataDict:(NSDictionary *)cardDataDict{
    
    switch (result) {
        case WisePadCheckCardResult_NoCard:{ NSLog(@"onWisePadReturnCheckCardResult - result: WisePadCheckCardResult_NoCard"); break;}
        case WisePadCheckCardResult_InsertedCard:{ NSLog(@"onWisePadReturnCheckCardResult - result: WisePadCheckCardResult_InsertedCard"); break;}
        case WisePadCheckCardResult_NotIccCard:{ NSLog(@"onWisePadReturnCheckCardResult - result: WisePadCheckCardResult_NotIccCard"); break;}
        case WisePadCheckCardResult_BadSwipe:{
            NSLog(@"onWisePadReturnCheckCardResult - result: WisePadCheckCardResult_BadSwipe");
            break;}
        case WisePadCheckCardResult_SwipedCard:{
            NSLog(@"onWisePadReturnCheckCardResult - result: WisePadCheckCardResult_SwipedCard");
            break;}
        case WisePadCheckCardResult_MagHeadFail:{ NSLog(@"onWisePadReturnCheckCardResult - result: WisePadCheckCardResult_MagHeadFail"); break;}
        case WisePadCheckCardResult_NoResponse:{ NSLog(@"onWisePadReturnCheckCardResult - result: WisePadCheckCardResult_NoResponse"); break;}
        case WisePadCheckCardResult_OnlyTrack2:{ NSLog(@"onWisePadReturnCheckCardResult - result: WisePadCheckCardResult_OnlyTrack2"); break;}
        default:{ NSLog(@"onWisePadReturnCheckCardResult - result: else"); break;}
    }
    NSLog(@"cardDataDict: %@", cardDataDict);

    switch (result) {
        case WisePadCheckCardResult_SwipedCard:
        case WisePadCheckCardResult_OnlyTrack2:{
            
            [self resetUI];
            checkCardCounter = 0;
            
            NSString *tempDisplayString = @"";
            NSArray *keys = [[cardDataDict allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
            for (NSString *loopKey in keys) {
                tempDisplayString = [NSString stringWithFormat:@"%@\n\n%@: %@", tempDisplayString, loopKey, [cardDataDict objectForKey:loopKey]];
            }
            [_txtDisplayData setText:tempDisplayString];
            _viewDisplayData.hidden = NO;
            
            lblGeneralData.text = NSLocalizedString(@"WisePadCheckCardResult_SwipedCard", @"");
            
            // 刷卡流程的密码处理：
            // 带键盘刷卡器  ：刷完卡在onReturnCheckCardResult检查serviceCode，如果serviceCode显示要PIN就调用startPinEntry，由刷卡器固件加密密码
            // 不带键盘刷卡器：刷完卡在onReturnCheckCardResult检查serviceCode，如果serviceCode显示要PIN就调用encryptPin，由刷卡器固件加密密码
            
            // 使用startPinEntry需要注意下例事项
            // 1. startPinEntry要用PAN来加密，没有磁道2就没有PAN，就用不了startPinEntry，会返回CommandNotAvailable的错误
            // 2. startPinEntry要在onReturnCheckResult後1秒內调用，不能单独调用startPinEntry
            
            // IC卡流程的密码处理：
            // 带键盘刷卡器  ：由固件加密密码，在Tag99返回加密的密码
            // 不带键盘刷卡器：在onRequestPinEntry用sendPinEntryResult传入密码由固件加密，在Tag99返回密码密文
            
            if ([[cardDataDict objectForKey:@"serviceCode"] length] == 3){
                int serviceCodeFirstDigit = (int)[[[cardDataDict objectForKey:@"serviceCode"] substringWithRange:NSMakeRange(0, 1)] integerValue];
                int serviceCodeThirdDigit = (int)[[[cardDataDict objectForKey:@"serviceCode"] substringWithRange:NSMakeRange(2, 1)] integerValue];
                NSLog(@"serviceCodeThirdDigit: %d", serviceCodeThirdDigit);
                
                switch (serviceCodeFirstDigit) {
                        /*
                         1: International interchange OK
                         2: International interchange, use IC (chip) where feasible
                         5: National interchange only except under bilateral agreement
                         6: National interchange only except under bilateral agreement, use IC (chip) where feasible
                         7: No interchange except under bilateral agreement (closed loop)
                         */
                    case 2:
                    case 6:{
                        lblGeneralData.text = @"Please use IC (chip)\nto do transcation for this card.";
                        return;
                        break;}
                    default:{
                        break;}
                }
                
                switch (serviceCodeThirdDigit) {
                        /*
                         0: No restrictions, PIN required
                         1: No restrictions
                         2: Goods and services only (no cash)
                         3: ATM only, PIN required
                         4: Cash only
                         5: Goods and services only (no cash), PIN required
                         6: No restrictions, use PIN where feasible
                         7: Goods and services only (no cash), use PIN where feasible
                         */
                    case 0:
                    case 3:
                    case 5:
                    case 6:
                    case 7:{
                        //NSLog(@"[[WisePadController sharedController] startPinEntry]");
                        break;
                    }
                    default:
                        break;
                }
                
//                if ([_switchCallStartPinEntryAfterSwipedCard isOn]){
                    lblGeneralData.text = @"startPinEntry ...";
                    
                    NSMutableDictionary *inputDict = [NSMutableDictionary dictionary];
                    [inputDict setObject:[NSNumber numberWithInt:20] forKey:@"pinEntryTimeout"];
                    
                    if ([self isFormatID46]){
                        [inputDict setObject:FID46_randomNumber forKey:@"randomNumber"];
                    }
                    if ([self isFormatID61]){
                        [inputDict setObject:FID61_orderID forKey:@"orderID"];
                        [inputDict setObject:FID61_randomNumber forKey:@"randomNumber"];
                    }
                    if ([self isFormatID65]){
                        [inputDict setObject:FID65_encPinKey forKey:@"encPinKey"];
                        [inputDict setObject:FID65_encDataKey forKey:@"encDataKey"];
                        [inputDict setObject:FID65_encMacKey forKey:@"encMacKey"];
                    }
                    
                    //M368
                    if ([[cardDataDict objectForKey:@"encTrack2"] length] > 0){
                        NSLog(@"[[WisePadController sharedController] startPinEntry:%@", inputDict);
                        [[WisePadController sharedController] startPinEntry:inputDict];
                    }
                    
                    //M188
                    //[self encryptPin:[cardDataDict objectForKey:@"123456"] pan:[cardDataDict objectForKey:@"PAN"]];
                }
//            }
            
            self.cardInfo = @{@"cardType":@"0",
                              @"randomNumber":[cardDataDict objectForKey:@"randomNumber"],
                              @"expiryDate":[cardDataDict objectForKey:@"expiryDate"],
                              @"cardNumber":[cardDataDict objectForKey:@"PAN"],
                              @"track2":[cardDataDict objectForKey:@"encTrack2"],
                              @"track3":[cardDataDict objectForKey:@"encTrack3"]
                              };
            
            break;}
        case WisePadCheckCardResult_NoCard:{
            lblGeneralData.text = NSLocalizedString(@"WisePadCheckCardResult_NoCard", @"");
            [self showStartButton];
            break;}
        case WisePadCheckCardResult_BadSwipe:{
            lblGeneralData.text = @"WisePadCheckCardResult_BadSwipe";
            [self showStartButton];
            //            lblGeneralData.text = NSLocalizedString(@"WisePadCheckCardResult_BadSwipe", @"");
            //            if (isSwipeCardOnly){
            //                [self checkCardWithData];
            //            }else{
            //                [self performSelector:@selector(checkCardAgainAfterBadSwipe) withObject:nil afterDelay:0.0];
            //            }
            break;}
        case WisePadCheckCardResult_NotIccCard:{
            lblGeneralData.text = NSLocalizedString(@"WisePadCheckCardResult_NotIccCard", @"");
            [self showStartButton];
            
            //Fallback-to-swipe
            //NSString *fallbackMessage = NSLocalizedString(@"WisePadCheckCardResult_FallbackToSwipe", @"");
            //lblGeneralData.text = fallbackMessage;
            
            //NSLog(@"[[WisePadController sharedController] startSwipe];");
            //[[WisePadController sharedController] startSwipe];
            
            //Or call checkCard to try ICC again
            
            break;}
        case WisePadCheckCardResult_InsertedCard:{
            checkCardCounter = 0;
            [self hidePickerView];
            if (isCheckCardOnly){
                lblGeneralData.text = @"WisePadCheckCardResult_InsertedCard";
            }else{
                lblGeneralData.text = NSLocalizedString(@"Processing", @"");
                [self startEmvWithData];
            }
            break;}
        case WisePadCheckCardResult_NoResponse:{
            lblGeneralData.text = NSLocalizedString(@"WisePadCheckCardResult_HardwareError", @"");
            [self showStartButton];
            break;}
        case WisePadCheckCardResult_MagHeadFail:{
            lblGeneralData.text = NSLocalizedString(@"WisePadCheckCardResult_HardwareError", @"");
            [self showStartButton];
            break;}
        default:{
            lblGeneralData.text = NSLocalizedString(@"WisePadCheckCardResult_HardwareError", @"");
            [self showStartButton];
            break;}
    }
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
                NSString *error = [[ResponseDictionaryTool responseDic] objectForKey:item.n39];
                HomePageViewController *homeVc = [[HomePageViewController alloc] init];
                [MBProgressHUD showSuccess:error toView:homeVc.view];
                [self.navigationController pushViewController:homeVc animated:YES];
                
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
                NSString *error = [[ResponseDictionaryTool responseDic] objectForKey:item.n39];
                HomePageViewController *homeVc = [[HomePageViewController alloc] init];
                [MBProgressHUD showSuccess:error toView:homeVc.view];
                [self.navigationController pushViewController:homeVc animated:YES];
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
                NSString *error = [[ResponseDictionaryTool responseDic] objectForKey:item.n39];
                QueryrRecordViewController *queryVc = [[QueryrRecordViewController alloc]init];
                [MBProgressHUD showSuccess:error toView:queryVc.view];
                [self.navigationController pushViewController:queryVc animated:YES];
            }
        }];
    }
}


- (void)checkCardAgainAfterBadSwipe{
    isBadSwiped = YES;
    [self checkCardWithData];
}

#pragma mark -- Transaction Flow -- Select Application

- (void)onWisePadRequestSelectApplication:(NSArray *)applicationArray{
    NSLog(@"onWisePadRequestSelectApplication - applicationArray: %@", applicationArray);
    lblGeneralData.text = NSLocalizedString(@"onRequestSelectApplication", @"");
    
    if (isAutoSelectApplication){
        [[WisePadController sharedController] selectApplication:0];
        return;
    }
    
    NSString *resultStr = @"";
    for (int i=0 ; i<[applicationArray count] ; i++){
        resultStr = [NSString stringWithFormat:@"%@[%@] ", resultStr, [applicationArray objectAtIndex:i]];
    }
    
    if ([applicationArray count]>0){
        self.pickerType = @"SelectApplication";
        self.pickerDataSourceArray = applicationArray;
        [self showPickerView];
    }
}

#pragma mark -- Transaction Flow -- PIN Entry

- (IBAction)btnAction_CancelPinEntry:(id)sender{
    NSLog(@"[[WisePadController sharedController] cancelPinEntry];");
    [[WisePadController sharedController] cancelPinEntry];
}

- (void)onWisePadRequestPinEntry{
    //NSLog(@"onWisePadRequestPinEntry");
    //lblGeneralData.text = NSLocalizedString(@"onRequestPinEntry", @"");
}

- (void)onWisePadRequestPinEntry:(WisePadPinEntrySource)pinEntrySource{
    NSLog(@"onWisePadRequestPinEntry - pinEntrySource: %d", pinEntrySource);
    //lblGeneralData.text = NSLocalizedString(@"onRequestPinEntry", @"");
    if (pinEntrySource == WisePadPinEntrySource_Phone){
        [self popUpAlertView_PinEntry];
    }else if (pinEntrySource == WisePadPinEntrySource_Keypad){
        lblGeneralData.text = @"Please entry PIN on device.";
    }
}

- (void)onWisePadReturnPinEntryResult:(WisePadPinEntryResult)result data:(NSDictionary *)data{
    NSLog(@"onWisePadReturnPinEntryResult - result: %d, data: %@", result, data);
    NSString *resultString = @"";
    switch (result) {
        case WisePadPinEntryResult_PinEntered:
            resultString = @"PinEntered";
            break;
        case WisePadPinEntryResult_Cancel:
            resultString = @"Cancel";
            break;
        case WisePadPinEntryResult_Timeout:
            resultString = @"Timeout";
            break;
        case WisePadPinEntryResult_KeyError:
            resultString = @"KeyError";
            break;
        case WisePadPinEntryResult_ByPass:
            resultString = @"ByPass";
            break;
        case WisePadPinEntryResult_NoPin:
            resultString = @"NoPin";
            break;
        case WisePadPinEntryResult_WrongPinLength:
            resultString = @"WrongPinLength";
            break;
        case WisePadPinEntryResult_IncorrectPin:
            resultString = @"Incorrect PIN";
            break;
        default:
            break;
    }
    NSString *epb = [data objectForKey:@"epb"];
    
    //Different format ID will have different data in the result dictionary
    if ([data objectForKey:@"encWorkingKey"]){ //FID 55
        lblGeneralData.text = [NSString stringWithFormat:@"onReturnPinEntryResult %@\nEPB: %@\nencWorkingKey: %@", resultString, epb,
                               [data objectForKey:@"encWorkingKey"]];
    }else if ([data objectForKey:@"randomNumber"]){ //FID 64
        lblGeneralData.text = [NSString stringWithFormat:@"onReturnPinEntryResult %@\nEPB: %@\nrandomNumber: %@", resultString, epb,
                               [data objectForKey:@"randomNumber"]];
    }else if ([data objectForKey:@"ksn"]){ //FID 60
        lblGeneralData.text = [NSString stringWithFormat:@"onReturnPinEntryResult %@\nEPB: %@\nKSN: %@", resultString, epb,
                               [data objectForKey:@"ksn"]];
    }else{ //FID 46
        lblGeneralData.text = [NSString stringWithFormat:@"onReturnPinEntryResult %@\nEPB: %@", resultString, epb];
    }
    
    [self requestTrade:epb];
    
    [self showStartButton];
}

- (void)onWisePadReturnPinEntryResult:(WisePadPinEntryResult)result
                                  epb:(NSString *)epb
                                  ksn:(NSString *)ksn{
    NSLog(@"onWisePadReturnPinEntryResult - result: %d, epb: %@, ksn: %@", result, epb, ksn);
  
    
    //Please use -(void)onWisePadReturnPinEntryResult:(WisePadPinEntryResult)result data:(NSDictionary *)data
}

#pragma mark -- Transaction Flow -- Online Server Process
- (void)onWisePadRequestCheckServerConnectivity{
    NSLog(@"onWisePadRequestCheckServerConnectivity");
    lblGeneralData.text = NSLocalizedString(@"onRequestCheckServerConnectivity", @"");
    
    UISegmentedControl *tempControl = (UISegmentedControl *)[self.view viewWithTag:501];
    if (tempControl.selectedSegmentIndex==0){
        NSLog(@"sendServerConnectivity:YES");
        [[WisePadController sharedController] sendServerConnectivity:YES];
    }else{
        NSLog(@"sendServerConnectivity:NO");
        [[WisePadController sharedController] sendServerConnectivity:NO];
    }
}

- (void)onWisePadRequestOnlineProcess:(NSString *)tlv{
    NSLog(@"onWisePadRequestOnlineProcess: %@", tlv);
    lblGeneralData.text = NSLocalizedString(@"onRequestOnlineProcess", @"");
    
    NSLog(@"[[WisePadController sharedController] decodeTlv:tlv]: %@", [[WisePadController sharedController] decodeTlv:tlv]);
    NSDictionary *tlvDict = [[WisePadController sharedController] decodeTlv:tlv];
    if ([tlvDict objectForKey:@"70"] != nil){
        tlvDict = [[WisePadController sharedController] decodeTlv:[tlvDict objectForKey:@"70"]];
    }
    
    
    NSString *track2Data     = [tlvDict objectForKey:@"encTrack2Eq"];
    NSString *accountNumber1 = [tlvDict objectForKey:@"maskedPAN"];
    NSString *dynamicKeyData = [tlvDict objectForKey:@"encTrack2EqRandomNumber"];
    NSString *pinblock       = [tlvDict objectForKey:@"99"];
    NSString *ICNumber       = [NSString stringWithFormat:@"%@", [tlvDict objectForKey:@"5F34"]];
    
    NSString *data55 = [tlvDict objectForKey:@"encOnlineMessage"];
    NSLog(@"data55:%@",data55);
    NSString *date = [NSString stringWithFormat:@"%@", [tlvDict objectForKey:@"5F24"]];
    NSLog(@"date:%@",date);
    
    NSLog(@"track2Data: %@", track2Data);
    NSLog(@"accountNumber1: %@", accountNumber1);
    NSLog(@"dynamicKeyData: %@", dynamicKeyData);
    NSLog(@"pinblock: %@", pinblock);
    NSLog(@"ICNumber: %@", ICNumber);
    
    
    
    self.cardInfo = @{@"len55":[NSNumber numberWithInt:data55.length],
                      @"data55":[data55 uppercaseString],
                      @"randomNumber":dynamicKeyData,
                      @"cardSerial":ICNumber,
                      @"cardNumber":accountNumber1,
                      @"track2":track2Data,
                      @"expiryDate":[date substringToIndex:4],
                      @"cardType":@"1"
                      };
    [self requestTrade:pinblock];
    
    if (isAutoSendOnlineProcessResult){
        [[WisePadController sharedController] sendOnlineProcessResult:@"8A023030"]; //Approval
        return;
    }else {
        [[WisePadController sharedController] sendOnlineProcessResult:@"8A023035"];
        return;
    }

    
    
    // Send TLV data to Server ...
    
    //[[WisePadController sharedController] sendOnlineProcessResult:@"8A023030"]; //Approval
    //[[WisePadController sharedController] sendOnlineProcessResult:@"8A023035"]; //Decline
    //[[WisePadController sharedController] sendOnlineProcessResult:@""]; //Send empty string to cancel transaction
    
    self.pickerType = @"OnlineProcessResult";
    self.pickerDataSourceArray = [NSArray arrayWithObjects:@"8A023030 (Approval)", @"8A023035 (Decline)", nil];
    [self showPickerView];
}

#pragma mark -- Transaction Flow -- Final Confirm
- (void)onWisePadRequestFinalConfirm{
    NSLog(@"onWisePadRequestFinalConfirm");
    
//    if (isAutoFinalConfirm){
        NSLog(@"[[WisePadController sharedController] sendFinalConfirmResult:YES];");
        [[WisePadController sharedController] sendFinalConfirmResult:YES];
        return;
//    }
    
    if (isCanceledPin){
        lblGeneralData.text = NSLocalizedString(@"Processing", @"");
        isCanceledPin = NO;
        NSLog(@"[[WisePadController sharedController] sendFinalConfirmResult:NO];");
        [[WisePadController sharedController] sendFinalConfirmResult:NO];
    }else{
        lblGeneralData.text = NSLocalizedString(@"onRequestFinalConfirm", @"");
        [self popUpAlertView_FinalConfirm];
    }
}

#pragma mark -- Transaction Flow -- Output Transaction Result
- (void)onWisePadReturnTransactionResult:(WisePadTransactionResult)result data:(NSDictionary *)data{
    NSLog(@"onWisePadReturnTransactionResult - result: %d, data: %@", result, data);
    
    
    
    //When the alert or picker appear and received transaction result, could be timeout
    [self hideAlertView];
    [self hidePickerView];
    
    lblGeneralData.text = NSLocalizedString(@"onReturnTransactionResult", @"");
    
    switch (result) {
        case WisePadTransactionResult_Approved:{
            [self popUpAlertView_General:NSLocalizedString(@"TransactionResult", @"") alertMsg:NSLocalizedString(@"TransactionApproved", @"") cancelBtnText:NSLocalizedString(@"AlertBtnOk_General", @"")];
            break;}
        case WisePadTransactionResult_Terminated:{
            [self popUpAlertView_General:NSLocalizedString(@"TransactionResult", @"") alertMsg:NSLocalizedString(@"TransactionTerminated", @"") cancelBtnText:NSLocalizedString(@"AlertBtnOk_General", @"")];
            break;}
        case WisePadTransactionResult_Declined:{
            [self popUpAlertView_General:NSLocalizedString(@"TransactionResult", @"") alertMsg:NSLocalizedString(@"TransactionDeclined", @"") cancelBtnText:NSLocalizedString(@"AlertBtnOk_General", @"")];
            break;}
        case WisePadTransactionResult_SetAmountCancelOrTimeout:{
            [self popUpAlertView_General:NSLocalizedString(@"TransactionResult", @"") alertMsg:NSLocalizedString(@"Transaction_SetAmountCancelOrTimeout", @"") cancelBtnText:NSLocalizedString(@"AlertBtnOk_General", @"")];
            break;}
        case WisePadTransactionResult_CapkFail:{
            [self popUpAlertView_General:NSLocalizedString(@"TransactionResult", @"") alertMsg:@"WisePadTransactionResult_CapkFail" cancelBtnText:NSLocalizedString(@"AlertBtnOk_General", @"")];
            break;}
        case WisePadTransactionResult_NotIcc:{
            [self popUpAlertView_General:NSLocalizedString(@"TransactionResult", @"") alertMsg:NSLocalizedString(@"Transaction_NotIcc", @"") cancelBtnText:NSLocalizedString(@"AlertBtnOk_General", @"")];
            break;}
        case WisePadTransactionResult_SelectApplicationFail:{
            [self popUpAlertView_General:NSLocalizedString(@"TransactionResult", @"") alertMsg:NSLocalizedString(@"WisePadTransactionResult_SelectApplicationFail", @"") cancelBtnText:NSLocalizedString(@"AlertBtnOk_General", @"")];
            break;}
        case WisePadTransactionResult_TdkError:{
            [self popUpAlertView_General:NSLocalizedString(@"TransactionResult", @"") alertMsg:@"TransactionTdkError" cancelBtnText:NSLocalizedString(@"AlertBtnOk_General", @"")];
            break;}
        case WisePadTransactionResult_ApplicationBlocked:{
            [self popUpAlertView_General:NSLocalizedString(@"TransactionResult", @"") alertMsg:@"WisePadTransactionResult_ApplicationBlocked" cancelBtnText:NSLocalizedString(@"AlertBtnOk_General", @"")];
            break;}
        case WisePadTransactionResult_IccCardRemoved:{
            [self popUpAlertView_General:NSLocalizedString(@"TransactionResult", @"") alertMsg:@"WisePadTransactionResult_IccCardRemoved" cancelBtnText:NSLocalizedString(@"AlertBtnOk_General", @"")];
            break; }
        default:{
            break;}
    }
}

#pragma mark -- Transaction Flow -- Callback with TLV data

- (void)onWisePadReturnReversalData:(NSString *)tlv{
    NSString *callbackName = @"onWisePadReturnReversalData";
    NSLog(@"%@: %@", callbackName, tlv);
    lblGeneralData.text = NSLocalizedString(callbackName, @"");
    [self displayLongData:[NSString stringWithFormat:@"Reversal data:\n%@", tlv]];
}

- (void)onWisePadReturnBatchData:(NSString *)tlv{
    NSString *callbackName = @"onWisePadReturnBatchData";
    NSLog(@"%@: %@", callbackName, tlv);
    lblGeneralData.text = NSLocalizedString(callbackName, @"");
    [self displayLongData:[NSString stringWithFormat:@"Batch data:\n%@", tlv]];
    
//    NSDictionary *decodeTlvDict = [[WisePadController sharedController] decodeTlv:tlv];
//    NSLog(@"decodeTlvDict: %@", decodeTlvDict);
//    
//    NSString *track2Data     = [decodeTlvDict objectForKey:@"encTrack2Eq"];
//    NSString *accountNumber1 = [decodeTlvDict objectForKey:@"maskedPAN"];
//    NSString *dynamicKeyData = [decodeTlvDict objectForKey:@"encTrack2EqRandomNumber"];
//    NSString *pinblock       = [decodeTlvDict objectForKey:@"99"];
//    NSString *ICNumber       = [NSString stringWithFormat:@"%@", [decodeTlvDict objectForKey:@"5F34"]];
//    
//    NSString *data55 = [decodeTlvDict objectForKey:@"encOnlineMessage"];
//    NSLog(@"data55:%@",data55);
//    NSString *date = [NSString stringWithFormat:@"%@", [decodeTlvDict objectForKey:@"5F24"]];
//    NSLog(@"date:%@",date);
//    
//    NSLog(@"track2Data: %@", track2Data);
//    NSLog(@"accountNumber1: %@", accountNumber1);
//    NSLog(@"dynamicKeyData: %@", dynamicKeyData);
//    NSLog(@"pinblock: %@", pinblock);
//    NSLog(@"ICNumber: %@", ICNumber);
//    
//    
//    self.cardInfo = @{@"len55":[NSNumber numberWithInt:data55.length],
//                      @"data55":[data55 uppercaseString],
//                      @"randomNumber":dynamicKeyData,
//                      @"cardSerial":ICNumber,
//                      @"cardNumber":accountNumber1,
//                      @"track2":track2Data,
//                      @"expiryDate":[date substringToIndex:4],
//                      @"cardType":@"1"
//                      };
}

- (void)displayLongData:(NSString *)tlv{
    viewTLVData.hidden = NO;
    txtTLVData.text = [NSString stringWithFormat:@"%@", tlv];
}

- (void)appendLongData:(NSString *)tlv{
    viewTLVData.hidden = NO;
    txtTLVData.text = [NSString stringWithFormat:@"%@\n%@", txtTLVData.text, tlv];
}

#pragma mark -- Transaction Flow -- Display Message
- (void)onWisePadRequestDisplayText:(WisePadDisplayText)displayMessage{
    //NSLog(@"onWisePadRequestDisplayText: %d", displayMessage);
    
    NSString *strDisplayMessage = @"";
    switch (displayMessage) {
        case WisePadDisplayText_AMOUNT_OK_OR_NOT:
            strDisplayMessage = @"Confirm amount?";
            break;
        case WisePadDisplayText_APPROVED:
            strDisplayMessage = @"Approved";
            break;
        case WisePadDisplayText_CALL_YOUR_BANK:
            strDisplayMessage = @"Please call your bank";
            break;
        case WisePadDisplayText_CANCEL_OR_ENTER:
            strDisplayMessage = @"WisePadDisplayText_CANCEL_OR_ENTER";
            break;
        case WisePadDisplayText_CARD_ERROR:
            strDisplayMessage = @"Card error";
            break;
        case WisePadDisplayText_DECLINED:
            strDisplayMessage = @"Declined";
            break;
        case WisePadDisplayText_ENTER_PIN:
            strDisplayMessage = @"Please enter PIN";
            break;
        case WisePadDisplayText_INCORRECT_PIN:
            strDisplayMessage = @"Incorrect PIN";
            isWrongPin = YES;
            break;
        case WisePadDisplayText_INSERT_CARD:
            strDisplayMessage = @"Please insert card";
            lblGeneralData.text = NSLocalizedString(@"EmvMsg_InsertCard", @"");
            break;
        case WisePadDisplayText_NOT_ACCEPTED:
            strDisplayMessage = @"Not accepted";
            break;
        case WisePadDisplayText_PIN_OK:
            strDisplayMessage = @"PIN entry is correct";
            isWrongPin = NO;
            break;
        case WisePadDisplayText_PLEASE_WAIT:
            strDisplayMessage = @"Please wait ...";
            break;
        case WisePadDisplayText_PROCESSING_ERROR:
            strDisplayMessage = @"Processing error";
            break;
        case WisePadDisplayText_REMOVE_CARD:
            strDisplayMessage = @"Please remove card.";
            //lblGeneralData.text = NSLocalizedString(@"EmvMsg_RemoveCard", @"");
            break;
        case WisePadDisplayText_USE_CHIP_READER:
            strDisplayMessage = @"WisePadDisplayText_USE_CHIP_READER";
            break;
        case WisePadDisplayText_USE_MAG_STRIPE:
            strDisplayMessage = @"WisePadDisplayText_USE_MAG_STRIPE";
            break;
        case WisePadDisplayText_TRY_AGAIN:
            strDisplayMessage = @"Please try again";
            break;
        case WisePadDisplayText_REFER_TO_YOUR_PAYMENT_DEVICE:
            strDisplayMessage = @"WisePadDisplayText_REFER_TO_YOUR_PAYMENT_DEVICE";
            break;
        case WisePadDisplayText_TRANSACTION_TERMINATED:
            strDisplayMessage = @"Transaction terminated.";
            break;
        case WisePadDisplayText_TRY_ANOTHER_INTERFACE:
            strDisplayMessage = @"Please try another interface.";
            break;
        case WisePadDisplayText_ONLINE_REQUIRED:
            strDisplayMessage = @"WisePadDisplayText_ONLINE_REQUIRED";
            break;
        case WisePadDisplayText_PROCESSING:
            strDisplayMessage = @"Processing ...";
            break;
        case WisePadDisplayText_WELCOME:
            strDisplayMessage = @"Welcome";
            break;
        case WisePadDisplayText_PRESENT_ONLY_ONE_CARD:
            strDisplayMessage = @"WisePadDisplayText_PRESENT_ONLY_ONE_CARD";
            break;
        case WisePadDisplayText_LAST_PIN_TRY:
            strDisplayMessage = @"Last PIN try.";
            break;
        case WisePadDisplayText_CAPK_LOADING_FAILED:
            strDisplayMessage = @"CAPK loading failed.";
            break;
        case WisePadDisplayText_SELECT_ACCOUNT:
            strDisplayMessage = @"Please select account";
            break;
        default:
            break;
    }
    NSLog(@"****** onRequestDisplayText: %@", strDisplayMessage);
    if (displayMessage == WisePadDisplayText_REMOVE_CARD){
        //lblGeneralData.text = [NSString stringWithFormat:@"%@ \n%@", lblGeneralData.text, strDisplayMessage];
    }else{
        //lblGeneralData.text = strDisplayMessage;
    }
    //[lblGeneralData sizeToFit];
}

- (void)onWisePadRequestClearDisplay{
    NSLog(@"onWisePadRequestClearDisplay");
    //lblGeneralData.text = @"";
}

#pragma mark -- Transaction Flow -- Low Battery Warning
- (void)onWisePadBatteryLow:(WisePadBatteryStatus)batteryStatus{
    NSLog(@"onWisePadBatteryLow - batteryStatus: %d", batteryStatus);
    if (batteryStatus == WisePadBatteryStatus_Low){
        lblGeneralData.text = NSLocalizedString(@"onBatteryLow_LowBattery", @"");
        lblError.text = NSLocalizedString(@"onBatteryLow_LowBattery", @"");
    }else if (batteryStatus == WisePadBatteryStatus_CriticallyLow){
        [self resetUI];
        lblGeneralData.text = NSLocalizedString(@"onBatteryLow_VeryLowBattery", @"");
        lblError.text = NSLocalizedString(@"onBatteryLow_VeryLowBattery", @"");
    }
}

#pragma mark -- Transaction Flow -- GetEmvCardData
- (IBAction)btnAction_GetEmvCardData:(id)sender{
    NSLog(@"btnAction_GetEmvCardData");
    lblGeneralData.text = @"getEmvCardData ...";
    [[WisePadController sharedController] getEmvCardData];
}

- (void)onWisePadReturnEmvCardDataResult:(NSString *)tlv{
    NSLog(@"onWisePadReturnEmvCardDataResult - tlv: %@", tlv);
    lblGeneralData.text = @"onWisePadReturnEmvCardDataResult";
    NSLog(@"[[WisePadController sharedController] decodeTlv:tlv]: %@", [[WisePadController sharedController] decodeTlv:tlv]);
    [self displayLongData:[NSString stringWithFormat:@"EMV card data:\n%@", tlv]];
}

- (IBAction)btnAction_GetEmvCardNumber:(id)sender{
    NSLog(@"btnAction_GetEmvCardNumber");
    lblGeneralData.text = @"getEmvCardNumber ...";
    [[WisePadController sharedController] getEmvCardNumber];
}

- (void)onWisePadReturnEmvCardNumber:(NSString *)cardNumber{
    NSLog(@"onWisePadReturnEmvCardNumber - cardNumber: %@", cardNumber);
    lblGeneralData.text = [NSString stringWithFormat:@"Card number: %@", cardNumber];
}

- (IBAction)btnAction_GetEmvCardBalance:(id)sender{
    NSLog(@"btnAction_GetEmvCardBalance");
    lblGeneralData.text = @"getEmvCardBalance ...";
    
    NSMutableDictionary *inputDict = [NSMutableDictionary dictionary];
    [inputDict setObject:[NSNumber numberWithInt:[self getTimeoutValue_checkCardTimeout]] forKey:@"checkCardTimeout"];
    [inputDict setObject:[NSNumber numberWithInt:[self getTimeoutValue_selectApplicationTimeout]] forKey:@"selectApplicationTimeout"];
    [inputDict setObject:[NSNumber numberWithBool:YES] forKey:@"autoSelectApplication"];
    [[WisePadController sharedController] getEmvCardBalance:[NSDictionary dictionaryWithDictionary:inputDict]];
}
- (void)onWisePadReturnEmvCardBalance:(NSString *)tlv{
    txtTLVData.text = @"";
    [self appendLongData:@"onWisePadReturnEmvCardBalance"];
    NSString *callbackName = @"onWisePadReturnEmvCardBalance";
    NSLog(@"%@: %@", callbackName, [[WisePadController sharedController] decodeTlv:tlv]);
    lblGeneralData.text = NSLocalizedString(callbackName, @"");
    [self appendLongData:[NSString stringWithFormat:@"%@", tlv]];
}
- (IBAction)btnAction_GetEmvTransactionLog:(id)sender{
    NSLog(@"btnAction_GetEmvTransactionLog");
    lblGeneralData.text = @"getEmvTransactionLog ...";
    
    NSMutableDictionary *inputDict = [NSMutableDictionary dictionary];
    [inputDict setObject:[NSNumber numberWithInt:[self getTimeoutValue_checkCardTimeout]] forKey:@"checkCardTimeout"];
    [inputDict setObject:[NSNumber numberWithInt:[self getTimeoutValue_selectApplicationTimeout]] forKey:@"selectApplicationTimeout"];
    [inputDict setObject:[NSNumber numberWithBool:YES] forKey:@"autoSelectApplication"];
    [[WisePadController sharedController] getEmvTransactionLog:[NSDictionary dictionaryWithDictionary:inputDict]];
}
- (void)onWisePadReturnEmvTransactionLog:(NSArray *)transactionLogArray{
    NSLog(@"onReturnEmvTransactionLog - transactionLogArray [count: %d]: %@", (int)[transactionLogArray count], transactionLogArray);
    txtTLVData.text = @"";
    
    lblGeneralData.text = @"onReturnEmvTransactionLog";
    [self appendLongData:[NSString stringWithFormat:@"onReturnEmvTransactionLog [count: %d]", (int)[transactionLogArray count]]];
    for (int i=0; i<[transactionLogArray count]; i++) {
        [self appendLongData:@"\n"];
        [self appendLongData:[transactionLogArray objectAtIndex:i]];
    }
}
- (IBAction)btnAction_GetEmvLoadLog:(id)sender{
    NSLog(@"btnAction_GetEmvLoadLog");
    lblGeneralData.text = @"getEmvLoadLog ...";
    
    NSMutableDictionary *inputDict = [NSMutableDictionary dictionary];
    [inputDict setObject:[NSNumber numberWithInt:[self getTimeoutValue_checkCardTimeout]] forKey:@"checkCardTimeout"];
    [inputDict setObject:[NSNumber numberWithInt:[self getTimeoutValue_selectApplicationTimeout]] forKey:@"selectApplicationTimeout"];
    [inputDict setObject:[NSNumber numberWithBool:YES] forKey:@"autoSelectApplication"];
    [[WisePadController sharedController] getEmvLoadLog:[NSDictionary dictionaryWithDictionary:inputDict]];
}
- (void)onWisePadReturnEmvLoadLog:(NSArray *)LoadLogArray{
    NSLog(@"onReturnEmvLoadLog - LoadLogArray [count: %d]: %@", (int)[LoadLogArray count], LoadLogArray);
    txtTLVData.text = @"";
    
    lblGeneralData.text = @"onReturnEmvLoadLog";
    [self appendLongData:[NSString stringWithFormat:@"onReturnEmvLoadLog [count: %d]", (int)[LoadLogArray count]]];
    for (int i=0; i<[LoadLogArray count]; i++) {
        [self appendLongData:@"\n"];
        [self appendLongData:[LoadLogArray objectAtIndex:i]];
    }
}


- (IBAction)btnAction_GetMagStripeCardNumber:(id)sender{
    NSLog(@"btnAction_GetMagStripeCardNumber");
    [[WisePadController sharedController] getMagStripeCardNumber];
}

- (void)onWisePadReturnMagStripeCardNumber:(WisePadCheckCardResult)result cardNumber:(NSString *)cardNumber{
    NSLog(@"onWisePadReturnMagStripeCardNumber - result: %d, cardNumber: %@", result, cardNumber);
    lblGeneralData.text = [NSString stringWithFormat:@"cardNumber: %@", cardNumber];
}

#pragma mark - Encryption
- (IBAction)btnAction_EncryptPin:(id)sender{
    NSLog(@"btnAction_EncryptPin");
    
    [self encryptPin:@"123456" pan:@"123456789012345678"];
}

- (void)encryptPin:(NSString *)pin pan:(NSString *)pan{
    //Sample:
    //PIN: 123456
    //PAN: 123456789012345678
    //Encrypted EPB: 9E1D43C2997B0998
    //Decrypted EPB: 061253DFFEDCBA98
    
    NSMutableDictionary *inputDict = [NSMutableDictionary dictionary];
    [inputDict setObject:pin forKey:@"pin"];
    [inputDict setObject:pan forKey:@"pan"];
    if ([self isFormatID61]){
        [inputDict setObject:FID61_randomNumber forKey:@"randomNumber"];
    }
    if ([self isFormatID46]){
        [inputDict setObject:FID46_randomNumber forKey:@"randomNumber"];
    }
    if ([self isFormatID65]){
        [inputDict setObject:FID65_encPinKey forKey:@"encPinKey"];
    }
    
    lblGeneralData.text = @"Encrypt PIN ...";
    NSLog(@"[[WisePadController sharedController] encryptPin: %@", inputDict);
    [[WisePadController sharedController] encryptPin:inputDict];
    
    
}

- (void)onWisePadReturnEncryptPinResult:(NSDictionary *)data{
    NSLog(@"onReturnEncryptPinResult - data: %@", data);
    //NSDictionary key:
    //epb: Encrypted PIN Block
    //ksn: For FormatID 60
    //randomNumber: For FormatID 46, 64
    //errorMessage: Error during encryption
    lblGeneralData.text = @"";
    if ([data objectForKey:@"epb"]){
        lblGeneralData.text = [NSString stringWithFormat:@"EPB: %@", [data objectForKey:@"epb"]];
    }
}
- (IBAction)btnAction_EncryptData:(id)sender{
    NSLog(@"btnAction_EncryptData");
    NSString *data = @"112233445566778811223344556677881122334455667788";
    
    lblGeneralData.text = [NSString stringWithFormat:@"Encrypting data..."];
    
    [[WisePadController sharedController] encryptDataWithSettings:
     [NSDictionary dictionaryWithObjectsAndKeys:
      data, @"data",
      [NSNumber numberWithInt:WisePadEncryptionMethod_TDES_CBC], @"encryptionMethod",
      [NSNumber numberWithInt:WisePadEncryptionKeySource_BY_DEVICE_16_BYTES_RANDOM_NUMBER], @"encryptionKeySource",
      [NSNumber numberWithInt:WisePadEncryptionPaddingMethod_PKCS7], @"encryptionPaddingMethod",
      [NSNumber numberWithInt:WisePadEncryptionKeyUsage_TPK], @"keyUsage",
      [NSNumber numberWithInt:8], @"macLength",
      @"E328D2B7381A587E2B7B9E032BAB0451C257CC0FD286CDC4", @"encWorkingKey", //kcv can be appended to encWorkingKey
      @"", @"kcvOfWorkingKey",
      @"8877665544332211", @"randomNumber",
      @"0000000000000000", @"initialVector",
      nil]];
}
- (void)onWisePadReturnEncryptDataResult:(NSDictionary *)data{
    NSLog(@"onWisePadReturnEncryptDataResult - data: %@", data);
    lblGeneralData.text = [NSString stringWithFormat:@"Encrypt data completed."];
    //Key included in data dictionary: encData, mac, randomNumber, ksn, isSuccess
}
- (void)onWisePadReturnEncryptDataResult:(NSString *)encryptedData ksn:(NSString *)ksn{
    //NSLog(@"onWisePadReturnEncryptDataResult - encryptedData: %@, ksn: %@", encryptedData, ksn);
}

#pragma mark - Phone Number
- (IBAction)btnAction_GetPhoneNumber:(id)sender{
    NSLog(@"btnAction_GetPhoneNumber");
    lblGeneralData.text = [NSString stringWithFormat:@"Get Phone Number ..."];
    [[WisePadController sharedController] startGetPhoneNumber];
}

- (void)onWisePadReturnPhoneNumber:(WisePadPhoneEntryResult)result phoneNumber:(NSString *)phoneNumber{
    NSLog(@"onWisePadReturnPhoneNumber - result: %d, phoneNumber: %@", result, phoneNumber);
    lblGeneralData.text = [NSString stringWithFormat:@"Phone number: %@", phoneNumber];
}

- (IBAction)btnAction_CancelGetPhoneNumber:(id)sender{
    NSLog(@"btnAction_CancelGetPhoneNumber");
    lblGeneralData.text = [NSString stringWithFormat:@"Cancel Get Phone Number ..."];
    [[WisePadController sharedController] cancelGetPhoneNumber];
}

#pragma mark - UIAlertView - PopUp
- (void)popUpAlertView_General:(NSString *)alertTitle
                      alertMsg:(NSString *)alertMsg
                 cancelBtnText:(NSString *)cancelBtnText{
    NSLog(@"popUpAlertView_General");
    [self hideTrackDataPanel];
    self.genericAlert = [[UIAlertView alloc] initWithTitle:alertTitle
                                                   message:alertMsg
                                                  delegate:self
                                         cancelButtonTitle:cancelBtnText
                                         otherButtonTitles:nil, nil];
//    [self.genericAlert show];
}

- (void)popUpAlertView_SetAmount:(NSString *)errorMessage{
    NSLog(@"popUpAlertView_SetAmount");
    [self hideTrackDataPanel];
    UISegmentedControl *tempControl = (UISegmentedControl *)[self.view viewWithTag:503];
    
    int heightPadding = 0;
    NSString *message = @"";
    if ([errorMessage length]>0){
        heightPadding = 30;
        message = [NSString stringWithFormat:@"%@%@", errorMessage, NSLocalizedString(@"AlertMsg_SetAmount_Retry", @"")];
    }else{
        heightPadding = 13;
        if (tempControl.selectedSegmentIndex == 1){ //Cashback
            message = [NSString stringWithFormat:@"%@", NSLocalizedString(@"AlertMsg_SetAmountAndCashback", @"")];
        }else{
            message = [NSString stringWithFormat:@"%@", NSLocalizedString(@"AlertMsg_SetAmount", @"")];
        }
    }
    
    self.genericAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"AlertTitle_SetAmount", @"")
                                                   message:message
                                                  delegate:self
                                         cancelButtonTitle:NSLocalizedString(@"AlertCancel_SetAmount", @"")
                                         otherButtonTitles:NSLocalizedString(@"AlertBtnOk_SetAmount", @""), nil];
    
    if (tempControl.selectedSegmentIndex == 1){
        self.genericAlert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
        [[self.genericAlert textFieldAtIndex:1] setPlaceholder:NSLocalizedString(@"AlertPlaceHolder_SetCashback", @"")];
        [[self.genericAlert textFieldAtIndex:1] setKeyboardType:UIKeyboardTypeDecimalPad];
        [[self.genericAlert textFieldAtIndex:1] setFont:[UIFont systemFontOfSize:15]];
    }else{
        self.genericAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    }
    [[self.genericAlert textFieldAtIndex:0] setPlaceholder:NSLocalizedString(@"AlertPlaceHolder_SetAmount", @"")];
    [[self.genericAlert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeDecimalPad];
    [[self.genericAlert textFieldAtIndex:0] setFont:[UIFont systemFontOfSize:15]];
    
    [self.genericAlert show];
}

- (void)popUpAlertView_PinEntry{
    NSLog(@"popUpAlertView_PinEntry");
    [self hideTrackDataPanel];
    NSString *message = @"";
    if (isWrongPin){
        isWrongPin = NO;
        message = [NSString stringWithFormat:@"%@", NSLocalizedString(@"AlertMsg_PinEntry_WrongPin", @"")];
    }else{
        message = [NSString stringWithFormat:@"%@", NSLocalizedString(@"AlertMsg_PinEntry", @"")];
    }
    
    self.genericAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"AlertTitle_PinEntry", @"")
                                                   message:message
                                                  delegate:self
                                         cancelButtonTitle:NSLocalizedString(@"AlertCancel_PinEntry", @"")
                                         otherButtonTitles:NSLocalizedString(@"AlertBtnOk_PinEntry", @""), nil];
    
    self.genericAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [[self.genericAlert textFieldAtIndex:0] setPlaceholder:NSLocalizedString(@"AlertPlaceHolder_PinEntry", @"")];
    [[self.genericAlert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
    [[self.genericAlert textFieldAtIndex:0] setFont:[UIFont systemFontOfSize:15]];
    
    [self.genericAlert show];
}

- (void)popUpAlertView_FinalConfirm{
    NSLog(@"popUpAlertView_FinalConfirm");
    [self hideTrackDataPanel];
    self.genericAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"AlertTitle_FinalConfirm", @"")
                                                   message:NSLocalizedString(@"AlertMsg_FinalConfirm", @"")
                                                  delegate:self
                                         cancelButtonTitle:NSLocalizedString(@"AlertCancel_FinalConfirm", @"")
                                         otherButtonTitles:NSLocalizedString(@"AlertBtnOk_FinalConfirm", @""), nil];
    [self.genericAlert show];
}

#pragma mark - UIAlertView - Click Event
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"alertView clickedButtonAtIndex");
    NSString *alertTitle = [alertView title];
    if ([alertTitle isEqualToString:NSLocalizedString(@"AlertTitle_SetAmount", @"")]){
        NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
        UITextField *amountTextField = nil;
        if ([self.genericAlert alertViewStyle] == UIAlertViewStylePlainTextInput){
            amountTextField = (UITextField *)[self.genericAlert textFieldAtIndex:0];
        }
        UITextField *cashbackTextField = nil;
        if ([self.genericAlert alertViewStyle] == UIAlertViewStyleLoginAndPasswordInput){
            amountTextField = (UITextField *)[self.genericAlert textFieldAtIndex:0];
            cashbackTextField = (UITextField *)[self.genericAlert textFieldAtIndex:1];
        }
        
        NSString *amountStr = @"";
        if (amountTextField.text == nil){
            amountTextField.text = @"";
        }
        if (amountTextField != nil){
            amountStr = [NSString stringWithString:[amountTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
            if ([amountStr length]==0){
                amountStr = @"0";
            }
        }
        
        NSString *cashbackStr = @"";
        if (cashbackTextField.text == nil){
            cashbackTextField.text = @"";
        }
        if (cashbackTextField != nil){
            cashbackStr = [NSString stringWithString:[cashbackTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
            if ([cashbackStr length]==0){
                cashbackStr = @"0";
            }
        }
        
        if ([buttonTitle isEqualToString:NSLocalizedString(@"AlertBtnOk_SetAmount", @"")]) {
            UISegmentedControl *tempControl = (UISegmentedControl *)[self.view viewWithTag:503];
            
            // Goods    - 商品
            // Services - 服务
            // Cashback - 返现
            // Inquiry  - 查询
            // Transfer - 转账
            // Payment  - 付款
            // Refund   - 退款
            
            WisePadTransactionType tempTransType = WisePadTransactionType_Goods;
            switch (tempControl.selectedSegmentIndex) {
                case 0:
                    tempTransType = WisePadTransactionType_Goods;
                    break;
                case 1:
                    tempTransType = WisePadTransactionType_Cashback;
                    break;
                case 2:
                    tempTransType = WisePadTransactionType_Services;
                    break;
                case 3:
                    tempTransType = WisePadTransactionType_Inquiry;
                    break;
                case 4:
                    tempTransType = WisePadTransactionType_Transfer;
                    break;
                case 5:
                    tempTransType = WisePadTransactionType_Payment;
                    break;
                default:
                    break;
            }
            
            if (tempControl.selectedSegmentIndex == 1){ //Cashback
                NSLog(@"amountStr   : %@", amountStr);
                NSLog(@"cashbackStr : %@", cashbackStr);
                if ([[WisePadController sharedController] setAmount:self.tadeAmount
                                                     cashbackAmount:cashbackStr
                                                       currencyCode:@"156"
                                                    transactionType:tempTransType
                                                 currencyCharacters:[NSArray arrayWithObjects:
                                                                     [NSNumber numberWithInt:(int)CurrencyCharacter_Yuan], nil]]){
                    NSLog(@"Valid amount");
                }else{
                    NSLog(@"Invalid amount");
                }
            }else{
                NSLog(@"amountStr : %@", amountStr);
                if ([[WisePadController sharedController] setAmount:self.tadeAmount
                                                     cashbackAmount:@""
                                                       currencyCode:@"156"
                                                    transactionType:tempTransType
                                                 currencyCharacters:[NSArray arrayWithObjects:
                                                                     [NSNumber numberWithInt:(int)CurrencyCharacter_Yuan], nil]]){
                    NSLog(@"Valid amount");
                }else{
                    NSLog(@"Invalid amount");
                }
            }
            _lblAmount.text = [NSString stringWithFormat:@"%@: %@%@%@ %@", NSLocalizedString(@"Amount", @""),
                               [[self.pickerDataSourceArray_Currency objectAtIndex:[_pickerCurrencyCharacter selectedRowInComponent:0]]
                                stringByReplacingOccurrencesOfString:@"NULL" withString:@""],
                               [[self.pickerDataSourceArray_Currency objectAtIndex:[_pickerCurrencyCharacter selectedRowInComponent:1]]
                                stringByReplacingOccurrencesOfString:@"NULL" withString:@""],
                               [[self.pickerDataSourceArray_Currency objectAtIndex:[_pickerCurrencyCharacter selectedRowInComponent:2]]
                                stringByReplacingOccurrencesOfString:@"NULL" withString:@""],
                               amountStr];
            
            lblGeneralData.text = NSLocalizedString(@"AlertMsg_SetAmount_Confirm", @"");
            [self showAmountView];
        } else { //Cancel
            //lblGeneralData.text = NSLocalizedString(@"Processing", @"");
            [[WisePadController sharedController] cancelSetAmount];
        }
    }
    
    else if ([alertTitle isEqualToString:NSLocalizedString(@"AlertTitle_PinEntry", @"")]){
        NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
        UITextField *textField = nil;
        if ([self.genericAlert alertViewStyle] == UIAlertViewStylePlainTextInput){
            textField = (UITextField *)[self.genericAlert textFieldAtIndex:0];
        }
        
        NSString *numberString = @"";
        if (textField != nil){
            numberString = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([numberString length]==0){
                numberString = @"";
            }
            NSLog(@"numberString  : %@", numberString);
        }
        
        if ([buttonTitle isEqualToString:NSLocalizedString(@"AlertBtnOk_PinEntry", @"")]) {
            if ([numberString length] > 0){
                NSLog(@"[[WisePadController sharedController] sendPinEntryResult: %@];", numberString);
                [[WisePadController sharedController] sendPinEntryResult:numberString];
            }else{
                NSLog(@"[[WisePadController sharedController] bypassPinEntry];");
                [[WisePadController sharedController] bypassPinEntry];
            }
            isCanceledPin = NO;
        } else { //Cancel
            lblGeneralData.text = NSLocalizedString(@"Processing", @"");
            NSLog(@"[[WisePadController sharedController] cancelPinEntry];");
            [[WisePadController sharedController] cancelPinEntry];
            isCanceledPin = YES;
        }
    }
    
    else if ([alertTitle isEqualToString:NSLocalizedString(@"AlertTitle_FinalConfirm", @"")]){
        lblGeneralData.text = NSLocalizedString(@"Processing", @"");
        NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
        if ([buttonTitle isEqualToString:NSLocalizedString(@"AlertBtnOk_FinalConfirm", @"")]) {
            NSLog(@"[[WisePadController sharedController] sendFinalConfirmResult:YES];");
            [[WisePadController sharedController] sendFinalConfirmResult:YES];
        } else { //Cancel
            NSLog(@"[[WisePadController sharedController] sendFinalConfirmResult:NO];");
            [[WisePadController sharedController] sendFinalConfirmResult:NO];
        }
    }
    
    else if ([alertTitle isEqualToString:NSLocalizedString(@"TransactionResult", @"")]){
        [self resetUI];
    }
    
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

#pragma mark - UIPicker
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (pickerView == pickerSelectValue){
        return 1;
    }else if (pickerView == _pickerCurrencyCharacter){
        return 3;
    }else{
        return 1;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == pickerSelectValue){
        return [pickerDataSourceArray count];
    }else if (pickerView == _pickerCurrencyCharacter){
        return [self.pickerDataSourceArray_Currency count];
    }else{
        return 0;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView == pickerSelectValue){
        if ([pickerDataSourceArray count] > row){
            return [pickerDataSourceArray objectAtIndex:row];
        }else{
            return @"";
        }
    }else if (pickerView == _pickerCurrencyCharacter){
        if ([[self.pickerDataSourceArray_Currency objectAtIndex:row] isEqualToString:@" "]){
            return @"Space";
        }else{
            return [self.pickerDataSourceArray_Currency objectAtIndex:row];
        }
    }else{
        return @"";
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView == pickerSelectValue){
        NSLog(@"pickerView didSelectRow: %d", (int)row);
    }else if (pickerView == _pickerCurrencyCharacter){
        NSLog(@"pickerView didSelectRow - row: %d, value: %@", (int)row, [self.pickerDataSourceArray_Currency objectAtIndex:row]);
    }else{
        
    }
}

- (IBAction)btnAction_SelectPickerValue_Confirm:(id)sender{
    NSLog(@"btnAction_SelectPickerValue_Confirm");
    
    if([self.pickerDataSourceArray count]>0){
        int pickerSelectedRow = (int)[pickerSelectValue selectedRowInComponent:0];
        if ([self.pickerType isEqualToString:@"SelectApplication"]){
            NSLog(@"[[WisePadController sharedController] selectApplication:%d];", pickerSelectedRow);
            [[WisePadController sharedController] selectApplication:pickerSelectedRow];
        }else if ([self.pickerType isEqualToString:@"OnlineProcessResult"]){
            if (pickerSelectedRow == 0){
                NSLog(@"[[WisePadController sharedController] sendOnlineProcessResult:@'8A023030']; //Approval");
                [[WisePadController sharedController] sendOnlineProcessResult:@"8A023030"]; //Approval
            }else{
                NSLog(@"[[WisePadController sharedController] sendOnlineProcessResult:@'8A023035']; //Decline");
                [[WisePadController sharedController] sendOnlineProcessResult:@"8A023035"]; //Decline
            }
        }else{
            NSLog(@"UI implementation error.");
        }
        
        self.pickerType = @"";
        self.pickerDataSourceArray = [NSArray array];
        [self hidePickerView];
        lblGeneralData.text = NSLocalizedString(@"Processing", @"");
    }else{
        lblGeneralData.text = @"No picker value available to select.";
    }
}

- (IBAction)btnAction_SelectPickerValue_Cancel:(id)sender{
    NSLog(@"btnAction_SelectPickerValue_Cancel");
    
    if([self.pickerDataSourceArray count]>0){
        if ([self.pickerType isEqualToString:@"SelectApplication"]){
            [[WisePadController sharedController] cancelSelectApplication];
        }else if ([self.pickerType isEqualToString:@"OnlineProcessResult"]){
            NSLog(@"[[WisePadController sharedController] sendOnlineProcessResult:@'']; //Send empty string to cancel transaction");
            [[WisePadController sharedController] sendOnlineProcessResult:@""]; //Send empty string to cancel transaction
        }else{
            NSLog(@"UI implementation error.");
        }
    }else{
        lblGeneralData.text = @"No picker value available to select.";
    }
    [self hidePickerView];
    lblGeneralData.text = NSLocalizedString(@"Processing", @"");
}

- (NSArray *)getCurrencyCharacterStrings{
    return [NSArray arrayWithObjects:
            @"A", @"B", @"C", @"D", @"E",
            @"F", @"G", @"H", @"I", @"J",
            @"K", @"L", @"M", @"N", @"O",
            @"P", @"Q", @"R", @"S", @"T",
            @"U", @"V", @"W", @"X", @"Y",
            @"Z",
            @" ",
            @"Dirham",
            @"Dollar",
            @"Euro",
            @"IndianRupee",
            @"Pound",
            @"SaudiRiyal",
            @"SaudiRiyal2",
            @"Won",
            @"Yen",
            @"/.",
            @".",
            @"Yuan",
            
            //New currency enum value may be added
            @"NULL", nil];
}

#pragma mark - Error Handling
- (void)onWisePadError:(WisePadErrorType)errorType errorMessage:(NSString *)errorMessage{
    NSLog(@"onWisePadError - errorType: %d, errorMessage: %@", errorType, errorMessage);
    lblError.text = errorMessage;
    
    if (errorType == WisePadErrorType_IllegalStateException){
        lblError.text = @"Can only perform one single task each time,\nplease wait previous task completed or timeout.";
    }
    
    NSString *invalidInputMessage = @"";
    
    switch (errorType) {
        case WisePadErrorType_InvalidInput:{
            [self showStartButton];
            lblGeneralData.text = errorMessage;
            invalidInputMessage = lblGeneralData.text;
            break;}
        case WisePadErrorType_InvalidInput_InputValueOutOfRange:{
            [self hideStartButton];
            lblGeneralData.text = @"Input value out of range. ";
            invalidInputMessage = lblGeneralData.text;
            break;}
        case WisePadErrorType_InvalidInput_InvalidDataFormat:{
            [self hideStartButton];
            lblGeneralData.text = [NSString stringWithFormat:@"%@ \n", errorMessage];
            invalidInputMessage = lblGeneralData.text;
            break;}
        case WisePadErrorType_InvalidInput_NoAcceptAmountForThisTransactionType:{
            [self hideStartButton];
            lblGeneralData.text = @"NoAcceptAmountForThisTransactionType ";
            invalidInputMessage = lblGeneralData.text;
            break;}
        case WisePadErrorType_InvalidInput_NotAcceptCashbackForThisTransactionType:{
            [self hideStartButton];
            lblGeneralData.text = @"NotAcceptCashbackForThisTransactionType ";
            invalidInputMessage = lblGeneralData.text;
            break;}
        case WisePadErrorType_InvalidInput_NotNumeric:{
            [self hideStartButton];
            lblGeneralData.text = @"Not numeric. ";
            invalidInputMessage = lblGeneralData.text;
            break;}
        case WisePadErrorType_DeviceReset:{
            [self resetUI];
            lblGeneralData.text = @"WisePadErrorType_DeviceReset. ";
            break;}
        case WisePadErrorType_CommError:{
            [self resetUI];
            lblGeneralData.text = @"WisePadErrorType_CommError ";
            break;}
        case WisePadErrorType_Unknown:{
            lblGeneralData.text = @"WisePadErrorType_Unknown ";
            break;}
        case WisePadErrorType_CommLinkUninitialized:{
            lblGeneralData.text = @"Please connect the device.";
            break;}
        case WisePadErrorType_InvalidFunctionInBTv2Mode:{
            lblGeneralData.text = @"Please stop Audio before connecting BTv4 device.";
            break;}
        case WisePadErrorType_InvalidFunctionInBTv4Mode:{
            lblGeneralData.text = @"Please stop BTv4 before connecting Audio device.";
            break;}
        case WisePadErrorType_BTv2FailToStart:{
            lblGeneralData.text = errorMessage;
            break;}
        case WisePadErrorType_BTv4FailToStart:{
            lblGeneralData.text = errorMessage;
            [self.BluetoothDeviceDict removeObjectForKey:@"BTv4_foundDevices"];
            [self.BluetoothDeviceDict removeObjectForKey:@"BTv4_connectedDevice"];
            [self.bluetoothDeviceTable reloadData];
            break;}
        case WisePadErrorType_IllegalStateException:{
            lblGeneralData.text = @"Can only perform one single task each time. ";
            break;}
        case WisePadErrorType_DeviceBusy:{
            lblGeneralData.text = @"WisePadErrorType_DeviceBusy";
            break;}
        default:{
            lblGeneralData.text = errorMessage;
            break;}
    }
    
    if (errorType == WisePadErrorType_InvalidInput ||
        errorType == WisePadErrorType_InvalidInput_InputValueOutOfRange ||
        errorType == WisePadErrorType_InvalidInput_InvalidDataFormat ||
        errorType == WisePadErrorType_InvalidInput_NoAcceptAmountForThisTransactionType ||
        errorType == WisePadErrorType_InvalidInput_NotAcceptCashbackForThisTransactionType ||
        errorType == WisePadErrorType_InvalidInput_NotNumeric){
        
        lblError.text = @"";
        if ([self.alertType length] > 0){
            NSLog(@"onWisePadError - self.alertType: %@", self.alertType);
        }
        if ([self.alertType isEqualToString:@"SetAmount"]){
            _lblAmount.text = @"";
            [self popUpAlertView_SetAmount:invalidInputMessage];
        }else if ([self.alertType isEqualToString:@"PinEntry"]){
            //[self popUpAlertView_PinEntry];
        }
    }
}

#pragma mark - Other API Function
- (IBAction)btnAction_DetectDevice:(id)sender {
    NSLog(@"btnAction_DetectDevice - isDevicePresent? %@", ([[WisePadController sharedController] isDevicePresent] ? @"YES" : @"NO"));
    if ([[WisePadController sharedController] isDevicePresent] == YES){
        lblGeneralData.text = @"Device connected";
    } else {
        lblGeneralData.text = @"Please connect the device.";
    }
}

- (void)onWisePadAudioInterrupted{
    NSLog(@"onWisePadAudioInterrupted");
    [self resetUI];
    lblGeneralData.text = @"onInterrupted";
}

#pragma mark - ENUM to NSString

- (NSString *)getWisePadControllerStateString{
    //NSLog(@"getWisePadControllerStateString");
    WisePadControllerState state = [[WisePadController sharedController] getWisePadControllerState];
    NSString *returnStr = @"";
    if (state == WisePadControllerState_CommLinkUninitialized){
        returnStr = @"CommLinkUninitialized";
    }else if (state == WisePadControllerState_Idle){
        returnStr = @"Idle";
    }else if (state == WisePadControllerState_WaitingForResponse){
        returnStr = @"WaitingForResponse";
    }else{
        returnStr = @"Unknwon State";
    }
    return returnStr;
}

#pragma mark - UI
- (void)appendDataToGeneralDataView:(NSString *)data{
    //viewGeneralData.hidden = NO;
    [txtGeneralData setText:[NSString stringWithFormat:@"%@\n%@", txtGeneralData.text, data]];
    [txtGeneralData scrollRangeToVisible:NSMakeRange([txtGeneralData.text length], 0)];
}

- (IBAction)resetAllUI:(id)sender{
    [self resetUI];
}

- (void)resetUI{
    //lblError.text = @"";
    //lblGeneralData.text = @"";
    [self hidePickerView];
    [self hideTrackDataPanel];
    [self hideAmountView];
    [self hideAlertView];
    [self hideDisplayDataView];
    [self showStartButton];
}

- (void)showStartButton{
    UIButton *btnStart = (UIButton *)[viewBtnPage1 viewWithTag:900];
    btnStart.hidden = NO;
}

- (void)hideStartButton{
    UIButton *btnStart = (UIButton *)[viewBtnPage1 viewWithTag:900];
    btnStart.hidden = YES;
}

- (void)showAmountView{
    viewAmount.hidden = NO;
}

- (void)hideAmountView{
    viewAmount.hidden = YES;
    _lblAmount.text = @"";
}

- (void)showDisplayDataView{
    _viewDisplayData.hidden = NO;
}

- (void)hideDisplayDataView{
    _viewDisplayData.hidden = YES;
}

- (void)showPickerView{
    NSLog(@"showPickerView");
    
    [pickerSelectValue reloadAllComponents];
    pickerSelectValue.hidden = NO;
    
    UIView *pickerBtnView = (UIView *)[self.view viewWithTag:1002];
    pickerBtnView.hidden = NO;
}

- (void)hidePickerView{
    //NSLog(@"hidePickerView");
    
    UIView *pickerBtnView = (UIView *)[self.view viewWithTag:1002];
    pickerBtnView.hidden = YES;
    
    pickerSelectValue.hidden = YES;
    
    self.pickerType = @"";
    self.pickerDataSourceArray = [NSArray array];
}

- (void)hideAlertView{
    //NSLog(@"hideAlertView");
    [self.genericAlert dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark -- ShowHide Panel
- (void)hideTrackDataPanel{
    //NSLog(@"");
    viewTrackDataPanel.hidden = YES;
    //viewTLVData.hidden = YES;
}

- (void)hideTlvPanel{
    //NSLog(@"");
    viewTLVData.hidden = YES;
}

- (void)showTrackDataPanelView{
    //NSLog(@"");
    viewTrackDataPanel.hidden = NO;
    viewTLVData.hidden = YES;
}

- (IBAction)showTlvDataView:(id)sender{
    viewTrackDataPanel.hidden = YES;
    viewTLVData.hidden = NO;
}

#pragma mark -- Clear Label

- (void)clearAllLabelAndTextbox{
    //NSLog(@"");
    [self clearCardDataLabel];
    
    lblGeneralData.text = @"";
    lblError.text = @"";
}

- (void)clearCardDataLabel{
    //NSLog(@"");
    _lblFormatID.text = @"";
    _lblPan.text = @"";
    _lblExpiryDate.text = @"";
    _lblCardholderName.text = @"";
    _lblKsn.text = @"";
    _lblServiceCode.text = @"";
    _lblTrack1.text = @"";
    _lblTrack2.text = @"";
    _lblTrack3.text = @"";
    _lblTracks.text = @"";
}

#pragma mark -- Keyboard
- (IBAction)backgroundButtonTouchUpInside:(id)sender {
    //NSLog(@"");
    [self hideTrackDataPanel];
    [self hideTlvPanel];
    [self hideDisplayDataView];
    [self hideKeyboard:nil];
}

- (IBAction)hideKeyboard:(id)sender{
    [_txtApdu resignFirstResponder];
    [_txtCurrencyCode resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self hideKeyboard:nil];
    return YES;
}

#pragma mark - Slider
- (IBAction)sliderValueChanged:(id)sender{
    int labelTagID = -1;
    switch ([sender tag]) {
        case 5000:{ labelTagID = 5010; break; } //checkCardTimeout
        case 5001:{ labelTagID = 5011; break; } //setAmountTimeout
        case 5002:{ labelTagID = 5012; break; } //selectApplicationTimeout
        case 5003:{ labelTagID = 5013; break; } //finalConfirmTimeout
        case 5004:{ labelTagID = 5014; break; } //pinEntryTimeout
        case 5005:{ labelTagID = 5015; break; } //onlineProcessTimeout
        default:{ break; }
    }
    if (labelTagID > 0){
        UILabel *label = (UILabel *)[self.view viewWithTag:labelTagID];
        [label setText:[NSString stringWithFormat:@"%.0f", [(UISlider *)sender value]]];
    }else{
        NSLog(@"UI Bug - Slider tag ID not found");
    }
}

- (int)getTimeoutValue_checkCardTimeout{
//    UILabel *label = (UILabel *)[self.view viewWithTag:5010];
//    return [label.text intValue];
    return 90;
}
- (int)getTimeoutValue_setAmountTimeout{
    //    UILabel *label = (UILabel *)[self.view viewWithTag:5010];
    //    return [label.text intValue];
    return 90;
}
- (int)getTimeoutValue_selectApplicationTimeout{
    //    UILabel *label = (UILabel *)[self.view viewWithTag:5010];
    //    return [label.text intValue];
    return 90;
}
- (int)getTimeoutValue_finalConfirmTimeout{
    //    UILabel *label = (UILabel *)[self.view viewWithTag:5010];
    //    return [label.text intValue];
    return 90;
}
- (int)getTimeoutValue_pinEntryTimeout{
    //    UILabel *label = (UILabel *)[self.view viewWithTag:5010];
    //    return [label.text intValue];
    return 90;
}
- (int)getTimeoutValue_onlineProcessTimeout{
    //    UILabel *label = (UILabel *)[self.view viewWithTag:5010];
    //    return [label.text intValue];
    return 90;
}


#pragma mark - TableView Delegates
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger numOfSection = 0;
    if (section == 0){
        numOfSection = ([self.BluetoothDeviceDict objectForKey:@"BTv4_connectedDevice"] != nil);
    }else{
        numOfSection = [[self.BluetoothDeviceDict objectForKey:@"BTv4_foundDevices"] count];
    }
    return numOfSection;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"cellForRowAtIndexPath: %@", indexPath);
    UITableViewCell	*cell;
    CBPeripheral	*peripheral;
    NSInteger		row	= [indexPath row];
    static NSString *cellID = @"DeviceList";
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID] autorelease];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    
    if ([indexPath section] == 0) {
        peripheral = [self.BluetoothDeviceDict objectForKey:@"BTv4_connectedDevice"];
    } else {
        peripheral = (CBPeripheral*)[[self.BluetoothDeviceDict objectForKey:@"BTv4_foundDevices"] objectAtIndex:row];
    }
    
    if (peripheral != nil){
        if ([[peripheral name] length]){
            //Remove "-LE" in peripheralName
            NSString *peripheralName = [peripheral name];
            if ([peripheralName length] >= 3){
                if ([[[peripheralName substringWithRange:NSMakeRange([peripheralName length]-3, 3)] uppercaseString] isEqualToString:@"-LE"]){
                    peripheralName = [peripheralName substringWithRange:NSMakeRange(0, [peripheralName length]-3)];
                }
            }
            [[cell textLabel] setText:peripheralName];
        }else{
            [[cell textLabel] setText:@"Peripheral"];
        }
        //[[cell detailTextLabel] setText: [peripheral isConnected] ? @"Connected" : @"Not connected"];
    }
    return cell;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CBPeripheral	*peripheral;
    NSInteger		row	= [indexPath row];
    
    if ([indexPath section] == 0) {
        peripheral = [self.BluetoothDeviceDict objectForKey:@"BTv4_connectedDevice"];
    } else {
        peripheral = (CBPeripheral*)[[self.BluetoothDeviceDict objectForKey:@"BTv4_foundDevices"] objectAtIndex:row];
    }
    
    //if ([peripheral isConnected]) {
    //} else {
    lblGeneralData.text = @"Connecting device ...";
    NSLog(@"[[WisePadController sharedController] connectBTv4:peripheral] - peripheral: %@", peripheral);
    self.currConnectingBTv4DeviceName = [peripheral name];
    [[WisePadController sharedController] connectBTv4:peripheral connectTimeout:kConnectBTv4Timeout];
    //}
}

#pragma mark - Bluetooth v4

- (IBAction)btnAction_ScanBTv4:(id)sender{
    NSLog(@"btnAction_ScanBTv4");
    isAutoConnectLastBTv4Device = NO;
    [self scanBTv4Device];
}

- (IBAction)btnAction_ConnectLastDevice:(id)sender{
    NSLog(@"btnAction_ConnectLastDevice");
    isAutoConnectLastBTv4Device = YES;
    
    if ([self getNSUserDefaultsObject:kLastConnectedBTv4DeviceUUID] == nil ||
        [(NSString *)[self getNSUserDefaultsObject:kLastConnectedBTv4DeviceUUID] length] == 0){
        lblGeneralData.text = @"LastConnectedBTv4DeviceUUID is null.";
        return;
    }else{
        lblGeneralData.text = @"Connecting device ...";
    }
    
    NSLog(@"(NSString *)[self getNSUserDefaultsObject:kLastConnectedBTv4DeviceUUID]: %@", (NSString *)[self getNSUserDefaultsObject:kLastConnectedBTv4DeviceUUID]);
    [[WisePadController sharedController] connectBTv4withUUID:(NSString *)[self getNSUserDefaultsObject:kLastConnectedBTv4DeviceUUID]
                                               connectTimeout:kConnectBTv4Timeout];
}

- (void)scanBTv4Device{
    NSLog(@"scanBTv4Device");
    //    NSMutableArray *deviceNameArray = [NSMutableArray array];
    //    [deviceNameArray addObject:@"BBPOS"];
    //    [deviceNameArray addObject:@"WisePad"];
    //    [deviceNameArray addObject:@"WP"];
    //    [deviceNameArray addObject:@"W+"];
    //    [deviceNameArray addObject:@"M"];
    //    [deviceNameArray addObject:@"Test"];
    
    [self.BluetoothDeviceDict removeObjectForKey:@"BTv4_foundDevices"];
    [self.BluetoothDeviceDict removeObjectForKey:@"BTv4_connectedDevice"];
    [self.bluetoothDeviceTable reloadData];
    lblError.text = @"";
    /*
     if (isAutoConnectLastBTv4Device){
     if ([self getNSUserDefaultsObject:kLastConnectedBTv4DeviceUUID] == nil ||
     [(NSString *)[self getNSUserDefaultsObject:kLastConnectedBTv4DeviceUUID] length] == 0){
     lblGeneralData.text = @"LastConnectedBTv4DeviceUUID is null.";
     }else{
     lblGeneralData.text = @"Scanning device ...";
     }
     }else{
     lblGeneralData.text = @"Scanning device ...";
     }*/
    [[WisePadController sharedController] scanBTv4:nil
                                       scanTimeout:kScanBTv4Timeout];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:1];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateTableView];
        });
    });
}

//更新界面
- (void)updateTableView {
    
    // create the alert
    self.alert = [MLTableAlert tableAlertWithTitle:@"请选择设备" cancelButtonTitle:@"取消"
                                      numberOfRows:^NSInteger (NSInteger section) {
                                          return [[self.BluetoothDeviceDict objectForKey:@"BTv4_foundDevices"] count];
                                      }
                                          andCells:^UITableViewCell* (MLTableAlert *anAlert, NSIndexPath *indexPath) {
                                              UITableViewCell	*cell;
                                              CBPeripheral	*peripheral;
                                              NSInteger		row	= [indexPath row];
                                              static NSString *cellID = @"DeviceList";
                                              
                                              cell = [anAlert.table dequeueReusableCellWithIdentifier:cellID];
                                              if (!cell)
                                                  //        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID] autorelease];
                                                  cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
                                              
//                                              if ([indexPath section] == 0) {
//                                                  peripheral = [self.BluetoothDeviceDict objectForKey:@"BTv4_connectedDevice"];
//                                              } else {
                                                  peripheral = (CBPeripheral*)[[self.BluetoothDeviceDict objectForKey:@"BTv4_foundDevices"] objectAtIndex:row];
//                                              }
                                              
                                              if (peripheral != nil){
                                                  if ([[peripheral name] length]){
                                                      //Remove "-LE" in peripheralName
                                                      NSString *peripheralName = [peripheral name];
                                                      if ([peripheralName length] >= 3){
                                                          if ([[[peripheralName substringWithRange:NSMakeRange([peripheralName length]-3, 3)] uppercaseString] isEqualToString:@"-LE"]){
                                                              peripheralName = [peripheralName substringWithRange:NSMakeRange(0, [peripheralName length]-3)];
                                                          }
                                                      }
                                                      [[cell textLabel] setText:peripheralName];
                                                  }else{
                                                      [[cell textLabel] setText:@"Peripheral"];
                                                  }
                                                  //[[cell detailTextLabel] setText: [peripheral isConnected] ? @"Connected" : @"Not connected"];
                                              }
                                              
                                              return cell;
                                          }];
    
    // Setting custom alert height
    self.alert.height = 300;
    
    // configure actions to perform
    [self.alert configureSelectionBlock:^(NSIndexPath *selectedIndex){
        
        CBPeripheral	*peripheral;
        NSInteger		row	= [selectedIndex row];
        
//        if ([selectedIndex section] == 0) {
//            peripheral = [self.BluetoothDeviceDict objectForKey:@"BTv4_connectedDevice"];
//        } else {
            peripheral = (CBPeripheral*)[[self.BluetoothDeviceDict objectForKey:@"BTv4_foundDevices"] objectAtIndex:row];
//        }
        
        //if ([peripheral isConnected]) {
        //} else {
        lblGeneralData.text = @"Connecting device ...";
        NSLog(@"[[WisePadController sharedController] connectBTv4:peripheral] - peripheral: %@", peripheral);
        self.currConnectingBTv4DeviceName = [peripheral name];
        [[WisePadController sharedController] connectBTv4:peripheral connectTimeout:kConnectBTv4Timeout];
        
        
        
    } andCompletionBlock:^{
        //self.navigationItem.title = @"Cancel Button Pressed\nNo Cells Selected";
    }];
    
    [self.alert show];
    
}

- (void)getPOSInfo {
    NSLog(@"btnAction_GetDeviceInfo");
    lblError.text = @"";
    lblGeneralData.text = @"Getting device info ...";
    [[WisePadController sharedController] getDeviceInfo];
    
    
}

- (void)connectPOS {
    NSLog(@"btnAction_ConnectLastDevice");
    isAutoConnectLastBTv4Device = YES;
    
    if ([self getNSUserDefaultsObject:kLastConnectedBTv4DeviceUUID] == nil ||
        [(NSString *)[self getNSUserDefaultsObject:kLastConnectedBTv4DeviceUUID] length] == 0){
        lblGeneralData.text = @"LastConnectedBTv4DeviceUUID is null.";
        return;
    }else{
        lblGeneralData.text = @"Connecting device ...";
    }
    
    NSLog(@"(NSString *)[self getNSUserDefaultsObject:kLastConnectedBTv4DeviceUUID]: %@", (NSString *)[self getNSUserDefaultsObject:kLastConnectedBTv4DeviceUUID]);
    [[WisePadController sharedController] connectBTv4withUUID:(NSString *)[self getNSUserDefaultsObject:kLastConnectedBTv4DeviceUUID]
                                               connectTimeout:kConnectBTv4Timeout];
}

- (void)onWisePadBTv4DeviceListRefresh:(NSArray *)foundDevices{
    NSLog(@"onWisePadBTv4DeviceListRefresh - foundDevices    : %@", foundDevices);
    
    if (foundDevices == nil){
        return;
    }
    [self.BluetoothDeviceDict removeObjectForKey:@"BTv4_foundDevices"];
    [self.BluetoothDeviceDict removeObjectForKey:@"BTv4_connectedDevice"];
    [self.BluetoothDeviceDict setObject:[NSArray arrayWithArray:foundDevices] forKey:@"BTv4_foundDevices"];
    [self.bluetoothDeviceTable reloadData];
    
    //NSLog(@"isAutoConnectLastBTv4Device: %d", isAutoConnectLastBTv4Device);
    if (isAutoConnectLastBTv4Device){
        NSString *lastConnectedBTv4DeviceName = (NSString *)[self getNSUserDefaultsObject:kLastConnectedBTv4DeviceUUID];
        NSString *foundDeviceName = @"";
        NSLog(@"lastConnectedBTv4DeviceName: %@", lastConnectedBTv4DeviceName);
        if (lastConnectedBTv4DeviceName != nil && [lastConnectedBTv4DeviceName length] > 0){
            for (int i=0 ; i<[foundDevices count]; i++) {
                foundDeviceName = [(CBPeripheral *)[foundDevices objectAtIndex:i] name];
                NSLog(@"Looping foundDevice - i:%d, foundDeviceName:%@", i, foundDeviceName);
                if ([foundDeviceName isEqualToString:lastConnectedBTv4DeviceName]){
                    lblGeneralData.text = [NSString stringWithFormat:@"Connecting\n%@", lastConnectedBTv4DeviceName];
                    NSLog(@"%@", lblGeneralData.text);
                    self.currConnectingBTv4DeviceName = [NSString stringWithString:lastConnectedBTv4DeviceName];
                    [[WisePadController sharedController] connectBTv4:(CBPeripheral *)[foundDevices objectAtIndex:i] connectTimeout:kConnectBTv4Timeout];
                }
            }
        }
    }
}

- (void)disconnectPOS {
    [self.BluetoothDeviceDict removeObjectForKey:@"BTv4_foundDevices"];
    [self.BluetoothDeviceDict removeObjectForKey:@"BTv4_connectedDevice"];
    [self.bluetoothDeviceTable reloadData];
    
    lblGeneralData.text = @"Stop scanning and disconnect";
    NSLog(@"[[WisePadController sharedController] stopScanBTv4];");
    [[WisePadController sharedController] stopScanBTv4];
    NSLog(@"[[WisePadController sharedController] disconnectBTv4];");
    [[WisePadController sharedController] disconnectBTv4];
}

- (IBAction)btnAction_DisconnectBTv4:(id)sender{
    NSLog(@"btnAction_DisconnectBTv4");
    
    [self.BluetoothDeviceDict removeObjectForKey:@"BTv4_foundDevices"];
    [self.BluetoothDeviceDict removeObjectForKey:@"BTv4_connectedDevice"];
    [self.bluetoothDeviceTable reloadData];
    
    lblGeneralData.text = @"Stop scanning and disconnect";
    NSLog(@"[[WisePadController sharedController] stopScanBTv4];");
    [[WisePadController sharedController] stopScanBTv4];
    NSLog(@"[[WisePadController sharedController] disconnectBTv4];");
    [[WisePadController sharedController] disconnectBTv4];
}

- (void)onWisePadBTv4Connected{
    //NSLog(@"onWisePadBTv4Connected");
}

- (void)onWisePadBTv4Connected:(CBPeripheral *)connectedPeripheral{ //Added connectedPeripheral in 2.1.0
    NSLog(@"onWisePadBTv4Connected - connectedPeripheral: %@", connectedPeripheral);
    [self resetUI];
    lblGeneralData.text = @"onBTv4Connected";
    lblError.text = @"";
    
    [self setNSUserDefaultsObject:[connectedPeripheral name] key:kLastConnectedBTv4DeviceName];
    [self setNSUserDefaultsObject:[[WisePadController sharedController] getPeripheralUUID:connectedPeripheral] key:kLastConnectedBTv4DeviceUUID];
    NSLog(@"kLastConnectedBTv4DeviceUUID value after setNSUserDefaultsObject: %@", [self getNSUserDefaultsObject:kLastConnectedBTv4DeviceUUID]);
    
    _lbLastConnectedBTv4DeviceName.text = (NSString *)[self getNSUserDefaultsObject:kLastConnectedBTv4DeviceName];
    _lbLastConnectedBTv4DeviceUUID.text = (NSString *)[self getNSUserDefaultsObject:kLastConnectedBTv4DeviceUUID];
    self.currConnectingBTv4DeviceName = @"";
    
//    NSMutableArray *newFoundDevices = [[[self.BluetoothDeviceDict objectForKey:@"BTv4_foundDevices"] mutableCopy] autorelease];
    NSMutableArray *newFoundDevices = [[self.BluetoothDeviceDict objectForKey:@"BTv4_foundDevices"] mutableCopy];
    [newFoundDevices removeObject:[self.BluetoothDeviceDict objectForKey:@"BTv4_connectedDevice"]];
    if (newFoundDevices != nil){
        [self.BluetoothDeviceDict setObject:newFoundDevices forKey:@"BTv4_foundDevices"];
    }
    [self.bluetoothDeviceTable reloadData];
    
    //    NSString *connectedPeripheralName = [connectedPeripheral name];
    //    if ([connectedPeripheralName length] >= 4){
    //        self.productModel = [connectedPeripheralName substringWithRange:NSMakeRange(0, 4)];
    //    }
    
    [self.scrollView scrollRectToVisible:CGRectMake(320*1, 0, 320, 240) animated:YES];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:1];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self getPOSInfo];
        });
    });
    
}

- (void)onWisePadBTv4Disconnected{
    NSLog(@"onWisePadBTv4Disconnected");
    [self resetUI];
    lblGeneralData.text = [NSString stringWithFormat:@"onBTv4Disconnected\n%@", lblGeneralData.text];
    
    [self.BluetoothDeviceDict removeObjectForKey:@"BTv4_connectedDevice"];
    [self.bluetoothDeviceTable reloadData];
}

- (void)onWisePadBTv4ScanTimeout{
    NSLog(@"onWisePadBTv4ScanTimeout");
    lblGeneralData.text = @"onWisePadBTv4ScanTimeout";
}

- (void)onWisePadBTv4ConnectTimeout{
    NSLog(@"onWisePadBTv4ConnectTimeout");
    lblGeneralData.text = @"onWisePadBTv4ConnectTimeout";
}

- (void)onWisePadRequestEnableBluetoothInSettings{
    NSLog(@"onWisePadRequestEnableBluetoothInSettings");
    lblGeneralData.text = @"Please enable Bluetooth in iOS Settings.";
}


#pragma mark - Audio
- (IBAction)startAudio:(id)sender{
    NSLog(@"startAudio");
    if ([[WisePadController sharedController] startAudio]){
        lblGeneralData.text = @"Audio started";
    }else{
        lblGeneralData.text = @"Fail to start audio";
    }
}

- (IBAction)stopAudio:(id)sender{
    NSLog(@"stopAudio");
    [[WisePadController sharedController] stopAudio];
    lblGeneralData.text = @"Audio stopped";
}





#pragma mark - NSUserDefaults
- (void)setNSUserDefaultsObject:(NSObject *)object key:(NSString *)key{
    //DebugLog(@"key: %@", key);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:object forKey:key];
    [defaults synchronize];
}

- (NSObject *)getNSUserDefaultsObject:(NSString *)key{
    //DebugLog(@"key: %@", key);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:key];
}

#pragma mark - Print
- (IBAction)btnAction_Print:(id)sender{
    int numOfData = 1;
    int printNextDataTimeout = 10;
    NSLog(@"[[WisePadController sharedController] startPrinting:%d printNextDataTimeout:%d];", numOfData, printNextDataTimeout);
    [[WisePadController sharedController] startPrinting:numOfData
                                   printNextDataTimeout:printNextDataTimeout];
}

- (void)onWisePadWaitingReprintOrPrintNext{
    NSLog(@"onWisePadWaitingReprintOrPrintNext");
    lblGeneralData.text = [NSString stringWithFormat:@"onWisePadWaitingReprintOrPrintNext"];
}

- (void)onWisePadRequestPrintData:(int)index isReprint:(BOOL)isReprint{
    NSLog(@"onWisePadRequestPrintData - index: %d, isReprint: %d", index, isReprint);
    lblGeneralData.text = [NSString stringWithFormat:@"onWisePadRequestPrintData\nindex: %d", index];
    /*
     if (index == 1){
     [[WisePadController sharedController] sendPrintData:receipt1];
     }else if (index == 2){
     [[WisePadController sharedController] sendPrintData:receipt2];
     }*/
    [[WisePadController sharedController] sendPrintData:[self getReceiptData_v2]];
}

- (void)onWisePadReturnPrintResult:(WisePadPrintResult)result{
    NSLog(@"onWisePadReturnPrintResult - PrintResult: %d", result);
    lblGeneralData.text = [NSString stringWithFormat:@"onWisePadReturnPrintResult\result: %d", result];
}

- (void)onWisePadPrintDataEnd{
    NSLog(@"onWisePadPrintDataEnd");
    lblGeneralData.text = [NSString stringWithFormat:@"onWisePadPrintDataEnd"];
}

- (void)onWisePadPrintDataCancelled{
    NSLog(@"onWisePadPrintDataCancelled");
    lblGeneralData.text = [NSString stringWithFormat:@"onWisePadPrintDataCancelled"];
}

- (NSData *)getReceiptData_v2{
    NSMutableData *receiptData = [NSMutableData data];
    
    int lineWidth = 384;
    int size0NoEmphasizeLineWidth = 384 / 8; //line width / font width
    NSString *singleLine = @"";
    for(int i = 0; i < size0NoEmphasizeLineWidth; ++i) {
        singleLine = [NSString stringWithFormat:@"%@-", singleLine];
    }
    singleLine = [self asciiToHexString:singleLine];
    NSString *doubleLine = @"";
    for(int i = 0; i < size0NoEmphasizeLineWidth; ++i) {
        doubleLine = [NSString stringWithFormat:@"%@=", doubleLine];
    }
    doubleLine = [self asciiToHexString:doubleLine];
    
    [receiptData appendData:[self hexStringToBytes:printCmd_INIT]];
    [receiptData appendData:[self hexStringToBytes:printCmd_POWER_ON]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    [receiptData appendData:[self hexStringToBytes:printCmd_ALIGN_CENTER]];
    ///*
    [receiptData appendData:[self hexStringToBytes:[[WisePadController sharedController] getImageCommand:[UIImage imageNamed:@"cafe.png"]]]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    [receiptData appendData:[self hexStringToBytes:printCmd_CHAR_SPACING_0]];
    [receiptData appendData:[self hexStringToBytes:printCmd_FONT_SIZE_0]];
    [receiptData appendData:[self hexStringToBytes:printCmd_EMPHASIZE_ON]];
    [receiptData appendData:[self hexStringToBytes:printCmd_FONT_5X12]];
    [receiptData appendData:[self hexStringToBytes:[self asciiToHexString:@"Suite 1602, 16/F, Tower 2"]]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    [receiptData appendData:[self hexStringToBytes:[self asciiToHexString:@"Nina Tower, No 8 Yeung Uk Road"]]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    [receiptData appendData:[self hexStringToBytes:[self asciiToHexString:@"Tsuen Wan, N.T., Hong Kong"]]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    
    [receiptData appendData:[self hexStringToBytes:printCmd_FONT_SIZE_1]];
    [receiptData appendData:[self hexStringToBytes:printCmd_FONT_5X12]];
    [receiptData appendData:[self hexStringToBytes:[self asciiToHexString:@"OFFICIAL RECEIPT"]]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    
    [receiptData appendData:[self hexStringToBytes:printCmd_FONT_SIZE_0]];
    [receiptData appendData:[self hexStringToBytes:printCmd_EMPHASIZE_OFF]];
    [receiptData appendData:[self hexStringToBytes:printCmd_FONT_10X18]];
    [receiptData appendData:[self hexStringToBytes:[self asciiToHexString:@"Form No. 2524"]]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    
    [receiptData appendData:[self hexStringToBytes:printCmd_FONT_8X12]];
    [receiptData appendData:[self hexStringToBytes:singleLine]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    
    [receiptData appendData:[self hexStringToBytes:printCmd_ALIGN_LEFT]];
    
    [receiptData appendData:[self hexStringToBytes:printCmd_FONT_10X18]];
    [receiptData appendData:[self hexStringToBytes:[self asciiToHexString:@"ROR NO "]]];
    [receiptData appendData:[self hexStringToBytes:printCmd_EMPHASIZE_ON]];
    [receiptData appendData:[self hexStringToBytes:[self asciiToHexString:@"ROR2014-000556-000029"]]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    [receiptData appendData:[self hexStringToBytes:printCmd_EMPHASIZE_OFF]];
    [receiptData appendData:[self hexStringToBytes:[self asciiToHexString:@"DATE/TIME "]]];
    [receiptData appendData:[self hexStringToBytes:printCmd_EMPHASIZE_ON]];
    [receiptData appendData:[self hexStringToBytes:[self asciiToHexString:@"08/20/2014 10:42:46 AM"]]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    
    [receiptData appendData:[self hexStringToBytes:printCmd_EMPHASIZE_OFF]];
    [receiptData appendData:[self hexStringToBytes:printCmd_FONT_8X12]];
    [receiptData appendData:[self hexStringToBytes:singleLine]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    
    [receiptData appendData:[self hexStringToBytes:printCmd_FONT_10X18]];
    [receiptData appendData:[self hexStringToBytes:printCmd_EMPHASIZE_ON]];
    [receiptData appendData:[self hexStringToBytes:[self asciiToHexString:@"CHAN TAI MAN"]]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    
    [receiptData appendData:[self hexStringToBytes:printCmd_EMPHASIZE_OFF]];
    [receiptData appendData:[self hexStringToBytes:[self asciiToHexString:@"BIR FORM NO : "]]];
    [receiptData appendData:[self hexStringToBytes:printCmd_EMPHASIZE_ON]];
    [receiptData appendData:[self hexStringToBytes:[self asciiToHexString:@"0605"]]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    
    [receiptData appendData:[self hexStringToBytes:printCmd_EMPHASIZE_OFF]];
    [receiptData appendData:[self hexStringToBytes:[self asciiToHexString:@"TYPE : "]]];
    [receiptData appendData:[self hexStringToBytes:printCmd_EMPHASIZE_ON]];
    [receiptData appendData:[self hexStringToBytes:[self asciiToHexString:@"AP"]]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    
    [receiptData appendData:[self hexStringToBytes:printCmd_EMPHASIZE_OFF]];
    [receiptData appendData:[self hexStringToBytes:[self asciiToHexString:@"PERIOD COVERED : "]]];
    [receiptData appendData:[self hexStringToBytes:printCmd_EMPHASIZE_ON]];
    [receiptData appendData:[self hexStringToBytes:[self asciiToHexString:@"2014-8-20"]]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    
    [receiptData appendData:[self hexStringToBytes:printCmd_EMPHASIZE_OFF]];
    [receiptData appendData:[self hexStringToBytes:[self asciiToHexString:@"ASSESSMENT NO : "]]];
    [receiptData appendData:[self hexStringToBytes:printCmd_EMPHASIZE_ON]];
    [receiptData appendData:[self hexStringToBytes:[self asciiToHexString:@"885"]]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    
    [receiptData appendData:[self hexStringToBytes:printCmd_EMPHASIZE_OFF]];
    [receiptData appendData:[self hexStringToBytes:[self asciiToHexString:@"DUE DATE : "]]];
    [receiptData appendData:[self hexStringToBytes:printCmd_EMPHASIZE_ON]];
    [receiptData appendData:[self hexStringToBytes:[self asciiToHexString:@"2014-8-20"]]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    
    int fontSize = 0;
    int fontWidth = 10 * (fontSize + 1) + (fontSize + 1);
    NSString *s1 = @"PARTICULARS";
    NSString *s2 = @"AMOUNT";
    NSString *s = [NSString stringWithString:s1];
    int numOfCharacterPerLine = lineWidth / fontWidth;
    for(int i = 0; i < numOfCharacterPerLine - [s1 length] - [s2 length]; ++i) {
        s = [NSString stringWithFormat:@"%@ ", s];
    }
    s = [NSString stringWithFormat:@"%@%@", s, s2];
    [receiptData appendData:[self hexStringToBytes:[self asciiToHexString:s]]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    
    fontSize = 0;
    fontWidth = 10 * (fontSize + 1);
    
    s1 = @"BASIC";
    s2 = @"100.00";
    s = [NSString stringWithString:s1];
    numOfCharacterPerLine = lineWidth / fontWidth;
    for(int i = 0; i < numOfCharacterPerLine - [s1 length] - [s2 length]; ++i) {
        s = [NSString stringWithFormat:@"%@ ", s];
    }
    s = [NSString stringWithFormat:@"%@%@", s, s2];
    [receiptData appendData:[self hexStringToBytes:printCmd_EMPHASIZE_OFF]];
    [receiptData appendData:[self hexStringToBytes:[self asciiToHexString:s]]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    
    s1 = @"    SUBCHANGE";
    s2 = @"500.00";
    s = [NSString stringWithString:s1];
    for(int i = 0; i < numOfCharacterPerLine - [s1 length] - [s2 length]; ++i) {
        s = [NSString stringWithFormat:@"%@ ", s];
    }
    s = [NSString stringWithFormat:@"%@%@", s, s2];
    [receiptData appendData:[self hexStringToBytes:[self asciiToHexString:s]]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    
    s1 = @"    INTEREST";
    s2 = @"0.00";
    s = [NSString stringWithString:s1];
    for(int i = 0; i < numOfCharacterPerLine - [s1 length] - [s2 length]; ++i) {
        s = [NSString stringWithFormat:@"%@ ", s];
    }
    s = [NSString stringWithFormat:@"%@%@", s, s2];
    [receiptData appendData:[self hexStringToBytes:[self asciiToHexString:s]]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    
    
    s1 = @"    COMPROMISE";
    s2 = @"0.00";
    s = [NSString stringWithString:s1];
    for(int i = 0; i < numOfCharacterPerLine - [s1 length] - [s2 length]; ++i) {
        s = [NSString stringWithFormat:@"%@ ", s];
    }
    s = [NSString stringWithFormat:@"%@%@", s, s2];
    [receiptData appendData:[self hexStringToBytes:[self asciiToHexString:s]]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    
    s1 = @"TOTAL";
    s2 = @"500.00";
    s = [NSString stringWithString:s1];
    for(int i = 0; i < numOfCharacterPerLine - [s1 length] - [s2 length]; ++i) {
        s = [NSString stringWithFormat:@"%@ ", s];
    }
    s = [NSString stringWithFormat:@"%@%@", s, s2];
    [receiptData appendData:[self hexStringToBytes:[self asciiToHexString:s]]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    
    [receiptData appendData:[self hexStringToBytes:printCmd_FONT_8X12]];
    [receiptData appendData:[self hexStringToBytes:singleLine]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    
    s1 = @"TOTAL AMOUNT DUE";
    s2 = @"600.00";
    s = [NSString stringWithString:s1];
    for(int i = 0; i < numOfCharacterPerLine - [s1 length] - [s2 length]; ++i) {
        s = [NSString stringWithFormat:@"%@ ", s];
    }
    s = [NSString stringWithFormat:@"%@%@", s, s2];
    [receiptData appendData:[self hexStringToBytes:printCmd_FONT_10X18]];
    [receiptData appendData:[self hexStringToBytes:[self asciiToHexString:s]]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    
    [receiptData appendData:[self hexStringToBytes:printCmd_FONT_8X12]];
    [receiptData appendData:[self hexStringToBytes:doubleLine]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    
    s1 = @"TOTAL AMOUNT PAID";
    s2 = @"600.00";
    s = [NSString stringWithString:s1];
    for(int i = 0; i < numOfCharacterPerLine - [s1 length] - [s2 length]; ++i) {
        s = [NSString stringWithFormat:@"%@ ", s];
    }
    s = [NSString stringWithFormat:@"%@%@", s, s2];
    
    [receiptData appendData:[self hexStringToBytes:printCmd_FONT_10X18]];
    [receiptData appendData:[self hexStringToBytes:[self asciiToHexString:s]]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    
    [receiptData appendData:[self hexStringToBytes:printCmd_EMPHASIZE_ON]];
    [receiptData appendData:[self hexStringToBytes:[self asciiToHexString:@"SIX HUNDRED DOLLARS ONLY"]]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    
    [receiptData appendData:[self hexStringToBytes:printCmd_EMPHASIZE_OFF]];
    [receiptData appendData:[self hexStringToBytes:printCmd_FONT_8X12]];
    [receiptData appendData:[self hexStringToBytes:singleLine]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    
    [receiptData appendData:[self hexStringToBytes:printCmd_FONT_10X18]];
    [receiptData appendData:[self hexStringToBytes:[self asciiToHexString:@"MANNER OF PAYMENT"]]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    
    [receiptData appendData:[self hexStringToBytes:printCmd_EMPHASIZE_ON]];
    [receiptData appendData:[self hexStringToBytes:[self asciiToHexString:@" ACCOUNTS RECEIVABLE"]]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    
    [receiptData appendData:[self hexStringToBytes:printCmd_EMPHASIZE_OFF]];
    [receiptData appendData:[self hexStringToBytes:[self asciiToHexString:@"TYPE OF PAYMENT"]]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    
    [receiptData appendData:[self hexStringToBytes:printCmd_EMPHASIZE_ON]];
    [receiptData appendData:[self hexStringToBytes:[self asciiToHexString:@" FULL"]]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    
    [receiptData appendData:[self hexStringToBytes:printCmd_EMPHASIZE_OFF]];
    [receiptData appendData:[self hexStringToBytes:[self asciiToHexString:@"MODE OF PAYMENT"]]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    
    [receiptData appendData:[self hexStringToBytes:printCmd_EMPHASIZE_ON]];
    [receiptData appendData:[self hexStringToBytes:[self asciiToHexString:@"  CASH"]]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    
    s1 = @"  AMOUNT";
    s2 = @"600.00";
    s = [NSString stringWithString:s1];
    for(int i = 0; i < numOfCharacterPerLine - [s1 length] - [s2 length]; ++i) {
        s = [NSString stringWithFormat:@"%@ ", s];
    }
    s = [NSString stringWithFormat:@"%@%@", s, s2];
    [receiptData appendData:[self hexStringToBytes:printCmd_EMPHASIZE_OFF]];
    [receiptData appendData:[self hexStringToBytes:[self asciiToHexString:s]]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    
    [receiptData appendData:[self hexStringToBytes:[self asciiToHexString:@"REMARKS"]]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    
    [receiptData appendData:[self hexStringToBytes:printCmd_EMPHASIZE_ON]];
    [receiptData appendData:[self hexStringToBytes:[self asciiToHexString:@"TEST"]]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    
    [receiptData appendData:[self hexStringToBytes:printCmd_EMPHASIZE_OFF]];
    [receiptData appendData:[self hexStringToBytes:printCmd_FONT_8X12]];
    [receiptData appendData:[self hexStringToBytes:singleLine]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    
    [receiptData appendData:[self hexStringToBytes:printCmd_ALIGN_CENTER]];
    
    [receiptData appendData:[self hexStringToBytes:printCmd_FONT_SIZE_1]];
    [receiptData appendData:[self hexStringToBytes:printCmd_EMPHASIZE_ON]];
    [receiptData appendData:[self hexStringToBytes:printCmd_FONT_8X12]];
    
    [receiptData appendData:[self hexStringToBytes:[self asciiToHexString:@"CARDHOLDER'S COPY"]]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    
    [receiptData appendData:[self hexStringToBytes:printCmd_ALIGN_LEFT]];
    
    [receiptData appendData:[self hexStringToBytes:printCmd_FONT_SIZE_0]];
    [receiptData appendData:[self hexStringToBytes:printCmd_EMPHASIZE_OFF]];
    [receiptData appendData:[self hexStringToBytes:singleLine]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    
    [receiptData appendData:[self hexStringToBytes:printCmd_ALIGN_CENTER]];
    [receiptData appendData:[self hexStringToBytes:printCmd_FONT_5X12]];
    
    [receiptData appendData:[self hexStringToBytes:[self asciiToHexString:@"This is to certify that the amount indicated herein has"]]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    [receiptData appendData:[self hexStringToBytes:[self asciiToHexString:@"been received by the undersigned"]]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    
    [receiptData appendData:[self hexStringToBytes:printCmd_EMPHASIZE_ON]];
    [receiptData appendData:[self hexStringToBytes:printCmd_FONT_10X18]];
    
    [receiptData appendData:[self hexStringToBytes:[self asciiToHexString:@"WONG SIU MING"]]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    //*/
    //--- Print barcode ---
    NSString *barcodeDataString = @"0123456789";
    NSMutableDictionary *barcodeDataDict = [NSMutableDictionary dictionary];
    [barcodeDataDict setObject:barcodeDataString forKey:@"barcodeDataString"];
    [barcodeDataDict setObject:[NSNumber numberWithInt:40] forKey:@"barcodeHeight"];
    [barcodeDataDict setObject:@"128" forKey:@"barcodeType"];
    NSString *barcode128 = [[WisePadController sharedController] getBarcodeCommand:barcodeDataDict];
    if ([barcode128 length] > 0){
        [receiptData appendData:[self hexStringToBytes:barcode128]];
        [receiptData appendData:[self hexStringToBytes:[self asciiToHexString:barcodeDataString]]];
    }else{
        NSLog(@"Error - Barcode (Code 128) data too long");
    }
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    
    //--- Print Unicde ---
    [receiptData appendData:[self hexStringToBytes:@"1B4500"]]; //emphasize mode off
    [receiptData appendData:[self hexStringToBytes:@"1C284102003000"]]; //Set unicode font 24x24
    //[receiptData appendData:[self hexStringToBytes:@"1C284102003001"]]; //Set unicode font 16x16
    //[receiptData appendData:[self hexStringToBytes:[NSString stringWithFormat:@"1D21%d%d", 1, 1]]];
    [receiptData appendData:[self hexStringToBytes:[NSString stringWithFormat:@"1D21%d%d", 0, 0]]]; //Set scale factor to 0, 0
    
    [receiptData appendData:[self hexStringToBytes:[[WisePadController sharedController] getUnicodeCommand:@"谢谢"]]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    
    [receiptData appendData:[self hexStringToBytes:[[WisePadController sharedController] getUnicodeCommand:@"Cảm ơn Tạm biệt"]]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    [receiptData appendData:[self hexStringToBytes:printCmd_NEW_LINE]];
    
    
    //[receiptData appendData:[self hexStringToBytes:@""]];
    //[receiptData appendData:[self hexStringToBytes:printCmd_]];
    [receiptData appendData:[self hexStringToBytes:printCmd_POWER_OFF]];
    return receiptData;
}

- (NSString *)asciiToHexString:(NSString *)asciiString{
    NSString *hexString = @"";
    for (int i=0; i<[asciiString length]; i++) {
        char loopChar = [asciiString characterAtIndex:i];
        hexString = [NSString stringWithFormat:@"%@%02X", hexString, loopChar];
    }
    return hexString;
}

#pragma mark - Utility
- (NSData *)getPrintDataWithString:(NSString *)stringData{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    return [stringData dataUsingEncoding:enc];
}

- (NSData *) hexStringToBytes:(NSString *)hexString {
    if ([hexString length] % 2 != 0){
        hexString = [NSString stringWithFormat:@"0%@", hexString];
    }
    
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= [hexString length]; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [hexString substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return [NSData dataWithData:data];
}

#pragma mark -

- (IBAction)btnAction_InjectSessionKey:(id)sender{
    NSLog(@"btnAction_InjectSessionKey");
    lblGeneralData.text = @"Injecting session key ...";
    
    //Inject PIN SK
    //    NSDictionary *pinKeyData = [NSDictionary dictionaryWithObjectsAndKeys:
    //                                @"e2dbf801f67eecd5c7c29d70b3716684", @"encSK",
    //                                @"c257cc", @"kcv",
    //                                [NSNumber numberWithInt:1], @"index", nil];
    
    NSDictionary *pinKeyData = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"f4d9f6b0756a9b02", @"encSK",
                                @"418d60", @"kcv",
                                [NSNumber numberWithInt:1], @"index", nil]; //8 byte SK
    
    //    //Inject PIN SK
    //    NSDictionary *emvKeyData = [NSDictionary dictionaryWithObjectsAndKeys:
    //                                @"c4febc83574923d7c7c29d70b3716684", @"encSK",
    //                                @"d20acd", @"kcv",
    //                                [NSNumber numberWithInt:2], @"index", nil];
    //
    //    //Inject PIN SK
    //    NSDictionary *trackKeyData = [NSDictionary dictionaryWithObjectsAndKeys:
    //                                  @"ca3a6cb61a154768c7c29d70b3716684", @"encSK",
    //                                  @"07a795", @"kcv",
    //                                  [NSNumber numberWithInt:3], @"index", nil];
    //
    //    //Inject PIN SK
    //    NSDictionary *macKeyData = [NSDictionary dictionaryWithObjectsAndKeys:
    //                                @"9fc958d8a242dc89c7c29d70b3716684", @"encSK",
    //                                @"7ab90a", @"kcv",
    //                                [NSNumber numberWithInt:4], @"index", nil];
    
    [[WisePadController sharedController] injectSessionKey:pinKeyData];
    
}

- (void)onWisePadReturnInjectSessionKeyResult:(BOOL)isSuccess{
    NSLog(@"onWisePadReturnInjectSessionKeyResult - isSuccess: %d", isSuccess);
    lblGeneralData.text = [NSString stringWithFormat:@"onWisePadReturnInjectSessionKeyResult - isSuccess: %d", isSuccess];
}

#pragma mark - Terminal Setting
- (IBAction)btnAction_UpdateTerminalSetting:(id)sender{
    NSLog(@"btnAction_UpdateTerminalSetting");
    lblGeneralData.text = @"Update terminal setting ...";
    NSString *input = _txtTerminalSettingTLV.text;
    NSLog(@"input: %@", input);
    [[WisePadController sharedController] updateTerminalSetting:input];
}

- (void)onWisePadReturnUpdateTerminalSettingResult:(WisePadTerminalSettingStatus)status{
    NSLog(@"onWisePadReturnUpdateTerminalSettingResult - status: %d", status);
    switch (status) {
        case WisePadTerminalSettingStatus_Success:{
            lblGeneralData.text = @"Update Success";
            break;}
        case WisePadTerminalSettingStatus_InvalidTlvFormat:{
            lblGeneralData.text = @"InvalidTlvFormat";
            break;}
        case WisePadTerminalSettingStatus_TagNotFound:{
            lblGeneralData.text = @"TagNotFound";
            break;}
        case WisePadTerminalSettingStatus_IncorrectLength:{
            lblGeneralData.text = @"IncorrectLength";
            break;}
        case WisePadTerminalSettingStatus_BootLoaderNotSupported:{
            lblGeneralData.text = @"BootLoaderNotSupported";
            break;}
        default:{
            break;}
    }
}

- (IBAction)btnAction_ReadTerminalSetting:(id)sender{
    NSLog(@"btnAction_UpdateTerminalSetting");
    lblGeneralData.text = @"Read terminal setting ...";
    NSString *input = _txtReadTerminalSetting.text;
    NSLog(@"input: %@", input);
    [[WisePadController sharedController] readTerminalSetting:input];
}

- (void)onWisePadReturnReadTerminalSettingResult:(WisePadTerminalSettingStatus)status tagValue:(NSString *)tagValue{
    NSLog(@"onWisePadReturnReadTerminalSettingResult - status: %d, tagValue: %@", status, tagValue);
    switch (status) {
        case WisePadTerminalSettingStatus_Success:{
            lblGeneralData.text = [NSString stringWithFormat:@"Tag value: %@", tagValue];
            break;}
        case WisePadTerminalSettingStatus_InvalidTlvFormat:{
            lblGeneralData.text = @"WisePadTerminalSettingStatus_InvalidTlvFormat";
            break;}
        case WisePadTerminalSettingStatus_TagNotFound:{
            lblGeneralData.text = @"WisePadTerminalSettingStatus_TagNotFound";
            break;}
        case WisePadTerminalSettingStatus_IncorrectLength:{
            lblGeneralData.text = @"WisePadTerminalSettingStatus_IncorrectLength";
            break;}
        case WisePadTerminalSettingStatus_BootLoaderNotSupported:{
            lblGeneralData.text = @"WisePadTerminalSettingStatus_BootLoaderNotSupported";
            break;}
        default:{
            break;}
    }
}

#pragma mark - APDU
- (IBAction)btnAction_PowerOnIcc:(id)sender{
    NSLog(@"btnAction_PowerOnIcc");
    lblGeneralData.text = @"Power on ICC ...";
    [self appendDataToGeneralDataView:@"powerOnIcc"];
    [[WisePadController sharedController] powerOnIcc];
}

- (void)onWisePadReturnPowerOnIccResult:(BOOL)isSuccess
                                    ksn:(NSString *)ksn
                                    atr:(NSString *)atr
                              atrLength:(int)atrLength{
    NSLog(@"onWisePadReturnPowerOnIccResult - isSuccess: %d, atr: %@, atrLength: %d, ksn: %@", isSuccess, atr, atrLength, ksn);
    [self appendDataToGeneralDataView:@"onReturnPowerOnIccResult"];
    self.apduKsn = ksn;
    if (isSuccess){
        lblGeneralData.text = @"PowerOnIcc success.";
        lblGeneralData.text = [NSString stringWithFormat:@"%@\nATR: %@", lblGeneralData.text, atr];
    }else{
        lblGeneralData.text = @"PowerOnIcc failed.";
    }
}

- (IBAction)btnAction_PowerOffIcc:(id)sender{
    NSLog(@"btnAction_PowerOffIcc");
    lblGeneralData.text = @"Power off ICC ...";
    [self appendDataToGeneralDataView:@"powerOffIcc"];
    [[WisePadController sharedController] powerOffIcc];
}

- (void)onWisePadReturnPowerOffIccResult:(BOOL)isSuccess{
    NSLog(@"onWisePadReturnPowerOffIccResult - isSuccess: %d", isSuccess);
    [self appendDataToGeneralDataView:@"onReturnPowerOffIccResult"];
    if (isSuccess){
        lblGeneralData.text = @"PowerOffIcc success.";
    }else{
        lblGeneralData.text = @"PowerOffIcc failed.";
    }
}

- (IBAction)btnAction_SendApdu:(id)sender{
    NSLog(@"btnAction_SendApdu");
    lblGeneralData.text = @"Sending APDU ...";
    if ([_txtApdu.text length] == 0 ||
        [_txtApduLength.text length] == 0){
        lblGeneralData.text = @"APDU input is empty.";
    }else{
        NSString *apduInput = _txtApdu.text;
        int apduLength = [_txtApduLength.text intValue];
        NSLog(@"apduInput: %@, apduLength: %d", apduInput, apduLength);
        [self appendDataToGeneralDataView:[NSString stringWithFormat:@"sendApdu:%@ apduLength:%d", apduInput, apduLength]];
        [[WisePadController sharedController] sendApdu:apduInput
                                            apduLength:apduLength];
    }
}

- (IBAction)btnAction_SendApduWithPkcs7Padding:(id)sender{
    NSLog(@"btnAction_SendApduWithPkcs7Padding");
    lblGeneralData.text = @"Sending APDU with PKCS7 ...";
    NSString *apduInput = _txtApdu.text; //7561F6478439E859 //00CA0000
    NSLog(@"apduInput: %@", apduInput);
    [[WisePadController sharedController] sendApduWithPkcs7Padding:apduInput];
}

- (void)onWisePadReturnApduResult:(BOOL)isSuccess
                             apdu:(NSString *)apdu
                       apduLength:(int)apduLength{
    NSLog(@"onReturnApduResult - isSuccess: %d, apdu: %@, apduLength: %d", isSuccess, apdu, apduLength);
    [self appendDataToGeneralDataView:@"onReturnApduResult"];
    if (isSuccess){
        lblGeneralData.text = @"ReturnApduResult success.";
    }else{
        lblGeneralData.text = @"ReturnApduResult failed.";
    }
    lblGeneralData.text = [NSString stringWithFormat:@"%@\nAPDU: %@\nLength: %d", lblGeneralData.text, apdu, apduLength];
}

- (void)onWisePadReturnApduResultWithPkcs7Padding:(BOOL)isSuccess
                                             apdu:(NSString *)apdu{
    NSLog(@"onReturnApduResultWithPkcs7Padding - isSuccess: %d, apdu: %@", isSuccess, apdu);
    if (isSuccess){
        lblGeneralData.text = @"onReturnApduResultWithPkcs7Padding success.";
    }else{
        lblGeneralData.text = @"onReturnApduResultWithPkcs7Padding failed.";
    }
    lblGeneralData.text = [NSString stringWithFormat:@"%@\nAPDU: %@", lblGeneralData.text, apdu];
}

#pragma mark - APDU (VIPOS)
- (IBAction)btnAction_viposExchangeApdu:(id)sender{
    lblGeneralData.text = @"Exchange APDU ...";
    NSString *apduInput = @"00a404000fa0000003334355502d4d4f42494c45";
    NSLog(@"[[WisePadController sharedController] exchangeApdu:...] with input: %@", apduInput);
    [[WisePadController sharedController] viposExchangeApdu:apduInput];
}

- (void)onWisePadReturnViposExchangeApduResult:(NSString *)apdu{
    NSLog(@"onWisePadReturnViposExchangeApduResult - apdu: %@", apdu);
    lblGeneralData.text = [NSString stringWithFormat:@"APDU: %@", apdu];
}

- (IBAction)btnAction_viposBatchExchangeApdu:(id)sender{
    lblGeneralData.text = @"Batch Exchange APDU ...";
    NSString *dateTimeString = @"20130307111735";
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    
    [dataDict setObject:[NSArray arrayWithObjects:@"13", dateTimeString, @"80FA00001036323030313030303336333436343132", nil] forKey:[NSNumber numberWithInt:1]];
    [dataDict setObject:[NSArray arrayWithObjects:@"14", dateTimeString, @"80FA00000806111111FFFFFFFF", nil] forKey:[NSNumber numberWithInt:2]];
    [dataDict setObject:[NSArray arrayWithObjects:@"15", dateTimeString, @"80FA070078000000000000000032303133303330353130313832392045444431383830353444354431443644363734464432453744423537313131462033373645423034414531323046343333463335304143413044323131423333353839313030303046203836424330373945414443423136333230313030800000", nil] forKey:[NSNumber numberWithInt:3]];
    [dataDict setObject:[NSArray arrayWithObjects:@"15", dateTimeString, @"80FA030078000000000000000032303133303330353130313832392045444431383830353444354431443644363734464432453744423537313131462033373645423034414531323046343333463335304143413044323131423333353839313030303046203836424330373945414443423136333230313030800000", nil] forKey:[NSNumber numberWithInt:4]];
    [dataDict setObject:[NSArray arrayWithObjects:@"15", dateTimeString, @"80FA0700F0000000000000000032303135303132313134313734302030373237364534354639374235333735413441364232464334463344393432432030443444363245303042314242363444203338394144394245374436433033323720373031393934313537443130313233373939374644394545343334313334373120413431344235464643334533304546302031423133453134323634454130373735314336443834394231374133434331432032393130303637333841413834423538454144333031303232303030303030462036443843353737354441413839453435303130302033393844303233314537394245", nil] forKey:[NSNumber numberWithInt:5]];
    
    NSLog(@"[[WisePadController sharedController] viposBatchExchangeApdu:...];");
    [[WisePadController sharedController] viposBatchExchangeApdu:[NSDictionary dictionaryWithDictionary:dataDict]];
}

- (void)onWisePadReturnViposBatchExchangeApduResult:(NSDictionary *)data{
    NSLog(@"onWisePadReturnViposBatchExchangeApduResult - data: %@", data);
    lblGeneralData.text = @"onWisePadReturnViposBatchExchangeApduResult";
    
    NSString *dataString = @"";
    NSArray *keys = [data allKeys];
    for (NSString *loopKey in keys) {
        dataString = [NSString stringWithFormat:@"%@\n%@: %@", dataString, loopKey, [data objectForKey:loopKey]];
    }
    [self displayLongData:dataString];
}

#pragma mark - OTA

#if kWithOTAController

- (BOOL)initOTAController{
    NSLog(@"[[BBDeviceOTAController sharedController] getApiVersion]: %@", [[BBDeviceOTAController sharedController] getApiVersion]);
    NSLog(@"[[BBDeviceOTAController sharedController] getApiBuildNumber]: %@", [[BBDeviceOTAController sharedController] getApiBuildNumber]);
    [[BBDeviceOTAController sharedController] setDelegate:self];
    
    NSString *serverURL = @"https://tms.bbpos.com:63357/HSMKeyWebService.svc/";
    NSLog(@"serverURL: %@", serverURL);
    
    if ([[BBDeviceOTAController sharedController] setOTAServerURL:[NSURL URLWithString:serverURL]] &&
        [[BBDeviceOTAController sharedController] setBBDeviceController:[WisePadController sharedController]]){
        return YES;
    }else{
        return NO;
    }
}

- (IBAction)btnAction_OTA_UpdateConfig:(id)sender{
    NSLog(@"btnAction_OTA_UpdateConfig");
    lblGeneralData.text = @"OTA_UpdateConfig";
    if ([self initOTAController]){
        _progressViewOTA.progress = 0;
        
        
        NSMutableDictionary *inputDict = [NSMutableDictionary dictionary];
        [inputDict setObject:@"bbpos1" forKey:@"username1"];
        [inputDict setObject:@"bbpos1" forKey:@"password1"];
        [inputDict setObject:@"bbpos2" forKey:@"username2"];
        [inputDict setObject:@"bbpos2" forKey:@"password2"];
        [inputDict setObject:[NSNumber numberWithBool:[_switchOTAForceUpdate isOn]] forKey:@"forceUpdate"]; //Ignore version checking
        
        NSLog(@"[[BBDeviceOTAController sharedController] startRemoteConfigUpdateWithData: %@", inputDict);
        [[BBDeviceOTAController sharedController] startRemoteConfigUpdateWithData:inputDict];
    }
}

- (IBAction)btnAction_OTA_UpdateFirmware:(id)sender{
    NSLog(@"btnAction_OTA_UpdateFirmware");
    lblGeneralData.text = @"OTA_UpdateFirmware";
    if ([self initOTAController]){
        _progressViewOTA.progress = 0;
        
        
        NSMutableDictionary *inputDict = [NSMutableDictionary dictionary];
        [inputDict setObject:@"bbpos1" forKey:@"username1"];
        [inputDict setObject:@"bbpos1" forKey:@"password1"];
        [inputDict setObject:@"bbpos2" forKey:@"username2"];
        [inputDict setObject:@"bbpos2" forKey:@"password2"];
        [inputDict setObject:[NSNumber numberWithBool:[_switchOTAForceUpdate isOn]] forKey:@"forceUpdate"]; //Ignore version checking
        //[inputDict setObject:@"322520C074A24CE1B09ABA4999FF4689" forKey:@"otaToken"];
        
        if ([_segmentedControlOTAFirmwareType selectedSegmentIndex] == 0){
            [inputDict setObject:[NSNumber numberWithInt:BBDeviceFirmwareType_MainProcessor] forKey:@"firmwareType"];
        }else if ([_segmentedControlOTAFirmwareType selectedSegmentIndex] == 1){
            [inputDict setObject:[NSNumber numberWithInt:BBDeviceFirmwareType_Coprocessor] forKey:@"firmwareType"];
        }
        
        NSLog(@"[[BBDeviceOTAController sharedController] startRemoteFirmwareUpdateWithData: %@", inputDict);
        [[BBDeviceOTAController sharedController] startRemoteFirmwareUpdateWithData:inputDict];
    }
}

- (IBAction)btnAction_OTA_InjectKey:(id)sender{
    NSLog(@"btnAction_OTA_InjectKey");
    lblGeneralData.text = @"OTA_InjectKey";
    if ([self initOTAController]){
        _progressViewOTA.progress = 0;
        
        
        NSMutableDictionary *inputDict = [NSMutableDictionary dictionary];
        [inputDict setObject:@"bbpos1" forKey:@"username1"];
        [inputDict setObject:@"bbpos1" forKey:@"password1"];
        [inputDict setObject:@"bbpos2" forKey:@"username2"];
        [inputDict setObject:@"bbpos2" forKey:@"password2"];
        
        NSLog(@"[[BBDeviceOTAController sharedController] startRemoteKeyInjectionWithData: %@", inputDict);
        [[BBDeviceOTAController sharedController] startRemoteKeyInjectionWithData:inputDict];
    }
}

- (IBAction)btnAction_OTA_Stop:(id)sender{
    NSLog(@"btnAction_OTA_Stop");
    lblGeneralData.text = @"OTA_Stop";
    [[BBDeviceOTAController sharedController] stop];
}

- (void)onReturnOTAProgress:(float)percentage{
    NSLog(@"onReturnOTAProgress - percentage: %.2f%%", percentage);
    _progressViewOTA.progress = (percentage / 100.0);
    _lblProgressOTA.text = [NSString stringWithFormat:@"%.2f%%", percentage];
}

- (void)onReturnRemoteKeyInjectionResult:(BBDeviceOTAResult)result responseMessage:(NSString *)responseMessage{
    NSLog(@"onReturnRemoteKeyInjectionResult - BBDeviceOTAResult: %d, responseMessage: %@", result, responseMessage);
    lblGeneralData.text = [NSString stringWithFormat:@"onReturnRemoteKeyInjectionResult: %d\nmessage: %@", result, responseMessage];
    
    
}
- (void)onReturnRemoteFirmwareUpdateResult:(BBDeviceOTAResult)result responseMessage:(NSString *)responseMessage{
    NSLog(@"onReturnRemoteFirmwareUpdateResult - BBDeviceOTAResult: %d, responseMessage: %@", result, responseMessage);
    lblGeneralData.text = [NSString stringWithFormat:@"onReturnRemoteFirmwareUpdateResult: %d\nmessage: %@", result, responseMessage];
    
    
}
- (void)onReturnRemoteConfigUpdateResult:(BBDeviceOTAResult)result responseMessage:(NSString *)responseMessage{
    NSLog(@"onReturnRemoteConfigUpdateResult - BBDeviceOTAResult: %d, responseMessage: %@", result, responseMessage);
    lblGeneralData.text = [NSString stringWithFormat:@"onReturnRemoteConfigUpdateResult: %d\nmessage: %@", result, responseMessage];
    
    
}

#endif

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
    //    NSInteger voucherNo = [self.voucherNo integerValue];
    
    
    //    self.voucherNo = [NSString stringWithFormat:@"%06zd",++voucherNo];
    
    //    enterPwdVC.voucherNo = [NSString stringWithFormat:@"%06zd",++voucherNo];
    enterPwdVC.voucherNo = [AC_POSManger shareInstance].vouchNo;
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
