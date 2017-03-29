//
//  MsrResult.h
//  MisPosClient
//
//  Created by 陈嘉祺 on 15-1-6.
//  Copyright (c) 2015年 xinocom. All rights reserved.
//

#ifndef MisPosClient_MsrResult_h
#define MisPosClient_MsrResult_h

// SESSION消息
typedef enum {
    SESSION_UNKNOWN = 0,               //!> 未知状态
    SESSION_SCAN_START = 10,           //!> 蓝牙搜索开始
    SESSION_SCAN_STOP,                 //!> 蓝牙搜索结束
    SESSION_CONN_FAIL,                 //!> 蓝牙连接失败
    SESSION_CONN_VALID,                //!> 连接合法设备
    SESSION_CONN_INVALID,              //!> 连接非法设备
    SESSION_DISCONNECT,                //!> 断开连接
    SESSION_KEK_DOWNLOAD = 100,        //!> KEK下载
    SESSION_MKEY_DOWNLOAD,             //!> 主密钥下载
    SESSION_WKEY_DOWNLOAD,             //!> 工作密钥下载
    SESSION_SELECT_PIN,                //!> 密钥选择
    SESSION_INPUT_PIN,                 //!> 密码输入
    SESSION_CALC_MAC,                  //!> MAC计算
    SESSION_PIN_ENCRYPT,                //!> PIN加密
    SESSION_OPEN_CARD = 110,            //!> 开启读卡器
    SESSION_READ_CARD,                 //!> 读磁条卡
    SESSION_SET_ICKEY,                 //!> 设置IC公钥
    SESSION_SET_AID,                   //!> 设置AID
    SESSION_SET_ATTRIB,                //!> 设置交易属性
    SESSION_SET_DATA,                  //!> 设置交易数据
    SESSION_START_EMV,                 //!> 开始IC交易流程
    SESSION_IC_REAUTH,                 //!> IC二次授权
    SESSION_END_EMV,                   //!> 结束IC交易流程
    SESSION_GET_DEVINFO = 120,         //!> 读取设备信息
    SESSION_GET_RANDNUM,               //!> 获取随机数
    SESSION_SET_PARAM,                 //!> 设置商终号
    SESSION_GET_PARAM,                 //!> 读取商终号
    SESSION_BEEP,                      //!> 蜂鸣器
    SESSION_SET_DATETIME,              //!> 设置时间日期
    SESSION_GET_DATETIME,              //!> 获取时间日期
    SESSION_RESET,                     //!> 取消/复位操作
    SESSION_CLOSE_DEVICE,              //!> 关闭设备
    SESSION_UPGRADE,                   //!> 升级应用/固件
} EU_POS_SESSION;

