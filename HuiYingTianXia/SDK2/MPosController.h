//
//  MPosController.h
//  MPosClient
//
//  Created by 陈嘉祺 on 15/8/4.
//  Copyright (c) 2015年 MoreFun. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "MPosDefine.h"

typedef NS_ENUM(NSInteger, MFDeviceType) {
    DeviceType_Unknown,
    DeviceType_M60A1,  // 音频刷卡头
    DeviceType_M60A2,  // 蓝牙刷卡头
    DeviceType_M60B,   // 蓝牙ＭＰＯＳ
};

@protocol MPosDelegate;

@interface MPosController : NSObject

@property (assign, nonatomic) id <MPosDelegate> delegate; // 代理

/// 实例化对象
+(id) sharedInstance;

#pragma mark - 音频刷卡器打开

/// 打开/连接音频刷卡器
/**
 * @see 相关消息回调: MPosDelegate::didDevicePlugged:
 * @see 相关消息回调: MPosDelegate::didDeviceUnplugged:
 * @see 相关消息回调: MPosDelegate::didInterrupted:
 * @see close:
 */
-(void) open;

/// 关闭音频刷卡器连接
/**
 * @see open:
 */
-(void) close;

/// 设备状态
/*
 * @param  无
 * @return NSInteger <BR>
            <p>音频: -1设备未插入, 0设备未连接, 1设备已连接<br>
            蓝牙: 0设备未连接, 1设备已连接</p>
 */
-(NSInteger) getDeviceState;

/// 获取设备类型
/*
 * @param  无
 * @return MFDeviceType <BR>
 */
-(MFDeviceType) getDeviceType;

/// 打开蓝牙设备
/**
 * @see scanBtDevice:
 * @see stopScan
 * @see connectBtDevice:
 * @see disconnectBtDevice
 */
-(void) openBtDevice;

/// 搜索蓝牙设备
/**
 * @param  timeout 搜索蓝牙超时时间
 * @see 相关消息回调: MPosDelegate::didFoundBtDevice:
 * @see openBtDevice
 * @see stopScan
 * @see connectBtDevice:
 * @see disconnectBtDevice
 */
-(void) scanBtDevice:(NSInteger)timeout;

/// 停止搜素
/**
 * @see 相关消息回调: MPosDelegate::didStopScanBtDevice
 * @see openBtDevice
 * @see scanBtDevice:
 * @see connectBtDevice:
 * @see disconnectBtDevice
 */
-(void) stopScan;

/// 连接蓝牙
/**
 * @param  btDevice 蓝牙标识
 * @see 相关消息回调: MPosDelegate::didConnected:
 * @see openBtDevice
 * @see scanBtDevice:
 * @see stopScan
 * @see disconnectBtDevice
 */
-(void) connectBtDevice:(NSString *)btDevice;


/// 断开当前蓝牙连接
/**
 * @see 相关消息回调: MPosDelegate::didDisconnect:
 * @see openBtDevice
 * @see scanBtDevice:
 * @see stopScan
 * @see connectBtDevice
 */
-(void) disconnectBtDevice;

/// 获得sdk(固件)版本
-(NSString *) getVersion;

/// 设置通讯接收超时
/**
 * @param timeout   [IN]    超时时间(单位:秒)
 * @see cancel
 **/
-(void) setTimeout: (NSInteger) timeout;

/// 上位机取消
/**
 * @see setTimeout:
 */
-(void) cancel;

/// 设置厂商ID
/**
 * @param factory     [IN]    厂商id
 * @see 消息回调函数: MPosDelegate::didSetDatetimeResp
 * @see setDatetime:factoryId:
 */
-(NSInteger)setFactoryCode: (NSInteger)fCode;

/// KEK下载请求
/**
 * @param key       [IN]    KEK密钥(长度为20的字符串，最后4位是检验值)
 * @param len       [IN]    KEK长度
 * @return int      小于0，表示蓝牙未准备好
 * @see 消息回调函数: MPosDelegate::didLoadKekResp:
 * @see loadMainKey:encryptMethod:keyIndex:keyLength:
 * @see loadWorkKey:macKey:trackKey:keyIndex:
 * @see setKeyIndex:
 */
-(NSInteger)loadKek: (NSString *)kek keyLength: (MFEU_KEY_LENGTH)len;

