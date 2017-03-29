//
//  AnFSwiperController.h
//
//

#import <Foundation/Foundation.h>

#define  AF_ERROR_OK 0
#define  AF_ERROR_FAIL_CONNECT_DEVICE 0x0001
#define  AF_ERROR_FAIL_GET_KSN  0x0002
#define  AF_ERROR_FAIL_READCARD 0x0003
#define  AF_ERROR_FAIL_ENCRYPTPIN 0x0004
#define  AF_ERROR_FAIL_GETMAC     0x0005
#define  AF_ERROR_FAIL_MCCARD   0x0007
#define  AF_ERROR_FAIL_READ_TRACK2     0x0008
#define  AF_ERROR_FAIL_TIMEOUT          0x0009
#define  AF_ERROR_FAIL_NOT_SWIPER     0x0010
#define  AF_ERROR_FAIL_PBOC_TWO       0x0011


typedef enum
{
    AF_STATE_ACTIVE = 0,
    AF_STATE_IDLE = 1,
    AF_STATE_BUSY = 2,
    AF_STATE_UNACTIVE = -1
}AFDeviceBlueState;



typedef enum
{
    AF_card_mc = 1,        //磁条卡
    AF_card_ic = 2,        //IC卡
    AF_card_all = 3        //银行卡
}af_cardType;              //银行卡类型


@protocol AnFSwiperControllerDelegate <NSObject>

@optional


//扫描设备结果
-(void)onFindBlueDevice:(NSDictionary *)dic;


//连接设备结果
-(void)onDidConnectBlueDevice:(NSDictionary *)dic;


//失去连接到设备
-(void)onDisconnectBlueDevice:(NSDictionary *)dic;


//读取ksn结果
/*
 @"1"          //设备硬件编号
 @"2"          //个人化状态
 @"6"          //密钥序列号
 
 */
-(void)onDidGetDeviceKsn:(NSDictionary *)dic;

//写入工作密钥回调
-(void)onDidUpdateKey:(int)retCode;

//检测到IC卡或磁条卡回调
-(void)onDetectCard;

//读取卡信息结果
/*
 //磁条卡
 #define kMCRandom @"4"                 //随机数
 #define kMCCount  @"5"                 //主账户
 #define kMCExpired  @"6"                 //失效日期
 #define kMCTrackTwoLen  @"8"          //二磁道数据长度
 #define kMCTrackTwoLen  @"9"          //三磁道数据长度
 #define kMCTrackTwoThreeData  @"A"    //二磁道加密数据
 #define kMCTrackTwoThreeData  @"B"    //三磁道加密数据
 //IC卡
 #define kICCount  @"5A"           //主账户
 #define kICExpired  @"5F24"         //失效日期
 #define kICTrackTwoData  @"57"    //二磁道信息
 #define kICCardSN  @"5F34"        //卡序列号
 #define kICData  @"55"            //ICData
 */
-(void)onDidReadCardInfo:(NSDictionary *)dic;



//加密Pin结果
/*
 @"1" PinBlock
 
 */
-(void)onEncryptPinBlock:(NSDictionary *)dic;


//mac计算结果
-(void)onDidGetMac:(NSString *)strmac;


//错误回调，errorCode的值在宏定义中，AF_ERROR_XXX
-(void)onError:(int)errorCode;

//app取消交易
-(void)onDidCancelCard;

//复合卡，需要插入IC卡
-(void)onNeedInsertICCard;

//PBOC二次授权
/*
 * retCode = 0x01正常交易， 0x02交易拒绝
 */
-(void)onDidSecondIssuance:(int)retCode;

//键盘上输入金额
-(void)onDidGetMoney:(NSString *) strMoney;

//点击了取消按键
-(void)onDidPressCancleKey;

@end

@interface AnFSwiperController : NSObject
{
    int intDeviceBlueState;
}
@property(nonatomic) id<AnFSwiperControllerDelegate> delegate;
@property (nonatomic) BOOL isConnectBlue;
@property (nonatomic, retain) NSDictionary *dicCurrect;
@property (nonatomic) af_cardType  currentCardType;


/*
 SDK初始化
 */
+(instancetype)shareInstance;



/*
 搜索蓝牙设备
 */
-(void)scanBlueDevice:(NSString *)filter;


/*
 停止扫描蓝牙
 */
-(void)stopScanBlueDevice;


/*
 连接蓝牙设备
 */

-(BOOL)connectDevice:(NSDictionary *)dic;


/*
 断开蓝牙设备
 */
-(void)disConnectDevice;


/*
 获取ksn编号,
 */

-(void)getKsn;


/*
 导入主密钥,
 */

-(void)writeMainKey:(NSString*)mainKey;


/*
 写入工作密钥
 DESKey、（32位密钥 + 8位checkValue = 40位）
 PINKey、（32位密钥 + 8位checkValue = 40位）
 */
-(void)writeSessionKey:(NSDictionary *)keyDic;


/*
刷卡
type 1: 消费
     2: 查余
 */
-(void)startSwiper:(int)type  money:(double)dbmoney;




/*
 加密pin
 */
-(void)encryptPin:(NSString *)Pin;


/*
 计算mac
 */
-(void)calcMac:(NSString *)data;


//取消交易
-(void)stopSwiper;


//PBOC二次授权
-(void)doSecondIssuance:(NSString *)tlv;


/*
 从设备键盘获得加密后的Pin
 timeOut 超时时间，单位:秒
 */
-(void)getPinBlockFromKB:(UInt8)timeOut;

/*
 从设备键盘获取金额
 timeOut 超时时间，单位:秒
 */
-(void)getMoneyFromKB:(UInt8)timeOut;


@end