/// 返回结果
typedef enum {
    RET_NULL = 0,
    
    RET_FAIL = -1,                 //!> 未知错误
    RET_FAIL_STX = -2,             //!> STX字段出错
    RET_FAIL_LEN = -3,             //!> LEN字段出错
    RET_FAIL_PATH = -4,            //!> PATH字段出错
    RET_FAIL_TYPE = -5,            //!> TYPE字段出错
    RET_FAIL_ID  = -6,             //!> ID不一致
    RET_FAIL_ETX = -7,             //!> ETX字段出错
    RET_FAIL_LRC = -8,             //!> LRC字段出错
    RET_FAIL_INIT = -9,             //!> 未进行初始化
    // 响应码错误返回
    RET_FAIL_CMD = -11,            //!> 指令码不支持
    RET_FAIL_PARAM = -12,          //!> 参数错误
    RET_FAIL_LENGTH = -13,         //!> 可变数据域长度错误
    RET_FAIL_FORMAT = -14,         //!> 帧格式错误
    RET_FAIL_GETLRC = -15,         //!> LRC错误
    RET_FAIL_OTHER = -16,          //!> 其他
    RET_FAIL_TIMEOUT = -17,        //!> 超时
    RET_FAIL_STATUS = -18,         //!> 返回当前状态
    RET_FAIL_PACKAGE = -21,        //!> 接收错误
    // 数据返回出错
    RET_FAIL_WKEY = -100,           //!> 组包失败: 工作密钥
    RET_FAIL_OPENCARD = -101,       //!> 组包失败: 开启读卡器
    RET_FAIL_SETICKEY = -102,       //!> 组包失败: 设置IC卡KEY
    RET_FAIL_SETAID = -103,         //!> 组包失败: 设置AID参数
    RET_FAIL_ICCODE = -104,         //!> 组包失败: 设置IC卡属性
    RET_FAIL_ICDATA = -105,         //!> 组包失败: 设置IC卡数据
    RET_FAIL_EMV_START = -106,      //!> 组包失败: 开始IC卡标准流程
    RET_FAIL_EMV_END = -107,        //!> 组包失败: 结束IC卡标准流程
    RET_FAIL_GET_DEVINFO = -108,    //!> 组包失败: 获取设备信息
    RET_FAIL_SETPARAM = -109,
    RET_FAIL_SETDATETIME = -110,    //!> 组包失败: 设置时间
    RET_FAIL_UPGRADE = -111,        //!> 组包失败: 升级
    RET_FAIL_PINENCRYPT = -112,     //!> 组包失败: PIN加密
    
    RET_TIMEOUT = -200,             //!> 超时
    RET_VERSION_NULL = -201,        //!> 版本号为空
    RET_VERSION_ERR = -202,         //!> 版本号比较失败
    RET_FILE_NOT_FOUND = -203,      //!> 文件找不到
    
    RET_PACKAGE = 10,               //!> 组包中...
    RET_USER_CANCEL = 20,           //!> 用户取消
    
    RET_RESULT = 100,               //!> 大于则有结果返回
    RET_KEK_DOWNLOAD,              //!> KEK下载
    RET_MKEY_DOWNLOAD,             //!> 主密钥下载
    RET_WKEY_DOWNLOAD,             //!> 工作密钥下载
    RET_SELECT_KEY,                //!> 密钥选择
    RET_INPUT_PIN,                 //!> 密码输入
    RET_CALC_MAC,                  //!> MAC计算
    RET_PIN_ENCRYPT,                //!> PIN加密
    RET_OPEN_CARD = 110,            //!> 开启读卡器
    RET_READ_CARD,                 //!> 读磁条卡
    RET_SET_ICKEY,                 //!> 设置IC公钥
    RET_SET_AID,                   //!> 设置AID
    RET_SET_ATTRIB,                //!> 设置交易属性
    RET_GET_DATA,                  //!> 获取交易数据
    RET_START_EMV,                 //!> 开始IC交易流程
    RET_IC_REAUTH,                 //!> IC二次授权
    RET_END_EMV,                   //!> 结束IC交易流程
    RET_GET_DEVINFO = 120,          //!> 读取设备信息
    RET_GET_RANDNUM,               //!> 获取随机数
    RET_SET_PARAM,                 //!> 设置商终号
    RET_GET_PARAM,                 //!> 读取商终号
    RET_BEEP,                      //!> 蜂鸣器
    RET_SET_DATETIME,              //!> 设置时间日期
    RET_GET_DATETIME,              //!> 获取时间日期
    RET_RESET,                     //!> 取消/复位操作
    RET_CLOSE_DEVICE,              //!> 关闭设备
    RET_UPGRADE,                   //!> 升级应用/固件
    RET_UPGRADE_FINISH,               //!> 升级结束
    RET_VERSION,                    //!> 版本比较成功
} EU_POS_RESULT;

//////////////////////////////////////////////////////////////////////////
#define MSR_DATETIME_SIZE               14  // 时间长度
#define MSR_PINBLOCK_SIZE               8   // PINBLOCK长度
#define MSR_MAC_SIZE                    8   // MAC长度
#define MSR_ACCOUNT_SIZE                19  // 主账号长度
#define MSR_PERIOD_SIZE                 4   // 有效期
#define MSR_SERVICECODE_SIZE            3   // 服务代码
#define MSR_TRACK_2_DATA_SIZE           80  // 二磁加密数据
#define MSR_TRACK_3_DATA_SIZE           208  // 二磁加密数据
#define MSR_SN_SIZE                     15  // SN号长度
#define MSR_VERSION_SIZE                24  // 版本号
#define MSR_DEVINFO_SIZE                32  // 厂商自定义信息
#define MSR_RANDNUM_SIZE                8   // 随机数
#define MSR_SHOPID_SIZE                 15  // 商户号
#define MSR_DEVID_SIZE                  8   // 终端号
#define MSR_UPRET_SIZE                  2   // 响应码
#define MSR_CHECKSUM_SIZE               20  // 校验值