/// 主密钥下载请求
/**
 * @param method    [IN]    加密方式
 * @param mainKey   [IN]    主密钥(长度为20的字符串，最后4位是检验值)
 * @param index     [IN]    主密钥索引
 * @param len       [IN]    主密钥长度
 * @return int      小于0，表示蓝牙未准备好
 * @see 消息回调函数: MPosDelegate::didLoadMainKeyResp:
 * @see loadKek:keyLength:
 * @see loadWorkKey:macKey:trackKey:keyIndex:
 * @see setKeyIndex:
 */
-(NSInteger)loadMainKey: (NSString *)mainKey encryptMethod: (MFEU_ENCRYPT_METHOD)method keyIndex: (MFEU_KEY_INDEX)index keyLength: (MFEU_KEY_LENGTH)len;

/// 工作密钥下载请求
/**
 * @param workKey   [IN]    主密钥(长度为40的字符串，最后4位是检验值)
 * @param index     [IN]    密钥索引
 * @param len       [IN]    密钥长度
 * @return int      小于0，表示蓝牙未准备好
 * @see 消息回调函数: MPosDelegate::didLoadWorkKeyResp:
 * @see loadKek:keyLength:
 * @see loadMainKey:encryptMethod:keyIndex:keyLength:
 * @see loadWorkKey:macKey:trackKey:keyIndex:
 * @see setKeyIndex:
 */
-(NSInteger)loadWorkKey: (NSString *)workKey keyIndex: (MFEU_KEY_INDEX)index keyLength: (MFEU_KEY_LENGTH)len;

/// 工作密钥下载请求
/**
 * @param pin       [IN]    pin密钥(长度为40的字符串，32位密钥＋8位kvc)
 * @param mac       [IN]    mac密钥(长度为40的字符串，32位密钥＋8位kvc)
 * @param track     [IN]    磁道密钥(长度为40的字符串，32位密钥＋8位kvc)
 * @param index     [IN]    密钥索引
 * @return int      小于0，表示蓝牙未准备好
 * @see 消息回调函数: MPosDelegate::didLoadWorkKeyResp:
 * @see loadKek:keyLength:
 * @see loadMainKey:encryptMethod:keyIndex:keyLength:
 * @see loadWorkKey:keyIndex:keyLength:
 * @see setKeyIndex:
 */
-(NSInteger)loadWorkKey: (NSString *)pin
                 macKey: (NSString *)mac
               trackKey: (NSString *)track
               keyIndex: (MFEU_KEY_INDEX)index;

-(NSInteger)loadWorkKeyEx: (NSString *)key
                  keyType: (MFEU_WKEY_TYPE)type
                 keyIndex: (MFEU_KEY_INDEX)index;
/// 密钥选择请求
/**
 * @param index     [IN]    密钥索引
 * @return int      小于0，表示蓝牙未准备好
 * @see 消息回调函数: MPosDelegate::didSetKeyIndexResp:
 * @see loadKek:keyLength:
 * @see loadMainKey:encryptMethod:keyIndex:keyLength:
 * @see loadWorkKey:keyIndex:keyLength:
 * @see loadWorkKey:macKey:trackKey:keyIndex:
 */
-(NSInteger) setKeyIndex: (MFEU_KEY_INDEX)index;

/// 密码输入请求
/**
 * @param maxlen    [IN]    输入密码的最大长度
 * @param timeout   [IN]    超时时间
 * @param pan       [IN]    主账号
 * @return int      小于0，表示蓝牙未准备好
 * @see 消息回调函数: MPosDelegate::didInputPinResp:pwdLength:pwdText:
 * @see calcMac:macAlg
 * @see pinEncrypt:maskedPAN
 */
-(NSInteger) inputPin: (NSInteger) maxlen timeOut: (NSInteger)timeout maskedPAN: (NSString *)pan;

/// MAC计算请求
/**
 * @param data      [IN]    输入密码数据
 * @param macAlg    [IN]    mac算法
 * @return int      小于0，表示蓝牙未准备好
 * @see 消息回调函数: MPosDelegate::didCalcMacResp:
 * @see calcMac2:macAlg
 * @see inputPin:timeOut:maskedPAN
 * @see pinEncrypt:maskedPAN
 */
-(NSInteger) calcMac: (NSString *)data macAlg: (MFEU_MAC_MFEU_ALG)macAlg;

