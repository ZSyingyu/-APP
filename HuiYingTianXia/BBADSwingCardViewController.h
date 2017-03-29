//
//  BBADSwingCardViewController.h
//  HuiYingTianXia
//
//  Created by 朱颖宇 on 15/8/24.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "vcom.h"
#import <Foundation/Foundation.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MessageUI.h>
#import "CSwiperStateChangedListener.h"

#import "EmvSwipeController.h"
#define kWithOTAController 0

@interface BBADSwingCardViewController : BaseViewController<CSwiperStateChangedListener,UITextViewDelegate,MFMailComposeViewControllerDelegate,EmvSwipeControllerDelegate, UIScrollViewDelegate, UITextFieldDelegate, UIAlertViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

{
@private
EmvSwipeController *controller;
//id <EmvSwipeControllerDelegate> EmvSwipeControllerDelegate;
BOOL pageControlUsed;
NSArray *pickerDataSourceArray;
int checkCardCounter;

NSString *pickerType;
NSString *alertType;

UIAlertView *genericAlert;
BOOL isBadSwiped;
BOOL isWrongPin;
BOOL isCanceledPin;

BOOL isStartEmvWithDisabledDisplayText;
BOOL isStartEmvWithTerminalTime;
BOOL isStartEmvWithAmount;
BOOL isAutoSetAmount;
BOOL isAutoSelectApplication;
BOOL isAutoPinEntry;
BOOL isAutoFinalConfirm;
BOOL isAutoSendOnlineProcessResult;
BOOL isCheckingCardPresent;
BOOL isRunningFelicaCommandSequence;
int exchangeApduAfterOnRequestOnlineProcess_apduIndex;
NSMutableArray *felicaCommandSequence;

NSString *tempNfcData;
NSString *plaintextPAN;
NSDate *debugTimer;
}

@property (nonatomic, retain) EmvSwipeController *controller;
@property (nonatomic, assign) id<EmvSwipeControllerDelegate> EmvSwipeControllerDelegate;
@property (nonatomic, retain) NSArray *pickerDataSourceArray;
@property (nonatomic, retain) NSString *pickerType;
@property (nonatomic, retain) NSString *alertType;
@property (nonatomic, retain) UIAlertView *genericAlert;
@property (nonatomic, retain) NSString *tempNfcData;
@property (nonatomic, retain) NSString *plaintextPAN;
@property (nonatomic, retain) NSMutableArray *felicaCommandSequence;
@property (nonatomic, retain) NSDate *debugTimer;

@property (retain, nonatomic) IBOutlet UILabel *lblApiVersionNumber;

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UIPageControl *pageControl;
@property (retain, nonatomic) IBOutlet UIView *viewBtnPage1;
@property (retain, nonatomic) IBOutlet UIView *viewBtnPage2;
@property (retain, nonatomic) IBOutlet UIView *viewBtnPage3;
@property (retain, nonatomic) IBOutlet UIView *viewBtnPage4;
@property (retain, nonatomic) IBOutlet UIView *viewBtnPage5;
@property (retain, nonatomic) IBOutlet UIView *viewBtnPage6;
@property (retain, nonatomic) IBOutlet UIView *viewBtnPage7;
@property (retain, nonatomic) IBOutlet UIView *viewBtnPage8;
@property (retain, nonatomic) IBOutlet UIView *viewBtnPage9;
@property (retain, nonatomic) IBOutlet UIView *viewBtnPage10;
@property (retain, nonatomic) IBOutlet UIView *viewBtnPage11;
@property (retain, nonatomic) IBOutlet UIView *viewBtnPage12;
@property (retain, nonatomic) IBOutlet UIView *viewBtnPage20;

@property (retain, nonatomic) IBOutlet UIView *viewGeneralDataPanel;
@property (retain, nonatomic) IBOutlet UILabel *lblGeneralData;
@property (retain, nonatomic) IBOutlet UIView *viewAmount;

@property (retain, nonatomic) IBOutlet UIView *viewStatePanel;
@property (retain, nonatomic) IBOutlet UILabel *lblCallbackData;
@property (retain, nonatomic) IBOutlet UILabel *lblEmvSwipeControllerState;
@property (retain, nonatomic) IBOutlet UILabel *lblError;

@property (retain, nonatomic) IBOutlet UIView *viewTrackDataPanel;

@property (retain, nonatomic) IBOutlet UIView *viewDisplayData;
@property (retain, nonatomic) IBOutlet UITextView *txtDisplayData;

@property (retain, nonatomic) IBOutlet UIView *viewGeneralData;
@property (retain, nonatomic) IBOutlet UITextView *txtGeneralData;

@property (retain, nonatomic) IBOutlet UIView *viewNFCData;
@property (retain, nonatomic) IBOutlet UILabel *lblNFCData;

