//
//  CommunicationManagerBase.h
//  voclib
//
//  Created by hezewen on 14-5-23.
// 实现和vcom一样的方法。最后组装的数据交给蓝牙类，蓝牙也是只负责传输数据。
// 后面要把组包和解包的方法单独抽象出来

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
//#import "DeviceSearchListener.h"
#import "ItronCommunicationManagerBase.h"
#import "HandleData.h"
#import "CSwiperStateChangedListener.h"


@class Transactioninfo;
@interface ItronCommunicationManagerBase : NSObject
{
    char bout[4096];
    int  boutlen;
    //返回数据指针和长度
    char* retdata;
    int retdatalen;
    
    NSTimer *itTimer;
    HandleData *myHandData;
    NSTimer *ttimer;//定时器
    
    BOOL overTimeFlag;
    int itronLog1;
    int deviceTag;
}
@property (nonatomic,retain) id<CommunicationCallBack> communication;

+ (ItronCommunicationManagerBase *)getInstance;

//- (int)searchDevices:(id<DeviceSearchListener>) dsl  timeout:(long) timeout;

- (void)stopSearching;
- (NSString *)getLibVersion;

- (int)openDevice:(CBPeripheral *)peripheral  cb:(id<CommunicationCallBack>) cb timeout:(long)timeout;
//通过UUID连接蓝牙设备by hzw 14.12.24
- (int)openDevice:(NSString *)UUIDString  cbDelegate:(id<CommunicationCallBack>) cb timeout:(long)timeout;

- (void)closeDevice;
- (BOOL)isConnected;
//打印日志
-(void)setDebug:(int)value;
//设置设备类型
- (void)setDeviceKind:(int)tag;
- (int)getDeviceKind;
/**************************************************/
//工具函数,返回bin二进制数据，长度为binlen的十六进制字符串
-(NSString*) HexValue:(char*)bin Len:(int)binlen;
//工具函数，打印二进制缓冲区内容
-(void)HexPrint:(char*)data Len:(int)_len;
/**************************************************/
//发送数据
- (int)mySendData:(char *)cmdstr;

//获取ksn
- (void) Request_GetKsn;

//扩展获取ksn
-(void) Request_GetExtKsn;

//获取随机数
-(void) Request_GetRandom:(int)randLen;

-(void)startDetector:(int)desMode
              random:(char*)_random
           randomLen:(int)_randomLen
                data:(char*)_data
             datalen:(int)_datalen
                time:(int)_time;
//获取psam卡上保存的商户号码和终端号
-(void) Request_VT;

//退出
-(void) Request_Exit;

//获取电池电量
-(void) Request_BatLevel;

//获取打印机状态
-(void) Request_PrtState;

//重传指令
-(void) Request_ReTrans;

//获取磁卡卡号明文
-(void) Request_GetCardNo:(int)timeout;

//获取磁道信息明文
-(void) Request_GetTrackPlaintext:(int)timeout;
/*************************************************/

/*!
 @method
 @abstract 获取磁道密文数据
 @discussion 需要获取磁道密文时候调用
 @param desMode 模式 请填0
 @param _keyIndex PSAM卡秘钥索引
 @param _random 随机数 由PSAM卡决定随机数和随机数长度
 @param _randomLen 随机数长度
 @param _tiem 超时时间
 */
-(void) Request_GetDes:(int)desMode
              keyIndex:(int)_keyIndex
                random:(char*) _random
             randomLen:(int)_randomLen
                  time:(int)_time;

/*!
 @method
 @abstract 获取pin密文数据
 @discussion 传入金额，请求用户输入密码时候调用
 @param desMode 模式 请填0
 @param _keyIndex PSAM卡秘钥索引
 @param _cash 消费金额
 @param _cashLen 消费金额长度
 @param _random 随机数 由PSAM卡决定随机数和随机数长度
 @param _randomLen 随机数长度
 @param _panData 参与加密计算的数据
 @param _panDataLen 参加加密计算的数据长度 数据域内容定长为8字节的PAN，如果不需要PAN，则直接填8个0x00
 @param _tiem 超时时间
 */
