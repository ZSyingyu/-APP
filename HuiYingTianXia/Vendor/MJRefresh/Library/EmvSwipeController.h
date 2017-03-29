//
//  EmvSwipeController.h
//  EmvSwipeAPI
//
//  Created by Alex Wong on 2015-01-02.
//  Copyright 2015 BBPOS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CAPK.h"

typedef enum {
    EmvSwipeControllerState_AudioStopped,
    EmvSwipeControllerState_Idle,
    EmvSwipeControllerState_WaitingForResponse
} EmvSwipeControllerState;

#pragma mark - Enum of Status, Return value

typedef enum {
    BatteryStatus_Low,
    BatteryStatus_CriticallyLow
} BatteryStatus;

typedef enum {
    EmvOption_Start,
    EmvOption_StartWithForceOnline
} EmvOption;

typedef enum {
    CheckCardResult_NoCard,
    CheckCardResult_InsertedCard,
    CheckCardResult_NotIccCard,
    CheckCardResult_BadSwipe,
    CheckCardResult_SwipedCard,
    CheckCardResult_MagHeadFail,
    CheckCardResult_NoResponse,
    CheckCardResult_OnlyTrack2,
    CheckCardResult_NFC_Track2,     //Added in 1.5.0
    CheckCardResult_UseIccCard,     //Added in 1.5.0
    CheckCardResult_TapCardDetected //Added in 2.5.0-Beta10
} CheckCardResult;

typedef enum {
    ErrorType_InvalidInput,
    ErrorType_InvalidInput_NotNumeric,
    ErrorType_InvalidInput_InputValueOutOfRange,
    ErrorType_InvalidInput_InvalidDataFormat,
    ErrorType_InvalidInput_NoAcceptAmountForThisTransactionType,
    ErrorType_InvalidInput_NotAcceptCashbackForThisTransactionType,
    
    ErrorType_DeviceReset,
    ErrorType_CommError,
    ErrorType_Unknown,
    
    ErrorType_AudioFailToStart,
    ErrorType_AudioNotYetStarted,
    ErrorType_IllegalStateException,
    ErrorType_CommandNotAvailable,                  //Added in 1.5.0
    ErrorType_AudioRecordingPermissionDenied,       //Added in 1.6.6 for iOS 7
    ErrorType_BackgroundTimeout,                    //Added in 1.6.6 for background mode
    ErrorType_AudioFailToStart_OtherAudioIsPlaying, //Added in 1.9.0-Beta2
    
    ErrorType_DeviceBusy //Added in 2.8.2_Beta3
} ErrorType;

typedef enum {
    TransactionResult_Approved,
    TransactionResult_Terminated,
    TransactionResult_Declined,
    TransactionResult_SetAmountCancelOrTimeout,
    TransactionResult_CapkFail,
    TransactionResult_NotIcc,
    TransactionResult_CardBlocked,                  //Updated in 1.7.2
    TransactionResult_DeviceError,                  //Updated in 1.7.2
    TransactionResult_CardNotSupported,             //Added in 1.5.0
    TransactionResult_MissingMandatoryData,         //Added in 1.5.0, Fixed a typo in 1.6.1
    TransactionResult_NoEmvApps,                    //Added in 1.5.0, Updated in 1.7.2
    TransactionResult_InvalidIccData,               //Added in 1.5.0, Fixed a typo in 1.6.1
    TransactionResult_ConditionsOfUseNotSatisfied,  //Added in 1.6.4
    TransactionResult_ApplicationBlocked,           //Added in 1.7.2
    TransactionResult_IccCardRemoved                //Added in 2.4.3
} TransactionResult;

typedef enum {
    TransactionType_Goods,
    TransactionType_Services,
    TransactionType_Cashback,
    TransactionType_Inquiry,
    TransactionType_Transfer,
    TransactionType_Payment,
    TransactionType_Refund  //Added in 2.4.3
} TransactionType;

typedef enum {
    ReferProcessResult_Approved,
    ReferProcessResult_Declined
} ReferProcessResult;