/// MAC计算请求
/**
 * @param data      [IN]    输入密码数据(转为BCD格式)
 * @param macAlg    [IN]    mac算法
 * @return int      小于0，表示蓝牙未准备好
 * @see 消息回调函数: MPosDelegate::didCalcMacResp:
 * @see calcMac:macAlg
 * @see inputPin:timeOut:maskedPAN
 * @see pinEncrypt:maskedPAN
 */
-(NSInteger) calcMac2: (NSString *)data macAlg: (MFEU_MAC_MFEU_ALG)macAlg;


/// PIN加密请求
/**
 * @param data      [IN]    输入密码数据
 * @param pan       [IN]    卡号(不超过19位)
 * @return int      小于0，表示蓝牙未准备好
 * @see 消息回调函数: MPosDelegate::didCalcMacResp:
 * @see calcMac:macAlg
 * @see inputPin:timeOut:maskedPAN
 */
-(NSInteger) pinEncrypt: (NSString *)data maskedPAN: (NSString *)pan;


/// PIN加密2
/**
 * @param type          [IN]    算法类型
 * @param exdata        [IN]    附加数据
 * @param indata        [IN]    输入密码数据
 * @param pan           [IN]    卡号(不超过19位)
 * @return int      小于0，表示蓝牙未准备好
 */
-(NSInteger) pinEncrypt2: (MFEU_PIN_ENCRYPT)type exData: (NSString *)exdata inData: (NSString *)indata maskedPAN: (NSString *)pan;

/// 开启读卡器请求
/**
 * @param tradeDescript [IN]    交易类型描述，比如  消费，余额查询
 * @param amount        [IN]    交易金额(单位：分)
 * @param timeout       [IN]    超时时间
 * @param type          [IN]    读卡类型
 * @param msg           [IN]    下位机显示的信息(如果为空，将根据交易类型描述和交易金额进行显示)
 * @return int      小于0，表示蓝牙未准备好
 * @see 消息回调函数: MPosDelegate::didOpenCardResp:
 * @see readMagcard:panMask:
 * @see startEmv:otherAmount:tradeType:ecashTrade:pbocFlow:icOnline:
 * @see endEmv:
 */
-(NSInteger) openCardReader: (NSString *)tradeDescript aMount: (NSInteger)amount timeOut: (NSInteger) timeout readType: (MFEU_READCARD_TYPE)type showMsg: (NSString *)msg;


/// 读磁条卡请求
/**
 * @param mode      [IN]    要读取的卡磁道
 * @param hide      [IN]    主账号屏蔽模式
 * @return int      小于0，表示蓝牙未准备好
 * @see 消息回调函数: MPosDelegate::didReadMagcardResp:maskedPAN:expiryDate:serivceCode:track2Length:track3Length:encTrack2:encTrack3:randomNumber:
 * @see openCardReader:aMount:timeOut:readType:showMsg:
 * @see inputPin:timeOut:maskedPAN:
 * @see pinEncrypt:maskedPAN:
 */
-(NSInteger) readMagcard: (MFEU_READCARD_MODE)mode panMask: (MFEU_READCARD_PANMASK)hide;

/// 清空IC卡公钥
-(void) clearIcKey;

/// 添加IC卡公钥
/**
 * @param str      [IN]    公钥信息
 * @return int      小于0，表示蓝牙未准备好
 * @see 消息回调函数: MPosDelegate::didSetICKeyResp:totalCount:
 * @see clearIcKey
 * @see setIcKey:
 */
-(void) addIcKeyStr: (NSString *)str;

/// 设置IC卡公钥请求
/**
 * @param data      [IN]    公钥信息
 * @return int      小于0，表示蓝牙未准备好
 * @see 消息回调函数: MPosDelegate::didSetICKeyResp:totalCount:
 * @see setIcAid:
 */
-(void) setIcKey: (NSArray *)dataArray;

/// 清空AID参数
-(void) clearIcAid;

/// 添加AID参数
/**
 * @param str      [IN]    AID参数信息
 * @return int      小于0，表示蓝牙未准备好
 * @see 消息回调函数: MPosDelegate::didSetICKeyResp:totalCount:
 * @see clearIcAid
 * @see setIcAid:
 */
-(void) addIcAidStr: (NSString *)str;

