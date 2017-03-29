//
//  CommunicationCallBack.h
//  voclib
//
//  Created by hezewen on 14-5-23.
//
//

#import <Foundation/Foundation.h>
#import "CSwiperStateChangedListener.h"
@protocol CommunicationCallBack <NSObject>

//通知监听器可以进行刷卡动作
- (void)onWaitingForCardSwipe;

//检测到IC卡插入回调,通知客户端正在进行ic卡操作,用户禁止拔卡
- (void)EmvOperationWaitiing;

//IC卡回写脚本执行返回结果
- (void)onICResponse:(int)result resScript:(NSString *)resuiltScript data:(NSString *)data;
//参数下载回调
- (void)onLoadParam:(NSString *)param;

- (void)onDeviceKind:(int)result;


- (void)dataArrive:(vcom_Result*) vs  Status:(int)_status;
//收到数据回调
- (void)onTimeout;
//通信超时回调

- (void)onError:(NSInteger) code msg:(NSString*) msg;
//出错回调

- (void)closeOk;
//蓝牙关闭成功的回调

/*!
 @method
 @abstract 通知ksn
 @discussion 正常启动刷卡器后，将返回ksn
 @param ksn 取得的ksn
 @2014.8.8修改，把版本也传过去
 */
-(void)onGetKsnCompleted:(NSString *)ksn AndType:(NSString *)type;
// @2014.8.8修改，把版本也传过去
- (void)onGetKsnAndVersionCompleted:(NSArray *)ksnAndVerson;
//ic卡刷卡器回调。
-(void)onDecodeCompleted:(NSString*) formatID
                  andKsn:(NSString*) ksn
            andencTracks:(NSString*) encTracks
         andTrack1Length:(int) track1Length
         andTrack2Length:(int) track2Length
         andTrack3Length:(int) track3Length
         andRandomNumber:(NSString*) randomNumber
           andCardNumber:(NSString *)maskedPAN
                  andPAN:(NSString*) pan
           andExpiryDate:(NSString*) expiryDate
       andCardHolderName:(NSString*) cardHolderName
                  andMac:(NSString *)mac
        andQTPlayReadBuf:(NSString*) readBuf
                cardType:(int)type
              cardserial:(NSString *)serialNum
             emvDataInfo:(NSString *)data55
                 cvmData:(NSString *)cvm;

//公钥修复成功
@optional
- (void)didfinishICUpdate;
@end
