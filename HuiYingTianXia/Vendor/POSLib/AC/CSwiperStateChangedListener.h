
//
//  CSwiperStateChangedListener.h : interface for the CSwiperStateChangedListener class.
//  StaticLibSDK
//
//  Created by Alex on 13-7-22.
//  Copyright (c) 2013年 www.itron.com.cn All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CSwiperStateChangedListener
@required
typedef struct{
    //保存了6D开头的整串返回数据
    char readbuf[1024];
    int readbufLen;
    
    //数据结果
    int res;
    // 发送指令
    char rescode[2];
    //psam卡号码
    char psamno[100];
    int  psamnoLen;
    
    //pan码
    char pan[20];
    int  panLen;
    
    //硬件序列号
    char hardSerialNo[40];
    int  hardSerialNoLen;
    
    //卡号明文
    char cardPlaintext[50];
    char cardPlaintextLen;
    
    //卡号密文
    char cardEncryption[50];
    char cardEncryptionLen;
    
    //磁道密文
    char trackEncryption[200];
    int  trackEncryptionLen;
    
    //磁道明文
    char trackPlaintext[200];
    int  trackPlaintextLen;
    
    char Track2[100];
    int  track2Len;
    char Track3[100];
    int  track3Len;
    
    //pin密文
    char pinEncryption[50];
    int  pinEncryptionLen;
    
    //mac计算结果
    char macres[100];
    int macresLen;
    
    //mac验证结果
    bool macVerifyResult;
    
    //商户号码
    char traderNoInPsam[200];
    int traderNoInPsamLen;
    
    //终端号码
    char termialNoInPsam[100];
    int  termialNoInPsamLen;
    
    
    //用户输入数据
    char userInput[100];
    int userInputLen;
    
    
    
    /*爱刷数据*/
    char cd1[100]; //磁道1
    char cd2[200]; //磁道2
    char cd3[200]; //磁道3
    char rand[20]; //随机数
    char seq[20];  //序列号
    char cdno[40];  //卡号码
    char cdmw[500]; //磁道密文
    int cd1len,cd2len,cd3len,randlen,seqlen,cdnolen,cdmwlen;
    char ksn[40];  //硬件号码
    int ksnlen;
    char ver[20];  //程序版本
    int verlen;
    char mac[50]; //mac
    int maclen;
    
    int carddateLen;
    char carddate[4]; //卡有效期
    int data55Len;
    char data55[300]; //ic卡55域名
    int xulieDataLen;
    char xulieData[16];//卡片序列号
    int cvmLen;
    char cvmData[3]; //CVM
    //加密指令放回数据
    char Return_DataEnc[100];
    int Return_DataEnclen;
    //透传命令返回数据
    int orderLen;
    int orderNum;
    char Return_orders[500];
    
    //IC卡回写
    int ICReturn;
    int scriptDataLen;
    char scriptData[20];
    int ICReturnDataLen;
    char ICReturnData[255];
    //    参数下载
    int loadLen;
    char loadData[500];
    //设备类型
    int deviceLen;
    char deviceKind[2];
    int cardTypeLen;
    char cardType[2];
    //蓝牙
    int bleNameLen;
    char bleName[100];
    int bleMacLen;
    char bleMac[100];
    int bleVerLen;
    char bleVer[100];
    int verDateLen;
    char verDate[100];
    
}vcom_Result;


/****************************************
 事件定义
 ****************************************/

//通知监听器刷卡器插入手机
-(void) onDevicePlugged;

//通知监听器刷卡器已从手机拔出
-(void) onDeviceUnPlugged;

//通知监听器控制器CSwiperController正在搜索刷卡器
-(void) onWaitingForDevice;

//通知监听器没有刷卡器硬件设备
-(void)onNoDeviceDetected;

//通知监听器可以进行刷卡动作
-(void)onWaitingForCardSwipe;

//通知监听器可以进行艾刷刷卡动作
-(void)onWaitingForCardSwipeForAiShua;

//解析艾刷返回的数据信息
-(void)secondReturnDataFromAiShua;

// 通知监听器检测到刷卡动作
-(void)onCardSwipeDetected;

//通知监听器开始解析或读取卡号、磁道等相关信息
-(void)onDecodingStart;
//插入ic卡
-(void)onICcardInput;
/*!
 @method
 @abstract 错误提示
 @discussion 出现错误。可能偶然的错误，设备与手机的适配问题，或者设备与驱动不符。
 @param errorCode 错误代码。
 @param errorMessage 错误信息。
 */

