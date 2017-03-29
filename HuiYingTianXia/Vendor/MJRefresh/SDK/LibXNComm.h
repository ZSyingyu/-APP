//
//  LibXNComm.h
//  MsrPos
//
//  Created by hunter on 15/8/3.
//  Copyright (c) 2015年 xinocom. All rights reserved.
//

#ifndef MsrPos_LibXNComm_h
#define MsrPos_LibXNComm_h


#include "MsrResult.h"


////////////////////////////////////////////////////////////////

/**
 *	@brief	设备基础信息
 *	@param 	deviceUUID              UUID
 *	@param 	deviceName              设备名
 */
@interface XNP_DEVICESINFO : NSObject
@property (nonatomic,copy) NSString* deviceUUID;
@property (nonatomic,copy) NSString* deviceName;
@end

/**
 *	@brief	KEK下载请求信息
 *	@param 	kekString                    密钥加密密钥密文数据
 *	@param 	kekCheckValueString          KEK明文校验数据
 */
@interface XNP_KEKINFO : NSObject
@property (nonatomic,copy) NSString* kekString;
@property (nonatomic,copy) NSString* kekCheckValueString;
@end

/**
 *	@brief  主密钥下载请求信息
 *	@param 	bEncryType            加密模式：：KEK加密
                                          ：原主密钥加密
 *  @param  iMKeyIndex            主密钥索引
 *	@param 	mkeyString            主密钥密文
 *  @param  mkeyCheckValueString  主密钥明文校验值
 */
@interface XNP_MKEYINFO : NSObject
@property (nonatomic,assign) XN_ENCRYPT_METHOD bEncryType;
@property (nonatomic,assign) XN_KEY_INDEX iMKeyIndex;
@property (nonatomic,copy) NSString* mkeyString;
@property (nonatomic,copy) NSString* mkeyCheckValueString;
@end

/**
 *	@brief  工作密钥下载请求信息
 *  @param  iWKeyIndex              工作密钥索引
 *	@param 	pinKeyString            PIN密钥密文
 *  @param  pinKeyCheckValueString  PIN密钥明文校验值
 *	@param 	macKeyString            MAC密钥密文
 *  @param  macKeyCheckValueString  MAC密钥明文校验值
 *	@param 	magKeyString            MAG密钥密文
 *  @param  magKeyCheckValueString  MAG密钥明文校验值
 */
@interface XNP_WKEYINFO : NSObject
@property (nonatomic,assign) XN_KEY_INDEX iWKeyIndex;
@property (nonatomic,copy) NSString* pinKeyString;
@property (nonatomic,copy) NSString* pinKeyCheckValueString;
@property (nonatomic,copy) NSString* macKeyString;
@property (nonatomic,copy) NSString* macKeyCheckValueString;
@property (nonatomic,copy) NSString* magKeyString;
@property (nonatomic,copy) NSString* magKeyCheckValueString;
@end

///**
// *	@brief  密钥选择请求
// *  @param  iKeyIndex              密钥索引 0 -9
// */
//@interface XNP_KEYCHOICEINFO : NSObject
//@property (nonatomic,assign) NSInteger iKeyIndex;
//@end

/**
 *	@brief  密钥输入请求
 *  @param  iMaxKeyLength              最大长度12
 *  @param  iPinInputTimeOut           超时时间
 *  @param  CardNumberString           卡号
 */
@interface XNP_PININPUTINFO : NSObject
@property (nonatomic,assign) NSInteger iMaxKeyLength;
@property (nonatomic,assign) NSInteger iPinInputTimeOut;
@property (nonatomic,copy)   NSString* CardNumberString;
@end

/**
 *	@brief  MAC计算请求
 *  @param  iMacAlgorithm               MAC计算算法
 *  @param  MacData                     计算MAC的原报文
 */
@interface XNP_MACVALUEINFO : NSObject
@property (nonatomic,assign) XN_MAC_CHOICE iMacAlgorithm;
@property (nonatomic,copy)   NSData* MacData;
@end

/**
 *	@brief  PIN加密请求          ---- 针对不在MPOS上输入PIN的情况
 *  @param  PinString               密码
 *  @param  CardNumberString        卡号
 */
@interface XNP_PINENCRYINFO : NSObject
@property (nonatomic,copy)   NSString * PinString;
@property (nonatomic,copy)   NSString * CardNumberString;
@end

/**
 *	@brief  开启读卡器请求
 *  @param  ReadCardType            读卡模式 IC 磁条
 *  @param  iReadCardTimeOut        读卡超时时间
 *  @param  ConsumTypeString        交易类型
 *  @param  ConsumMoneyString       交易金额
 *  @param  ShowStringString        界面显示
 */
@interface XNP_OPENCARDINFO : NSObject
@property (nonatomic,assign) XN_READCARD_TYPE ReadCardType;
@property (nonatomic,assign) NSInteger iReadCardTimeOut;
@property (nonatomic,copy)   NSString * ConsumTypeString;
@property (nonatomic,copy)   NSString * ConsumMoneyString;
@property (nonatomic,copy)   NSString * ShowStringString;
@end