/// 简单结果返回
typedef enum {
    RESP_UNKNOWN = 0xFF,                //!> 未知错误
    RESP_SUCC = 0x00,                   //!> 成功
    RESP_FAIL = 0x01,                   //!> 失败
} XN_MSR_RESP;

/// 结果返回: 开启读卡器
typedef enum {
    RESP_OPENCARD_UNKNOWN = 0xFF,       //!> 未知错误
    RESP_OPENCARD_USERCANCEL = 0x00,    //!> 用户取消操作
    RESP_OPENCARD_FINISH = 0x01,        //!> 刷卡结束
    RESP_OPENCARD_INSERT = 0x02,        //!> IC 卡已插入
} XN_MSR_OPENCARD_RESP;

/// 响应读卡方式
typedef enum {
    RESP_READCARD_SUCC = 0x00,          //!> 成功
    RESP_READCARD_FAIL = 0xFF,          //!> 失败
} XN_MSR_READCARD_RESP;

/// EMV执行结果
typedef enum {
    RESP_EMV_SUCC = 0x00,          //!> 成功
    RESP_EMV_ACCEPT = 0x01,        //!> 交易接受
    RESP_EMV_REJECT = 0x02,        //!> 交易拒绝
    RESP_EMV_ONLINE = 0x03,        //!> 联机
    RESP_EMV_FAIL = 0xFF,          //!> 交易失败
    RESP_EMV_FALLBACK = 0xFE,      //!> 回退
} XN_MSR_EMV_RESP;

/// EMV-密码提示
typedef enum {
    PIN_EMV_NOREQ = 0x00,          //!> 无要求
    PIN_EMV_REQ = 0x01,            //!> 要求后续流程输入联机PIN
} XN_MSR_EMV_PIN;

typedef enum {
    RESP_REAUTH_UNKNOWN = 0x00,         //!> 未知错误
    RESP_REAUTH_ACCEPT = 0x01,          //!> 交易授受
    RESP_REAUTH_REJECT = 0x04,          //!> 二次授权交易拒绝
    RESP_REAUTH_FAIL = 0xFF,            //!> 交易失败
} XN_MSR_REAUTH_RESP;

typedef enum {
    DEVSTAT_DEFAULT = 0xFF,             //!> 默认初始状态
    DEVSTAT_WKEYIN = 0x00,              //!> 工作密钥已灌装
    DEVSTAT_MKEYIN = 0x01,              //!> 主密钥已灌装
    DEVSTAT_KEKMOD = 0x02,              //!> KEK已修改
} XN_MSR_DEVSTAT;

typedef enum {
    UPSTAT_BEGIN = 0x00,                //!> 升级开始
    UPSTAT_DOING = 0x00,                //!> 升级中
    UPSTAT_END = 0x01,                  //!> 升级结束
} XN_MSR_UPGRADE_STAT;

/// 返回按键类型
typedef enum {
    KEYTYPE_OK = 0x00,                  //!< 确认键
    KEYTYPE_CANCEL = 0x06,              //!< 取消键
} XN_MSR_KEYTYPE;

/// 密钥长度
typedef enum {
    LEN_SINGLE = 0x01,     //!< 单倍长
    LEN_DOUBLE = 0x02,     //!< 双倍长
} XN_KEY_LENGTH;

/// 加密方式
typedef enum {
    ENCRYPT_KEK = 0x00,     //!< KEK加密
    ENCRYPT_MAINKEY = 0x01, //!< 原主钥加密
} XN_ENCRYPT_METHOD;

/// 密钥索引号
typedef enum {
    KEY_IND_0 = 0x00,       //!< 索引0
    KEY_IND_1,              //!< 索引1
    KEY_IND_2,              //!< 索引2
    KEY_IND_3,              //!< 索引3
    KEY_IND_4,              //!< 索引4
    KEY_IND_5,              //!< 索引5
    KEY_IND_6,              //!< 索引6
    KEY_IND_7,              //!< 索引7
    KEY_IND_8,              //!< 索引8
    KEY_IND_9,              //!< 索引9
} XN_KEY_INDEX;

