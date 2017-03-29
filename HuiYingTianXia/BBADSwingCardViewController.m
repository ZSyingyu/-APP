//
//  BBADSwingCardViewController.m
//  HuiYingTianXia
//
//  Created by 朱颖宇 on 15/8/24.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import "BBADSwingCardViewController.h"
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

#import "EmvSwipeController.h"
#import <QuartzCore/QuartzCore.h>
#import <sys/utsname.h>

#import "NSString+MD5HexDigest.h"
#import "MJExtension.h"

#define kNumberOfBtnView 10
#define kIsLoopTransaction 0

//----- 加密方案 61 -----
static NSString *FID61_orderID = @"30303030303030303030303030303030"; //Hardcode for testing
static NSString *FID61_randomNumber = @"000782";

//----- 加密方案 46 -----
static NSString *FID46_randomNumber = @"0001020304050607";

//----- 加密方案 65 -----
//FID 65 的 encPinKey, encDataKey, encMacKey, KCV 都是由後台加密再下发至APP
//KCV: 密钥校验值，用 明文工作密钥 加密(3DES ECB) 0000000000000000

//下例的encKey只是BBPOS内部测试用途，客户收到样品机后必须更改才能正常使用
static NSString *FID65_encPinKey = @"12042B145F8516D74F0B96AAA5A8B548C257CC0FD286CDC4";
static NSString *FID65_encDataKey = @"12042B145F8516D74F0B96AAA5A8B548C257CC0FD286CDC4";
static NSString *FID65_encMacKey = @"12042B145F8516D74F0B96AAA5A8B548C257CC0FD286CDC4";

@interface BBADSwingCardViewController ()<AC_POSMangerDelegate>
@property(nonatomic, strong)TTTAttributedLabel *labTip;

@property(strong,nonatomic)NSDictionary *cardInfo;

//@property(strong,nonatomic)UITextView *txtGeneralData;
//@property(nonatomic)CheckCardMode *tempCheckCardMode;

@end

NSString * text;
int ctrlFlag;
//bool readOldFileForiTronDevice = TRUE;

@implementation BBADSwingCardViewController

@synthesize getKsnBtn = _getKsnBtn;
@synthesize cardInfoView = _cardInfoView;


#pragma mark - @synthesize
@synthesize controller;
@synthesize EmvSwipeControllerDelegate;
@synthesize scrollView;
@synthesize pageControl;
@synthesize lblCallbackData;
@synthesize viewBtnPage1;
@synthesize viewBtnPage2;
@synthesize viewBtnPage3;
@synthesize viewBtnPage4;
@synthesize viewBtnPage5;
@synthesize viewBtnPage6;
@synthesize viewBtnPage7;
@synthesize viewBtnPage8;
@synthesize viewBtnPage9;
@synthesize viewBtnPage10;
@synthesize viewBtnPage11;
@synthesize viewBtnPage12;
@synthesize viewBtnPage20;
@synthesize lblEmvSwipeControllerState;
@synthesize lblError;
@synthesize viewTrackDataPanel;
@synthesize viewDisplayData;
@synthesize txtDisplayData;
@synthesize viewGeneralData;
@synthesize txtGeneralData;
@synthesize viewNFCData;
@synthesize lblNFCData;
@synthesize pickerSelectValue;
@synthesize lblGeneralData;
@synthesize lblApiVersionNumber;
@synthesize viewGeneralDataPanel;
@synthesize viewAmount;
@synthesize viewStatePanel;
@synthesize pickerDataSourceArray;
@synthesize pickerType;
@synthesize alertType;
@synthesize genericAlert;
@synthesize tempNfcData;
@synthesize plaintextPAN;
@synthesize felicaCommandSequence;
@synthesize debugTimer;

//NSString *machineName(){
//    struct utsname systemInfo;
//    uname(&systemInfo);
//    return [NSString stringWithCString:systemInfo.machine  encoding:NSUTF8StringEncoding];
//}


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
    
    //BBPOS
    
    [[EmvSwipeController sharedController] setDelegate:self];
    [[EmvSwipeController sharedController] setDetectDeviceChange:YES];
    
    NSLog(@"[[EmvSwipeController sharedController] startAudio];");
    if ([[EmvSwipeController sharedController] startAudio]){
//        lblGeneralData.text = @"Audio function has been started.";
        NSLog(@"开启音频");
    }else{
        //Wait onError
    }
    
    if ([[EmvSwipeController sharedController] isDevicePresent] == YES){
//        lblGeneralData.text = NSLocalizedString(@"DevicePlugged", @"");
        NSLog(@"音频插口插入");
    } else {
//        lblGeneralData.text = NSLocalizedString(@"DeviceUnplugged", @"");
        NSLog(@"音频插口未插入");
    }
    
    tempNfcData = [[NSString alloc] init];
    plaintextPAN = [[NSString alloc] init];
    felicaCommandSequence = [[NSMutableArray alloc] init];
    debugTimer = [[NSDate alloc] init];

    if ([[[EmvSwipeController sharedController] getIntegratedApiVersion] count] > 1){
        NSLog(@"[[EmvSwipeController sharedController] getIntegratedApiVersion]: %@", [[EmvSwipeController sharedController] getIntegratedApiVersion]);
        NSLog(@"[[EmvSwipeController sharedController] getIntegratedApiBuildNumber]: %@", [[EmvSwipeController sharedController] getIntegratedApiBuildNumber]);
    }
    
    [self getKsn];
    
}

- (void)getKsn{
    [self appendDataToGeneralDataView:@"getKsn"];
    [[EmvSwipeController sharedController] getKsn];
}

- (void)appendDataToGeneralDataView:(NSString *)data{
    //viewGeneralData.hidden = NO;
    [self.txtGeneralData setText:[NSString stringWithFormat:@"%@\n%@", self.txtGeneralData.text, data]];
    [self.txtGeneralData scrollRangeToVisible:NSMakeRange([self.txtGeneralData.text length], 0)];
    NSLog(@"data:%@",data);
}

- (void)onReturnDeviceInfo:(NSDictionary *)deviceInfoDict{
    NSLog(@"onReturnDeviceInfo - deviceInfoDict: %@", deviceInfoDict);
    [self appendDataToGeneralDataView:@"onReturnDeviceInfo"];
    
    
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

}