typedef enum {
    DisplayText_AMOUNT,        //Deprecated in 1.3.0
    DisplayText_AMOUNT_OK_OR_NOT,
    DisplayText_APPROVED,
    DisplayText_CALL_YOUR_BANK,
    DisplayText_CANCEL_OR_ENTER,
    DisplayText_CARD_ERROR,
    DisplayText_DECLINED,
    DisplayText_ENTER_AMOUNT,  //Deprecated in 1.3.0
    DisplayText_ENTER_PIN,     //Deprecated in 1.3.0
    DisplayText_INCORRECT_PIN,
    DisplayText_INSERT_CARD,
    DisplayText_NOT_ACCEPTED,
    DisplayText_PIN_OK,
    DisplayText_PLEASE_WAIT,
    DisplayText_PROCESSING_ERROR,
    DisplayText_REMOVE_CARD,
    DisplayText_USE_CHIP_READER,
    DisplayText_USE_MAG_STRIPE,
    DisplayText_TRY_AGAIN,
    DisplayText_REFER_TO_YOUR_PAYMENT_DEVICE,
    DisplayText_TRANSACTION_TERMINATED,
    DisplayText_TRY_ANOTHER_INTERFACE,
    DisplayText_ONLINE_REQUIRED,
    DisplayText_PROCESSING,
    DisplayText_WELCOME,
    DisplayText_PRESENT_ONLY_ONE_CARD,
    DisplayText_LAST_PIN_TRY,
    DisplayText_CAPK_LOADING_FAILED,
    DisplayText_SELECT_ACCOUNT,                             //Added in 2.5.0-Beta10
    DisplayText_INSERT_OR_TAP_CARD,                         //Added in 2.5.0-Beta10
    DisplayText_APPROVED_PLEASE_SIGN,                       //Added in 2.5.0-Beta10
    DisplayText_TAP_CARD_AGAIN,                             //Added in 2.5.0-Beta10
    DisplayText_AUTHORISING,                                //Added in 2.5.0-Beta10
    DisplayText_INSERT_OR_SWIPE_CARD_OR_TAP_ANOTHER_CARD,   //Added in 2.5.0-Beta10
    DisplayText_INSERT_OR_SWIPE_CARD,                       //Added in 2.5.0-Beta10
    DisplayText_MULTIPLE_CARDS_DETECTED                     //Added in 2.5.0-Beta10
} DisplayText;

typedef enum {
    TerminalSettingStatus_Success,
    TerminalSettingStatus_InvalidTlvFormat,
    TerminalSettingStatus_TagNotFound,
    TerminalSettingStatus_IncorrectLength
} TerminalSettingStatus; //Added in 2.0.0

typedef enum {
    CheckCardMode_Swipe,
    CheckCardMode_Insert,
    CheckCardMode_Tap,
    CheckCardMode_SwipeOrInsert
} CheckCardMode; //Added in 2.5.0-Beta10, Updated in 2.6.0

//CheckCardMode_SwipeOrTap,         //Deprecated in 2.6.0
//CheckCardMode_SwipeOrInsertOrTap, //Deprecated in 2.6.0
//CheckCardMode_InsertOrTap,        //Deprecated in 2.6.0

typedef enum {
    EmvSwipeEncryptionMethod_TDES_ECB,
    EmvSwipeEncryptionMethod_TDES_CBC,
    EmvSwipeEncryptionMethod_AES_ECB,
    EmvSwipeEncryptionMethod_AES_CBC,
    EmvSwipeEncryptionMethod_MAC_ANSI_X9_9,
    EmvSwipeEncryptionMethod_MAC_ANSI_X9_19,
    EmvSwipeEncryptionMethod_MAC_METHOD_1,
    EmvSwipeEncryptionMethod_MAC_METHOD_2
} EmvSwipeEncryptionMethod;

typedef enum {
    EmvSwipeEncryptionKeySource_BY_DEVICE_16_BYTES_RANDOM_NUMBER,
    EmvSwipeEncryptionKeySource_BY_DEVICE_8_BYTES_RANDOM_NUMBER,
    EmvSwipeEncryptionKeySource_BOTH,
    EmvSwipeEncryptionKeySource_BY_SERVER_16_BYTES_WORKING_KEY,
    EmvSwipeEncryptionKeySource_BY_SERVER_8_BYTES_WORKING_KEY,
    EmvSwipeEncryptionKeySource_STORED_IN_DEVICE_16_BYTES_KEY
} EmvSwipeEncryptionKeySource;

typedef enum {
    EmvSwipeEncryptionPaddingMethod_ZERO_PADDING,
    EmvSwipeEncryptionPaddingMethod_PKCS7
} EmvSwipeEncryptionPaddingMethod;