-(void) Request_GetPin:(int)pinMode
              keyIndex:(int)_keyIndex
                  cash:(char*)_cash cashLen:(int)_cashLen
                random:(char*)_random randomLen:(int)_randdomLen
               panData:(char*)_panData pandDataLen:(int)_panDataLen
                  time:(int)_time;

/*!
 @method
 @abstract 获取计算mac的数据
 @discussion 对mac数据进行处理,尾部加0到8的整数，然后每8个字节异或
 @param macMode 模式 请填0 表示如果数据为非8字节对齐，则后补00为8字节对齐，然后点付宝根据自己的版本来处理数据
 @param _keyIndex PSAM卡秘钥索引
 @param _random 随机数 由PSAM卡决定随机数和随机数长度
 @param _randomLen 随机数长度
 @param _data 请求计算mac的数据
 @param _dataLen 数据长度
 */
-(void) Request_GetMac:(int)macMode
              keyIndex:(int)_keyIndex
                random:(char*)_random randomLen:(int)_randomLen
                  data:(char*)_data dataLen:(int)_dataLen;

//请求psam卡mac计算
-(void) Request_CheckMac:(int)macMode
                keyIndex:(int)_keyIndex
                  random:(char*)_random randomLen:(int)_randomLen
                    data:(char*)_data dataLen:(int)_dataLen;
//请求psam卡mac计算
-(void) Request_CheckMac2:(int)macMode
                 keyIndex:(int)_keyIndex
                   random:(char*)_random randomLen:(int)_randomLen
                     data:(char*)_data dataLen:(int)_dataLen
                      mac:(char*)_mac maclen:(int)_maclen;
//请求pasm卡mac校验
-(void) Request_CheckMacEx:(int)macMode keyIndex:(int)_keyIndex random:(char *)_random randomLen:(int)_randomLen data:(char *)_data dataLen:(int)_dataLen mac:(char*)_mac maclen:(int)_maclen;

//
/*!
 @method
 @abstract 扩展请求连续操作2  0293
 @discussion 传入金额，请求用户先刷卡然后输入密码
 @param desMode 模式 0=磁卡密文  1=磁卡密文+密码  2=手工输入卡号+磁卡密文+密码
 3=二次输入+磁卡密文+密码
 @param _PINKeyIndex PIN秘钥索引
 @param _DESKeyIndex DES秘钥索引
 @param _MACKeyIndex MAC秘钥索引
 @param _CtrlMode bit0 －1/0 上送的数据有/无mac
 Bit1 － 1/0上送的数据是有/无终端id
 Bit2 － 1/0上送的数据是有/无psam卡号
 Bit3 － 1/0上送的数据是有/无卡号密文数据
 Bit4 － 1/0 密钥索引启用/不启用
 Bit5 － 1/0磁道信息明文/密文
 Bit6 －  保留
 Bit7 － 1/0 手输卡号密文/明文
 @param _ParameterRandom 随机数 由PSAM卡决定随机数和随机数长度
 @param _ParameterRandomLen 随机数长度
 @param _cash 消费金额
 @param _cashLen 消费金额长度
 @param _appendData 参与加密计算的数据
 @param _appendDataLen 参加加密计算的数据长度 数据域内容定长为8字节的PAN，如果不需要PAN，则直接填8个0x00
 @param _tiem 超时时间
 */
-(void) Request_ExtCtrlConOper:(int)mode
                   PINKeyIndex:(int)_PINKeyIndex
                    DESKeyInex:(int)_DESKeyIndex
                   MACKeyIndex:(int)_MACKeyIndex
                      CtrlMode:(char)_CtrlMode
               ParameterRandom:(char*)_ParameterRandom ParameterRandomLen:(int)_ParameterRandomLen
                          cash:(char*)_cash cashLen:(int)_cashLen
                    appendData:(char*)_appendData appendDataLen:(int)_appendDataLen
                          time:(int)_time;

