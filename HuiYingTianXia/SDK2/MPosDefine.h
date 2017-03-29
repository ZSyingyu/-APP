//
//  MsrParam
//  MPosClient
//
//  Created by 陈嘉祺 on 15/3/19.
//  Copyright (c) 2015年 MoreFun. All rights reserved.
//

#ifndef ___MFPOS_DEFINE_H___
#define ___MFPOS_DEFINE_H___

typedef enum {
    MF_DDI_UNKNOWN = 0, //!< 未知
    MF_DDI_BLE,         //!< BLE蓝牙
    MF_DDI_AUDIO,      //!< 音频刷卡器
} MFEU_DRIVER_INTERFACE;

// SESSION消息
typedef enum {
    MF_SESSION_UNKNOWN = 0,                //!> 未知状态
    MF_SESSION_SCAN_START = 10,            //!> 蓝牙搜索开始
    MF_SESSION_SCAN_STOP,                  //!> 蓝牙搜索结束
    MF_SESSION_SCAN_ONE,                   //!> 搜索到一个蓝牙设备
    MF_SESSION_CONN_FAIL,                  //!> 蓝牙连接失败
    MF_SESSION_CONN_VALID,                 //!> 连接合法设备
    MF_SESSION_CONN_INVALID,               //!> 连接非法设备
    MF_SESSION_DISCONNECT,                 //!> 断开连接
    MF_SESSION_AUDIO_CONNECT,              //!> 音频设备插入
    MF_SESSION_AUDIO_DISCONNECT,           //!> 音频设备拔掉
    MF_SESSION_AUDIO_INTERRUPTED,          //!> 音频中断
    MF_SESSION_KEK_DOWNLOAD = 100,         //!> KEK下载
    MF_SESSION_MKEY_DOWNLOAD,              //!> 主密钥下载
    MF_SESSION_WKEY_DOWNLOAD,              //!> 工作密钥下载
    MF_SESSION_SELECT_PIN,                 //!> 密钥选择
    MF_SESSION_INPUT_PIN,                  //!> 密码输入
    MF_SESSION_CALC_MAC,                   //!> MAC计算
    MF_SESSION_PIN_ENCRYPT,                //!> PIN加密
    MF_SESSION_PIN_ENCRYPT2,               //!> PIN加密2
    MF_SESSION_OPEN_CARD = 110,            //!> 开启读卡器
    MF_SESSION_READ_CARD,                  //!> 读磁条卡
    MF_SESSION_SET_ICKEY,                  //!> 设置IC公钥
    MF_SESSION_SET_AID,                    //!> 设置AID
    MF_SESSION_SET_ATTRIB,                 //!> 设置交易属性
    MF_SESSION_SET_DATA,                   //!> 设置交易数据
    MF_SESSION_START_EMV,                  //!> 开始IC交易流程
    MF_SESSION_IC_REAUTH,                  //!> IC二次授权
    MF_SESSION_END_EMV,                    //!> 结束IC交易流程
    MF_SESSION_GET_DEVINFO = 120,          //!> 读取设备信息
    MF_SESSION_GET_RANDNUM,                //!> 获取随机数
    MF_SESSION_SET_PARAM,                  //!> 设置商终号
    MF_SESSION_GET_PARAM,                  //!> 读取商终号
    MF_SESSION_BEEP,                       //!> 蜂鸣器
    MF_SESSION_SET_DATETIME,               //!> 设置时间日期
    MF_SESSION_GET_DATETIME,               //!> 获取时间日期
    MF_SESSION_RESET = 130,                //!> 取消/复位操作
    MF_SESSION_CLOSE_DEVICE,               //!> 关闭设备
    MF_SESSION_UPGRADE,                    //!> 升级应用/固件
    MF_SESSION_DATA_ENCODE = 150,          //!> 数据加密
    MF_SESSION_DATA_WRITE,                 //!> 自定义数据写入
    MF_SESSION_DATA_READ,                  //!> 自定义数据读取
    MF_SESSION_ICDATA,                     //!> 取IC卡数据
    MF_SESSION_EMVDATA_EX,                 //!> 取IC卡数据(8004)
    MF_SESSION_EMVDATA_EX2,                //!> 取IC卡数据(从TAG中获取)
    MF_SESSION_JF_MAGCARD = 160,            //!> 读磁条卡(即富)
    MF_SESSION_JF_ICDATA,                  //!> 取IC交易数据(即富)
    MF_SESSION_JF_KSN,                     //!> 读序列号(即富)
    MF_SESSION_GET_DEVINFO_EX,              //!> 读取设备信息（扩展）
} MFEU_POS_SESSION;