typedef enum {
    EmvSwipeEncryptionKeyUsage_TEK,
    EmvSwipeEncryptionKeyUsage_TAK,
    EmvSwipeEncryptionKeyUsage_TPK
} EmvSwipeEncryptionKeyUsage;

/*
 typedef enum {
 SupportedTrack_Track12,
 SupportedTrack_Track23,
 SupportedTrack_Track123,
 SupportedTrack_Unknown
 } SupportedTrack; //Deprecated in 1.4.1
 
 typedef enum {
 StartEmvResult_Success,
 StartEmvResult_Fail
 } StartEmvResult; //Deprecated in 2.2.0
 
 typedef enum {
 NfcDataExchangeStatus_Success,
 NfcDataExchangeStatus_NotYetPowerOn,
 NfcDataExchangeStatus_NoResponse
 } NfcDataExchangeStatus; //Deprecated in 2.5.0-Beta10
*/

@protocol EmvSwipeControllerDelegate;

@interface EmvSwipeController : NSObject {
    NSObject <EmvSwipeControllerDelegate>* delegate;
    BOOL detectDeviceChange;
}

@property (nonatomic, assign) NSObject <EmvSwipeControllerDelegate>* delegate;
@property (nonatomic, assign) BOOL detectDeviceChange;
@property (nonatomic, getter=isDebugLogEnabled, setter=setDebugLogEnabled:) BOOL debugLogEnabled;

- (NSString *)getApiVersion;
- (NSString *)getApiBuildNumber;

- (NSDictionary *)getIntegratedApiVersion;
- (NSDictionary *)getIntegratedApiBuildNumber;

+ (EmvSwipeController *)sharedController;
- (EmvSwipeControllerState)getEmvSwipeState;
- (EmvSwipeControllerState)getEmvSwipeControllerState;

- (void)isDeviceHere;
- (BOOL)isDevicePresent;
- (BOOL)startAudio; //Updated in 1.9.1
- (void)stopAudio;
- (void)resetEmvSwipeController;
- (void)releaseEmvSwipeController; //Added in 1.8.0 (For ARC project to release the controller)

// --- Function of Transaction Flow ---
- (void)getDeviceInfo;
- (BOOL)setAmount:(NSString *)amount
   cashbackAmount:(NSString *)cashbackAmount
     currencyCode:(NSString *)currencyCode
  transactionType:(TransactionType)transactionType; //Updated in 1.7.0
- (void)checkCard;
- (void)checkCard:(NSDictionary *)data; //Added in 2.2.0, timeout are configurable [Require FW 7.11c or above]
- (void)startEmv:(EmvOption)EmvOption;
- (void)startEmv:(EmvOption)EmvOption terminalTime:(NSString *)terminalTime; //Please use startEmvWithData
- (void)startEmvWithData:(NSDictionary *)data;  //Added in 2.2.0, timeouts are configurable [Require FW 7.11c or above]
- (void)selectApplication:(int)applicationIndex;
- (void)getKsn;                                     //Added in 1.4.1
- (void)getEmvCardData;                             //Added in 1.6.0, Updated in 1.6.1
- (void)getEmvCardNumber;                           //Added in 2.4.0
- (void)getEmvCardBalance:(NSDictionary *)data;     //Added in 2.7.0-Beta1
- (void)getEmvTransactionLog:(NSDictionary *)data;  //Added in 2.7.0-Beta1
- (void)getEmvLoadLog:(NSDictionary *)data;         //Added in 2.7.0-Beta2

// Reply request of EmvSwipe
- (void)sendTerminalTime:(NSString *)terminalTime;
- (void)sendFinalConfirmResult:(BOOL)isConfirmed;
- (void)sendServerConnectivity:(BOOL)isConnected;
- (void)sendOnlineProcessResult:(NSString *)tlv;

// Cancel
- (void)cancelCheckCard; //Added in 1.8.2
- (void)cancelSetAmount;
- (void)cancelSelectApplication;

// EMV Level 1 command for ADPU exchange
- (void)powerOnIcc;     //Added in 1.4.1
- (void)powerOffIcc;    //Added in 1.4.1
- (void)sendApdu:(NSString *)apdu apduLength:(int)apduLength;   //Added in 1.4.1
- (void)sendApduWithPkcs7Padding:(NSString *)apdu;              //Added in 1.6.4-Beta6