/// 设置AID参数请求
/**
 * @param data      [IN]    AID信息
 * @param action    [IN]    执行的动作
 * @return int      小于0，表示蓝牙未准备好
 * @see 消息回调函数: MPosDelegate::didSetAidResp:totalCount:
 * @see setIcKey:
 */
-(void) setIcAid: (NSArray *)dataArray;

/// 设置IC交易属性请求(暂未开放)
/**
 * @param data      [IN]    交易属性信息
 * @return int      小于0，表示蓝牙未准备好
 */
-(NSInteger) getEmvAttrib: (NSString *)data;

/// 设置IC交易数据请求
/**
 * @param data      [IN]    交易数据tag列表(ASC格式)
 * @return int      小于0，表示蓝牙未准备好
 * @see 消息回调函数: MPosDelegate::didGetEmvDataResp:beforeLength:randomNumber:
 * @see startEmv:otherAmount:tradeType:ecashTrade:pbocFlow:icOnline:
 * @see endEmv:
 * @see getICData
 * @see getEmvDataEx:
 * @see getEmvDataEx2:
 */
-(NSInteger) getEmvData: (NSString *)data;

/// 取IC卡数据
/**
 * @see 消息回调函数: MPosDelegate::didGetICDataResp:maskedPAN:encTrack:expiryDate:
 * @see startEmv:otherAmount:tradeType:ecashTrade:pbocFlow:icOnline:
 * @see endEmv:
 * @see getEmvData:
 * @see getEmvDataEx:
 * @see getEmvDataEx2:
 **/
-(NSInteger) getICData;

/// 通过tag取EMV数据，卡号等信息是通过GetICData接口获取加密数据
/**
 * @param eTransType        [IN]    交易类型
 * @return int              小于0，表示蓝牙未准备好
 * @see 消息回调函数: MPosDelegate::didGetEmvDataExResp:beforeLength:randomNumber:serialNumber:maskedPAN:encTrack:expiryDate:
 * @see startEmv:otherAmount:tradeType:ecashTrade:pbocFlow:icOnline:
 * @see endEmv:
 * @see getEmvData:
 * @see getICData:
 * @see getEmvDataEx2:
 */
-(NSInteger) getEmvDataEx: (MFEU_TRADE_TYPE)eTransType;

/// 通过tag取EMV数据，卡号等信息也是通过tag来获取未加密数据
/**
 * @param eTransType        [IN]    交易类型
 * @return int              小于0，表示蓝牙未准备好
 * @see 消息回调函数: MPosDelegate::didGetEmvDataExResp:beforeLength:randomNumber:serialNumber:maskedPAN:encTrack:expiryDate:
 * @see startEmv:otherAmount:tradeType:ecashTrade:pbocFlow:icOnline:
 * @see endEmv:
 * @see getEmvData:
 * @see getICData:
 * @see getEmvDataEx:
 */
-(NSInteger) getEmvDataEx2: (MFEU_TRADE_TYPE)eTransType;

/// IC标准流程请求
/**
 * @param amount        [IN]    授权金额，以分为单位
 * @param omount        [IN]    其他金额，以分为单位
 * @param type          [IN]    交易类型
 * @param ecash         [IN]    是否允许电子现金
 * @param pboc          [IN]    下位机EMV执行程度
 * @param online        [IN]    是否强制联机
 * @return int      小于0，表示蓝牙未准备好
 * @see 消息回调函数: MPosDelegate::didStartEmvResp:pinReq:
 * @see getEmvData:
 * @see getICData:
 * @see getEmvData:
 * @see getEmvDataEx:
 * @see icDealOnline:onlineResult:
 * @see endEmv:
 */
-(NSInteger) startEmv: (NSInteger)amount otherAmount: (NSInteger)oamount tradeType: (MFEU_TRADE_TYPE)type ecashTrade: (MFEU_ECASH_TRADE)ecash pbocFlow: (MFEU_PBOC_FLOW)pboc icOnline: (MFEU_IC_ONLINE)online;


/// IC二次授权请求
/**
 * @param data      [IN]    交易数据信息
 * @param result    [IN]    是否联机成功
 * @return int      小于0，表示蓝牙未准备好
 * @see 消息回调函数: MPosDelegate::didIcDealOnlineResp:
 * @see startEmv:otherAmount:tradeType:ecashTrade:pbocFlow:icOnline:
 * @see endEmv:
 * @see getEmvData:
 * @see getICData:
 * @see getEmvData:
 * @see getEmvDataEx:
 */