- (void)onReturnKsn:(NSDictionary *)ksnDict{
    NSLog(@"onReturnKsn - ksnDict: %@", ksnDict);
    [self appendDataToGeneralDataView:@"onReturnKsn"];
    if (ksnDict == nil){
        lblGeneralData.text = @"No KSN";
    }else{
        lblGeneralData.text = @"onReturnKsn";
        txtDisplayData.text = [NSString stringWithFormat:@"PinKsn: %@\nTrackKsn: %@\nEmvKsn: %@\nUID: %@\nCSN: %@\n",
                               [ksnDict objectForKey:@"pinKsn"],
                               [ksnDict objectForKey:@"trackKsn"],
                               [ksnDict objectForKey:@"emvKsn"],
                               [ksnDict objectForKey:@"uid"],
                               [ksnDict objectForKey:@"csn"]];
        viewDisplayData.hidden = NO;
    }
    
    NSString *ksn = [NSString stringWithFormat:@"%@",[ksnDict objectForKey:@"pinKsn"]];
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

- (void)startEmv {
    lblError.text = @"";
    self.pickerType = @"";
    
//    [self clearCardDataLabel];
    [self hideStartButton];
    [self hideTrackDataPanel];
    [self hideTlvPanel];
    
    txtGeneralData.text = @"";
    self.lblPlainTextPAN.text = @"";
    
    [self appendDataToGeneralDataView:@"checkCard"];
    lblGeneralData.text = NSLocalizedString(@"Processing", @"");
    
    NSLog(@"[[EmvSwipeController sharedController] startEmv:EmvOption_StartWithForceOnline];");
    [[EmvSwipeController sharedController] startEmv:EmvOption_StartWithForceOnline];

}

- (void)checkCardWithData{
    NSMutableDictionary *inputDict = [NSMutableDictionary dictionary];
    [inputDict setObject:[NSNumber numberWithInt:[self getTimeoutValue_checkCardTimeout]] forKey:@"checkCardTimeout"];
    if ([self isFormatID61]){
        [inputDict setObject:FID61_orderID forKey:@"orderID"];
        [inputDict setObject:FID61_randomNumber forKey:@"randomNumber"];
    }
    if ([self isFormatID46]){
        [inputDict setObject:FID46_randomNumber forKey:@"randomNumber"];
    }
    if ([self isFormatID65]){
        [inputDict setObject:FID65_encPinKey forKey:@"encPinKey"];
        [inputDict setObject:FID65_encDataKey forKey:@"encDataKey"];
        [inputDict setObject:FID65_encMacKey forKey:@"encMacKey"];
    }
    
//    if ([_switchAddCheckCardModeInput isOn]){
        CheckCardMode tempCheckCardMode = CheckCardMode_SwipeOrInsert;
        
        switch ([_segmentedControlCheckCardMode selectedSegmentIndex]) {
            case 0:{
                tempCheckCardMode = CheckCardMode_Swipe;
                break;}
            case 1:{
                tempCheckCardMode = CheckCardMode_Insert;
                break;}
            case 2:{
                tempCheckCardMode = CheckCardMode_Tap;
                break;}
            case 3:{
                tempCheckCardMode = CheckCardMode_SwipeOrInsert;
                break;}
            default:{
                break;}
//        }
        [inputDict setObject:[NSNumber numberWithInt:tempCheckCardMode] forKey:@"checkCardMode"];
        NSLog(@"Selected checkCardMode: %@", [self getCheckCardModeString:tempCheckCardMode]);
        
    }
    
    NSLog(@"[[EmvSwipeController sharedController] checkCard: %@", inputDict);
    [[EmvSwipeController sharedController] checkCard:[NSDictionary dictionaryWithDictionary:inputDict]];
    
//    [self startEmvWithData];
}

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

- (void)onWaitingForCard{
    //    NSLog(@"onWaitingForCard");
    
}

- (void)onWaitingForCard:(CheckCardMode)checkCardMode{
    
//    [MBProgressHUD showSuccess:@"请刷卡或插卡" toView:self.view];
    
    NSLog(@"onWaitingForCard - checkCardMode: %@", [self getCheckCardModeString:checkCardMode]);
    [self appendDataToGeneralDataView:@"onWaitingForCard"];
    
    lblGeneralData.text = [NSString stringWithFormat:@"onWaitingForCard ...\n(%@)", [self getCheckCardModeString:checkCardMode]];

}

- (NSString *)getCheckCardModeString:(CheckCardMode)checkCardMode{
    NSString *returnString = @"";
    switch (checkCardMode) {
        case CheckCardMode_Swipe:{ returnString = @"CheckCardMode_Swipe"; break; }
        case CheckCardMode_Insert:{ returnString = @"CheckCardMode_Insert"; break; }
        case CheckCardMode_Tap:{ returnString = @"CheckCardMode_Tap"; break; }
        case CheckCardMode_SwipeOrInsert:{ returnString = @"CheckCardMode_SwipeOrInsert"; break; }
        default:{ returnString = @"Unknown CheckCardMode"; break; }
    }
    return returnString;
}

- (void)onReturnCheckCardResult:(CheckCardResult)result cardDataDict:(NSDictionary *)cardDataDict{
    
    NSLog(@"onReturnCheckCardResult - result: %d", result);
    NSLog(@"onReturnCheckCardResult - cardDataDict: %@", cardDataDict);
    self.alertType = @"";
    self.lblPlainTextPAN.text = @"";
    
    self.cardInfo = @{@"cardType":@"0",
                      @"randomNumber":[cardDataDict objectForKey:@"randomNumber"],
                      @"expiryDate":[cardDataDict objectForKey:@"expiryDate"],
                      @"cardNumber":[cardDataDict objectForKey:@"PAN"],
                      @"track2":[cardDataDict objectForKey:@"encTrack2"],
                      @"track3":[cardDataDict objectForKey:@"encTrack3"]
                      };
    
    NSLog(@"cardInfo:%@",self.cardInfo);
    
    [self swingcardCallback:self.cardInfo];
    
    switch (result) {
        case CheckCardResult_SwipedCard:
        case CheckCardResult_OnlyTrack2:
        case CheckCardResult_NFC_Track2:{
//            [self resetUI];
            checkCardCounter = 0;
            
            NSString *tempDisplayString = @"";
            NSArray *keys = [[cardDataDict allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
            for (NSString *loopKey in keys) {
                tempDisplayString = [NSString stringWithFormat:@"%@\n\n%@: %@", tempDisplayString, loopKey, [cardDataDict objectForKey:loopKey]];
            }
            
            [txtDisplayData setText:tempDisplayString];
            viewDisplayData.hidden = NO;
            
            // 刷卡流程的密码处理：
            // M368：刷完卡在onReturnCheckCardResult检查serviceCode，如果serviceCode显示要PIN就调用startPinEntry，由刷卡器固件加密密码
            // M188：刷完卡在onReturnCheckCardResult检查serviceCode，如果serviceCode显示要PIN就调用encryptPIN，由刷卡器固件加密密码
            
            // 另外要注意，startPinEntry要用PAN来加密
            // 没有磁道2就没有PAN，就用不了startPinEntry
            
            // IC卡流程的密码处理：
            // M368：由固件加密密码，在Tag99返回加密的密码
            // M188：在onRequestPinEntry用sendPinEntryResult传入密码由固件加密，在Tag99返回密码密文
            
            if ([[cardDataDict objectForKey:@"serviceCode"] length] == 3){
                int serviceCodeFirstDigit = [[[cardDataDict objectForKey:@"serviceCode"] substringWithRange:NSMakeRange(0, 1)] intValue];
                int serviceCodeThirdDigit = [[[cardDataDict objectForKey:@"serviceCode"] substringWithRange:NSMakeRange(2, 1)] intValue];
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
                        break;}
                    default:{
                        break;}
                }
            }
            
            self.plaintextPAN = @"";
            if ([[cardDataDict objectForKey:@"PAN"] length] > 0){
                self.plaintextPAN = [cardDataDict objectForKey:@"PAN"];
                self.lblPlainTextPAN.text = [NSString stringWithFormat:@"PlainTextPAN: %@", [cardDataDict objectForKey:@"PAN"]];
            }
            
            lblGeneralData.text = NSLocalizedString(@"CheckCardResult_SwipedCard", @"");
            break;
        }
        case CheckCardResult_NoCard:{
            [self showStartButton];
            if (isCheckingCardPresent){
                lblGeneralData.text = @"CheckCardResult_NoCard";
            }else{
                lblGeneralData.text = NSLocalizedString(@"CheckCardResult_NoCard", @"");
            }
            break;}
        case CheckCardResult_BadSwipe:{
            lblGeneralData.text = @"CheckCardResult_BadSwipe";
            [self showStartButton];
            //            if (isCheckingCardPresent){
            //                lblGeneralData.text = @"CheckCardResult_BadSwipe";
            //            }else{
            //                lblGeneralData.text = NSLocalizedString(@"Processing", @"");
            //                [self checkCardAgainAfterBadSwipe];
            //            }
            break;}
        case CheckCardResult_NotIccCard:{
            //lblGeneralData.text = NSLocalizedString(@"CheckCardResult_NotIccCard", @"");
            [self showStartButton];
            
            //Fallback-to-swipe
            NSString *fallbackMessage = @"Invalid IC card";
            lblGeneralData.text = fallbackMessage;
            //[self checkCardWithData];
            
            break;}
        case CheckCardResult_InsertedCard:{
            //[self checkCardWithData];
            //return;
            
            if (isCheckingCardPresent){
                lblGeneralData.text = @"CheckCardResult_InsertedCard";
            }else{
                checkCardCounter = 0;
                [self hidePickerView];
                [self startEmvWithData];
                lblGeneralData.text = NSLocalizedString(@"Processing", @"");
            }
            break;}
        case CheckCardResult_NoResponse:{
            lblGeneralData.text = @"CheckCardResult_NoResponse";
            [self showStartButton];
            break;}
        case CheckCardResult_MagHeadFail:{
            lblGeneralData.text = @"CheckCardResult_MagHeadFail";
            [self showStartButton];
            break;}
        case CheckCardResult_UseIccCard:{
            lblGeneralData.text = @"CheckCardResult_UseIccCard";
            [self showStartButton];
            break;}
        case CheckCardResult_TapCardDetected:{
            lblGeneralData.text = @"CheckCardResult_NfcCardDetected";
            if (isCheckingCardPresent){
                lblGeneralData.text = @"CheckCardResult_TapCardDetected";
                [self showStartButton];
            }else{
                lblGeneralData.text = @"CheckCardResult_TapCardDetected";
                [self startEmvWithData];
            }
            break;}
        default:{
            lblGeneralData.text = NSLocalizedString(@"CheckCardResult_HardwareError", @"");
            [self showStartButton];
            break;}
    }
    
//    [self startEmvWithData];
    
}

- (void)hidePickerView{
    //NSLog(@"hidePickerView");
    
    UIView *pickerBtnView = (UIView *)[self.view viewWithTag:1002];
    pickerBtnView.hidden = YES;
    
    pickerSelectValue.hidden = YES;
    
    self.pickerType = @"";
    self.pickerDataSourceArray = [NSArray array];
}

- (void)startEmvWithData{
    NSString *terminalTime = @""; //e.g. 130108152010 (YYMMddHHmmss)
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYMMddHHmmss"];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    terminalTime = [formatter stringFromDate:[NSDate date]];
//    [formatter release];
    
    NSMutableDictionary *inputDict = [NSMutableDictionary dictionary];
//    if (isStartEmvWithTerminalTime){
        [inputDict setObject:terminalTime forKey:@"terminalTime"];
//    }
    //Timeouts are configurable [Require FW 7.11c or above]
    [inputDict setObject:[NSNumber numberWithInt:[self getTimeoutValue_checkCardTimeout]] forKey:@"checkCardTimeout"];
    [inputDict setObject:[NSNumber numberWithInt:[self getTimeoutValue_setAmountTimeout]] forKey:@"setAmountTimeout"];
    [inputDict setObject:[NSNumber numberWithInt:[self getTimeoutValue_selectApplicationTimeout]] forKey:@"selectApplicationTimeout"];
    [inputDict setObject:[NSNumber numberWithInt:[self getTimeoutValue_onlineProcessTimeout]] forKey:@"onlineProcessTimeout"];
    [inputDict setObject:[NSNumber numberWithInt:[self getTimeoutValue_finalConfirmTimeout]] forKey:@"finalConfirmTimeout"];
    [inputDict setObject:[NSNumber numberWithInt:[self getTimeoutValue_pinEntryTimeout]] forKey:@"pinEntryTimeout"]; //pinEntryTimeout is for China firmware only
    
//    [inputDict setObject:@"90" forKey:@"checkCardTimeout"];
//    [inputDict setObject:@"90" forKey:@"setAmountTimeout"];
//    [inputDict setObject:@"90" forKey:@"selectApplicationTimeout"];
//    [inputDict setObject:@"90" forKey:@"onlineProcessTimeout"];
//    [inputDict setObject:@"90" forKey:@"finalConfirmTimeout"];
//    [inputDict setObject:@"90" forKey:@"pinEntryTimeout"]; //pinEntryTimeout is for China firmware only
    
    [inputDict setObject:[NSNumber numberWithInt:EmvOption_StartWithForceOnline] forKey:@"emvOption"];
    
//    if ([_switchAddCheckCardModeInput isOn]){
        CheckCardMode tempCheckCardMode = CheckCardMode_SwipeOrInsert;
//        switch ([_segmentedControlCheckCardMode selectedSegmentIndex]) {
        switch (tempCheckCardMode) {
            case 0:{
                tempCheckCardMode = CheckCardMode_Swipe;
                break;}
            case 1:{
                tempCheckCardMode = CheckCardMode_Insert;
                break;}
            case 2:{
                tempCheckCardMode = CheckCardMode_Tap;
                break;}
            case 3:{
                tempCheckCardMode = CheckCardMode_SwipeOrInsert;
                break;}
            default:{
                break;}
        }
        [inputDict setObject:[NSNumber numberWithInt:tempCheckCardMode] forKey:@"checkCardMode"];
        NSLog(@"Selected checkCardMode: %@", [self getCheckCardModeString:tempCheckCardMode]);
//    }
    
    //Firmware 9.xx.xx.xx accept amount as startEmv input
    if (isStartEmvWithAmount){
        [inputDict setObject:@"10" forKey:@"amount"];
        [inputDict setObject:@"" forKey:@"cashbackAmount"];
        [inputDict setObject:[self getCurrencyCode] forKey:@"currencyCode"];
        
        // Goods    - 商品
        // Services - 服务
        // Cashback - 返现
        // Inquiry  - 查询
        // Transfer - 转账
        // Payment  - 付款
        // Refund   - 退款
        [inputDict setObject:[NSNumber numberWithInt:TransactionType_Goods] forKey:@"transactionType"];
    }
    
    //Input for different MK/SK encryption (Format 46, 61)
    if ([self isFormatID61]){
        [inputDict setObject:FID61_orderID forKey:@"orderID"];
        [inputDict setObject:FID61_randomNumber forKey:@"randomNumber"];
    }
    if ([self isFormatID46]){
        [inputDict setObject:FID46_randomNumber forKey:@"randomNumber"];
    }
    if ([self isFormatID65]){
        [inputDict setObject:FID65_encPinKey forKey:@"encPinKey"];
        [inputDict setObject:FID65_encDataKey forKey:@"encDataKey"];
        [inputDict setObject:FID65_encMacKey forKey:@"encMacKey"];
    }
    
    //Add additional tag to onRequestOnlineProcess, onReturnBatchData, onReturnReversalData
    //Available tags: @"4F",@"50",@"57",@"5A",@"82",@"84",@"89",@"8A",@"8E",@"95",@"99",@"9A",@"9B",@"9C",@"5F20",@"5F24",@"5F25",@"5F2A",@"5F30",@"5F34",@"9F01",@"9F02",@"9F03",@"9F06",@"9F07",@"9F09",@"9F0D",@"9F0E",@"9F0F",@"9F10",@"9F12",@"9F16",@"9F1A",@"9F1C",@"9F1E",@"9F21",@"9F26",@"9F27",@"9F33",@"9F34",@"9F35",@"9F36",@"9F37",@"9F39",@"9F40",@"9F41",@"9F4E",@"9F53",@"9F5B"
    //[inputDict setObject:[NSArray arrayWithObjects:@"4F",@"50",@"57",@"5A",@"82", nil] forKey:@"encOnlineMessageTags"];
    //[inputDict setObject:[NSArray arrayWithObjects:@"4F",@"50",@"57",@"5A",@"82", nil] forKey:@"encBatchDataTags"];
    //[inputDict setObject:[NSArray arrayWithObjects:@"4F",@"50",@"57",@"5A",@"82", nil] forKey:@"encReversalDataTags"];
    
    //Disable display text can decreease transaction time
    if ([_switchEnableDisplayText isOn]){
        [inputDict setObject:[NSNumber numberWithInt:YES] forKey:@"enableDisplayText"];
    }else{
        [inputDict setObject:[NSNumber numberWithInt:NO] forKey:@"enableDisplayText"];
    }
    if (isStartEmvWithDisabledDisplayText){
        [inputDict setObject:[NSNumber numberWithInt:NO] forKey:@"enableDisplayText"];
    }
    
    
    
    NSLog(@"[[EmvSwipeController sharedController] startEmvWithData: %@", inputDict);
    [[EmvSwipeController sharedController] startEmvWithData:inputDict];
}

- (NSString *)getCurrencyCode{
    NSString *returnCurrencyCode = @"840";
    if ([self isFormatID65]){
        returnCurrencyCode = @"156"; //CNY
    }else{
        NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
        //NSLog(@"Current language: %@", language);
        BOOL isChineseLanguage = NO;
        if ([language length] >= 2){
            if ([[[language substringWithRange:NSMakeRange(0, 2)] lowercaseString] isEqualToString:@"zh"]){
                isChineseLanguage = YES;
            }
        }
        if (isChineseLanguage){
            returnCurrencyCode = @"156"; //CNY
        }else{
            returnCurrencyCode = @"840"; //USD
        }
    }
    NSLog(@"currencyCode: %@", returnCurrencyCode);
    return returnCurrencyCode;
}

- (void)showStartButton{
    UIButton *btnStart = (UIButton *)[viewBtnPage1 viewWithTag:900];
    btnStart.hidden = NO;
}

- (void)onNoDeviceDetected {
    NSLog(@"onNoDeviceDetected");
//    [self resetUI];
    [self appendDataToGeneralDataView:@"onNoDeviceDetected"];
    lblGeneralData.text = NSLocalizedString(@"NoDeviceDetected", @"");
}

- (void)onRequestSetAmount{
    NSLog(@"onRequestSetAmount");
    [self appendDataToGeneralDataView:@"onRequestSetAmount"];
    lblGeneralData.text = NSLocalizedString(@"onRequestSetAmount", @"");
    
    [self hideStartButton];
    
//    if (isAutoSetAmount){
        [self appendDataToGeneralDataView:@"setAmount"];
        
        // Goods    - 商品
        // Services - 服务
        // Cashback - 返现
        // Inquiry  - 查询
        // Transfer - 转账
        // Payment  - 付款
        // Refund   - 退款
        
        [[EmvSwipeController sharedController] setAmount:self.tadeAmount
                                          cashbackAmount:@""
                                            currencyCode:[self getCurrencyCode]
                                         transactionType:TransactionType_Goods];
        
        //        [[EmvSwipeController sharedController] setAmount:@"0"
        //                                          cashbackAmount:@""
        //                                            currencyCode:[self getCurrencyCode]
        //                                         transactionType:TransactionType_Inquiry];
//    }else{
//        self.alertType = @"SetAmount";
//        [self popUpAlertView_SetAmount:nil];
//    }
    

}

- (void)hideStartButton{
    UIButton *btnStart = (UIButton *)[viewBtnPage1 viewWithTag:900];
    btnStart.hidden = YES;
}

- (void)popUpAlertView_SetAmount:(NSString *)errorMessage{
    NSLog(@"popUpAlertView_SetAmount");
    [self hideTrackDataPanel];
    UISegmentedControl *tempControl = (UISegmentedControl *)[self.view viewWithTag:503];
    
    int heightPadding = 0;
    NSString *message = @"";
    if ([errorMessage length]>0){
        heightPadding = 30;
        message = [NSString stringWithFormat:@"%@", errorMessage];
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

#pragma mark -- ShowHide Panel
- (void)hideTrackDataPanel{
    //NSLog(@"");
    viewTrackDataPanel.hidden = YES;
    //viewDisplayData.hidden = YES;
}

- (void)hideTlvPanel{
    //NSLog(@"");
    viewDisplayData.hidden = YES;
}

- (void)hideNFCPanel{
    //NSLog(@"");
    viewNFCData.hidden = YES;
}

- (void)showTrackDataPanelView{
    //NSLog(@"");
    viewTrackDataPanel.hidden = NO;
    viewDisplayData.hidden = YES;
}

- (void)showPickerView{
    NSLog(@"showPickerView");
    
    [pickerSelectValue reloadAllComponents];
    pickerSelectValue.hidden = NO;
    
    UIView *pickerBtnView = (UIView *)[self.view viewWithTag:1002];
    pickerBtnView.hidden = NO;
}

- (void)hideAlertView{
    //NSLog(@"hideAlertView");
    [self.genericAlert dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)cancelCheckCard{
    NSLog(@"[[EmvSwipeController sharedController] cancelCheckCard];");
    [[EmvSwipeController sharedController] cancelCheckCard];
}

- (void)onReturnCancelCheckCardResult:(BOOL)isSuccess{
    NSLog(@"onReturnCancelCheckCardResult - isSuccess: %d", isSuccess);
    lblGeneralData.text = [NSString stringWithFormat:@"onReturnCancelCheckCardResult - isSuccess: %d", isSuccess];
}

- (void)checkCardAgainAfterBadSwipe{
    isBadSwiped = YES;
    [self checkCardWithData];
}

#pragma mark -- Flow -- Select Application

- (void)onRequestSelectApplication:(NSArray *)applicationArray{
    NSLog(@"onRequestSelectApplication - applicationArray: %@", applicationArray);
    lblGeneralData.text = NSLocalizedString(@"onRequestSelectApplication", @"");
    [self appendDataToGeneralDataView:@"onRequestSelectApplication"];
    
    if (isAutoSelectApplication){
        [self appendDataToGeneralDataView:@"selectApplication:0"];
        NSLog(@"[[EmvSwipeController sharedController] selectApplication:0];");
        [[EmvSwipeController sharedController] selectApplication:0];
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

#pragma mark -- Flow -- PIN Entry

- (void)onRequestPinEntry{
    NSLog(@"onRequestPinEntry");
    lblGeneralData.text = NSLocalizedString(@"onRequestPinEntry", @"");
    [self appendDataToGeneralDataView:@"onRequestPinEntry"];
    
//    if (isAutoPinEntry){
        NSString *pin = @"4315";
        [self appendDataToGeneralDataView:[NSString stringWithFormat:@"sendPinEntryResult: %@", pin]];
        [[EmvSwipeController sharedController] sendPinEntryResult:pin];
        return;
//    }
    
    self.alertType = @"PinEntry";
    [self popUpAlertView_PinEntry];
}

#pragma mark -- Flow -- Online Server Process
- (void)onRequestCheckServerConnectivity{
    NSLog(@"onRequestCheckServerConnectivity");
    lblGeneralData.text = NSLocalizedString(@"onRequestCheckServerConnectivity", @"");
    [self appendDataToGeneralDataView:@"onRequestCheckServerConnectivity"];
    
    UISegmentedControl *tempControl = (UISegmentedControl *)[self.view viewWithTag:501];
    if (tempControl.selectedSegmentIndex==0){
        NSLog(@"sendServerConnectivity:YES");
        [self appendDataToGeneralDataView:@"sendServerConnectivity:YES"];
        [[EmvSwipeController sharedController] sendServerConnectivity:YES];
    }else{
        NSLog(@"sendServerConnectivity:NO");
        [self appendDataToGeneralDataView:@"sendServerConnectivity:NO"];
        [[EmvSwipeController sharedController] sendServerConnectivity:NO];
    }
}

- (void)onOnlineProcessDataDetected{
    NSString *callbackName = @"onOnlineProcessDataDetected";
    NSLog(@"%@", callbackName);
    [self appendDataToGeneralDataView:[NSString stringWithFormat:@"%@", callbackName]];
    lblGeneralData.text = NSLocalizedString(callbackName, @"");
}

- (void)onRequestOnlineProcess:(NSString *)tlv{
    NSLog(@"onRequestOnlineProcess: %@", tlv);
    
    if (isAutoSendOnlineProcessResult){
        [[EmvSwipeController sharedController] sendOnlineProcessResult:@"8A023030"]; //Approval
        return;
    }
    
    lblGeneralData.text = NSLocalizedString(@"onRequestOnlineProcess", @"");
    [self appendDataToGeneralDataView:[NSString stringWithFormat:@"%@ - TLV: %@\n", @"onRequestOnlineProcess", tlv]];
    
    NSDictionary *tlvDict = [[EmvSwipeController sharedController] decodeTlv:tlv];
    if ([tlvDict objectForKey:@"70"] != nil){
        tlvDict = [[EmvSwipeController sharedController] decodeTlv:[tlvDict objectForKey:@"70"]];
    }
    NSLog(@"tlvDict: %@", tlvDict);
    
    // Send TLV data to Server ...
    
    // ...
    
//    if ([self isFormatID46]){
        NSString *dcData = [[EmvSwipeController sharedController] viposGetIccData:tlv];
        NSLog(@"dcData: %@", dcData);
        NSLog(@"dcData dictionary: %@", [[EmvSwipeController sharedController] decodeTlv:dcData]);
        
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
        
        exchangeApduAfterOnRequestOnlineProcess_apduIndex = 1;
        NSString *apdu = @"801a1301082012101111245180";
        NSLog(@"[[EmvSwipeController sharedController] viposExchangeApdu:%@];", apdu);
        [[EmvSwipeController sharedController] viposExchangeApdu:apdu]; //setup key
    

        self.cardInfo = @{@"len55":[NSNumber numberWithInt:data55.length],
                          @"data55":[data55 uppercaseString],
                          @"randomNumber":dynamicKeyData,
                          @"cardSerial":ICNumber,
                          @"cardNumber":accountNumber1,
                          @"track2":track2Data,
                          @"expiryDate":[date substringToIndex:4],
                          @"cardType":@"1"
                          };
    
    [self swingcardCallback:self.cardInfo];
    
        
//        return;
//    }
    
    
    
    //[[EmvSwipeController sharedController] sendOnlineProcessResult:@"8A023030"]; //Approval
    //[[EmvSwipeController sharedController] sendOnlineProcessResult:@"8A023035"]; //Decline
    //[[EmvSwipeController sharedController] sendOnlineProcessResult:@""]; //Send empty string to cancel transaction
    
    self.pickerType = @"OnlineProcessResult";
    self.pickerDataSourceArray = [NSArray arrayWithObjects:@"8A023030 (Approval)", @"8A023035 (Decline)", nil];
    [self showPickerView];
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
    
    message = @"111111";
    
//    self.genericAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"AlertTitle_PinEntry", @"")
//                                                   message:message
//                                                  delegate:self
//                                         cancelButtonTitle:NSLocalizedString(@"AlertCancel_PinEntry", @"")
//                                         otherButtonTitles:NSLocalizedString(@"AlertBtnOk_PinEntry", @""), nil];
    
    self.genericAlert = [[UIAlertView alloc] initWithTitle:nil
                                                   message:nil
                                                  delegate:self
                                         cancelButtonTitle:NSLocalizedString(@"AlertCancel_PinEntry", @"")
                                         otherButtonTitles: nil];
    
    self.genericAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [[self.genericAlert textFieldAtIndex:0] setPlaceholder:NSLocalizedString(@"AlertPlaceHolder_PinEntry", @"")];
    [[self.genericAlert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
    [[self.genericAlert textFieldAtIndex:0] setFont:[UIFont systemFontOfSize:15]];
    
    [self.genericAlert show];
    
}

#pragma mark -- Flow -- Terminal Time

- (void)onRequestTerminalTime{
    NSLog(@"onRequestTerminalTime");
    lblGeneralData.text = NSLocalizedString(@"onRequestTerminalTime", @"");
    [self appendDataToGeneralDataView:@"onRequestTerminalTime"];
    
    NSString *terminalTime = @""; //e.g. 130108152010 (YYMMddHHmmss)
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYMMddHHmmss"];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    terminalTime = [formatter stringFromDate:[NSDate date]];
//    [formatter release];
    
    NSLog(@"sendTerminalTime: %@ (YYMMddHHmmss)", terminalTime);
    [self appendDataToGeneralDataView:[NSString stringWithFormat:@"sendTerminalTime:%@", terminalTime]];
    [[EmvSwipeController sharedController] sendTerminalTime:terminalTime];
}

#pragma mark -- Flow -- Final Confirm
- (void)onRequestFinalConfirm{
    NSLog(@"onRequestFinalConfirm");
    [self appendDataToGeneralDataView:@"onRequestFinalConfirm"];
    
    if (isAutoFinalConfirm){
        [self appendDataToGeneralDataView:@"sendFinalConfirmResult:YES"];
        [[EmvSwipeController sharedController] sendFinalConfirmResult:YES];
        return;
    }
    
    if (isCanceledPin){
        lblGeneralData.text = NSLocalizedString(@"Processing", @"");
        isCanceledPin = NO;
        [self appendDataToGeneralDataView:@"sendFinalConfirmResult:NO"];
        [[EmvSwipeController sharedController] sendFinalConfirmResult:NO];
    }else{
        lblGeneralData.text = NSLocalizedString(@"onRequestFinalConfirm", @"");
        [self popUpAlertView_FinalConfirm];
    }
}

#pragma mark -- Flow -- Check Card Status
- (void)btnAction_StartTransaction:(id)sender {
    NSLog(@"btnAction_StartTransaction");
    
    isCheckingCardPresent = NO;
    isBadSwiped = NO;
    lblError.text = @"";
    self.pickerType = @"";
    
    [self clearCardDataLabel];
    [self hideStartButton];
    //[self hideAmountView];
    [self hideTrackDataPanel];
    [self hideTlvPanel];
    
    txtGeneralData.text = @"";
    self.lblPlainTextPAN.text = @"";
    
    [self appendDataToGeneralDataView:@"checkCard"];
    lblGeneralData.text = NSLocalizedString(@"Processing", @"");
    //[[EmvSwipeController sharedController] checkCard];
    
    NSLog(@"[[EmvSwipeController sharedController] startAudio];");
    [[EmvSwipeController sharedController] startAudio];
    
    //Firmware that support NFC can input checkCardMode in startEmv, can skip calling checkCard to reduce transaction time
    switch ([_segmentedControlCheckCardMode selectedSegmentIndex]) {
        case 2:{ //CheckCardMode_Tap
            [self startEmvWithData];
            break;}
        default:{
            [self checkCardWithData];
            break;}
    }
}

#pragma mark -- Flow -- Output Transaction Result
- (void)onReturnTransactionResult:(TransactionResult)result data:(NSDictionary *)data{
    NSLog(@"onReturnTransactionResult - result: %d, data: %@ \n\n\n", result, data);
    
    if (kIsLoopTransaction){
        [self btnAction_StartTransaction:nil];
        return;
    }
    
    [self appendDataToGeneralDataView:[NSString stringWithFormat:@"onReturnTransactionResult - Result:%d \n\n", result]];
    
    //When the alert or picker appear and received transaction result, could be timeout
    [self hideAlertView];
    [self hidePickerView];
    self.alertType = @"";
    lblGeneralData.text = NSLocalizedString(@"onReturnTransactionResult", @"");
    
    switch (result) {
        case TransactionResult_Approved:
            [self popUpAlertView_General:NSLocalizedString(@"TransactionResult", @"") alertMsg:NSLocalizedString(@"TransactionApproved", @"") cancelBtnText:NSLocalizedString(@"AlertBtnOk_General", @"")];
            break;
        case TransactionResult_Terminated:
            [self popUpAlertView_General:NSLocalizedString(@"TransactionResult", @"") alertMsg:NSLocalizedString(@"TransactionTerminated", @"") cancelBtnText:NSLocalizedString(@"AlertBtnOk_General", @"")];
            break;
        case TransactionResult_Declined:
            [self popUpAlertView_General:NSLocalizedString(@"TransactionResult", @"") alertMsg:NSLocalizedString(@"TransactionDeclined", @"") cancelBtnText:NSLocalizedString(@"AlertBtnOk_General", @"")];
            break;
        case TransactionResult_SetAmountCancelOrTimeout:
            [self popUpAlertView_General:NSLocalizedString(@"TransactionResult", @"") alertMsg:@"TransactionResult_SetAmountCancelOrTimeout" cancelBtnText:NSLocalizedString(@"AlertBtnOk_General", @"")];
            break;
        case TransactionResult_CapkFail:
            [self popUpAlertView_General:NSLocalizedString(@"TransactionResult", @"") alertMsg:@"TransactionResult_CapkFail" cancelBtnText:NSLocalizedString(@"AlertBtnOk_General", @"")];
            break;
        case TransactionResult_NotIcc:
            [self popUpAlertView_General:NSLocalizedString(@"TransactionResult", @"") alertMsg:@"TransactionResult_NotIcc" cancelBtnText:NSLocalizedString(@"AlertBtnOk_General", @"")];
            break;
        case TransactionResult_CardBlocked:
            [self popUpAlertView_General:NSLocalizedString(@"TransactionResult", @"") alertMsg:@"TransactionResult_CardBlocked" cancelBtnText:NSLocalizedString(@"AlertBtnOk_General", @"")];
            break;
        case TransactionResult_DeviceError:
            [self popUpAlertView_General:NSLocalizedString(@"TransactionResult", @"") alertMsg:@"TransactionResult_DeviceError" cancelBtnText:NSLocalizedString(@"AlertBtnOk_General", @"")];
            break;
        case TransactionResult_CardNotSupported:
            [self popUpAlertView_General:NSLocalizedString(@"TransactionResult", @"") alertMsg:@"TransactionResult_CardNotSupported" cancelBtnText:NSLocalizedString(@"AlertBtnOk_General", @"")];
            break;
        case TransactionResult_MissingMandatoryData:
            [self popUpAlertView_General:NSLocalizedString(@"TransactionResult", @"") alertMsg:@"TransactionResult_MissingMandatoryData" cancelBtnText:NSLocalizedString(@"AlertBtnOk_General", @"")];
            break;
        case TransactionResult_NoEmvApps:
            [self popUpAlertView_General:NSLocalizedString(@"TransactionResult", @"") alertMsg:@"TransactionResult_NoEmvApps" cancelBtnText:NSLocalizedString(@"AlertBtnOk_General", @"")];
            break;
        case TransactionResult_InvalidIccData:
            [self popUpAlertView_General:NSLocalizedString(@"TransactionResult", @"") alertMsg:@"TransactionResult_InvalidIccData" cancelBtnText:NSLocalizedString(@"AlertBtnOk_General", @"")];
            break;
        case TransactionResult_ConditionsOfUseNotSatisfied:
            [self popUpAlertView_General:NSLocalizedString(@"TransactionResult", @"") alertMsg:@"TransactionResult_ConditionsOfUseNotSatisfied" cancelBtnText:NSLocalizedString(@"AlertBtnOk_General", @"")];
            break;
        case TransactionResult_ApplicationBlocked:
            [self popUpAlertView_General:NSLocalizedString(@"TransactionResult", @"") alertMsg:@"TransactionResult_ApplicationBlocked" cancelBtnText:NSLocalizedString(@"AlertBtnOk_General", @"")];
            break;
        case TransactionResult_IccCardRemoved:
            [self popUpAlertView_General:NSLocalizedString(@"TransactionResult", @"") alertMsg:@"TransactionResult_IccCardRemoved" cancelBtnText:NSLocalizedString(@"AlertBtnOk_General", @"")];
            break;
        default:
            [self popUpAlertView_General:NSLocalizedString(@"TransactionResult", @"") alertMsg:@"Uncatched ENUM" cancelBtnText:NSLocalizedString(@"AlertBtnOk_General", @"")];
            break;
    }
    
    
}

#pragma mark - UIAlertView - PopUp
- (void)popUpAlertView_General:(NSString *)alertTitle
                      alertMsg:(NSString *)alertMsg
                 cancelBtnText:(NSString *)cancelBtnText{
    //NSLog(@"popUpAlertView_General");
    [self hideTrackDataPanel];
    self.genericAlert = [[UIAlertView alloc] initWithTitle:alertTitle
                                                   message:alertMsg
                                                  delegate:self
                                         cancelButtonTitle:cancelBtnText
                                         otherButtonTitles:nil, nil];
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

#pragma mark -- Flow -- Callback with TLV data
- (void)onReversalDataDetected{
    NSString *callbackName = @"onReversalDataDetected";
    NSLog(@"%@", callbackName);
    [self appendDataToGeneralDataView:[NSString stringWithFormat:@"%@", callbackName]];
    lblGeneralData.text = NSLocalizedString(callbackName, @"");
}

- (void)onReturnReversalData:(NSString *)tlv{
    NSString *callbackName = @"onReturnReversalData";
    NSLog(@"%@: %@", callbackName, tlv);
    [self appendDataToGeneralDataView:[NSString stringWithFormat:@"%@ - TLV: %@\n", callbackName, tlv]];
    lblGeneralData.text = NSLocalizedString(callbackName, @"");
    [self displayDataOnScrollTextView:[NSString stringWithFormat:@"Reversal data:\n%@", tlv]];
}

- (void)onBatchDataDetected{
    NSString *callbackName = @"onBatchDataDetected";
    NSLog(@"%@", callbackName);
    [self appendDataToGeneralDataView:[NSString stringWithFormat:@"%@", callbackName]];
    lblGeneralData.text = NSLocalizedString(callbackName, @"");
}

- (void)onReturnBatchData:(NSString *)tlv{
    NSString *callbackName = @"onReturnBatchData";
    NSLog(@"%@: %@", callbackName, tlv);
    lblGeneralData.text = NSLocalizedString(callbackName, @"");
    [self displayLongData:[NSString stringWithFormat:@"Batch data:\n%@", tlv]];
    
    if (kIsLoopTransaction){
        return;
    }
    
    NSDictionary *decodeTlvDict = [[EmvSwipeController sharedController] decodeTlv:tlv];
    NSLog(@"decodeTlvDict: %@", decodeTlvDict);
}

- (void)displayLongData:(NSString *)tlv{
    viewDisplayData.hidden = NO;
    txtDisplayData.text = [NSString stringWithFormat:@"%@", tlv];
}

- (void)displayDataOnScrollTextView:(NSString *)data{
   
    viewDisplayData.hidden = NO;
    
    [txtDisplayData setText:[NSString stringWithFormat:@"%@", data]];
    
}

- (void)clearGeneralDataView{
    [txtGeneralData setText:@""];
}


- (void)hideGeneralDataView{
    viewGeneralData.hidden = YES;
}

#pragma mark -- Flow -- Display Message
- (void)onRequestDisplayText:(DisplayText)displayMessage{
    //NSLog(@"onRequestDisplayText: %d", displayMessage);
    
    NSString *strDisplayMessage = @"";
    switch (displayMessage) {
        case DisplayText_AMOUNT:
            strDisplayMessage = @"Please input amount";
            break;
        case DisplayText_AMOUNT_OK_OR_NOT:
            strDisplayMessage = @"Confirm amount?";
            break;
        case DisplayText_APPROVED:
            strDisplayMessage = @"Approved";
            break;
        case DisplayText_CALL_YOUR_BANK:
            strDisplayMessage = @"Please call your bank";
            break;
        case DisplayText_CANCEL_OR_ENTER:
            strDisplayMessage = @"CANCEL_OR_ENTER";
            break;
        case DisplayText_CARD_ERROR:
            strDisplayMessage = @"Card error";
            break;
        case DisplayText_DECLINED:
            strDisplayMessage = @"Declined";
            break;
        case DisplayText_ENTER_AMOUNT:
            strDisplayMessage = @"Please input amount";
            break;
        case DisplayText_ENTER_PIN:
            strDisplayMessage = @"Please enter PIN";
            break;
        case DisplayText_INCORRECT_PIN:
            strDisplayMessage = @"Incorrect PIN";
            isWrongPin = YES;
            break;
        case DisplayText_INSERT_CARD:
            strDisplayMessage = @"Please insert card";
            lblGeneralData.text = NSLocalizedString(@"EmvMsg_InsertCard", @"");
            break;
        case DisplayText_NOT_ACCEPTED:
            strDisplayMessage = @"Not accepted";
            break;
        case DisplayText_PIN_OK:
            strDisplayMessage = @"PIN entry is correct";
            isWrongPin = NO;
            break;
        case DisplayText_PLEASE_WAIT:
            strDisplayMessage = @"Please wait ...";
            break;
        case DisplayText_PROCESSING_ERROR:
            strDisplayMessage = @"Processing error";
            break;
        case DisplayText_REMOVE_CARD:
            strDisplayMessage = @"Please remove card.";
            //lblGeneralData.text = NSLocalizedString(@"EmvMsg_RemoveCard", @"");
            break;
        case DisplayText_USE_CHIP_READER:
            strDisplayMessage = @"USE_CHIP_READER";
            break;
        case DisplayText_USE_MAG_STRIPE:
            strDisplayMessage = @"USE_MAG_STRIPE";
            break;
        case DisplayText_TRY_AGAIN:
            strDisplayMessage = @"Please try again";
            break;
        case DisplayText_REFER_TO_YOUR_PAYMENT_DEVICE:
            strDisplayMessage = @"REFER_TO_YOUR_PAYMENT_DEVICE";
            break;
        case DisplayText_TRANSACTION_TERMINATED:
            strDisplayMessage = @"Transaction terminated.";
            break;
        case DisplayText_TRY_ANOTHER_INTERFACE:
            strDisplayMessage = @"Please try another interface.";
            break;
        case DisplayText_ONLINE_REQUIRED:
            strDisplayMessage = @"ONLINE_REQUIRED";
            break;
        case DisplayText_PROCESSING:
            strDisplayMessage = @"Processing ...";
            break;
        case DisplayText_WELCOME:
            strDisplayMessage = @"Welcome";
            break;
        case DisplayText_PRESENT_ONLY_ONE_CARD:
            strDisplayMessage = @"PRESENT_ONLY_ONE_CARD";
            break;
        case DisplayText_LAST_PIN_TRY:
            strDisplayMessage = @"Last PIN try.";
            break;
        case DisplayText_CAPK_LOADING_FAILED:{
            strDisplayMessage = @"CAPK_LOADING_FAILED";
            break;}
        case DisplayText_SELECT_ACCOUNT:{
            strDisplayMessage = @"SELECT_ACCOUNT";
            break;}
        case DisplayText_INSERT_OR_TAP_CARD:{
            strDisplayMessage = @"INSERT_OR_TAP_CARD";
            break;}
        case DisplayText_APPROVED_PLEASE_SIGN:{
            strDisplayMessage = @"APPROVED_PLEASE_SIGN";
            break;}
        case DisplayText_TAP_CARD_AGAIN:{
            strDisplayMessage = @"TAP_CARD_AGAIN";
            break;}
        case DisplayText_AUTHORISING:{
            strDisplayMessage = @"AUTHORISING";
            break;}
        case DisplayText_INSERT_OR_SWIPE_CARD_OR_TAP_ANOTHER_CARD:{
            strDisplayMessage = @"INSERT_OR_SWIPE_CARD_OR_TAP_ANOTHER_CARD";
            break;}
        case DisplayText_INSERT_OR_SWIPE_CARD:{
            strDisplayMessage = @"INSERT_OR_SWIPE_CARD";
            break;}
        case DisplayText_MULTIPLE_CARDS_DETECTED:{
            strDisplayMessage = @"MULTIPLE_CARDS_DETECTED";
            break;}
        default:{
            break;}
    }
    [self appendDataToGeneralDataView:[NSString stringWithFormat:@"onRequestDisplayText - %@", strDisplayMessage]];
    
    NSLog(@"****** onRequestDisplayText: %@", strDisplayMessage);
    
    lblGeneralData.text = strDisplayMessage;
}

- (void)onRequestClearDisplay{
    NSLog(@"onRequestClearDisplay");
    [self appendDataToGeneralDataView:@"onRequestClearDisplay"];
    //lblGeneralData.text = @"";
}

#pragma mark -- Flow -- Low Battery Warning
- (void)onBatteryLow:(BatteryStatus)batteryStatus{
    NSLog(@"onBatteryLow - batteryStatus: %d", batteryStatus);
    [self appendDataToGeneralDataView:[NSString stringWithFormat:@"onBatteryLow - batteryStatus:%d", batteryStatus]];
    if (batteryStatus == BatteryStatus_Low){
        lblGeneralData.text = NSLocalizedString(@"onBatteryLow_LowBattery", @"");
        lblError.text = NSLocalizedString(@"onBatteryLow_LowBattery", @"");
    }else if (batteryStatus == BatteryStatus_CriticallyLow){
//        [self resetUI];
        lblGeneralData.text = NSLocalizedString(@"onBatteryLow_VeryLowBattery", @"");
        lblError.text = NSLocalizedString(@"onBatteryLow_VeryLowBattery", @"");
    }
}

- (void)encryptPin{
    NSLog(@"btnAction_EncryptPin");
    
    [_txtPINForEncryptPIN resignFirstResponder];
    [_txtPANForEncryptPIN resignFirstResponder];
    
    NSMutableDictionary *inputDict = [NSMutableDictionary dictionary];
    [inputDict setObject:_txtPANForEncryptPIN.text forKey:@"pan"];
    [inputDict setObject:_txtPINForEncryptPIN.text forKey:@"pin"];
    if ([self isFormatID61]){
        [inputDict setObject:FID61_randomNumber forKey:@"randomNumber"];
    }
    if ([self isFormatID46]){
        [inputDict setObject:FID46_randomNumber forKey:@"randomNumber"];
    }
    if ([self isFormatID65]){
        [inputDict setObject:FID65_encPinKey forKey:@"encPinKey"];
        [inputDict setObject:FID65_encDataKey forKey:@"encDataKey"];
    }
    
    lblGeneralData.text = @"Encrypt PIN ...";
    NSLog(@"[[EmvSwipeController sharedController] encryptPin: %@", inputDict);
    [[EmvSwipeController sharedController] encryptPin:inputDict];
}

- (void)onReturnEncryptPinResult:(NSDictionary *)data{
    NSLog(@"onReturnEncryptPinResult - data: %@", data);
    lblGeneralData.text = [NSString stringWithFormat:@"EPB: %@\nKSN: %@",
                           [data objectForKey:@"epb"],
                           [data objectForKey:@"ksn"]];
}

#pragma mark - APDU
- (IBAction)btnAction_PowerOnIcc:(id)sender{
    NSLog(@"btnAction_PowerOnIcc");
    lblGeneralData.text = @"Power on ICC ...";
    [self appendDataToGeneralDataView:@"powerOnIcc"];
    [[EmvSwipeController sharedController] powerOnIcc];
}

- (void)onReturnPowerOnIccResult:(BOOL)isSuccess
                             ksn:(NSString *)ksn
                             atr:(NSString *)atr
                       atrLength:(int)atrLength{
    NSLog(@"onReturnPowerOnIccResult - isSuccess: %d, atr: %@, atrLength: %d, ksn: %@", isSuccess, atr, atrLength, ksn);
    [self appendDataToGeneralDataView:@"onReturnPowerOnIccResult"];
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
    [[EmvSwipeController sharedController] powerOffIcc];
}

- (void)onReturnPowerOffIccResult:(BOOL)isSuccess{
    NSLog(@"onReturnPowerOffIccResult - isSuccess: %d", isSuccess);
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
        [[EmvSwipeController sharedController] sendApdu:apduInput
                                             apduLength:apduLength];
    }
}

- (IBAction)btnAction_SendApduWithPkcs7Padding:(id)sender{
    NSLog(@"btnAction_SendApduWithPkcs7Padding");
    lblGeneralData.text = @"Sending APDU with PKCS7 ...";
    NSString *apduInput = _txtApdu.text; //7561F6478439E859 //00CA0000
    NSLog(@"apduInput: %@", apduInput);
    [[EmvSwipeController sharedController] sendApduWithPkcs7Padding:apduInput];
}

- (void)onReturnApduResult:(BOOL)isSuccess
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

- (void)onReturnApduResultWithPkcs7Padding:(BOOL)isSuccess
                                      apdu:(NSString *)apdu{
    NSLog(@"onReturnApduResultWithPkcs7Padding - isSuccess: %d, apdu: %@", isSuccess, apdu);
    if (isSuccess){
        lblGeneralData.text = @"onReturnApduResultWithPkcs7Padding success.";
    }else{
        lblGeneralData.text = @"onReturnApduResultWithPkcs7Padding failed.";
    }
    lblGeneralData.text = [NSString stringWithFormat:@"%@\nAPDU: %@", lblGeneralData.text, apdu];
}

- (IBAction)btnAction_ExchangeApdu:(id)sender{
    lblGeneralData.text = @"Exchange APDU ...";
    NSString *apduInput = _txtApdu2.text;
    NSLog(@"[[EmvSwipeController sharedController] exchangeApdu:...] with input: %@", apduInput);
    [[EmvSwipeController sharedController] viposExchangeApdu:apduInput];
}

- (void)onReturnViposExchangeApduResult:(NSString *)apdu{
    NSLog(@"onReturnViposExchangeApduResult - apdu: %@", apdu);
    lblGeneralData.text = [NSString stringWithFormat:@"APDU: %@", apdu];
    
    if (exchangeApduAfterOnRequestOnlineProcess_apduIndex == 1){
        exchangeApduAfterOnRequestOnlineProcess_apduIndex = 2;
        NSString *apdu = @"80fa000018363232383738303231323231393330373030000000000000";
        NSLog(@"[[EmvSwipeController sharedController] exchangeApdu:%@];", apdu);
        [[EmvSwipeController sharedController] viposExchangeApdu:apdu]; //encrypt PAN
    }else if (exchangeApduAfterOnRequestOnlineProcess_apduIndex == 2){
        exchangeApduAfterOnRequestOnlineProcess_apduIndex = -1;
        
        //NSLog(@"[[EmvSwipeController sharedController] sendOnlineProcessResult:@'8A023030'];");
        //[[EmvSwipeController sharedController] sendOnlineProcessResult:@"8A023030"];
        
        self.pickerType = @"OnlineProcessResult";
        self.pickerDataSourceArray = [NSArray arrayWithObjects:@"8A023030 (Approval)", @"8A023035 (Decline)", nil];
        [self showPickerView];
    }
}

- (IBAction)btnAction_batchExchangeApdu:(id)sender{
    lblGeneralData.text = @"Batch Exchange APDU ...";
    NSString *dateTimeString = @"20130307111735";
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    
    int max = 3;
    int min = 1;
    int testDataSetNum = rand() % (max - min) + min;
    
    switch (testDataSetNum) {
        case 1:{ //Several short data
            [dataDict setObject:[NSArray arrayWithObjects:@"13", dateTimeString, @"80FA00001036323030313030303336333436343132", nil] forKey:[NSNumber numberWithInt:1]];
            [dataDict setObject:[NSArray arrayWithObjects:@"14", dateTimeString, @"80FA00000806111111FFFFFFFF", nil] forKey:[NSNumber numberWithInt:2]];
            [dataDict setObject:[NSArray arrayWithObjects:@"15", dateTimeString, @"80FA070078000000000000000032303133303330353130313832392045444431383830353444354431443644363734464432453744423537313131462033373645423034414531323046343333463335304143413044323131423333353839313030303046203836424330373945414443423136333230313030800000", nil] forKey:[NSNumber numberWithInt:3]];
            [dataDict setObject:[NSArray arrayWithObjects:@"15", dateTimeString, @"80FA030078000000000000000032303133303330353130313832392045444431383830353444354431443644363734464432453744423537313131462033373645423034414531323046343333463335304143413044323131423333353839313030303046203836424330373945414443423136333230313030800000", nil] forKey:[NSNumber numberWithInt:4]];
            [dataDict setObject:[NSArray arrayWithObjects:@"15", dateTimeString, @"80FA010078000000000000000032303133303330353130313832392045444431383830353444354431443644363734464432453744423537313131462033373645423034414531323046343333463335304143413044323131423333353839313030303046203836424330373945414443423136333230313030800000", nil] forKey:[NSNumber numberWithInt:5]];
            break;}
        case 2:{ //one long data only
            [dataDict setObject:[NSArray arrayWithObjects:@"15", @"20150121141740", @"80FA0700F0000000000000000032303135303132313134313734302030373237364534354639374235333735413441364232464334463344393432432030443444363245303042314242363444203338394144394245374436433033323720373031393934313537443130313233373939374644394545343334313334373120413431344235464643334533304546302031423133453134323634454130373735314336443834394231374133434331432032393130303637333841413834423538454144333031303232303030303030462036443843353737354441413839453435303130302033393844303233314537394245", nil] forKey:[NSNumber numberWithInt:1]];
            break;}
        case 3:{ //Several short data and one long data
            [dataDict setObject:[NSArray arrayWithObjects:@"13", dateTimeString, @"80FA00001036323030313030303336333436343132", nil] forKey:[NSNumber numberWithInt:1]];
            [dataDict setObject:[NSArray arrayWithObjects:@"14", dateTimeString, @"80FA00000806111111FFFFFFFF", nil] forKey:[NSNumber numberWithInt:2]];
            [dataDict setObject:[NSArray arrayWithObjects:@"15", dateTimeString, @"80FA070078000000000000000032303133303330353130313832392045444431383830353444354431443644363734464432453744423537313131462033373645423034414531323046343333463335304143413044323131423333353839313030303046203836424330373945414443423136333230313030800000", nil] forKey:[NSNumber numberWithInt:3]];
            [dataDict setObject:[NSArray arrayWithObjects:@"15", dateTimeString, @"80FA030078000000000000000032303133303330353130313832392045444431383830353444354431443644363734464432453744423537313131462033373645423034414531323046343333463335304143413044323131423333353839313030303046203836424330373945414443423136333230313030800000", nil] forKey:[NSNumber numberWithInt:4]];
            [dataDict setObject:[NSArray arrayWithObjects:@"15", dateTimeString, @"80FA0700F0000000000000000032303135303132313134313734302030373237364534354639374235333735413441364232464334463344393432432030443444363245303042314242363444203338394144394245374436433033323720373031393934313537443130313233373939374644394545343334313334373120413431344235464643334533304546302031423133453134323634454130373735314336443834394231374133434331432032393130303637333841413834423538454144333031303232303030303030462036443843353737354441413839453435303130302033393844303233314537394245", nil] forKey:[NSNumber numberWithInt:5]];
            break;}
        default:
            break;
    }
    
    //NSLog(@"[[EmvSwipeController sharedController] batchExchangeApdu:...] with input: %@", dataDict);
    NSLog(@"[[EmvSwipeController sharedController] viposBatchExchangeApdu:...];");
    [[EmvSwipeController sharedController] viposBatchExchangeApdu:[NSDictionary dictionaryWithDictionary:dataDict]];
}

- (void)onReturnViposBatchExchangeApduResult:(NSDictionary *)data{
    NSLog(@"onReturnViposBatchExchangeApduResult - data: %@", data);
    lblGeneralData.text = @"onReturnViposBatchExchangeApduResult";
    
    NSString *dataString = @"";
    NSArray *keys = [data allKeys];
    for (NSString *loopKey in keys) {
        dataString = [NSString stringWithFormat:@"%@\n%@: %@", dataString, loopKey, [data objectForKey:loopKey]];
    }
    [self displayDataOnScrollTextView:dataString];
    
}

#pragma mark - Other


- (IBAction)btnAction_GetEmvCardData:(id)sender{
    NSLog(@"btnAction_GetEmvCardData");
    lblGeneralData.text = @"Getting EMV card data ...";
    [self appendDataToGeneralDataView:@"getEmvCardData"];
    NSLog(@"[[EmvSwipeController sharedController] getEmvCardData];");
    [[EmvSwipeController sharedController] getEmvCardData];
}

- (void)onReturnEmvCardDataResult:(NSString *)tlv{
    [self appendDataToGeneralDataView:@"onReturnEmvCardDataResult"];
    NSString *callbackName = @"onReturnEmvCardDataResult";
    NSLog(@"%@: %@", callbackName, tlv);
    lblGeneralData.text = NSLocalizedString(callbackName, @"");
    NSLog(@"[[EmvSwipeController sharedController] decodeTlv:tlv]: %@", [[EmvSwipeController sharedController] decodeTlv:tlv]);
    [self displayDataOnScrollTextView:[NSString stringWithFormat:@"onReturnEmvCardDataResult:\n%@", tlv]];
}

- (IBAction)btnAction_GetEmvCardNumber:(id)sender{
    NSLog(@"btnAction_GetEmvCardNumber");
    lblGeneralData.text = @"Getting EMV card Number ...";
    [self appendDataToGeneralDataView:@"getEmvCardNumber"];
    NSLog(@"[[EmvSwipeController sharedController] getEmvCardNumber];");
    [[EmvSwipeController sharedController] getEmvCardNumber];
}

- (void)onReturnEmvCardNumber:(NSString *)cardNumber{
    [self appendDataToGeneralDataView:@"onReturnEmvCardDataResult"];
    NSString *callbackName = @"onReturnEmvCardNumberResult";
    NSLog(@"%@: %@", callbackName, cardNumber);
    lblGeneralData.text = NSLocalizedString(callbackName, @"");
    [self displayDataOnScrollTextView:[NSString stringWithFormat:@"onReturnEmvCardNumber:\n%@", cardNumber]];
}

- (IBAction)btnAction_GetEmvCardBalance:(id)sender{
    NSLog(@"btnAction_GetEmvCardBalance");
    lblGeneralData.text = @"getEmvCardBalance ...";
    
    NSMutableDictionary *inputDict = [NSMutableDictionary dictionary];
    [inputDict setObject:[NSNumber numberWithInt:[self getTimeoutValue_checkCardTimeout]] forKey:@"checkCardTimeout"];
    [inputDict setObject:[NSNumber numberWithInt:[self getTimeoutValue_selectApplicationTimeout]] forKey:@"selectApplicationTimeout"];
    [inputDict setObject:[NSNumber numberWithBool:YES] forKey:@"autoSelectApplication"];
    [[EmvSwipeController sharedController] getEmvCardBalance:[NSDictionary dictionaryWithDictionary:inputDict]];
}
- (void)onReturnEmvCardBalance:(NSString *)tlv{
    [self appendDataToGeneralDataView:@"onReturnEmvCardBalance"];
    NSString *callbackName = @"onReturnEmvCardBalance";
    NSLog(@"%@: %@", callbackName, tlv);
    lblGeneralData.text = NSLocalizedString(callbackName, @"");
    [self displayDataOnScrollTextView:[NSString stringWithFormat:@"onReturnEmvCardBalance:\n%@", tlv]];
}
- (IBAction)btnAction_GetEmvTransactionLog:(id)sender{
    NSLog(@"btnAction_GetEmvTransactionLog");
    lblGeneralData.text = @"getEmvTransactionLog ...";
    
    NSMutableDictionary *inputDict = [NSMutableDictionary dictionary];
    [inputDict setObject:[NSNumber numberWithInt:[self getTimeoutValue_checkCardTimeout]] forKey:@"checkCardTimeout"];
    [inputDict setObject:[NSNumber numberWithInt:[self getTimeoutValue_selectApplicationTimeout]] forKey:@"selectApplicationTimeout"];
    [inputDict setObject:[NSNumber numberWithBool:YES] forKey:@"autoSelectApplication"];
    [[EmvSwipeController sharedController] getEmvTransactionLog:[NSDictionary dictionaryWithDictionary:inputDict]];
}
- (void)onReturnEmvTransactionLog:(NSArray *)transactionLogArray{
    NSLog(@"onReturnEmvTransactionLog - transactionLogArray: %@", transactionLogArray);
    
    NSString *tempString = @"onReturnEmvTransactionLog";
    lblGeneralData.text = NSLocalizedString(@"onReturnEmvTransactionLog", @"");
    for (int i=0; i<[transactionLogArray count]; i++) {
        tempString = [NSString stringWithFormat:@"%@\n\n%@", tempString, [transactionLogArray objectAtIndex:i]];
    }
    [self displayDataOnScrollTextView:tempString];
}
- (IBAction)btnAction_GetEmvLoadLog:(id)sender{
    NSLog(@"btnAction_GetEmvLoadLog");
    lblGeneralData.text = @"getEmvLoadLog ...";
    
    NSMutableDictionary *inputDict = [NSMutableDictionary dictionary];
    [inputDict setObject:[NSNumber numberWithInt:[self getTimeoutValue_checkCardTimeout]] forKey:@"checkCardTimeout"];
    [inputDict setObject:[NSNumber numberWithInt:[self getTimeoutValue_selectApplicationTimeout]] forKey:@"selectApplicationTimeout"];
    [inputDict setObject:[NSNumber numberWithBool:YES] forKey:@"autoSelectApplication"];
    [[EmvSwipeController sharedController] getEmvLoadLog:[NSDictionary dictionaryWithDictionary:inputDict]];
}
- (void)onReturnEmvLoadLog:(NSArray *)dataArray{
    NSLog(@"onReturnEmvLoadLog - dataArray: %@", dataArray);
    
    NSString *tempString = @"onReturnEmvLoadLog";
    lblGeneralData.text = NSLocalizedString(@"onReturnEmvLoadLog", @"");
    for (int i=0; i<[dataArray count]; i++) {
        tempString = [NSString stringWithFormat:@"%@\n\n%@", tempString, [dataArray objectAtIndex:i]];
    }
    [self displayDataOnScrollTextView:tempString];
}

#pragma mark - UIAlertView - Click Event
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //NSLog(@"alertView clickedButtonAtIndex");
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
            
            TransactionType tempTransType = TransactionType_Goods;
            switch (tempControl.selectedSegmentIndex) {
                case 0:
                    tempTransType = TransactionType_Goods;
                    break;
                case 1:
                    tempTransType = TransactionType_Cashback;
                    break;
                case 2:
                    tempTransType = TransactionType_Services;
                    break;
                case 3:
                    tempTransType = TransactionType_Inquiry;
                    break;
                case 4:
                    tempTransType = TransactionType_Transfer;
                    break;
                case 5:
                    tempTransType = TransactionType_Payment;
                    break;
                default:
                    break;
            }
            
            if (tempControl.selectedSegmentIndex == 1){ //Cashback
                NSLog(@"amountStr   : %@", amountStr);
                NSLog(@"cashbackStr : %@", cashbackStr);
                [self appendDataToGeneralDataView:@"setAmount"];
                if ([[EmvSwipeController sharedController] setAmount:self.tadeAmount
                                                      cashbackAmount:cashbackStr
                                                        currencyCode:[self getCurrencyCode]
                                                     transactionType:tempTransType]){
                    NSLog(@"Valid amount");
                }else{
                    NSLog(@"Invalid amount");
                }
            }else{
                NSLog(@"amountStr  : %@", amountStr);
                [self appendDataToGeneralDataView:@"setAmount"];
                if ([[EmvSwipeController sharedController] setAmount:amountStr
                                                      cashbackAmount:@""
                                                        currencyCode:[self getCurrencyCode]
                                                     transactionType:tempTransType]){
                    NSLog(@"Valid amount");
                }else{
                    NSLog(@"Invalid amount");
                }
            }
            _lblAmount.text = [NSString stringWithFormat:@"%@: %@ %@", NSLocalizedString(@"Amount", @""), NSLocalizedString(@"CurrencySign", @""), amountStr];
            [self showAmountView];
        } else { //Cancel
            lblGeneralData.text = NSLocalizedString(@"Processing", @"");
            [[EmvSwipeController sharedController] cancelSetAmount];
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
        
        numberString = @"111111";
        
        if ([buttonTitle isEqualToString:NSLocalizedString(@"AlertBtnOk_PinEntry", @"")]) {
            if ([numberString length] > 0){
                [self appendDataToGeneralDataView:[NSString stringWithFormat:@"sendPinEntryResult: %@", numberString]];
                [[EmvSwipeController sharedController] sendPinEntryResult:numberString];
            }else{
                [self appendDataToGeneralDataView:[NSString stringWithFormat:@"bypassPinEntry"]];
                [[EmvSwipeController sharedController] bypassPinEntry];
            }
            isCanceledPin = NO;
        } else { //Cancel
            lblGeneralData.text = NSLocalizedString(@"Processing", @"");
            [self appendDataToGeneralDataView:@"cancelPinEntry"];
            [[EmvSwipeController sharedController] cancelPinEntry];
            isCanceledPin = YES;
        }
    }
    
    else if ([alertTitle isEqualToString:NSLocalizedString(@"AlertTitle_FinalConfirm", @"")]){
        lblGeneralData.text = NSLocalizedString(@"Processing", @"");
        NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
        if ([buttonTitle isEqualToString:NSLocalizedString(@"AlertBtnOk_FinalConfirm", @"")]) {
            [self appendDataToGeneralDataView:@"sendFinalConfirmResult:YES"];
            [[EmvSwipeController sharedController] sendFinalConfirmResult:YES];
        } else { //Cancel
            [self appendDataToGeneralDataView:@"sendFinalConfirmResult:NO"];
            [[EmvSwipeController sharedController] sendFinalConfirmResult:NO];
        }
    }
    
    else if ([alertTitle isEqualToString:NSLocalizedString(@"TransactionResult", @"")]){
        [self resetUI];
    }
    
    
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

#pragma mark - UIPicker
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [pickerDataSourceArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if ([pickerDataSourceArray count] > row){
        return [pickerDataSourceArray objectAtIndex:row];
    }else{
        return @"";
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"pickerView didSelectRow: %d", (int)row);
}


- (IBAction)btnAction_SelectPickerValue_Confirm:(id)sender{
    NSLog(@"btnAction_SelectPickerValue_Confirm");
    
    if([self.pickerDataSourceArray count]>0){
        int pickerSelectedRow = (int)[pickerSelectValue selectedRowInComponent:0];
        if ([self.pickerType isEqualToString:@"SelectApplication"]){
            [self appendDataToGeneralDataView:[NSString stringWithFormat:@"selectApplication:%d", pickerSelectedRow]];
            [[EmvSwipeController sharedController] selectApplication:pickerSelectedRow];
        }else if ([self.pickerType isEqualToString:@"OnlineProcessResult"]){
            [self appendDataToGeneralDataView:[NSString stringWithFormat:@"sendOnlineProcessResult:%d", pickerSelectedRow]];
            if (pickerSelectedRow == 0){
                NSLog(@"[[EmvSwipeController sharedController] sendOnlineProcessResult:@'8A023030']; //Approval");
                [[EmvSwipeController sharedController] sendOnlineProcessResult:@"8A023030"]; //Approval
            }else{
                NSLog(@"[[EmvSwipeController sharedController] sendOnlineProcessResult:@'8A023035']; //Decline");
                [[EmvSwipeController sharedController] sendOnlineProcessResult:@"8A023035"]; //Decline
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
            [self appendDataToGeneralDataView:@"cancelSelectApplication"];
            [[EmvSwipeController sharedController] cancelSelectApplication];
        }else if ([self.pickerType isEqualToString:@"OnlineProcessResult"]){
            [self appendDataToGeneralDataView:@"sendOnlineProcessResult:@"""""];
            
            NSLog(@"[[WisePadController sharedController] sendOnlineProcessResult:@'']; //Send empty string to cancel transaction");
            [[EmvSwipeController sharedController] sendOnlineProcessResult:@""]; //Send empty string to cancel transaction
        }else{
            NSLog(@"UI implementation error.");
        }
    }else{
        lblGeneralData.text = @"No picker value available to select.";
    }
    [self hidePickerView];
    lblGeneralData.text = NSLocalizedString(@"Processing", @"");
}

#pragma mark - Error Handling
- (void)onError:(ErrorType)ErrorType errorMessage:(NSString *)errorMessage{
    NSLog(@"onError - ErrorType: %d, errorMessage: %@", ErrorType, errorMessage);
    [self appendDataToGeneralDataView:[NSString stringWithFormat:@"onError: %@", errorMessage]];
    lblError.text = errorMessage;
    
    if (ErrorType == ErrorType_IllegalStateException){
        lblError.text = @"Can only perform one single task each time,\nplease wait previous task completed or timeout.";
    }
    
    NSString *invalidInputMessage = @"";
    
    switch (ErrorType) {
        case ErrorType_InvalidInput:{
            [self showStartButton];
            lblGeneralData.text = errorMessage;
            invalidInputMessage = errorMessage;
            break;}
        case ErrorType_InvalidInput_InputValueOutOfRange:{
            [self hideStartButton];
            lblGeneralData.text = @"Input value out of range";
            invalidInputMessage = lblGeneralData.text;
            break;}
        case ErrorType_InvalidInput_InvalidDataFormat:{
            [self hideStartButton];
            lblGeneralData.text = errorMessage;
            invalidInputMessage = errorMessage;
            break;}
        case ErrorType_InvalidInput_NoAcceptAmountForThisTransactionType:{
            [self hideStartButton];
            lblGeneralData.text = @"NoAcceptAmountForThisTransactionType";
            invalidInputMessage = lblGeneralData.text;
            break;}
        case ErrorType_InvalidInput_NotAcceptCashbackForThisTransactionType:{
            [self hideStartButton];
            lblGeneralData.text = @"NotAcceptCashbackForThisTransactionType";
            invalidInputMessage = lblGeneralData.text;
            break;}
        case ErrorType_InvalidInput_NotNumeric:{
            [self hideStartButton];
            lblGeneralData.text = @"Not numeric";
            invalidInputMessage = lblGeneralData.text;
            break;}
        case ErrorType_DeviceReset:{
            [self resetUI];
            lblGeneralData.text = @"ErrorType_DeviceReset";
            break;}
        case ErrorType_CommError:{
            [self resetUI];
            lblGeneralData.text = @"ErrorType_CommError";
            break;}
        case ErrorType_Unknown:{
            [self resetUI];
            lblGeneralData.text = @"ErrorType_Unknown";
            break;}
        case ErrorType_AudioFailToStart:{
            lblGeneralData.text = @"ErrorType_AudioFailToStart";
            break;}
        case ErrorType_AudioNotYetStarted:{
            lblGeneralData.text = @"ErrorType_AudioNotYetStarted\nPlease press the 'Start Audio' button";
            break;}
        case ErrorType_IllegalStateException:{
            lblGeneralData.text = @"Can only perform one single task each time.";
            break;}
        case ErrorType_CommandNotAvailable:{
            [self resetUI];
            lblGeneralData.text = @"ErrorType_CommandNotAvailable\nThe function maybe not support in your firmware\nOR it is called in an incorrect sequence.";
            break;}
        case ErrorType_AudioRecordingPermissionDenied:{
            lblGeneralData.text = @"Audio recording permission denied.\nPlease change the setting in:\nSettings > Privacy > Microphone";
            break;}
        case ErrorType_AudioFailToStart_OtherAudioIsPlaying:{
            lblGeneralData.text = @"startAudio failed since other audio is playing.";
            break;}
        case ErrorType_BackgroundTimeout:{
            //Audio in background mode (eg. pressed home button) will last for 10s, after 10s EmvSwipe API will call stopAudio automatically
            [self resetUI];
            lblGeneralData.text = @"Background timeout.\nAudio stopped and Transaction aborted.";
            break;}
        case ErrorType_DeviceBusy:{
            lblGeneralData.text = @"ErrorType_DeviceBusy";
            break;}
        default:{
            lblGeneralData.text = errorMessage;
            break;}
    }
    
    if (ErrorType == ErrorType_InvalidInput ||
        ErrorType == ErrorType_InvalidInput_InputValueOutOfRange ||
        ErrorType == ErrorType_InvalidInput_InvalidDataFormat ||
        ErrorType == ErrorType_InvalidInput_NoAcceptAmountForThisTransactionType ||
        ErrorType == ErrorType_InvalidInput_NotAcceptCashbackForThisTransactionType ||
        ErrorType == ErrorType_InvalidInput_NotNumeric){
        
        lblError.text = @"";
        if ([self.alertType length] > 0){
            NSLog(@"onError - self.alertType: %@", self.alertType);
        }
        if ([self.alertType isEqualToString:@"SetAmount"]){
            _lblAmount.text = @"";
            [self popUpAlertView_SetAmount:invalidInputMessage];
        }else if ([self.alertType isEqualToString:@"PinEntry"]){
            [self popUpAlertView_PinEntry];
        }
    }
}

#pragma mark - Encryption
- (IBAction)btnAction_EncryptPin:(id)sender{
    NSLog(@"btnAction_EncryptPin");
    
    [_txtPINForEncryptPIN resignFirstResponder];
    [_txtPANForEncryptPIN resignFirstResponder];
    
    NSMutableDictionary *inputDict = [NSMutableDictionary dictionary];
    [inputDict setObject:_txtPANForEncryptPIN.text forKey:@"pan"];
    [inputDict setObject:_txtPINForEncryptPIN.text forKey:@"pin"];
    if ([self isFormatID61]){
        [inputDict setObject:FID61_randomNumber forKey:@"randomNumber"];
    }
    if ([self isFormatID46]){
        [inputDict setObject:FID46_randomNumber forKey:@"randomNumber"];
    }
    if ([self isFormatID65]){
        [inputDict setObject:FID65_encPinKey forKey:@"encPinKey"];
        [inputDict setObject:FID65_encDataKey forKey:@"encDataKey"];
    }
    
    lblGeneralData.text = @"Encrypt PIN ...";
    NSLog(@"[[EmvSwipeController sharedController] encryptPin: %@", inputDict);
    [[EmvSwipeController sharedController] encryptPin:inputDict];
}

- (void)onReturnEncryptPinResult:(NSString *)epb ksn:(NSString *)ksn{
    //Please use onReturnEncryptPinResult:(NSDictionary *)data;
}

- (IBAction)btnAction_EncryptData:(id)sender{
    NSLog(@"btnAction_EncryptData");
    NSString *data = _txtEncryptDataInput.text;
    
    _txtEncryptDataResult.text = [NSString stringWithFormat:@"Encrypting: %@", data];
    lblGeneralData.text = [NSString stringWithFormat:@"Encrypting data..."];
    
    //[[EmvSwipeController sharedController] encryptData:data];
    
    [[EmvSwipeController sharedController] encryptDataWithSettings:
     [NSDictionary dictionaryWithObjectsAndKeys:
      data, @"data",
      [NSNumber numberWithInt:EmvSwipeEncryptionMethod_TDES_CBC], @"encryptionMethod",
      [NSNumber numberWithInt:EmvSwipeEncryptionKeySource_BY_DEVICE_16_BYTES_RANDOM_NUMBER], @"encryptionKeySource",
      [NSNumber numberWithInt:EmvSwipeEncryptionPaddingMethod_PKCS7], @"encryptionPaddingMethod",
      [NSNumber numberWithInt:EmvSwipeEncryptionKeyUsage_TPK], @"keyUsage",
      [NSNumber numberWithInt:8], @"macLength",
      @"E328D2B7381A587E2B7B9E032BAB0451C257CC0FD286CDC4", @"encWorkingKey", //kcv can be appended to encWorkingKey
      @"", @"kcvOfWorkingKey",
      @"8877665544332211", @"randomNumber",
      @"0000000000000000", @"initialVector",
      nil]];
}

- (void)onReturnEncryptDataResult:(NSDictionary *)data{
    NSLog(@"onWisePadReturnEncryptDataResult - data: %@", data);
    lblGeneralData.text = [NSString stringWithFormat:@"Encrypt data completed."];
    //Key included in data dictionary: encData, mac, randomNumber, ksn, isSuccess
}
- (void)onReturnEncryptDataResult:(NSString *)encryptedData ksn:(NSString *)ksn{
    //NSLog(@"onWisePadReturnEncryptDataResult - encryptedData: %@, ksn: %@", encryptedData, ksn);
}

#pragma mark - Other API Function
- (IBAction)detectDevice:(id)sender {
    NSLog(@"detectDevice - isDevicePresent? %@", ([[EmvSwipeController sharedController] isDevicePresent] ? @"YES" : @"NO"));
    if ([[EmvSwipeController sharedController] isDevicePresent] == YES){
        lblGeneralData.text = @"Device Plugged";
    } else {
        lblGeneralData.text = @"Device Unplugged";
    }
}

- (void)onInterrupted{
    NSLog(@"onInterrupted");
    [self appendDataToGeneralDataView:@"onInterrupted"];
    [self resetUI];
    lblGeneralData.text = @"onInterrupted";
}

- (IBAction)btnAction_IsDeviceHere:(id)sender{
    NSLog(@"btnAction_IsDeviceHere");
    lblGeneralData.text = @"Checking isDeviceHere ...";
    [[EmvSwipeController sharedController] isDeviceHere];
}

- (void)onDeviceHere:(BOOL)isHere{
    NSLog(@"onDeviceHere - isHere: %d", isHere);
    lblGeneralData.text = [NSString stringWithFormat:@"onDeviceHere - isHere: %d", isHere];
}

#pragma mark - ENUM to NSString

- (NSString *)getEmvSwipeControllerStateString{
    //NSLog(@"getEmvSwipeControllerStateString");
    EmvSwipeControllerState state = [[EmvSwipeController sharedController] getEmvSwipeControllerState];
    NSString *returnStr = @"";
    if (state == EmvSwipeControllerState_AudioStopped){
        returnStr = @"Stopped";
    }else if (state == EmvSwipeControllerState_Idle){
        returnStr = @"Idle";
    }else if (state == EmvSwipeControllerState_WaitingForResponse){
        returnStr = @"WaitingForResponse";
    }else{
        returnStr = @"Unknwon State";
    }
    return returnStr;
}

#pragma mark - UI
- (IBAction)hideKeyboard:(id)sender{
    [_txtApdu resignFirstResponder];
    [_txtApdu2 resignFirstResponder];
    [_txtApduLength resignFirstResponder];
    [_txtEncryptDataInput resignFirstResponder];
    [_txtTerminalSettingTLV resignFirstResponder];
    [_txtReadTerminalSetting resignFirstResponder];
    [_txtPINForEncryptPIN resignFirstResponder];
    [_txtPANForEncryptPIN resignFirstResponder];
}

- (IBAction)showGeneralDataView:(id)sender{
    viewGeneralData.hidden = NO;
}

- (IBAction)resetAllUI:(id)sender{
    [self resetUI];
}

- (void)resetUI{
    //lblError.text = @"";
    lblGeneralData.text = @"";
    [self hidePickerView];
    [self hideTrackDataPanel];
    [self hideAmountView];
    [self hideAlertView];
    [self hideGeneralDataView];
    [self showStartButton];
}

- (void)showAmountView{
    viewAmount.hidden = NO;
}

- (void)hideAmountView{
    viewAmount.hidden = YES;
    _lblAmount.text = @"";
}


- (IBAction)showTlvDataView:(id)sender{
    viewTrackDataPanel.hidden = YES;
    viewDisplayData.hidden = NO;
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
    _txtTrackData.text = @"";
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
    [self hideNFCPanel];
    [self hideGeneralDataView];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (textField == _txtEncryptDataInput){
        [self btnAction_EncryptData:nil];
    }
    return NO;
}

#pragma mark - Debug Timer

- (void)startDebugTimer{
    self.debugTimer = [NSDate date];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    
//    [formatter release];
}

- (void)printDebugTimer{
    float duration = ([[NSDate date] timeIntervalSinceReferenceDate] - [self.debugTimer timeIntervalSinceReferenceDate]);
    
    NSString *debugString = [NSString stringWithFormat:@"Duration: %.3fs", duration];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    
    NSLog(@"%@\n\n\n", debugString);
    
//    [formatter release];
}

#pragma mark - Terminal Setting
- (IBAction)btnAction_UpdateTerminalSetting:(id)sender{
    NSLog(@"btnAction_UpdateTerminalSetting");
    NSString *input = _txtTerminalSettingTLV.text;
    NSLog(@"input: %@", input);
    [[EmvSwipeController sharedController] updateTerminalSetting:input];
}

- (void)onReturnUpdateTerminalSettingResult:(TerminalSettingStatus)status{
    NSLog(@"onReturnUpdateTerminalSettingResult - status: %d", status);
    lblGeneralData.text = [NSString stringWithFormat:@"UpdateTerminalSettingResult status: %d", status];
}

- (IBAction)btnAction_ReadTerminalSetting:(id)sender{
    NSLog(@"btnAction_UpdateTerminalSetting");
    NSString *input = _txtReadTerminalSetting.text;
    NSLog(@"input: %@", input);
    [[EmvSwipeController sharedController] readTerminalSetting:input];
}

- (void)onReturnReadTerminalSettingResult:(TerminalSettingStatus)status tagValue:(NSString *)tagValue{
    NSLog(@"onReturnReadTerminalSettingResult - status: %d, tagValue: %@", status, tagValue);
    lblGeneralData.text = [NSString stringWithFormat:@"status: %d, tagValue: %@", status, tagValue];
}

#pragma mark - New EMV Kernel

- (void)onRequestVerifyID:(NSString *)tlv{
    NSLog(@"onRequestVerifyID - tlv: %@", tlv);
    
    NSLog(@"[[EmvSwipeController sharedController] sendVerifyIDResult:YES];");
    [[EmvSwipeController sharedController] sendVerifyIDResult:YES];
}

#pragma mark - CAPK
- (IBAction)btnAction_CAPK_getCAPKList:(id)sender{
    NSLog(@"[[EmvSwipeController sharedController] getCAPKList];");
    [[EmvSwipeController sharedController] getCAPKList];
}

- (IBAction)btnAction_CAPK_getCAPKDetail:(id)sender{
    NSString *location = @"30";
    NSLog(@"[[EmvSwipeController sharedController] getCAPKDetail:@'%@'];", location);
    [[EmvSwipeController sharedController] getCAPKDetail:location];
}

- (IBAction)btnAction_CAPK_findCAPKLocation:(id)sender{
    NSDictionary *inputDict = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"A123456789", @"rid",
                               @"5A", @"index", nil];
    NSLog(@"[[EmvSwipeController sharedController] findCAPKLocation: %@", inputDict);
    [[EmvSwipeController sharedController] findCAPKLocation:inputDict];
}
- (IBAction)btnAction_CAPK_updateCAPK:(id)sender{
    CAPK *capk = [[CAPK alloc] init];
    capk.location = @"30";
    capk.rid = @"A123456789";
    capk.exponent = @"030000";
    capk.modulus = @"000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F202122232425262728292A2B2C2D2E2F303132333435363738393A3B3C3D3E3F404142434445464748494A4B4C4D4E4F505152535455565758595A5B5C5D5E5F606162636465666768696A6B6C6D6E6F707172737475767778797A7B7C7D7E7F808182838485868788898A8B8C8D8E8F909192939495969798999A9B9C9D9E9FA0A1A2A3A4A5A6A7A8A9AAABACADAEAFB0B1B2B3B4B5B6B7B8B9BABBBCBDBEBFC0C1C2C3C4C5C6C7C8C9CACBCCCDCECFD0D1D2D3D4D5D6D7D8D9DADBDCDDDEDFE0E1E2E3E4E5E6E7E8E9EAEBECEDEEEFF0F1F2F3F4F5F6F7";
    capk.checksum = @"0102030405060708091011121314151617181920";
    capk.size = @"07C0";
    capk.index = @"5A";
    
    NSLog(@"[[EmvSwipeController sharedController] updateCAPK: %@", capk);
    [[EmvSwipeController sharedController] updateCAPK:capk];
//    [capk release];
}

- (IBAction)btnAction_getEmvReportList:(id)sender{
    NSLog(@"[[EmvSwipeController sharedController] getEmvReportList];");
    [[EmvSwipeController sharedController] getEmvReportList];
}

- (IBAction)btnAction_getEmvReport:(id)sender{
    NSString *applicationIndex = @"00";
    NSLog(@"[[EmvSwipeController sharedController] getEmvReport:@'%@'];", applicationIndex);
    [[EmvSwipeController sharedController] getEmvReport:applicationIndex];
}

// CAPK Callback
- (void)onReturnCAPKList:(NSArray *)capkArray{
    NSLog(@"onReturnCAPKList - capkArray: %@", capkArray);
    lblGeneralData.text = [NSString stringWithFormat:@"onReturnCAPKLocation\n capkArray count: %d", (int)[capkArray count]];
    [self showGeneralDataView:nil];
    [self clearGeneralDataView];
    
    for(int i=0 ; i<[capkArray count] ; i++){
        CAPK *capk = [capkArray objectAtIndex:i];
        NSLog(@"\n--- i: %d ---", i);
        NSLog(@"capk.location: %@", capk.location);
        NSLog(@"capk.rid: %@", capk.rid);
        NSLog(@"capk.index: %@", capk.index);
        
        [self appendDataToGeneralDataView:[NSString stringWithFormat:@"\n--- i: %d ---", i]];
        [self appendDataToGeneralDataView:[NSString stringWithFormat:@"location: %@", capk.location]];
        [self appendDataToGeneralDataView:[NSString stringWithFormat:@"rid: %@", capk.rid]];
        [self appendDataToGeneralDataView:[NSString stringWithFormat:@"index: %@", capk.index]];
    }
}
- (void)onReturnCAPKDetail:(CAPK *)capk{
    NSLog(@"onReturnCAPKDetail - capk: %@", capk);
    lblGeneralData.text = @"onReturnCAPKDetail";
    NSLog(@"capk.location: %@", capk.location);
    NSLog(@"capk.rid: %@", capk.rid);
    NSLog(@"capk.exponent: %@", capk.exponent);
    NSLog(@"capk.modulus: %@", capk.modulus);
    NSLog(@"capk.checksum: %@", capk.checksum);
    NSLog(@"capk.size: %@", capk.size);
    NSLog(@"capk.index: %@", capk.index);
    
    [self showGeneralDataView:nil];
    [self clearGeneralDataView];
    [self appendDataToGeneralDataView:[NSString stringWithFormat:@"location: %@", capk.location]];
    [self appendDataToGeneralDataView:[NSString stringWithFormat:@"rid: %@", capk.rid]];
    [self appendDataToGeneralDataView:[NSString stringWithFormat:@"exponent: %@", capk.exponent]];
    [self appendDataToGeneralDataView:[NSString stringWithFormat:@"modulus: %@", capk.modulus]];
    [self appendDataToGeneralDataView:[NSString stringWithFormat:@"checksum: %@", capk.checksum]];
    [self appendDataToGeneralDataView:[NSString stringWithFormat:@"size: %@", capk.size]];
    [self appendDataToGeneralDataView:[NSString stringWithFormat:@"index: %@", capk.index]];
}
- (void)onReturnCAPKLocation:(NSString *)location{
    NSLog(@"onReturnCAPKLocation - location: %@", location);
    lblGeneralData.text = [NSString stringWithFormat:@"onReturnCAPKLocation\n location: %@", location];
}
- (void)onReturnUpdateCAPKResult:(BOOL)isSuccess{
    NSLog(@"onReturnUpdateCAPKResult - isSuccess: %d", isSuccess);
    lblGeneralData.text = [NSString stringWithFormat:@"onReturnUpdateCAPKResult\n isSuccess: %d", isSuccess];
}
- (void)onReturnEmvReportList:(NSDictionary *)data{
    NSLog(@"onReturnEmvReportList - data: %@", data);
    lblGeneralData.text = [NSString stringWithFormat:@"onReturnEmvReportList\n [data count]: %d", (int)[data count]];
    
    [self showGeneralDataView:nil];
    [self clearGeneralDataView];
    NSArray *keys = [data allKeys];
    for (NSString *key in keys) {
        [self appendDataToGeneralDataView:[NSString stringWithFormat:@"applicationIndex: %@", key]];
        [self appendDataToGeneralDataView:[NSString stringWithFormat:@"AID: %@\n", [data objectForKey:key]]];
    }
}
- (void)onReturnEmvReport:(NSString *)tlv{
    NSLog(@"onReturnEmvReport - tlv: %@", tlv);
    lblGeneralData.text = @"onReturnEmvReport";
    [self displayDataOnScrollTextView:[NSString stringWithFormat:@"onReturnEmvReport - TLV:\n%@", tlv]];
    
    NSLog(@"decodeTlv: %@", [[EmvSwipeController sharedController] decodeTlv:tlv]);
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
        [[BBDeviceOTAController sharedController] setBBDeviceController:[EmvSwipeController sharedController]]){
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
    lblGeneralData.text = [NSString stringWithFormat:@"onReturnRemoteKeyInjectionResult \nBBDeviceOTAResult: %d\nresponseMessage: %@", result, responseMessage];
    
    
}
- (void)onReturnRemoteFirmwareUpdateResult:(BBDeviceOTAResult)result responseMessage:(NSString *)responseMessage{
    NSLog(@"onReturnRemoteFirmwareUpdateResult - BBDeviceOTAResult: %d, responseMessage: %@", result, responseMessage);
    lblGeneralData.text = [NSString stringWithFormat:@"onReturnRemoteFirmwareUpdateResult \nBBDeviceOTAResult: %d\nresponseMessage: %@", result, responseMessage];
    
    
}
- (void)onReturnRemoteConfigUpdateResult:(BBDeviceOTAResult)result responseMessage:(NSString *)responseMessage{
    NSLog(@"onReturnRemoteConfigUpdateResult - BBDeviceOTAResult: %d, responseMessage: %@", result, responseMessage);
    lblGeneralData.text = [NSString stringWithFormat:@"onReturnRemoteConfigUpdateResult \nBBDeviceOTAResult: %d\nresponseMessage: %@", result, responseMessage];
    
    
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
    
    [[EmvSwipeController sharedController] stopAudio];
    [[EmvSwipeController sharedController] setDelegate:nil];
    
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
@end