// Encryption
- (void)encryptPin:(NSDictionary *)data;                //Added in 2.7.0-Beta2
- (void)encryptPin:(NSString *)pin pan:(NSString *)pan; //Added in 1.7.1
- (void)encryptData:(NSString *)data;                   //Added in 1.8.0
- (void)encryptDataWithSettings:(NSDictionary *)data;   //Added in 2.9.0-Beta1 [Require FW 9.00.20.28 or above]

// Terminal Setting
- (void)readTerminalSetting:(NSString *)tag;     //Added in 2.0.0
- (void)updateTerminalSetting:(NSString *)tlv;   //Added in 2.0.0

// New EMV Kernel
- (void)sendVerifyIDResult:(BOOL)isSuccess; //Added in 2.4.0 [Require FW 8.0a or above]

// Utility
- (NSDictionary *)decodeTlv:(NSString *)tlv; //Added in 2.4.0

//ViPOS
- (NSString *)viposGetIccData:(NSString *)tlv; //Added in 2.4.0
- (void)viposExchangeApdu:(NSString *)apdu;                     //Added in 2.3.0
- (void)viposBatchExchangeApdu:(NSDictionary *)apduCommands;    //Added in 2.4.0
- (void)sendPinEntryResult:(NSString *)pin;                     //Enable for ViPOS
- (void)bypassPinEntry;                                         //Enable for ViPOS
- (void)cancelPinEntry;                                         //Enable for ViPOS

// CAPK
- (void)getCAPKList;
- (void)getCAPKDetail:(NSString *)location;
- (void)findCAPKLocation:(NSDictionary *)data;
- (void)updateCAPK:(CAPK *)capk;
- (void)getEmvReportList;
- (void)getEmvReport:(NSString *)applicationIndex;

// Deprecated Function
//- (void)sendReferProcessResult:(ReferProcessResult)result;   //Deprecated since Firmware 4.2x and 4.3x
//- (void)cancelReferProcess;                                  //Deprecated since Firmware 4.2x and 4.3x

//- (void)powerOnNfc:(NSString *)data;                                  //Deprecated in 2.5.0-Beta10
//- (void)powerOffNfc;                                                  //Deprecated in 2.5.0-Beta10
//- (void)nfcDataExchange:(NSString *)data dataLength:(int)dataLength;  //Deprecated in 2.5.0-Beta10
//- (void)readFelicaCardData:(NSString *)data;                          //Deprecated in 2.5.0-Beta10

@end

@protocol EmvSwipeControllerDelegate <NSObject>

@optional

- (void)onBatteryLow:(BatteryStatus)batteryStatus;
- (void)onWaitingForCard;
- (void)onWaitingForCard:(CheckCardMode)checkCardMode; //Added in 2.6.0

- (void)onOnlineProcessDataDetected;    //Added in 2.8.0
- (void)onBatchDataDetected;            //Added in 2.8.0
- (void)onReversalDataDetected;         //Added in 2.8.0

// Callback of Result
- (void)onReturnCheckCardResult:(CheckCardResult)result cardDataDict:(NSDictionary *)cardDataDict;
- (void)onReturnCancelCheckCardResult:(BOOL)isSuccess;      //Added in 1.9.2
- (void)onReturnBatchData:(NSString *)tlv;
- (void)onReturnTransactionResult:(TransactionResult)result data:(NSDictionary *)data; //Updated in 2.4.0, data dictionary is for special firmware only
- (void)onReturnDeviceInfo:(NSDictionary *)deviceInfoDict;  //Updated in 1.4.1
- (void)onReturnReversalData:(NSString *)tlv;
- (void)onReturnKsn:(NSDictionary *)ksnDict;                //Added in 1.4.1

// Callback of Request
- (void)onRequestSelectApplication:(NSArray *)applicationArray;
- (void)onRequestSetAmount;
- (void)onRequestCheckServerConnectivity;
- (void)onRequestOnlineProcess:(NSString *)tlv;
- (void)onRequestTerminalTime;
- (void)onRequestFinalConfirm;
- (void)onRequestDisplayText:(DisplayText)displayMessage;
- (void)onRequestClearDisplay;
- (void)onRequestPinEntry; //Enable for ViPOS

// Callback of Error
- (void)onError:(ErrorType)ErrorType errorMessage:(NSString *)errorMessage;
- (void)onInterrupted;
- (void)onNoDeviceDetected;

