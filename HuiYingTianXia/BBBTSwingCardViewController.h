//
//  BBBTSwingCardViewController.h
//  HuiYingTianXia
//
//  Created by 朱颖宇 on 15/8/31.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"
#import "vcom.h"
#import <Foundation/Foundation.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MessageUI.h>
#import "CSwiperStateChangedListener.h"

#import "WisePadController.h"
#define kWithOTAController 0



@interface BBBTSwingCardViewController : BaseViewController<CSwiperStateChangedListener,UITextViewDelegate,MFMailComposeViewControllerDelegate,WisePadControllerDelegate, UIScrollViewDelegate, UITextFieldDelegate, UIAlertViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
@private
//id <WisePadControllerDelegate> WisePadControllerDelegate;
BOOL pageControlUsed;
NSArray *pickerDataSourceArray;
NSArray *pickerDataSourceArray_Currency;
int checkCardCounter;

NSString *pickerType;
NSString *alertType;
NSString *currConnectingBTv4DeviceName;
NSString *productModel;
NSString *apduKsn;

UIAlertView *genericAlert;
BOOL isBadSwiped;
BOOL isWrongPin;
BOOL isCanceledPin;
BOOL isCheckCardOnly;
BOOL isSwipeCardOnly;
BOOL isAutoSetAmount;
BOOL isAutoSelectApplication;
BOOL isAutoFinalConfirm;
BOOL isAutoSendOnlineProcessResult;
BOOL isStartEmvWithTerminalTime;
BOOL isStartEmvWithDisabledDisplayText;
BOOL isAutoConnectLastBTv4Device;

NSMutableDictionary *BluetoothDeviceDict;
}

@property (nonatomic, assign) id<WisePadControllerDelegate> WisePadControllerDelegate;
@property (nonatomic, retain) NSArray *pickerDataSourceArray;
@property (nonatomic, retain) NSArray *pickerDataSourceArray_Currency;
@property (nonatomic, retain) NSString *pickerType;
@property (nonatomic, retain) NSString *alertType;
@property (nonatomic, retain) NSString *currConnectingBTv4DeviceName;
@property (nonatomic, retain) NSString *productModel;
@property (nonatomic, retain) NSString *apduKsn;
@property (nonatomic, retain) UIAlertView *genericAlert;
@property (nonatomic, retain) NSMutableDictionary *BluetoothDeviceDict;

@property (retain, nonatomic) IBOutlet UILabel *lblApiVersionNumber;

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UIPageControl *pageControl;
@property (retain, nonatomic) IBOutlet UIView *viewBtnPage0;
@property (retain, nonatomic) IBOutlet UIView *viewBtnPage1;
@property (retain, nonatomic) IBOutlet UIView *viewBtnPage2;
@property (retain, nonatomic) IBOutlet UIView *viewBtnPage3;
@property (retain, nonatomic) IBOutlet UIView *viewBtnPage4;
@property (retain, nonatomic) IBOutlet UIView *viewBtnPage5;
@property (retain, nonatomic) IBOutlet UIView *viewBtnPage9;
@property (retain, nonatomic) IBOutlet UIView *viewBtnPage11;
@property (retain, nonatomic) IBOutlet UIView *viewBtnPage12;
@property (retain, nonatomic) IBOutlet UIView *viewBtnPage13;
@property (retain, nonatomic) IBOutlet UIView *viewTerminalSetting;
@property (retain, nonatomic) IBOutlet UIView *viewBtnPage20;

@property (retain, nonatomic) IBOutlet UIView *viewGeneralData;
@property (retain, nonatomic) IBOutlet UITextView *txtGeneralData;
@property (retain, nonatomic) IBOutlet UIView *viewGeneralDataPanel;
@property (retain, nonatomic) IBOutlet UILabel *lblGeneralData;
@property (retain, nonatomic) IBOutlet UIView *viewAmount;

@property (retain, nonatomic) IBOutlet UIView *viewStatePanel;
@property (retain, nonatomic) IBOutlet UILabel *lblCallbackData;
@property (retain, nonatomic) IBOutlet UILabel *lblWisePadControllerState;
@property (retain, nonatomic) IBOutlet UILabel *lblError;

@property (retain, nonatomic) IBOutlet UIView *viewTrackDataPanel;

@property (retain, nonatomic) IBOutlet UIView *viewTLVData;
@property (retain, nonatomic) IBOutlet UITextView *txtTLVData;