-(NSInteger) icDealOnline: (NSString *)data onlineResult: (MFEU_ONLINE_RESULT)result;


/// IC交易流程结束请求
/**
 * @return int      小于0，表示蓝牙未准备好
 * @see 消息回调函数: MPosDelegate::didEndEmvResp
 * @see startEmv:otherAmount:tradeType:ecashTrade:pbocFlow:icOnline:
 * @see icDealOnline:onlineResult:
 * @see getEmvData:
 * @see getICData:
 * @see getEmvData:
 * @see getEmvDataEx:
 */
-(NSInteger) endEmv;

/// 读取设备信息请求
/**
 * @return int      小于0，表示蓝牙未准备好
 * @see 消息回调函数: MPosDelegate::didReadPosInfoResp:status:battery:app_ver:data_ver:custom_info:
 * @see readPosInfoEx
 * @see setDatetime:factoryId:
 * @see setFactoryCode:
 */
-(NSInteger) readPosInfo;

/// 获取随机数请求
/**
 * @return int      小于0，表示蓝牙未准备好
 * @see 消息回调函数: MPosDelegate::didGetRandNumResp:
 */
-(NSInteger) getRandomNum;


/// 设置商终号请求
/**
 * @param pszShop    [IN]    商户号(最大长度15位，以0x00结尾)
 * @param pszDevice  [IN]    终端号(最大长度15位，以0x00结尾)
 * @return int      小于0，表示蓝牙未准备好
 */
-(NSInteger) setMTCode: (NSString *)shop devId: (NSString *)devid;

/// 获取商终号请求请求
/**
 * @return int      小于0，表示蓝牙未准备好
 */
-(NSInteger) getMTCode;

/// 蜂鸣器
/**
 * @param times     [IN]    蜂鸣次数
 * @param freq      [IN]    蜂鸣频率(单位:hz)
 * @param duration  [IN]    每次蜂鸣时间(单位:ms)
 * @param step      [IN]    两次蜂鸣时间间隔(单位:ms)
 * @return int      小于0，表示蓝牙未准备好
 */
-(NSInteger) beep: (NSInteger)times freq: (NSInteger)freq duration: (NSInteger)duration step: (NSInteger) step;

/// 设置时间请求
/**
 * @param datetime  [IN]    日期时间(格式: YYYYMMDDHHMMSS, 长度14位，以0x00结尾)
 * @param factoryid [IN]    厂商ID
 * @return int      小于0，表示蓝牙未准备好
 * @see 消息回调函数: MPosDelegate::didSetDatetimeResp
 * @see getDatetime
 */
-(NSInteger) setDatetime: (NSString *)datetime factoryId: (NSInteger)factoryid;

/// 获取时间请求
/**
 * @return int      小于0，表示蓝牙未准备好
 * @see 消息回调函数: MPosDelegate::didGetDatetimeResp:
 * @see setDatetime:factoryId:
 */
-(NSInteger) getDatetime;

/// 取消/复位操作请求
/**
 * @return int      小于0，表示蓝牙未准备好
 * @see 消息回调函数: MPosDelegate::didResetPosResp:
 * @see setDatetime:factoryId:
 * @see updatePos:
 */
-(NSInteger) resetPos;

/// 关闭设备请求
/**
 * @param option    [IN]    指示关机或休眠
 * @return int      小于0，表示蓝牙未准备好
 */
-(NSInteger) poweroffPos: (MFEU_CLOSE_ACTION)action;

/// 升级设备
/**
 * @param pUpgradeFilename  [IN]    升级文件存储的路径
 * @return int      小于0，表示蓝牙未准备好
 * @see 消息回调函数: MPosDelegate::didUpgradeResp:size:
 * @see setDatetime:factoryId:
 * @see resetPos
 */
-(NSInteger) updatePos: (NSString *)upgradeFilename;

/// 数据加密
/**
 * @param pszKey    [IN]    密钥密文使用主密钥加密
 * @param data      [IN]    数据明文
 * @return int              小于0，表示蓝牙未准备好
 * @see 消息回调函数: MPosDelegate::didDataEncodeResp:
 */