/**
 *	@brief  读取磁条卡请求信息
 *  @param  ReadCardMode         读取磁条卡模式
 *  @param  ReadCardMask         主账号屏蔽模式
 */
@interface XNP_READMAGCARDINFO : NSObject
@property (nonatomic,assign) XN_READCARD_MODE ReadCardMode;
@property (nonatomic,assign) XN_READCARD_PANMASK ReadCardMask;
@end

/**
 *	@brief  设置公钥请求信息
 *  @param  SetCapkAction         设置公钥操作
 *  @param  CapkTlvDataString     公钥数据
 */
@interface XNP_SETCAPKINFO : NSObject
@property (nonatomic,assign) XN_ICKEY_ACTION SetCapkAction;
@property (nonatomic,copy) NSArray* CapkTlvDataString;
@end

/**
 *	@brief  设置公钥请求信息
 *  @param  SetAidction         设置参数操作
 *  @param  AidTlvDataString    参数数据
 */
@interface XNP_SETAIDINFO : NSObject
@property (nonatomic,assign) XN_ICAID_ACTION SetAidction;
@property (nonatomic,copy) NSArray* AidTlvDataString;
@end

///**
// *	@brief  设置IC卡的交易属性请求数据
// *  @param  SetIcActionDataString     设置IC卡的标签数据
// */
//@interface XNP_SETICACTIONINFO : NSObject
//@property (nonatomic,copy) NSString * SetIcActionDataString;
//@end

///**
// *	@brief  取IC卡的交易的55域TAG值请求数据
// *  @param  IC55TAGString     设置IC卡的标签数据
// */
//@interface XNP_GETICACTION55DATAINFO : NSObject
//@property (nonatomic,copy) NSString * IC55TAGString;
//@end

/**
 *	@brief  执行EMV标准流程请求数据
 *  @param  TransactionAmountString     授权金额
 *  @param  AmountOtherString           其他金额
 *  @param  TransactionType             交易类型
 *  @param  ECCashSupport               电子现金指示器
 *  @param  PbocCourse                  PBOC流程指示
 *  @param  bOnLineReq                  是否强制练级
 */
@interface XNP_RUNEMVSTATEINFO : NSObject
@property (nonatomic,copy) NSString * TransactionAmountString;
@property (nonatomic,copy) NSString * AmountOtherString;
@property (nonatomic,assign) XN_TRADE_TYPE TransactionType;
@property (nonatomic,assign) XN_ECASH_TRADE ECCashSupport;
@property (nonatomic,assign) XN_PBOC_FLOW   PbocCourse;
@property (nonatomic,assign) XN_IC_ONLINE   bOnLineReq;
@end

/**
 *	@brief  二次授权请求信息
 *  @param  bOnLineResq                  联机成功标志
 *  @param  Return55DataString           8583应答的55域数据
 */
@interface XNP_GENARATEACINFO : NSObject
@property (nonatomic,copy)  NSString * Return55DataString;
@property (nonatomic,assign) XN_ONLINE_RESULT   bOnLineResq;
@end

/**
 *	@brief  蜂鸣器请求信息
 *  @param  iBeepCount                  执行蜂鸣器的次数
 *  @param  iBeepHz                     蜂鸣器的频率
 *  @param  iTimeIng                    蜂鸣器响鸣时间
 *  @param  iIntervalTime               蜂鸣器响鸣间隔时间
 */
@interface XNP_BEEPINFO : NSObject
@property (nonatomic,assign)  NSInteger  iBeepCount;
@property (nonatomic,assign)  NSInteger  iBeepHz;
@property (nonatomic,assign)  NSInteger  iTimeIng;
@property (nonatomic,assign)  NSInteger  iIntervalTime;
@end

///**
// *	@brief  设置时间请求信息
// *  @param  iBeepCount                  执行蜂鸣器的次数
// */
//@interface XNP_SETDATA : NSObject
//@property (nonatomic,copy)  NSString *  DataString;
//@end

/**
 *	@brief   更新文件
 *  @param  FilepathString                  文件名称
 */
@interface XNP_UPDATEDEVICE : NSObject
@property (nonatomic,copy)  NSString *  FilepathString;
@end

///////////////////////////////////////////////////////////////////


/**
 *	@brief  读取设备返回消息
 *  @param  XNDeviceSNString                  联机成功标志
 *  @param  bDeviceState                      设备个人化的状态
 *  @param  VersionInfoString                 版本信息
 *  @param  XNDefineInfoString                厂商自定义信息
 */
@interface XNP_READDEVICERESPINFO : NSObject
@property (nonatomic,copy)  NSString * XNDeviceSNString;
@property (nonatomic,assign) XN_MSR_DEVSTAT   bDeviceState;
@property (nonatomic,copy)  NSString * VersionInfoString;
@property (nonatomic,copy)  NSString * XNDefineInfoString;
@end

/**
 *	@brief  读取磁条卡返回消息
 *  @param  PanString                    主账号
 *  @param  bServiceCode                 服务代码
 *  @param  periodString                 有效期
 *  @param  Track2String                 2磁道数据
 *  @param  Track3String                 3磁道数据
 */