/// 返回结果
typedef enum {
    MF_RET_NULL = 0,
    
    MF_RET_FAIL = -1,                 //!> 未知错误
    MF_RET_FAIL_STX = -2,             //!> STX字段出错
    MF_RET_FAIL_LEN = -3,             //!> LEN字段出错
    MF_RET_FAIL_PATH = -4,            //!> PATH字段出错
    MF_RET_FAIL_TYPE = -5,            //!> TYPE字段出错
    MF_RET_FAIL_ID  = -6,             //!> ID不一致
    MF_RET_FAIL_ETX = -7,             //!> ETX字段出错
    MF_RET_FAIL_LRC = -8,             //!> LRC字段出错
    // 响应码错误返回
    MF_RET_FAIL_CMD = -11,            //!> 指令码不支持
    MF_RET_FAIL_PARAM = -12,          //!> 参数错误
    MF_RET_FAIL_LENGTH = -13,         //!> 可变数据域长度错误
    MF_RET_FAIL_FORMAT = -14,         //!> 帧格式错误
    MF_RET_FAIL_GETLRC = -15,         //!> LRC错误
    MF_RET_FAIL_OTHER = -16,          //!> 其他
    MF_RET_FAIL_TIMEOUT = -17,        //!> 超时
    MF_RET_FAIL_STATUS = -18,         //!> 返回当前状态
    MF_RET_FAIL_PACKAGE = -21,        //!> 接收错误
    // 数据返回出错
    MF_RET_FAIL_WKEY = -100,           //!> 组包失败: 工作密钥
    MF_RET_FAIL_OPENCARD = -101,       //!> 组包失败: 开启读卡器
    MF_RET_FAIL_SETICKEY = -102,       //!> 组包失败: 设置IC卡KEY
    MF_RET_FAIL_SETAID = -103,         //!> 组包失败: 设置AID参数
    MF_RET_FAIL_ICCODE = -104,         //!> 组包失败: 设置IC卡属性
    MF_RET_FAIL_ICDATA = -105,         //!> 组包失败: 设置IC卡数据
    MF_RET_FAIL_EMV_START = -106,      //!> 组包失败: 开始IC卡标准流程
    MF_RET_FAIL_EMV_END = -107,        //!> 组包失败: 结束IC卡标准流程
    MF_RET_FAIL_GET_DEVINFO = -108,    //!> 组包失败: 获取设备信息
    MF_RET_FAIL_SETPARAM = -109,
    MF_RET_FAIL_SETDATETIME = -110,    //!> 组包失败: 设置时间
    MF_RET_FAIL_UPGRADE = -111,        //!> 组包失败: 升级
    MF_RET_FAIL_PINENCRYPT = -112,     //!> 组包失败: PIN加密
    MF_RET_FAIL_PINENCRYPT2 = -113,    //!> 组包失败: PIN加密2
   
    MF_RET_TIMEOUT = -200,             //!> 超时
    MF_RET_VERSION_NULL = -201,        //!> 版本号为空
    MF_RET_VERSION_ERR = -202,         //!> 版本号比较失败
    MF_RET_FILE_NOT_FOUND = -203,      //!> 文件找不到
    MF_RET_DEVICE_ERROR = -204,         //!> 设备问题
    
    MF_RET_PACKAGE = 10,               //!> 组包中...
    MF_RET_USER_CANCEL = 20,           //!> 用户取消
    
    MF_RET_RESULT = 99,               //!> 大于则有结果返回
    MF_RET_KEK_DOWNLOAD = 100,          //!> KEK下载
    MF_RET_MKEY_DOWNLOAD,             //!> 主密钥下载
    MF_RET_WKEY_DOWNLOAD,             //!> 工作密钥下载
    MF_RET_SELECT_KEY,                //!> 密钥选择
    MF_RET_INPUT_PIN,                 //!> 密码输入
    MF_RET_CALC_MAC,                  //!> MAC计算
    MF_RET_PIN_ENCRYPT,                //!> PIN加密
    MF_RET_OPEN_CARD = 110,            //!> 开启读卡器
    MF_RET_READ_CARD,                 //!> 读磁条卡
    MF_RET_SET_ICKEY,                 //!> 设置IC公钥
    MF_RET_SET_AID,                   //!> 设置AID
    MF_RET_SET_ATTRIB,                //!> 设置交易属性
    MF_RET_SET_DATA,                  //!> 设置交易数据
    MF_RET_START_EMV,                 //!> 开始IC交易流程
    MF_RET_IC_REAUTH,                 //!> IC二次授权
    MF_RET_END_EMV,                   //!> 结束IC交易流程
    MF_RET_GET_DEVINFO = 120,          //!> 读取设备信息
    MF_RET_GET_RANDNUM,               //!> 获取随机数
    MF_RET_SET_PARAM,                 //!> 设置商终号
    MF_RET_GET_PARAM,                 //!> 读取商终号
    MF_RET_BEEP,                      //!> 蜂鸣器
    MF_RET_SET_DATETIME,              //!> 设置时间日期
    MF_RET_GET_DATETIME,              //!> 获取时间日期
    MF_RET_RESET = 130,               //!> 取消/复位操作
    MF_RET_CLOSE_DEVICE,              //!> 关闭设备
    MF_RET_UPGRADE,                   //!> 升级应用/固件
    MF_RET_UPGRADE_FINISH,             //!> 升级结束
    MF_RET_VERSION,                    //!> 版本比较成功
    MF_RET_DATA_ENCODE = 150,          //!> 数据加密
    MF_RET_DATA_WRITE,                 //!> 自定义数据写入
    MF_RET_DATA_READ,                  //!> 自定义数据读取
    MF_RET_ICDATA,                     //!> 取IC卡数据
    MF_RET_JF_MAGCARD = 160,            //!> 读磁条卡(即富)
    MF_RET_JF_ICDATA,                  //!> 取IC卡交易数据(即富)
    MF_RET_JF_KSN,                     //!> 取KSN号(即富)
    MF_RET_GET_DEVINFO_EX,             //!> 读取设备信息（扩展）
} MFEU_POS_RESULT;