@property (retain, nonatomic) IBOutlet UIPickerView *pickerSelectValue;
@property (retain, nonatomic) IBOutlet UIPickerView *pickerCurrencyCharacter;
@property (retain, nonatomic) IBOutlet UILabel *lblTest1;
@property (retain, nonatomic) IBOutlet UILabel *lblTest2;
@property (retain, nonatomic) IBOutlet UILabel *lblBuildNumber;
@property (retain, nonatomic) IBOutlet UILabel *lblAmount;
@property (retain, nonatomic) IBOutlet UILabel *lblPan;
@property (retain, nonatomic) IBOutlet UILabel *lblExpiryDate;
@property (retain, nonatomic) IBOutlet UILabel *lblCardholderName;
@property (retain, nonatomic) IBOutlet UILabel *lblKsn;
@property (retain, nonatomic) IBOutlet UILabel *lblServiceCode;
@property (retain, nonatomic) IBOutlet UILabel *lblTrack1;
@property (retain, nonatomic) IBOutlet UILabel *lblTrack2;
@property (retain, nonatomic) IBOutlet UILabel *lblTrack3;
@property (retain, nonatomic) IBOutlet UILabel *lblFormatID;
@property (retain, nonatomic) IBOutlet UILabel *lblDemoAppTitle;
@property (retain, nonatomic) IBOutlet UILabel *lblTracks;
@property (retain, nonatomic) IBOutlet UITextField *txtApdu;
@property (retain, nonatomic) IBOutlet UITableView *bluetoothDeviceTable;
@property (retain, nonatomic) IBOutlet UILabel *lbLastConnectedBTv4DeviceName;
@property (retain, nonatomic) IBOutlet UILabel *lbLastConnectedBTv4DeviceUUID;
@property (retain, nonatomic) IBOutlet UITextField *txtCurrencyCode;
@property (retain, nonatomic) IBOutlet UITextView *txtDisplayData;
@property (retain, nonatomic) IBOutlet UIView *viewDisplayData;
@property (retain, nonatomic) IBOutlet UITextField *txtTerminalSettingTLV;
@property (retain, nonatomic) IBOutlet UITextField *txtReadTerminalSetting;
@property (retain, nonatomic) IBOutlet UILabel *lblFinalMessage;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segmentedControlAmountInputType;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segmentedControlFormatID;
@property (retain, nonatomic) IBOutlet UILabel *lblSelectFormatID;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segmentedControlCheckCardMode;
@property (retain, nonatomic) IBOutlet UISwitch *switchCallStartPinEntryAfterSwipedCard;
@property (retain, nonatomic) IBOutlet UISwitch *switchOTAForceUpdate;
@property (retain, nonatomic) IBOutlet UILabel *lblProgressOTA;
@property (retain, nonatomic) IBOutlet UILabel *lblOTAControllerVersion;
@property (retain, nonatomic) IBOutlet UIProgressView *progressViewOTA;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segmentedControlOTAFirmwareType;
@property (retain, nonatomic) IBOutlet UITextField *txtApduLength;

- (IBAction)btnAction_DetectDevice:(id)sender;
- (IBAction)btnAction_StartTransaction:(id)sender;
- (IBAction)btnAction_CheckCard:(id)sender;
- (IBAction)btnAction_SwipeCard:(id)sender;
- (IBAction)btnAction_GetDeviceInfo:(id)sender;
- (IBAction)btnAction_SetAmount:(id)sender;
- (IBAction)btnAction_EnableSetAmount:(id)sender;
- (IBAction)btnAction_CancelCheckCard:(id)sender;
- (IBAction)btnAction_StartEMV:(id)sender;
- (IBAction)btnAction_Print:(id)sender;
- (IBAction)btnAction_GetEmvCardData:(id)sender;
- (IBAction)btnAction_GetEmvCardNumber:(id)sender;
- (IBAction)btnAction_GetEmvCardBalance:(id)sender;
- (IBAction)btnAction_GetEmvTransactionLog:(id)sender;
- (IBAction)btnAction_GetEmvLoadLog:(id)sender;
- (IBAction)btnAction_GetMagStripeCardNumber:(id)sender;
- (IBAction)btnAction_EncryptPin:(id)sender;
- (IBAction)btnAction_EncryptData:(id)sender;
- (IBAction)btnAction_GetPhoneNumber:(id)sender;
- (IBAction)btnAction_CancelGetPhoneNumber:(id)sender;
- (IBAction)btnAction_UpdateTerminalSetting:(id)sender;
- (IBAction)btnAction_ReadTerminalSetting:(id)sender;
- (IBAction)btnAction_viposExchangeApdu:(id)sender;
- (IBAction)btnAction_viposBatchExchangeApdu:(id)sender;
- (IBAction)btnAction_CancelPinEntry:(id)sender;

- (IBAction)btnAction_SelectPickerValue_Confirm:(id)sender;
- (IBAction)btnAction_SelectPickerValue_Cancel:(id)sender;

//OTA
- (IBAction)btnAction_OTA_UpdateFirmware:(id)sender;
- (IBAction)btnAction_OTA_UpdateConfig:(id)sender;
- (IBAction)btnAction_OTA_InjectKey:(id)sender;
- (IBAction)btnAction_OTA_Stop:(id)sender;

//APDU
- (IBAction)btnAction_PowerOnIcc:(id)sender;
- (IBAction)btnAction_PowerOffIcc:(id)sender;
- (IBAction)btnAction_SendApdu:(id)sender;
- (IBAction)btnAction_SendApduWithPkcs7Padding:(id)sender;

#pragma mark - UI
- (IBAction)backgroundButtonTouchUpInside:(id)sender;
- (IBAction)showTlvDataView:(id)sender;
- (IBAction)resetAllUI:(id)sender;
- (IBAction)hideKeyboard:(id)sender;
- (IBAction)sliderValueChanged:(id)sender;

#pragma mark - Audio
- (IBAction)startAudio:(id)sender;
- (IBAction)stopAudio:(id)sender;

#pragma mark - Bluetooth
- (IBAction)btnAction_ScanBTv4:(id)sender;
- (IBAction)btnAction_ConnectLastDevice:(id)sender;
- (IBAction)btnAction_DisconnectBTv4:(id)sender;

//{
//    vcom* m_vcom;
//    UITextView *_cardInfoView;
//    id timer;
//    id timerForAishua;
//}
@property (nonatomic,retain) UITextView *cardInfoView;
@property (nonatomic,retain) UIButton *getKsnBtn;
@property (nonatomic,retain) UIButton *swipeCardBtn;
@property (nonatomic,retain) UIButton *stopBtn;
@property(strong,nonatomic)NSString *vouchNo;


-(void)refreshSwipeDisplay:(NSString *)displayData;



//启动录音，启动数据接收
-(void) StartRec;

//停止录音，停止数据接收
-(void)StopRec;
@end