@interface XNP_READMAGCARDRESPINFO : NSObject
@property (nonatomic,copy)   NSString * PanString;
@property (nonatomic,copy)   NSString * bServiceCode;
@property (nonatomic,copy)   NSString * periodString;
@property (nonatomic,copy)   NSString * Track2String;
@property (nonatomic,copy)   NSString * Track3String;
@end

/***
 *	@brief  读取磁条卡返回消息
 *  @param  DownloadPosString              已完成下载的字节数
 *  @param  FileSizeString                 文件大小字节数
 */
@interface XNP_UPDATATIMINGINFO : NSObject
@property (nonatomic,copy)   NSString * DownloadPosString;
@property (nonatomic,copy)   NSString * FileSizeString;
@end


/***
 *	@brief  读取磁条卡返回消息
 *  @param  DownloadPosString              已完成下载的字节数
 *  @param  FileSizeString                 文件大小字节数
 */
@interface XNP_READICCARDRESPINFO : NSObject
@property (nonatomic,copy)   NSString * PanString;
@property (nonatomic,copy)   NSString * bServiceCode;
@property (nonatomic,copy)   NSString * periodString;
@property (nonatomic,copy)   NSString * Track2String;
@end
///////////////////////////////////////////////////////////////////

/***  
 *  @代码块作用：错误描述
 *  @参数 devicesDictionary
 *        蓝牙设备列表
 **/
typedef void(^XNErrorCodeDec)(EU_POS_RESULT errorCode,NSString *ErrorInfo);

/***  
 *  @代码块作用：  成功代码块
 *  @参数
 *
 **/
typedef void(^XNSuccessBlock)();

/***
 *  @代码块作用：  蜂鸣器成功代码块
 *  @参数
 *
 **/
typedef void(^XNBeepBlock)();

/**
 *  @代码块作用：查找设备的代码块
 *  @参数 devicesDictionary
 *        蓝牙设备列表
 **/
typedef void(^SearchXNDevices)(NSMutableDictionary * devicesDictionary);

/**
 *  @代码块作用：查找到一个设备
 *  @参数 devicesDictionary
 *        蓝牙设备列表
 **/
typedef void(^SearchOneXNDevices)(XNP_DEVICESINFO * Onedevice);

/**
 *  @代码块作用：查找设备时间到了
 *  @参数
 *
 **/
typedef void(^SearchTimeOut)();

/**
 *  @代码块作用：连接成功的代码块
 *  @参数
 *
 **/
typedef void(^XNConnectDeviceSuccess)();

/**
 *  @代码块作用：返回输入密码后的代码块
 *  @参数 pinBlock 密码加密后的数据
 *
 **/
typedef void(^XNInputPinRespSuccess)(NSString *pinBlock);

/**
 *  @代码块作用：返回计算后mac的代码块
 *  @参数 macBlock 计算后的mac数据
 *
 **/
typedef void(^XNMacCalculateRespSuccess)(NSString *macBlock);

/**
 *  @代码块作用：响应为IC卡的代码块
 *  @参数
 *
 **/
typedef void(^XNIcReaderSuccess)();

/**
 *  @代码块作用：响应为磁条卡的代码块
 *  @参数
 *
 **/
typedef void(^XNMagSuccess)();

/**
 *  @代码块作用：读取磁条卡信息的代码块
 *  @参数 cardinfo 磁条卡信息 包括2，3磁道，主账号，有效期，服务代码
 *
 **/
typedef void(^XNReadMagSuccess)(XNP_READMAGCARDRESPINFO *cardinfo);


/**
 *  @代码块作用：读取磁条卡信息的代码块
 *  @参数 cardinfo 磁条卡信息 包括2，3磁道，主账号，有效期，服务代码
 *
 **/
typedef void(^XNReadICSuccess)(XNP_READICCARDRESPINFO *cardinfo);

/**
 *  @代码块作用：返回IC卡55域数据
 *  @参数 tag55String 获取到的55域数据
 *
 **/
typedef void(^XNGetIC55RespSuccess)(NSString *tag55String);

/**
 *  @代码块作用：返回IC卡55域数据
 *  @参数 tag55String 获取到的55域数据
 *
 **/
typedef void(^XNGetDeviceInfoRespSuccess)(XNP_READDEVICERESPINFO *deviceInfoString);

/**
 *  @代码块作用：返回随机数数据数据
 *  @参数 randString 获取到的随机数数据
 *
 **/
typedef void(^XNGetRandStringRespSuccess)(NSString *randString);

/**
 *  @代码块作用：获取日期时间
 *  @参数 dateString 获取到的日期数据数据
 *
 **/
typedef void(^XNGetDateTimeStringRespSuccess)(NSString *dateString);

/**
 *  @代码块作用：升级过程中代码块
 *  @参数 updateinfo 更新过程的数据
 *
 **/
typedef void(^XNUpdatingRespSuccess)(XNP_UPDATATIMINGINFO *updateinfo);

/**
 *  @代码块作用：升级结束代码块
 *  @参数
 *
 **/
typedef void(^XNUpdatedRespSuccess)();
#endif