// MAC算法
typedef enum {
    XN_MAC_UBC = 0,
    XN_MAC_X99_X919,
    XN_MAC_X99_EBC
}XN_MAC_CHOICE;

// 读卡类型
typedef enum {
    READ_TRACK = 0x01,      //!< 读取磁道信息
    IC_PRESENT = 0x02,       //!< 检查IC是否在位
    COMBINED = (0x01 | 0x02)
} XN_READCARD_TYPE;

// 读卡模式
typedef enum {
    READ_TRACK_2 = 0x02,        //!< 第二磁道数据
    READ_TRACK_4 = 0x04,        //!< 第三磁道数据
    READ_TRACK_COMBINED = (0x02 | 0x04)
} XN_READCARD_MODE;

// 主账号屏蔽模式
typedef enum {
    READ_NOMASK = 0x00,       //!< 主账号不屏蔽显示
    READ_MASK = 0x01,      //!< 账号屏蔽显示
} XN_READCARD_PANMASK;

// IC公钥设置操作
typedef enum {
    IC_KEY_CLEARALL = 0x01,     //!< 清除全部公钥
    IC_KEY_ADD = 0x02,          //!< 增加一个公钥
    IC_KEY_DEL = 0x03,          //!< 删除一个公钥
    IC_KEY_LIST = 0x04,         //!< 读取公钥列表
    IC_KEY_READ = 0x05,         //!< 读取指定公钥
} XN_ICKEY_ACTION;

/// AID设置操作
typedef enum {
    IC_AID_CLEARALL = 0x01,     //!< 清除全部AID
    IC_AID_ADD = 0x02,          //!< 增加一个AID
    IC_AID_DEL = 0x03,          //!< 删除一个AID
    IC_AID_LIST = 0x04,         //!< 读取AID列表
    IC_AID_READ = 0x05,         //!< 读取指定AID
} XN_ICAID_ACTION;

/// 电子现金交易指示器
typedef enum {
    ECASH_FORBIT = 0x00,       //!< 不支持
    ECASH_PERMIT = 0x01,        //!< 支持
} XN_ECASH_TRADE;

/// PBOC流程指示
typedef enum {
    PBOC_FULL = 0x01,           //!< 读应用数据
    PBOC_PART = 0x06,           //!< 第一次密文生成，完整流程
} XN_PBOC_FLOW;

/// IC卡操作是否联机
typedef enum {
    ONLINE_NO = 0x00,           //!< 不强制联机
    ONLINE_YES = 0x01,          //!< 强制联机
} XN_IC_ONLINE;