#define VCOM_ERROR 1 //提供errorMsg，描述错误原因
#define VCOM_ERROR_FAIL_TO_START  2//CSwiperController创建失败
#define VCOM_ERROR_FAIL_TO_GET_KSN   3//取ksn失败
- (void)onError:(int)errorCode ErrorMessage:(NSString *)errorMessage;

/**
 *	@注释	通知电话中断结束设备准备好了
 */
-(void)onDeviceReady;


//通知监听器控制器CSwiperController的操作被中断
-(void)onInterrupted;

//通知监听器控制器CSwiperController的操作超时
//(超出预定的操作时间，30秒)
-(void)onTimeout;

/*!
 @method
 @abstract 通知ksn
 @discussion 正常启动刷卡器后，将返回ksn
 @param ksn 取得的ksn
 @2014.8.8修改，把版本也传过去
 */
-(void)onGetKsnCompleted:(NSString *)ksn;
// @2014.8.8修改，把版本也传过去
- (void)onGetKsnAndVersionCompleted:(NSArray *)ksnAndVerson;
//通知监听器解码刷卡器输出数据完毕。
/*
 formatID　　　　　此参数保留
 ksn               刷卡器设备编码
 encTracks         加密的磁道资料。1，2，3的十六进制字符
 track1Length       磁道1的长度（没有加密数据为0）
 track2Length       磁道2的长度（没有加密数据为0）
 track3Length       磁道3的长度（没有加密数据为0）
 randomNumber     加密时产生的随机数
 maskedPAN        基本账号号码。卡号的一种格式“ddddddddXXXXXXXXdddd”(隐藏卡号
 的中间的几位数字)d 数字   X 隐藏字符
 expiryDate         到期日，格式ＹＹＭＭ
 cardHolderName　　持卡人姓名
 */
//
//-(void)onDecodeCompleted:(NSString*) formatID
//                  andKsn:(NSString*) ksn
//            andencTracks:(NSString*) encTracks
//         andTrack1Length:(int) track1Length
//         andTrack2Length:(int) track2Length
//         andTrack3Length:(int) track3Length
//         andRandomNumber:(NSString*) randomNumber
//            andMaskedPAN:(NSString*) maskedPAN
//           andExpiryDate:(NSString*) expiryDate
//       andCardHolderName:(NSString*) cardHolderName
//                  andMac:(NSString *)mac
//        andQTPlayReadBuf:(NSString*) readBuf;
//ic卡刷卡器回调。
-(void)onDecodeCompleted:(NSString*) formatID
                  andKsn:(NSString*) ksn
            andencTracks:(NSString*) encTracks
         andTrack1Length:(int) track1Length
         andTrack2Length:(int) track2Length
         andTrack3Length:(int) track3Length
         andRandomNumber:(NSString*) randomNumber
           andCardNumber:(NSString *)maskedPAN
                  andPAN:(NSString*) PAN
           andExpiryDate:(NSString*) expiryDate
       andCardHolderName:(NSString*) cardHolderName
                  andMac:(NSString *)mac
        andQTPlayReadBuf:(NSString*) readBuf
                cardType:(int)type
              cardserial:(NSString *)serialNum
             emvDataInfo:(NSString *)data55
                 cvmData:(NSString *)cvm;


enum
{
    DECODE_SWIPE_FAIL,//刷卡失败
    DECODE_CRC_ERROR,//CRC 错误
    DECODE_COMM_ERROR,//通信错误
    DECODE_UNKNOWN_ERROR//未知错误
};
//解析卡号、磁道信息等数据出错时，回调此接口
-(void)onDecodeDrror:(int)decodeResult;

//收到数据
-(void) dataArrive:(vcom_Result*) vs  Status:(int)_status;
//mic插入
-(void) onMicInOut:(int) inout;

//检测到IC卡插入回调,通知客户端正在进行ic卡操作,用户禁止拔卡
- (void)EmvOperationWaitiing;

//设备类型回调
- (void)onDeviceKind:(int) result;
//参数下载回调
- (void)onLoadParam:(NSString *)param;
//IC卡回写脚本执行返回结果1)
- (void)onICResponse:(int)result resScript:(NSString *)resuiltScript data:(NSString *)data;
//公钥修复成功
@optional
- (void)didfinishICUpdate;

@end