/// 密钥长度
typedef enum {
    MF_LEN_SINGLE = 0x01,     //!< 单倍长
    MF_LEN_DOUBLE = 0x02,     //!< 双倍长
    MF_LEN_DOUBLEMAG = 0x03,   //!< 双倍长带磁道加密
} MFEU_KEY_LENGTH;

/// 工作密钥类型
typedef enum {
    MF_WKEY_PIN = 0x01,     //!< PIN密钥
    MF_WKEY_MAC = 0x02,     //!< MAC密钥
    MF_WKEY_TRACK = 0x03,   //!< 磁道密钥
} MFEU_WKEY_TYPE;

/// 加密方式
typedef enum {
    MF_ENCRYPT_KEK = 0x00,         //!< KEK加密
    MF_ENCRYPT_MAINKEY = 0x01,     //!< 原主钥加密
    MF_ENCRYPT_PLAINTEXT = 0x02,   //!< 明文
    MF_ENCRYPT_C_FJPOSTAR = 0x03,      //!< 国通新驿模式
} MFEU_ENCRYPT_METHOD;

/// 密钥索引号
typedef enum {
    MF_KEY_IND_0 = 0x00,       //!< 索引0
    MF_KEY_IND_1,              //!< 索引1
    MF_KEY_IND_2,              //!< 索引2
    MF_KEY_IND_3,              //!< 索引3
    MF_KEY_IND_4,              //!< 索引4
    MF_KEY_IND_5,              //!< 索引5
    MF_KEY_IND_6,              //!< 索引6
    MF_KEY_IND_7,              //!< 索引7
    MF_KEY_IND_8,              //!< 索引8
    MF_KEY_IND_9,              //!< 索引9
} MFEU_KEY_INDEX;