/*!
 @method
 @abstract 请求连续操作 0208
 @discussion 传入金额，请求用户先刷卡然后输入密码
 @param desMode 模式 0=磁卡密文  1=磁卡密文+密码  2=手工输入卡号+磁卡密文+密码
 3=二次输入+磁卡密文+密码
 @param _ParameterRandom 随机数 由PSAM卡决定随机数和随机数长度
 @param _ParameterRandomLen 随机数长度
 @param _cash 消费金额
 @param _cashLen 消费金额长度
 @param _appendData 参与加密计算的数据
 @param _appendDataLen 参加加密计算的数据长度 数据域内容定长为8字节的PAN，如果不需要PAN，则直接填8个0x00
 @param _tiem 超时时间
 */
-(void) Request_ConOper:(int)mode
        ParameterRandom:(char*)_ParameterRandom ParameterRandomLen:(int)_ParameterRandomLen
                   cash:(char*)_cash cashLen:(int)_cashLen
             appendData:(char*)_appendData appendDataLen:(int)_appendDataLen
                   time:(int)_time;


/*!
 @method
 @abstract 扩展请求连续操作 0288
 @discussion 传入金额，请求用户先刷卡然后输入密码
 @param desMode 模式 0=磁卡密文  1=磁卡密文+密码  2=手工输入卡号+磁卡密文+密码
 3=二次输入+磁卡密文+密码
 @param _ParameterRandom 随机数 由PSAM卡决定随机数和随机数长度
 @param _ParameterRandomLen 随机数长度
 @param _cash 消费金额
 @param _cashLen 消费金额长度
 @param _appendData 参与加密计算的数据
 @param _appendDataLen 参加加密计算的数据长度 数据域内容定长为8字节的PAN，如果不需要PAN，则直接填8个0x00
 @param _tiem 超时时间
 */
-(void) Request_ExtConOper:(int)mode
           ParameterRandom:(char*)_ParameterRandom ParameterRandomLen:(int)_ParameterRandomLen
                      cash:(char*)_cash cashLen:(int)_cashLen
                appendData:(char*)_appendData appendDataLen:(int)_appendDataLen
                      time:(int)_time;

/*!
 @method
 @abstract 更新工作密钥 0210
 @discussion 更新工作秘钥
 @param Mainkey 主秘钥索引
 @param _PinKey 更新Pin秘钥
 @param _PinKeyLen 更新的Pin秘钥长度
 @param _MacKey 更新的Mac秘钥
 @param _MacKeyLen 更新的Mac秘钥长度
 @param _DesKey 更新的Des秘钥
 @param _DesKeyLen 更新的Des秘钥长度
 */
-(void) Request_ReNewKey:(int)Mainkey PinKey:(char*)_PinKey PinKeyLen:(int)_PinKeyLen
                  MacKey:(char*)_MacKey MacKeyLen:(int)_MacKeyLen
                  DesKey:(char*)_DesKey DesKeyLen:(int)_DesKeyLen;

/*!
 @method
 @abstract 更新终端号码和商户号 0211
 @discussion 更新工作秘钥
 @param vendor 商户号数据
 @param _vendorLen 商户号长度
 @param _terid 终端号数据
 @param _teridLen 终端号长度
 */
-(void) Request_ReNewVT:(char*)vendor vendorLen:(int)_vendorLen
                  terid:(char*)_terid teridLen:(int)_teridLen;

//热敏打印数据
//data-打印内容 cnt-打印数量
/*
 格式:
 类型,内容
 返回值:0-组包成功 -1-组包失败
 */
//-(int) rmPrint:(char[40][200]) _data dataLen:(int) len printCnt:(int)cnt;
-(int) rmPrint2:(NSMutableArray*) lineList pCnt:(int)_cnt;
-(int) rmPrint3:(NSMutableArray*) lineList pCnt:(int)_cnt pakLen:(int)_paklen;
//返回 -1-报文错误 0-报文格式正确 其他，错误的结果
-(int)ParseResult:(unsigned char*)buf bufLen:(int)_bufLen res:(vcom_Result*)_res;
//打印数据
-(void) Request_PrtData:(int)currentPackage
           totalPackage:(int)_totalPackage
                  count:(int)_count
                   data:(char*)_data dataLen:(int)_dataLen;