-(NSInteger) dataEncode: (NSString *)data encryptKey: (NSString *)key;

/// 自定义数据写入
/**
 * @param data      [IN]    写入数据
 * @param method    [IN]    是否清除
 * @return int              小于0，表示蓝牙未准备好
 * @see 消息回调函数: MPosDelegate::didDataWriteResp:
 * @see dataRead
 */
-(NSInteger) dataWrite: (NSString *)data clearFlag: (MFEU_DATA_WRITE)method;

-(NSInteger) dataWriteEx: (NSData *)data start: (NSInteger)pos;

/// 自定义数据读取
/**
 * @return int              小于0，表示蓝牙未准备好
 * @see 消息回调函数: MPosDelegate::didDataReadResp:
 * @see dataWrite:
 */
-(NSInteger) dataRead;

-(NSInteger) dataReadEx: (NSInteger) start length: (NSInteger)size;

/// 读取设备信息(扩展)
/**
 * @return int      小于0，表示蓝牙未准备好
 * @see 消息回调函数: MPosDelegate::didReadPosInfoResp:status:battery:app_ver:data_ver:custom_info:
 * @see readPosInfo
 * @see setDatetime:factoryId:
 * @see setFactoryCode:
 */
-(NSInteger) readPosInfoEx;

/// 读取KSN
-(NSInteger) getKsn;

/**
 *  刷卡/插入IC卡读取卡数据
 *
 * @param amountFen        金额(分)
 * @param eTransType       交易类型
 * @param timeOutSecond    等待超时时间(秒)
 * @param isEncrypt        返回数据是否加密
 * @param showMsg          MPOS上显示信息
 * @see openCardReader:aMount:timeOut:readType:showMsg:
 * @see MPosDelegate::didWaitingForCardSwipe
 * @see MPosDelegate::didReadCardCancel
 * @see MPosDelegate::didReadCardFail:
 * @see MPosDelegate::didDetectIcc
 * @see MPosDelegate::didDecodeCompleted:maskedPAN:expiryDate:serviceCode:track2Size:track3Size:track2Data:track3Data:randomNumber:serialNum:iccData:otherInfo:
 */
-(void) cardRead:(NSInteger)amountFen transType: (MFEU_TRADE_TYPE)eTransType timeOutSecond:(NSInteger) timeout isEncrypt: (BOOL)isEncrypt showMsg: (NSString *)showMsg;

@end

#pragma mark - protocol MPosDelegate
@protocol MPosDelegate <NSObject>
/// 错误回调
/**
 * @param  errCode 错误状态 (包含但不限于：超时回调，刷卡器端取消交易回调，获取ksn失败回调，刷卡失败回调，连接蓝牙失败回调(蓝牙刷卡器特有))
 * @param  errorMessage 错误信息
 */
- (void)didError:(NSInteger)errorCode andMessage:(NSString *)errorMessage;

#pragma mark - 刷卡器相关回调
//
///检测到非IC刷卡器(等待刷卡)
/**
 * @param  无
 */
- (void)didWaitingForCardSwipe;

/// 刷卡/插卡 取消
-(void) didReadCardCancel;

/// 刷卡/插卡 失败
/**
 * @param resp 错误代码
 */
-(void) didReadCardFail: (MFEU_MSR_OPENCARD_RESP) resp;

/// 检测到插入IC卡
- (void)didDetectIcc;

/// 等待IC读卡
- (void)didWaitingForICData;

/*! 刷卡数据回调
 * @param isICCard          判断是否IC刷卡还是磁道刷卡
 * @param maskedPAN         主账号
 * @param expiryDate        有效期
 * @param serviceCode       服务代码（仅针对磁条卡）
 * @param track2Size        二磁道长度
 * @param track3Size        三磁道长度（仅针对磁条卡）
 * @param track2data        二磁道数据
 * @param track3data        三磁道数据（仅针对磁条卡）
 * @param randomNumber      随机数数据
 * @param serialNum         序列号（仅针对IC卡）
 * @param data55            ic刷卡 55域数据（仅针对IC卡）
 * @param otherInfo         保留，用以扩充其他字段
 \return 无
 */