/// 交易类型
typedef enum {
    FUNC_BALANCE ,			//!< 查询
    //消费类
    FUNC_SALE,				//!< 消费
    //预授权类
    FUNC_PREAUTH,				//!< 预授权
    FUNC_AUTHSALE,				//!< 预授权完成请求
    FUNC_AUTHSALEOFF,			//!< 预授权完成通知
    FUNC_AUTHSETTLE,			//!< 预授权结算
    FUNC_ADDTO_PREAUTH,			//!< 追加预授权
    //退货类
    FUNC_REFUND ,				//!< 退货
    //撤销类
    FUNC_VOID_SALE,			//!< 消费撤销
    FUNC_VOID_AUTHSALE,			//!< 预授权完成撤销
    FUNC_VOID_AUTHSETTLE,		//!< 结算撤销
    FUNC_VOID_PREAUTH,			//!< 预授授权撤销
    FUNC_VOID_REFUND,			//!< 撤销退货
    //离线类
    FUNC_OFFLINE,				//!< 离线结算
    FUNC_ADJUST,				//!< 结算调整
    //电子钱包类
    FUNC_EP_LOAD,				//!< EP圈存
    FUNC_EP_PURCHASE,			//!< EP消费
    FUNC_CASH_EP_LOAD,			//!< 现金充值圈存
    FUNC_NOT_BIND_EP_LOAD,		//!< 非指定帐户圈存
    //分期类
    FUNC_INSTALMENT,			//!< 分期付款
    FUNC_VOID_INSTALMENT,		//!< 撤销分期
    //积分类
    FUNC_BONUS_IIS_SALE,		//!< 发卡行积分消费
    FUNC_VOID_BONUS_IIS_SALE,	//!< 撤销发卡行积分消费
    FUNC_BONUS_ALLIANCE,		//!< 联盟积分消费
    FUNC_VOID_BONUS_ALLIANCE,	//!< 撤销联盟积分消费
    FUNC_ALLIANCE_BALANCE,		//!< 联盟积分查询
    FUNC_ALLIANCE_REFUND,		//!< 联盟积分退货
    FUNC_INTEGRALSIGNIN,		//收银员积分签到
    //电子现金类
    FUNC_QPBOC,					//!< 快速消费
    FUNC_EC_PURCHASE,			//!< 电子现金消费
    FUNC_EC_LOAD,				//!< 电子现金指定账户圈存
    FUNC_EC_LOAD_CASH,			//!< 电子现金圈存现金
    //FUNC_EC_LOAD_NOT_BIND,		//!< 电子现金圈存非指定账户
    FUNC_EC_NOT_BIND_OUT,		//电子现金非指定账户圈存转出
    FUNC_EC_NOT_BIND_IN,		//电子现金非指定账户转入
    FUNC_EC_VOID_LOAD_CASH,		//!< 电子现金圈存现金撤销
    FUNC_EC_REFUND,				//!< 电子现金脱机退货
    FUNC_EC_BALANCE,			//!< 电子现金余额查询
    //无卡类
    FUNC_APPOINTMENT_SALE,		//!< 无卡预约消费
    FUNC_VOID_APPOINTMENT_SALE,	//!< 撤销无卡预约消费
    //磁条充值类
    FUNC_MAG_LOAD_CASH,			//!< 磁条预付费卡现金充值
    FUNC_MAG_LOAD_ACCOUNT,		//!< 磁条预付费卡账户充值
    //手机芯片类
    FUNC_PHONE_SALE,			//!< 手机芯片消费
    FUNC_VOID_PHONE_SALE,		//!< 撤销手机芯片消费
    FUNC_REFUND_PHONE_SALE,		//!< 手机芯片退货
    FUNC_PHONE_PREAUTH,			//!< 手机芯片预授权
    FUNC_VOID_PHONE_PREAUTH,	//!< 撤销手机芯片预授权
    FUNC_PHONE_AUTHSALE,		//!< 手机芯片预授权完成
    FUNC_PHONE_AUTHSALEOFF,		//!< 手机芯片完成通知
    FUNC_VOID_PHONE_AUTHSALE,	//!< 撤销手机完成请求
    FUNC_PHONE_BALANCE,			//!< 手机芯片余额查询
    //订购类
    FUNC_ORDER_SALE,			//!< 订购消费
    FUNC_VOID_ORDER_SALE,		//!< 订购消费撤销
    FUNC_ORDER_PREAUTH,			//!< 订购预授权
    FUNC_VOID_ORDER_PREAUTH,	//!< 订购预授权撤销
    FUNC_ORDER_AUTHSALE,		//!< 订购预授权完成
    FUNC_VOID_ORDER_AUTHSALE,	//!< 订购预授权完成撤销
    FUNC_ORDER_AUTHSALEOFF,		//!< 订购预授权完成通知
    FUNC_ORDER_REFUND,			//!< 订购退货
    //其他
    FUNC_EMV_SCRIPE,			//!< EMV脚本结果通知
    FUNC_EMV_REFUND,			//!< EMV脱机退货
    FUNC_PBOC_LOG,				//!< 读PBOC日志
    FUNC_LOAD_LOG,				//!< 读圈存日志
    FUNC_REVERSAL,				//!< 冲正
    FUNC_TC,
    FUNC_SETTLE,				//!< 结算
    
    COUNTTRANSTYPECOUNT
} XN_TRADE_TYPE;

/// 是否联机成功
typedef enum  {
    ONLINE_SUCC = 0x00,             //!> 联机成功
    ONLINE_FAIL = 0x01,             //!> 联机未成功
} XN_ONLINE_RESULT;