/// MAC算法
typedef enum {
    MF_MACALG_UBC = 0x00,     //!< UBC算法
    MF_MACALG_X99,            //!< X99/X919
    MF_MACALG_EBC,            //!< EBC算法
} MFEU_MAC_MFEU_ALG;

/// PIN加密2 - 算法类型
typedef enum {
    MF_PIN_ENCRYPT_TEXT = 0x00,    //!< 明文
    MF_PIN_ENCRYPT_XOR,            //!< 固定异或
    MF_PIN_ENCRYPT_SNXOR,          //!< ＳＮ异或
    MF_PIN_ENCRYPT_F1,             //!< 国通星驿
} MFEU_PIN_ENCRYPT;


// 读卡类型
typedef enum {
    MF_READ_TRACK = 0x01,      //!< 读取磁道信息
    MF_IC_PRESENT = 0x02,       //!< 检查IC是否在位
    MF_COMBINED = (0x01 | 0x02)
} MFEU_READCARD_TYPE;
    
// 读卡模式
typedef enum {
    MF_READ_TRACK_2 = 0x02,            //!< 第二磁道数据(加密)
    MF_READ_TRACK_4 = 0x04,            //!< 第三磁道数据(加密)
    MF_READ_TRACK_2_TEXT = 0x12,       //!< 第二磁道数据(不加密)
    MF_READ_TRACK_4_TEXT = 0x14,       //!< 第三磁道数据(不加密)
    MF_READ_TRACK_COMBINED = (0x02 | 0x04),
    MF_READ_TRACK_COMBINED_TEXT = (0x12 | 0x14)
} MFEU_READCARD_MODE;
    
// 主账号屏蔽模式
typedef enum {
    MF_READ_NOMASK = 0x00,       //!< 主账号不屏蔽显示
    MF_READ_MASK = 0x01,      //!< 账号屏蔽显示
} MFEU_READCARD_PANMASK;

// IC公钥设置操作
typedef enum {
    MF_IC_KEY_CLEARALL = 0x01,     //!< 清除全部公钥
    MF_IC_KEY_ADD = 0x02,          //!< 增加一个公钥
    MF_IC_KEY_DEL = 0x03,          //!< 删除一个公钥
    MF_IC_KEY_LIST = 0x04,         //!< 读取公钥列表
    MF_IC_KEY_READ = 0x05,         //!< 读取指定公钥
} MFEU_ICKEY_ACTION;

/// AID设置操作
typedef enum {
    MF_IC_AID_CLEARALL = 0x01,     //!< 清除全部AID
    MF_IC_AID_ADD = 0x02,          //!< 增加一个AID
    MF_IC_AID_DEL = 0x03,          //!< 删除一个AID
    MF_IC_AID_LIST = 0x04,         //!< 读取AID列表
    MF_IC_AID_READ = 0x05,         //!< 读取指定AID
} MFEU_ICAID_ACTION;
    
/// 电子现金交易指示器
typedef enum {
    MF_ECASH_FORBIT = 0x00,       //!< 不支持
    MF_ECASH_PERMIT = 0x01,        //!< 支持
} MFEU_ECASH_TRADE;
    
/// PBOC流程指示
typedef enum {
    MF_PBOC_FULL = 0x06,           //!< 读应用数据
    MF_PBOC_PART = 0x01,           //!< 第一次密文生成
} MFEU_PBOC_FLOW;

/// IC卡操作是否联机
typedef enum {
    MF_ONLINE_NO = 0x00,           //!< 不强制联机
    MF_ONLINE_YES = 0x01,          //!< 强制联机
} MFEU_IC_ONLINE;