// 请求psam卡DES加密 (04H)
-(void) Request_DataEnc:(int)keyIndex
                TimeOut:(int)_itmeOut
                   Mode:(int)_mode
        ParameterRandom:(char*)_ParameterRandom
     ParameterRandomLen:(int)_ParameterRandomLen
                   data:(char*)_data
                dataLen:(int)_dataLen;
//PSAM卡货IC卡透传指令
/*
 * PSAM或IC卡透传指令
 * @param mode 卡类型 0 PSAM卡 1 IC卡
 * @param Ordersindex 命令个数
 * @param orders 命令集合 (A命令长度+ A命令内容 + B命令长度 + B命令内容 +C.....)
 * @param ordersLength 命令长度
 * @param timer 超时时间
 * @return
 */
- (void)Request_ThroughOrders:(int)mode
                  OrdersIndex:(int)ordersIndex
                   OrdersData:(char *)orderData
                  OrdersLegth:(int)dataLength
                      TimeOut:(int)time;

//公钥修复
-(void)publickeyRepair;
/**
 00：点付宝
 01：掌付宝
 02：音频2型机
 03：i30+
 04：hsm20机型
 05：i21(新爱刷)
 */

- (void)getTerminalType;
////
/* 参数下载
 标志：bit0=0/1表示公钥/aid。其它位保留（默认填写0）
 包号：从0开始，依次递增。包号为0：则会清空终端内原有的密钥。非0则追加数据
 数据域：为8583协议的62域内容（不包含长度）
 
 */
- (void)UpdateTerminalParameters:(int)_index
                         pageNum:(int)_pageNum
                            data:(char*)_data
                         dataLen:(int) _dataLength
                            time:(int)_time;
//Ic卡交易脚本回写
/*参数:
 _resCode:8583应答码
 data:85838协议的55域。
 */
- (void)secondIssuance:(char *)_resCode
                  data:(char *)_data
            dataLength:(int)_dataLengt
                  time:(int)_time;

/*
 启动IC卡与磁条卡交易命令
 Ctrlmode 控制标志（爱刷的控制标志，与点付宝的控制标志不同）
 bit0＝0/1 表示随机有爱刷产生/由双方产生。
 由双方产生时，爱刷只产生4字节。如果手机侧不足4字节，则爱刷会前补FF到4字节
 Bit1＝0/1 表示终端需要不上送/上送mac。
 如果要求上送mac且随机数有双方产生，则mac的密钥的离散随机数是由
 双方产生的随机数共同组成。格式为：终端的4字节+手机侧的4字节。
 如果要求上送mac且随机数由终端产生，则mac密钥的离散随机数是由爱刷产生的4字节扩展为8字节。扩展方式为bcd码转为hex格式：比如，爱刷产生的4字节随机数为0x12345678，则扩展为8字节后则为：0x01 0x02 0x03 0x04 0x05 0x06 0x07 0x08。
 Bit2＝0/1 表示终端上送的卡号不屏蔽/屏蔽
 Bit3＝0/1  不上送/上送各磁道的原始长度
 Bit4=0/1磁道数据加密/不加密
 Bit5=0/1上送/不上送PAN码
 Bit6=0/1 55域不加密/加密
 Bit7 =0/1 不上送/上送各磁道密文的长度
 字节2：
 Bit0 = 0/1 表示这个数据域参与mac计算/只有数据域内的磁道数据和随机数参与
 字节3-字节4保留，填写为全0
 Bit1 = 0/1 使用全部ic卡/银联标准55域
 
 Ctrlmode 控制标志（蓝牙点付宝）
 模式：0：=保留 1：=刷卡+密码，2=手输入卡号+刷卡+密码，3=二次输入卡号+刷卡+密码
 控制标志：（字节1）
 Bit0＝0 保留
 Bit1＝0/1 表示终端需要不上送/上送mac。
 Bit2＝0  保留
 Bit3＝0  保留
 Bit4=0/1 磁道数据加密/不加密
 Bit5=0/1上送/不上送PAN码
 Bit6=0/1  55域不加密/加密
 Bit7 =0  保留
 字节2:
 Bit0 = 0/1 表示数据域+ 55域/只有数据域参与
 Bit1 = 0/1 全部ic卡域/标准55域
 Bit2 =0/1 密钥索引不启用/启用
 Bit3=0/1 刷卡的卡号密文/明文 不上送/上送
 Bit4=0/1 不上送/上送psam卡卡号
 Bit5=0/1 不上送/上送终端ID
 Bit6=0/1  手输入卡号加密/明文
 Bit7 =0/1  支持/不支持IC卡降级
 字节3：
 bit0 = 0/1 刷卡的卡号加密/不加密
 bit1 = 0/1卡号加密时不压缩/压缩（当字节3的bit0=1时且字节2的bit3=1，或者当字节2的bit6=1时，该标志有作用）
 bit2 =0/1  不上送/上送卡有效期
 
 Random 随机数
 Appenddata 附加数据域
 Time 超时时间
 Transactioninfo IC卡交易参数
 c7
 */