- (void)didDecodeCompleted:(BOOL) isICCard
                 maskedPAN:(NSString *)maskedPAN
                expiryDate:(NSString *)expiryDate
               serviceCode:(NSString *)serviceCode
                track2Size:(int)track2Size
                track3Size:(int)track3Size
                track2Data:(NSString *)track2Data
                track3Data:(NSString *)track3Data
              randomNumber:(NSString *)randomNumber
                 serialNum:(NSString *)serialNum
                   iccData:(NSString *)data55
                 otherInfo:(NSDictionary *)otherInfo;

#pragma mark - 蓝牙刷卡器回调
/// 搜索到一个蓝牙设备 (每搜索到一个设备就会回调一次)
/**
 * @param  btDevice 蓝牙设备标识
 * @return 无
 */
- (void)didFoundBtDevice:(NSString *)btDevice;

/// 停止蓝牙搜索
-(void) didStopScanBtDevice;

-(void) didStopScanBtDevice: (NSMutableArray *)deviceArray;

/// 成功连接到一个设备回调
/**
 * @param  devName 设备标识(音频参数为空)
 * @return 无
 */
-(void) didConnected:(NSString *)devName;

/// 连接断开
-(void) didDisconnected;

/// 连接失败
-(void) didConnectFail;

#pragma mark - 音频刷卡器实现回调

/// 检测到音频插入
-(void) didDevicePlugged;

/// 检测到音频拔出
-(void) didDeviceUnplugged;

/// 检测到音频打断(如：来电话)
-(void) didInterrupted;

/////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 通讯协议相关回调
/// POS数据返回类型
/**
 * @param sessionType           POS数据类型
 * @param responseCode          返回值
 */
-(void) didSessionResponse: (MFEU_POS_SESSION) sessionType returnCode: (MFEU_POS_RESULT) responceCode;

/// 接收超时
-(void) didTimeout;

/// 下载KEK回调
/**
 * @param resp              响应下载KEK返回结果
 */
-(void) didLoadKekResp: (MFEU_MSR_RESP)resp;

/// 下载主密钥回调
/**
 * @param resp              响应下载主密钥返回结果
 */
-(void) didLoadMainKeyResp: (MFEU_MSR_RESP)resp;

/// 下载工作密钥回调
/**
 * @param resp              响应下载工作密钥返回结果
 */
-(void) didLoadWorkKeyResp: (MFEU_MSR_RESP)resp;
-(void) didLoadWorkKeyExResp: (MFEU_MSR_RESP)resp;

/// 密钥选择回调
/**
 * @param resp              响应密钥选择返回结果
 */
-(void) didSetKeyIndexResp: (MFEU_MSR_RESP)resp;

/// CalcMac回调
/**
 * @param mac              mac数据(ASC格式）
 * @param text              mac数据(明文格式)
 */
-(void) didCalcMacResp: (NSString *)mac string: (NSString *)text;

/// 密码输入回调
-(void) didInputPinResp: (MFEU_MSR_KEYTYPE) type pwdLength: (NSInteger) len pwdText: (NSString *)text;

/// Pin加密回调
/**
 * @param pin              加密数据(BCD格式）
 */
-(void) didPinEncryptResp: (NSString *)pin;

/// 开启读卡器
/**
 * @param resp              开启读卡器返回结果
 */
-(void) didOpenCardResp: (MFEU_MSR_OPENCARD_RESP)resp;

/// 读取磁条卡信息
/**
 * @param resp              响应的读卡方式
 * @param pan               主账号
 * @param exdate            有效期
 * @param sCode             服务代码
 * @param t2Size            二磁道长度
 * @param t3Size            三磁道长度
 * @param t2data            二磁道数据
 * @param t3data            三磁道数据
 * @param randNum           随机数数据
 **/

-(void) didReadMagcardResp: (MFEU_MSR_READCARD_RESP)resp maskedPAN: (NSString *)pan expiryDate: (NSString *)exdate serivceCode: (NSString *)sCode track2Length: (NSInteger)t2Size track3Length: (NSInteger)t3Size encTrack2: (NSString *)t2data encTrack3: (NSString *)t3data randomNumber: (NSString *)randNum;

/// 设置IC公钥回调
/**
 * @param index             当前下载进度
 * @param total             公钥总数
 */
-(void) didSetICKeyResp: (NSInteger)index totalCount: (NSInteger)total;