/// 交易类型
typedef enum {
	MF_FUNC_BALANCE ,			//!< 查询
	//消费类
	MF_FUNC_SALE,				//!< 消费
	//预授权类
	MF_FUNC_PREAUTH,				//!< 预授权
	MF_FUNC_AUTHSALE,				//!< 预授权完成请求
	MF_FUNC_AUTHSALEOFF,			//!< 预授权完成通知
	MF_FUNC_AUTHSETTLE,			//!< 预授权结算
	MF_FUNC_ADDTO_PREAUTH,			//!< 追加预授权
	//退货类
	MF_FUNC_REFUND ,				//!< 退货
	//撤销类
	MF_FUNC_VOID_SALE,			//!< 消费撤销
	MF_FUNC_VOID_AUTHSALE,			//!< 预授权完成撤销
	MF_FUNC_VOID_AUTHSETTLE,		//!< 结算撤销
	MF_FUNC_VOID_PREAUTH,			//!< 预授授权撤销
	MF_FUNC_VOID_REFUND,			//!< 撤销退货
	//离线类
	MF_FUNC_OFFLINE,				//!< 离线结算
	MF_FUNC_ADJUST,				//!< 结算调整
	//电子钱包类
	MF_FUNC_EP_LOAD,				//!< EP圈存
	MF_FUNC_EP_PURCHASE,			//!< EP消费
	MF_FUNC_CASH_EP_LOAD,			//!< 现金充值圈存
	MF_FUNC_NOT_BIND_EP_LOAD,		//!< 非指定帐户圈存
	//分期类
	MF_FUNC_INSTALMENT,			//!< 分期付款
	MF_FUNC_VOID_INSTALMENT,		//!< 撤销分期
	//积分类
	MF_FUNC_BONUS_IIS_SALE,		//!< 发卡行积分消费
	MF_FUNC_VOID_BONUS_IIS_SALE,	//!< 撤销发卡行积分消费
	MF_FUNC_BONUS_ALLIANCE,		//!< 联盟积分消费
	MF_FUNC_VOID_BONUS_ALLIANCE,	//!< 撤销联盟积分消费
	MF_FUNC_ALLIANCE_BALANCE,		//!< 联盟积分查询
	MF_FUNC_ALLIANCE_REFUND,		//!< 联盟积分退货
	MF_FUNC_INTEGRALSIGNIN,		//收银员积分签到
	//电子现金类
	MF_FUNC_QPBOC,					//!< 快速消费
	MF_FUNC_EC_PURCHASE,			//!< 电子现金消费
	MF_FUNC_EC_LOAD,				//!< 电子现金指定账户圈存
	MF_FUNC_EC_LOAD_CASH,			//!< 电子现金圈存现金
	//FUNC_EC_LOAD_NOT_BIND,		//!< 电子现金圈存非指定账户
	MF_FUNC_EC_NOT_BIND_OUT,		//电子现金非指定账户圈存转出
	MF_FUNC_EC_NOT_BIND_IN,		//电子现金非指定账户转入
	MF_FUNC_EC_VOID_LOAD_CASH,		//!< 电子现金圈存现金撤销
	MF_FUNC_EC_REFUND,				//!< 电子现金脱机退货
	MF_FUNC_EC_BALANCE,			//!< 电子现金余额查询
	//无卡类
	MF_FUNC_APPOINTMENT_SALE,		//!< 无卡预约消费
	MF_FUNC_VOID_APPOINTMENT_SALE,	//!< 撤销无卡预约消费
	//磁条充值类
	MF_FUNC_MAG_LOAD_CASH,			//!< 磁条预付费卡现金充值
	MF_FUNC_MAG_LOAD_ACCOUNT,		//!< 磁条预付费卡账户充值
	//手机芯片类
	MF_FUNC_PHONE_SALE,			//!< 手机芯片消费
	MF_FUNC_VOID_PHONE_SALE,		//!< 撤销手机芯片消费
	MF_FUNC_REFUND_PHONE_SALE,		//!< 手机芯片退货
	MF_FUNC_PHONE_PREAUTH,			//!< 手机芯片预授权
	MF_FUNC_VOID_PHONE_PREAUTH,	//!< 撤销手机芯片预授权
	MF_FUNC_PHONE_AUTHSALE,		//!< 手机芯片预授权完成
	MF_FUNC_PHONE_AUTHSALEOFF,		//!< 手机芯片完成通知
	MF_FUNC_VOID_PHONE_AUTHSALE,	//!< 撤销手机完成请求
	MF_FUNC_PHONE_BALANCE,			//!< 手机芯片余额查询
	//订购类
	MF_FUNC_ORDER_SALE,			//!< 订购消费
	MF_FUNC_VOID_ORDER_SALE,		//!< 订购消费撤销
	MF_FUNC_ORDER_PREAUTH,			//!< 订购预授权
	MF_FUNC_VOID_ORDER_PREAUTH,	//!< 订购预授权撤销
	MF_FUNC_ORDER_AUTHSALE,		//!< 订购预授权完成
	MF_FUNC_VOID_ORDER_AUTHSALE,	//!< 订购预授权完成撤销
	MF_FUNC_ORDER_AUTHSALEOFF,		//!< 订购预授权完成通知
	MF_FUNC_ORDER_REFUND,			//!< 订购退货
	//其他
	MF_FUNC_EMV_SCRIPE,			//!< EMV脚本结果通知
	MF_FUNC_EMV_REFUND,			//!< EMV脱机退货
	MF_FUNC_PBOC_LOG,				//!< 读PBOC日志
	MF_FUNC_LOAD_LOG,				//!< 读圈存日志
	MF_FUNC_REVERSAL,				//!< 冲正
	MF_FUNC_TC,
	MF_FUNC_SETTLE,				//!< 结算
    
	MF_COUNTTRANSTYPECOUNT
} MFEU_TRADE_TYPE;