/// 关机选项
typedef enum {
    CLOSE_POWEROFF = 0x01,          //!> 关机
    CLOSE_SUSPEND = 0x02,             //!> 休眠
} XN_CLOSE_ACTION;

/// 升级请求状态
typedef enum {
    UPREQ_START = 0X01,             //!> 升级开始
    UPREQ_DOING = 0x02,             //!> 升级中
    UPREQ_FINISH = 0x03,            //!> 结束
} XN_UPGRADE_REQ;

///////////////////////////////////////////////////////////////////////////////////////////
/// 密码输入
typedef struct __tag_input_pin {
    XN_MSR_KEYTYPE keyType;             //!> 返回的功能键(0x00 确认键, 0x06 取消键)
    unsigned char pwdLen;            //!> 输入密码长度(0 表示是按了功能键，比如按了 enter 键或者取消键\r\n4-12 表示输入的密码长度)
    unsigned char pPinblock[MSR_PINBLOCK_SIZE];  //!> 加密后的PINBLOCK
} ST_INPUT_PIN;

// 计算MAC
typedef struct __tag_calc_mac {
    unsigned char szMac[MSR_MAC_SIZE];           //!> MAC地址
} ST_CALC_MAC;

// PIN加密
typedef struct __tag_pin_encrypt {
    unsigned char pPinblock[MSR_PINBLOCK_SIZE];           //!> 加密后的PINBLOCK
} ST_PIN_ENCRYPT;

// 读磁条卡
typedef struct __tag_read_card {
    XN_MSR_READCARD_RESP resp;                      //!> 响应的读卡方式
    char szAccount[MSR_ACCOUNT_SIZE + 1];           //!> 主账号
    char szPeriod[MSR_PERIOD_SIZE + 1];             //!> 有效期
    char szServiceCode[MSR_SERVICECODE_SIZE + 1];   //!> 服务代码
    unsigned char cTrack2Size;                      //!> 二磁道长度
    unsigned char cTrack3Size;                      //!> 三磁道长度
    unsigned char szTrack2data[MSR_TRACK_2_DATA_SIZE + 1];   //!> 二磁道数据
    unsigned int nTrack2Length;                              //!> 二磁道数据长度
    unsigned char szTrack3data[MSR_TRACK_3_DATA_SIZE + 1];   //!> 三磁道数据
    unsigned int nTrack3Length;                              //!> 三磁道数据长度
} ST_READ_CARD;

/// IC卡交易流程开始
typedef struct __tag_start_emv {
    XN_MSR_EMV_RESP resp;                           //!> 执行结果
    XN_MSR_EMV_PIN pinReq;                          //!> 联机PIN输入指示
} ST_START_EMV;

/// 获取设备信息
typedef struct __tag_get_devinfo {
    char szSN[MSR_SN_SIZE + 1];                     //!> SN号
    XN_MSR_DEVSTAT status;                            //!> 设备个人化状态
    char szVer[MSR_VERSION_SIZE + 1];               //!> 版本号
    char szInfo[MSR_DEVINFO_SIZE + 1];              //!> 厂商自定义信息
} ST_GET_DEVINFO;

/// 获取随机数
typedef struct __tag_get_randnum {
    unsigned char szRandNum[MSR_RANDNUM_SIZE + 1];           //!> 随机数
} ST_GET_RANDNUM;

/// 获取商终号
typedef struct __tag_get_param {
    char szShopid[MSR_SHOPID_SIZE + 1];             //!> 商户号
    char szDevid[MSR_DEVID_SIZE + 1];               //!> 终端号
} ST_GET_PARAM;

/// 获取时间
typedef struct __tag_get_datetime {
    char *szDatetime[MSR_DATETIME_SIZE];            //!> 日期+时间(格式: YYYYMMDDHHMMSS, 长度14位，以0x00结尾)
} ST_GET_DATETIME;

/// 升级
typedef struct __tag_upgrade {
    XN_MSR_UPGRADE_STAT stat;                       //!> 响应状态
    char szCode[MSR_UPRET_SIZE + 1];                //!> 响应码
    char szSHA1[MSR_CHECKSUM_SIZE + 1];              //!> 校验码
} ST_UPGRADE;
#endif