@property (retain, nonatomic) IBOutlet UIPickerView *pickerSelectValue;
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
@property (retain, nonatomic) IBOutlet UITextField *txtApduLength;
@property (retain, nonatomic) IBOutlet UITextField *txtApdu2;
@property (retain, nonatomic) IBOutlet UITextView *txtTrackData;
@property (retain, nonatomic) IBOutlet UILabel *lblPlainTextPAN;
@property (retain, nonatomic) IBOutlet UITextField *txtEncryptDataInput;
@property (retain, nonatomic) IBOutlet UITextView *txtEncryptDataResult;
@property (retain, nonatomic) IBOutlet UITextField *txtTerminalSettingTLV;
@property (retain, nonatomic) IBOutlet UITextField *txtReadTerminalSetting;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segmentedControlFormatID;
@property (retain, nonatomic) IBOutlet UILabel *lblSelectFormatID;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segmentedControlCheckCardMode;
@property (retain, nonatomic) IBOutlet UISwitch *switchEnableDisplayText;
@property (retain, nonatomic) IBOutlet UISwitch *switchAddCheckCardModeInput;
@property (retain, nonatomic) IBOutlet UITextField *txtPANForEncryptPIN;
@property (retain, nonatomic) IBOutlet UITextField *txtPINForEncryptPIN;
@property (retain, nonatomic) IBOutlet UIProgressView *progressViewOTA;
@property (retain, nonatomic) IBOutlet UILabel *lblProgressOTA;
@property (retain, nonatomic) IBOutlet UISwitch *switchOTAForceUpdate;
@property (retain, nonatomic) IBOutlet UILabel *lblOTAControllerVersion;

- (IBAction)detectDevice:(id)sender;
- (IBAction)btnAction_StartAudio:(id)sender;
- (IBAction)btnAction_StopAudio:(id)sender;

- (IBAction)btnAction_StartTransaction:(id)sender;
- (IBAction)btnAction_CheckCardWithData:(id)sender;
- (IBAction)btnAction_isCardPresent:(id)sender;
- (IBAction)btnAction_CancelCheckCard:(id)sender;
- (IBAction)btnAction_StartEmv:(id)sender;
- (IBAction)btnAction_StartEmvWithData:(id)sender;
- (IBAction)btnAction_SetAmount:(id)sender;
- (IBAction)btnAction_GetDeviceInfo:(id)sender;
- (IBAction)btnAction_GetKsn:(id)sender;
- (IBAction)btnAction_GetEmvCardData:(id)sender;
- (IBAction)btnAction_GetEmvCardNumber:(id)sender;
- (IBAction)btnAction_GetEmvCardBalance:(id)sender;
- (IBAction)btnAction_GetEmvTransactionLog:(id)sender;
- (IBAction)btnAction_GetEmvLoadLog:(id)sender;

- (IBAction)btnAction_SelectPickerValue_Confirm:(id)sender;
- (IBAction)btnAction_SelectPickerValue_Cancel:(id)sender;

- (IBAction)btnAction_PowerOnIcc:(id)sender;
- (IBAction)btnAction_PowerOffIcc:(id)sender;
- (IBAction)btnAction_SendApdu:(id)sender;
- (IBAction)btnAction_SendApduWithPkcs7Padding:(id)sender;
- (IBAction)btnAction_ExchangeApdu:(id)sender;

- (IBAction)btnAction_IsDeviceHere:(id)sender;
- (IBAction)btnAction_EncryptPin:(id)sender;
- (IBAction)btnAction_EncryptData:(id)sender;

- (IBAction)btnAction_UpdateTerminalSetting:(id)sender;
- (IBAction)btnAction_ReadTerminalSetting:(id)sender;

//CAPK
- (IBAction)btnAction_CAPK_getCAPKList:(id)sender;
- (IBAction)btnAction_CAPK_getCAPKDetail:(id)sender;
- (IBAction)btnAction_CAPK_findCAPKLocation:(id)sender;
- (IBAction)btnAction_CAPK_updateCAPK:(id)sender;

- (IBAction)btnAction_getEmvReportList:(id)sender;
- (IBAction)btnAction_getEmvReport:(id)sender;

//OTA
- (IBAction)btnAction_OTA_UpdateFirmware:(id)sender;
- (IBAction)btnAction_OTA_UpdateConfig:(id)sender;
- (IBAction)btnAction_OTA_InjectKey:(id)sender;
- (IBAction)btnAction_OTA_Stop:(id)sender;

#pragma mark - UI
- (IBAction)backgroundButtonTouchUpInside:(id)sender;
- (IBAction)showTlvDataView:(id)sender;
- (IBAction)resetAllUI:(id)sender;
- (IBAction)hideKeyboard:(id)sender;
- (IBAction)showGeneralDataView:(id)sender;
- (IBAction)sliderValueChanged:(id)sender;

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