/// 是否联机成功
typedef enum  {
    MF_ONLINE_SUCC = 0x00,             //!> 联机成功
    MF_ONLINE_FAIL = 0x01,             //!> 联机未成功
} MFEU_ONLINE_RESULT;

/// 关机选项
typedef enum {
    MF_CLOSE_POWEROFF = 0x01,          //!> 关机
    MF_CLOSE_SUSPEND = 0x02,             //!> 休眠
} MFEU_CLOSE_ACTION;

/// 升级请求状态
typedef enum {
    MF_UPREQ_START = 0X01,             //!> 升级开始
    MF_UPREQ_DOING = 0x02,             //!> 升级中
    MF_UPREQ_FINISH = 0x03,            //!> 结束
} MFEU_UPGRADE_REQ;

/// 简单结果返回
typedef enum {
    MF_RESP_UNKNOWN = 0xFF,                //!> 未知错误
    MF_RESP_SUCC = 0x00,                   //!> 成功
    MF_RESP_FAIL = 0x01,                   //!> 失败
} MFEU_MSR_RESP;

/// 结果返回: 开启读卡器
typedef enum {
    MF_RESP_OPENCARD_UNKNOWN = 0xFF,       //!> 未知错误
    MF_RESP_OPENCARD_USERCANCEL = 0x00,    //!> 用户取消操作
    MF_RESP_OPENCARD_FINISH = 0x01,        //!> 刷卡结束
    MF_RESP_OPENCARD_INSERT = 0x02,        //!> IC 卡已插入
    MF_RESP_OPENCARD_RFID = 0x03,          //!> RF 卡插入
    MF_RESP_OPENCARD_ICFORCE = 0x04,       //!> 强制IC卡
    MF_RESP_OPENCARD_TIMEOVER = 0x05,      //!> 超时
    MF_RESP_OPENCARD_CHECKERR = 0x06,      //!> 校验错误
} MFEU_MSR_OPENCARD_RESP;

/// 响应读卡方式
typedef enum {
    MF_RESP_READCARD_SUCC = 0x00,          //!> 成功
    MF_RESP_READCARD_FAIL = 0xFF,          //!> 失败
} MFEU_MSR_READCARD_RESP;

/// EMV执行结果
typedef enum {
    MF_RESP_EMV_SUCC = 0x00,          //!> 成功
    MF_RESP_EMV_ACCEPT = 0x01,        //!> 交易接受
    MF_RESP_EMV_REJECT = 0x02,        //!> 交易拒绝
    MF_RESP_EMV_ONLINE = 0x03,        //!> 联机
    MF_RESP_EMV_FAIL = 0xFF,          //!> 交易失败
    MF_RESP_EMV_FALLBACK = 0xFE,      //!> 回退
} MFEU_MSR_EMV_RESP;