- (void)onDevicePlugged;
- (void)onDeviceUnplugged;

// EMV Level 1 command for ADPU exchange
- (void)onReturnPowerOnIccResult:(BOOL)isSuccess
                             ksn:(NSString *)ksn
                             atr:(NSString *)atr
                       atrLength:(int)atrLength;    //Added in 1.4.1
- (void)onReturnPowerOffIccResult:(BOOL)isSuccess;  //Added in 1.4.1
- (void)onReturnApduResult:(BOOL)isSuccess
                      apdu:(NSString *)apdu
                apduLength:(int)apduLength;         //Added in 1.4.1
- (void)onReturnApduResultWithPkcs7Padding:(BOOL)isSuccess
                                      apdu:(NSString *)apdu;        //Added in 1.6.4-Beta5
- (void)onReturnViposExchangeApduResult:(NSString *)apdu;            //Added in 2.3.0
- (void)onReturnViposBatchExchangeApduResult:(NSDictionary *)data;   //Added in 2.4.0

// Encryption
- (void)onReturnEncryptPinResult:(NSDictionary *)data;                              //Added in 2.7.0-Beta2
- (void)onReturnEncryptPinResult:(NSString *)epb ksn:(NSString *)ksn;               //Added in 1.7.1
- (void)onReturnEncryptDataResult:(NSString *)encryptedData ksn:(NSString *)ksn;    //Added in 1.8.0
- (void)onReturnEncryptDataResult:(NSDictionary *)data;                             //Added in 2.9.0-Beta1

// GetEmvCardData
- (void)onReturnEmvCardDataResult:(NSString *)tlv;                  //Added in 1.6.0, Updated in 1.6.1
- (void)onReturnEmvCardNumber:(NSString *)cardNumber;               //Added in 2.4.0
- (void)onReturnEmvCardBalance:(NSString *)tlv;                     //Added in 2.7.0-Beta1
- (void)onReturnEmvTransactionLog:(NSArray *)transactionLogArray;   //Added in 2.7.0-Beta1
- (void)onReturnEmvLoadLog:(NSArray *)dataArray;                    //Added in 2.7.0-Beta2

- (void)onDeviceHere:(BOOL)isHere;

// Terminal Setting
- (void)onReturnReadTerminalSettingResult:(TerminalSettingStatus)status tagValue:(NSString *)tagValue; //Added in 2.0.0
- (void)onReturnUpdateTerminalSettingResult:(TerminalSettingStatus)status; //Added in 2.0.0

// For China PBOC
- (void)onRequestVerifyID:(NSString *)tlv;      //Added in 2.4.0 [Require FW 8.0a or above]

// CAPK
- (void)onReturnCAPKList:(NSArray *)capkArray;
- (void)onReturnCAPKDetail:(CAPK *)capk;
- (void)onReturnCAPKLocation:(NSString *)location;
- (void)onReturnUpdateCAPKResult:(BOOL)isSuccess;
- (void)onReturnEmvReportList:(NSDictionary *)data;
- (void)onReturnEmvReport:(NSString *)tlv;

// Deprecated Callback
//- (void)onPowerDown;                            //Deprecated in 1.6.0
//- (void)onReturnTransactionLog:(NSString *)tlv; //Deprecated since Firmware 4.2x and 4.3x
//- (void)onRequestAdviceProcess:(NSString *)tlv; //Deprecated since Firmware 4.2x and 4.3x
//- (void)onRequestReferProcess:(NSString *)pan;  //Deprecated since Firmware 4.2x and 4.3x
//- (void)onReturnStartEmvResult:(StartEmvResult)result ksn:(NSString *)ksn; //Deprecated in 2.2.0

//- (void)onReturnPowerOnNfcResult:(BOOL)isSuccess
//                        response:(NSString *)response
//                  responseLength:(int)responseLength;     //Deprecated in 2.5.0-Beta10
//- (void)onReturnPowerOffNfcResult:(BOOL)isSuccess;        //Deprecated in 2.5.0-Beta10
//- (void)onReturnNfcDataResult:(NfcDataExchangeStatus)status
//                         data:(NSString *)data
//                   dataLength:(int)dataLength;            //Deprecated in 2.5.0-Beta10
//- (void)onReturnFelicaCardDataResult:(NfcDataExchangeStatus)status
//                                data:(NSString *)data;    //Deprecated in 2.5.0-Beta10


@end