/// 设置AID参数回调
/**
 * @param index             当前下载进度
 * @param total             AID参数总数
 */
-(void) didSetAidResp: (NSInteger)index totalCount: (NSInteger)total;

/// StartEmv回调
/*
 * @param resp              执行结果
 * @param pinReq            联机PIN输入指示
 */
-(void) didStartEmvResp: (MFEU_MSR_EMV_RESP)resp pinReq: (MFEU_MSR_EMV_PIN)req;

/// GetEmvData回调
/*
 * @param data              55域加密数据(ASC格式)
 * @param randNum           随机数数据(ASC格式)
 */
-(void) didGetEmvDataResp: (NSString *)data beforeLength: (NSInteger)length randomNumber: (NSString *)randNum;

/// GetICData回调
/*
 * @param serial            23域卡片序列号(ASC格式)
 * @param pan               银行卡号
 * @param track             二磁道密文(ASC格式)
 * @param date              有效期
 */
-(void) didGetICDataResp: (NSString *)serial maskedPAN: (NSString *)pan encTrack: (NSString *)track expiryDate: (NSString *)date;

/// GetEmvDataEx回调
/*
 * @param data55            55域加密数据(ASC格式)
 * @param len55             55域原始数据长度
 * @param randNum           随机数数据(ASC格式)
 * @param serial            23域卡片序列号(ASC格式)
 * @param pan               银行卡号
 * @param track             二磁道密文(ASC格式)
 * @param date              有效期

 */
-(void) didGetEmvDataExResp: (NSString *)data55 beforeLength: (NSInteger)len55 randomNumber: (NSString *)randNum serialNumber: (NSString *)serial maskedPAN: (NSString *)pan encTrack: (NSString *)track expiryDate: (NSString *)date;

/// Ic卡二次授权回调
/*
 * @param resp              操作结果
 */
-(void) didIcDealOnlineResp: (MFEU_MSR_REAUTH_RESP) resp;

/// EMV结束回调
-(void) didEndEmvResp;

/*! 获取ReadPosInfo()回调
 \param ksn             终端号
 \param status          设备个人化状态
 \param battery         电池状态
 \param app_ver         版本号
 \param data_ver        数据版本号
 \param custom_info     厂商自定义信息
 \return 无
 */
-(void) didReadPosInfoResp:(NSString *)ksn status: (MFEU_MSR_DEVSTAT)status battery: (MFEU_MSR_BATTERY)battery app_ver: (NSString *)app_ver data_ver: (NSString *)data_ver custom_info: (NSString *)custom_info;

/// 获以随机数回调
/**
 * @param randNum       返回的随机数(ASC格式)
 **/
-(void) didGetRandNumResp: (NSString *)randNum;

/// 获取MPOS当前时间回调
/**
 * @param datetime      返回的终端当前时间(格式:YYYYMMDDhhmmss)
 **/
-(void) didGetDatetimeResp: (NSString *)datetime;

/// 设置商终号回调
-(void) didSetParamResp;

/// 获取商终号回调
-(void) didGetParamResp: (NSString *)shop devId: (NSString *)devid;

/// 时间、厂商ID设置回调
-(void) didSetDatetimeResp;

/// 蜂鸣器回调
-(void) didBeepResp;

/// 复位回调
/**
 * @param resp          复位结果
 **/
-(void) didResetPosResp: (MFEU_MSR_RESP)resp;

/// 关机回调
-(void) didCloseDeviceResp;

/// 升级回调
/**
 * @param pos       当前进度
 * @param length    总文件大小
 **/
-(void) didUpgradeResp: (NSInteger) pos size: (NSInteger) length;

/// 升级完成
-(void) didUpgradeFinish;

/// 数据加密
/**
 * @param data      加密后的数据(ASC格式)
 */
-(void) didDataEncodeResp: (NSString *)data;

/// 自定义数据写入
/**
 * @param resp      MFEU_MSR_RESP
 */
-(void) didDataWriteResp: (MFEU_MSR_RESP)resp;

/// 自定义数据读取
/**
 * @param resp      MFEU_MSR_RESP
 * @param data      读取的数据
 */
-(void) didDataReadResp: (MFEU_MSR_RESP)resp data: (NSData *)data string: (NSString *)str;

-(void) didGetKsnResp: (NSString *)serialNo psam: (NSString *)psamNo;

@end