/// EMV-密码提示
typedef enum {
    MF_PIN_EMV_NOREQ = 0x00,          //!> 无要求
    MF_PIN_EMV_REQ = 0x01,            //!> 要求后续流程输入联机PIN
} MFEU_MSR_EMV_PIN;

typedef enum {
    MF_RESP_REAUTH_UNKNOWN = 0x00,         //!> 未知错误
    MF_RESP_REAUTH_ACCEPT = 0x01,          //!> 交易授受
    MF_RESP_REAUTH_GACAAC = 0x02,          //!> 交易拒绝
    MF_RESP_REAUTH_ONLINE = 0x03,          //!> 联机
    MF_RESP_REAUTH_REJECT = 0x04,          //!> 二次授权交易拒绝
    MF_RESP_REAUTH_FAIL = 0xFF,            //!> 交易失败
} MFEU_MSR_REAUTH_RESP;

typedef enum {
    MF_DEVSTAT_DEFAULT = 0xFF,             //!> 默认初始状态
    MF_DEVSTAT_WKEYIN = 0x00,              //!> 工作密钥已灌装
    MF_DEVSTAT_MKEYIN = 0x01,              //!> 主密钥已灌装
    MF_DEVSTAT_KEKMOD = 0x02,              //!> KEK已修改
} MFEU_MSR_DEVSTAT;

typedef enum {
    MF_UPSTAT_BEGIN = 0x00,                //!> 升级开始
    MF_UPSTAT_DOING = 0x00,                //!> 升级中
    MF_UPSTAT_END = 0x01,                  //!> 升级结束
} MFEU_MSR_UPGRADE_STAT;

/// 返回按键类型
typedef enum {
    MF_KEYTYPE_OK = 0x00,                  //!< 确认键
    MF_KEYTYPE_CANCEL = 0x06,              //!< 取消键
} MFEU_MSR_KEYTYPE;

typedef enum {
    BATTERY_CAPACITY_UNKOWN = 0,                    //!> 未知状态
    BATTERY_CAPACITY_CRITICAL,                      //!> 临界
    BATTERY_CAPACITY_LOW,                           //!> 低压
    BATTERY_CAPACITY_NORMAL,                        //!> 正常
    BATTERY_CAPACITY_HIGH,                          //!> 电量充足
    BATTERY_CAPACITY_FULL,                          //!> 满电
} MFEU_MSR_BATTERY;

/// 自定义数据写入
typedef enum {
    MF_DATA_WRITE = 0x00,             //!> 不清除
    MF_DATA_CLEAR = 0x01,             //!> 数据清除
} MFEU_DATA_WRITE;

#ifdef __cplusplus
extern "C"{
#endif
    
/// 将AscII码的字符串转换成压缩的HEX格式
/** 0141212 ==> 0x20 0x14 0x12 0x12
 *	非偶数长度的字符串根据对齐方式，采取左补0，右补F方式
 *	@param pszBcdBuf          [INOUT]     转换输出的HEX数据
 *	@param pszAsciiBuf        [IN]        被转换的ASCII字符串
 *	@param nLen               [IN]        输入数据长度(ASCII字符串的长度)
 *	@param cType              [IN]        对齐方式  0－左对齐  1－右对齐
 *	@return -1 失败,成功返回长度
 */
int MFPosAsc2Hex (unsigned char* pszBcdBuf, const unsigned char* pszAsciiBuf, int nLen, char cType);

/// 将HEX码数据转换成AscII码字符串
/** 0x20 0x14 0x12 0x12 ==> 20141212
 * @param pszAsciiBuf         [INOUT]     转换输出的AscII码数据
 * @param pszBcdBuf           [IN]        被转换的Hex数据
 * @param nLen                [IN]        转换数据长度(HEX码数据长度)
 * @param cType               [IN]        对齐方式  1－左对齐  0－右对齐
 * @return 0 成功; -1 失败
 *******************************************************************************/
int MFPosHex2Asc (unsigned char* pszAsciiBuf, const unsigned char* pszBcdBuf, int nLen, char cType);

#ifdef __cplusplus
}
#endif
        
#endif