-(void) stat_EmvSwiper:(int)mode
           PINKeyIndex:(int)_PINKeyIndex
            DESKeyInex:(int)_DESKeyIndex
           MACKeyIndex:(int)_MACKeyIndex
              CtrlMode:(char*)_CtrlMode
       ParameterRandom:(char*)_ParameterRandom
    ParameterRandomLen:(int)_ParameterRandomLen
                  cash:(char*)_cash
               cashLen:(int)_cashLen
            appendData:(char*)_appendData
         appendDataLen:(int)_appendDataLen
                  time:(int)_time
       Transactioninfo:(Transactioninfo *) transactioninfo;

/*
 请求用户输入
 输入参数:
 Ctrlmode: 控制模式
 bit0－bit4表示模式：
 0：表示银行卡卡号输入，
 1：表示数字类输入
 2：表示支持字母数字输入
 Bit5 =0/1 无二次输入/有二次输入
 Bit6=0/1 密钥索引是否启用
 Bit7 =0/1 数据是否加密
 
 _tout: 超时时间(秒）
 minvalue:允许输入的最小长度
 maxvalue:允许输入的最大长度
 kindex: 加密时使用的密钥索引
 _random: 参与加密的随机数
 _title: 用户输入时显示的提示信息
 */
-(void)Get_Userinput:(int)ctrlmode
             timeout:(unsigned char)_tout
                 min:(unsigned char)minvalue
                 max:(unsigned char)maxvalue
            keyindex:(unsigned char)kindex
              random:(char*)_random randomLen:(int)_randdomLen
               title:(char*)_title titleLen:(int)_titleLen;
//显示信息
//info信息内容
//timer-显示时间（秒）
-(void) display:(NSString*) strinfo  timer:(int)_time;

//返回结果报文解析函数
//返回 -1-报文错误 0-报文格式正确 其他，错误的结果
-(int)ParseResult:(unsigned char*)buf bufLen:(int)_bufLen res:(vcom_Result*)_res;

//解析加密后的Pin密文数据
//参数
//输入
//buf:返回数据缓冲
//_bufLen:返回数据缓冲长度
//输出
//_pin:加密的pin缓冲
//返回值:
//_pin缓冲长度
-(int) GetEnPinData:(char*) buf bufLen:(int)_bufLen pin:(char*)_pin;

/*
 解析返回结果的2，3磁道数据
 输入数据:
 buf,_bufLen:返回数据指针和长度
 输出数据:
 _cdbuf,_cdbufLen：2，3磁道加密数据和长度
 _pan:输出的pan数据
 */

-(void)getEn23CiDao:(char*) buf bufLen:(int)_bufLen
              cdbuf:(char*)_cdbuf cdbufLen:(int*)_cdbufLen
                pan:(char*)_pan
               rand:(char*)_rand randLen:(int*)_randLen;


/*
 解析获取扩展卡号取的返回数据
 psamno8bytes:8字节psam卡号码
 hardno10bytes:10字节的硬件序列号
 */

-(void)GetExtKsnRetData:(char*) psamno8bytes
                 hardNo:(char*)hardno10bytes;

-(char *)GetKsnRetData;

-(char *)SetNullToRetData;


- (char *)HexToBin1:(char *)hex;

- (char*)BinToHex:(char *)bin off:(int )off lenght:(int) len;
-(NSString*)GetSDKVerson;

@end














