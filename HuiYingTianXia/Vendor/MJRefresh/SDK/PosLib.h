
#ifndef ___POSLIB_H___
#define ___POSLIB_H___
#import "LibXNComm.h"
#include "MsrResult.h"

typedef void (*PosLibResponseFunc)(EU_POS_SESSION sessionType);
typedef void (*PosLibSearchOneDeviceFunc)(NSString *uuid,NSString *name);
@interface MPosInterface:NSObject

/**
 *获取蓝牙操作的对象（单例）
 *
 **/
+(id)getInstance;

//POSLIB初始化
-(void) PosLib_Init;

///**
// *搜索蓝牙
// *iScanTimeOut 搜索的一个时间
// *searchXNDevicesCB 搜索返回的一个代码块
// **/
//-(void) PosLib_Scan:(int) iScanTimeOut searchXNDevicesBlock:(SearchXNDevices)searchXNDevicesCB;

/**
 *搜索蓝牙
 *iScanTimeOut 搜索的一个时间
 *searchXNDevicesCB 搜索返回的一个代码块
 **/
-(void) PosLib_Scan_EX:(int) iScanTimeOut searchOneXNDevicesBlock:(SearchOneXNDevices)searchXNDevicesCB searchTimeOutBlock:(SearchTimeOut)searchTimeOutblock;


/**
 *连接设备
 *UUIDString 设备的UUID
 *
 **/
-(void) connectXnPos:(NSString *)UUIDString connectSuccessBlock:(XNConnectDeviceSuccess)successConnectCB connectFailedBlock:(XNErrorCodeDec)failedConnectCB;

/**
 *连接设备状态
 *0 连接成功
 *<0 连接失败
 **/
-(int) connectState;

/**
 *断开与设备的连接
 *返回
 *
 **/
-(void) disconnectPos;


/**
 *KEK下载请求
 * @param XNP_MKEYINFO    KEK信息
 * @param XNSuccessBlock  成功代码块
 * @param XNErrorCodeDec  失败代码块
 */
-(void) loadKek:(XNP_KEKINFO *)kekinfo  loadSuccessBlock:(XNSuccessBlock)successCB loadFailedBlock:(XNErrorCodeDec)failedCB;

/**
 * 主密钥下载
 * @param XNP_MKEYINFO     主密钥信息
 * @param XNSuccessBlock  成功代码块
 * @param XNErrorCodeDec  失败代码块
 */
-(void) LoadMainKey:(XNP_MKEYINFO *)mkeyinfo loadSuccessBlock:(XNSuccessBlock)successCB loadFailedBlock:(XNErrorCodeDec)failedCB;

/**
 * 工作密钥下载
 * @param XNP_WKEYINFO    工作密钥信息
 * @param XNSuccessBlock  成功代码块
 * @param XNErrorCodeDec  失败代码块
 */
-(void) LoadWorkKey:(XNP_WKEYINFO *)mkeyinfo loadSuccessBlock:(XNSuccessBlock)successCB loadFailedBlock:(XNErrorCodeDec)failedCB;

/**
 * 密钥选择
 * @param XN_KEY_INDEX    选择的密钥索引
 * @param XNSuccessBlock  成功代码块
 * @param XNErrorCodeDec  失败代码块
 */
-(void) choiceOneKey:(XN_KEY_INDEX)keyindex successBlock:(XNSuccessBlock)successCB failedBlock:(XNErrorCodeDec)failedCB;

/**
 * 密码输入
 * @param XNP_PININPUTINFO pin输入的请求信息
 * @param XNInputPinRespSuccess   成功代码块
 * @param XNErrorCodeDec          失败代码块
 */
-(void) inputPin:(XNP_PININPUTINFO *)pininfo inputpinsuccessBlock:(XNInputPinRespSuccess)successCB failedBlock:(XNErrorCodeDec)failedCB;

/**
 * MAC计算
 * @param XNP_MACVALUEINFO 计算MAC输入的请求信息
 * @param XNSuccessBlock   成功代码块
 * @param XNErrorCodeDec   失败代码块
 */
-(void) calculateMac:(XNP_MACVALUEINFO *)macinfo maccalculatesuccessBlock:(XNMacCalculateRespSuccess)successCB failedBlock:(XNErrorCodeDec)failedCB;

/**
 * 密码加密计算
 * @param XNP_PINENCRYINFO        包括密码数据以及卡号 ----针对不在终端上输密码的情况
 * @param XNInputPinRespSuccess   成功代码块
 * @param XNErrorCodeDec          失败代码块
 */
-(void) pinEncry:(XNP_PINENCRYINFO *)pininfo pincalculatesuccessBlock:(XNInputPinRespSuccess)successCB failedBlock:(XNErrorCodeDec)failedCB;

/**
 * 打开读卡器操作
 * @param XNP_OPENCARDINFO         开启读卡器操作请求信息
 * @param XNIcReaderSuccess        表示底下为IC卡操作的代码块
 * @param XNMagSuccess             表示底下为磁条卡操作的代码块
 * @param XNErrorCodeDec           失败代码块
 */
-(void) openCardReader:(XNP_OPENCARDINFO *)cardinfo icsucessBlock:(XNIcReaderSuccess)icsuccessCB magsuccessBlock:(XNMagSuccess)magsuccessBlock failedBlock:(XNErrorCodeDec)failedCB;

/**
 * 读取磁条卡信息
 * @param XNP_OPENCARDINFO         开启读卡器操作请求信息
 * @param XNReadMagSuccess         读取磁条卡成功的代码块
 * @param XNErrorCodeDec           失败代码块
 */
-(void) readMagCardInfo:(XNP_READMAGCARDINFO *)readmode readsucessBlock:(XNReadMagSuccess)readsuccessCB failedBlock:(XNErrorCodeDec)failedCB;


/**
 * 复位终端
 *
 */
- (void)resetPos:(XNSuccessBlock)successCB;
/**
 * 设置IC卡公钥
 * @param XNP_SETCAPKINFO         公钥信息
 * @param XNSuccessBlock          成功代码块
 * @param XNErrorCodeDec          失败代码块
 */
-(void) setIcCapk:(XNP_SETCAPKINFO *)capkstring successBlock:(XNSuccessBlock)successCB failedBlock:(XNErrorCodeDec)failedCB;

/**
 * 设置IC卡参数
 * @param XNP_SETAIDINFO         参数信息
 * @param XNSuccessBlock         成功代码块
 * @param XNErrorCodeDec         失败代码块
 */
-(void) setIcAidParam:(XNP_SETAIDINFO *)aidstring successBlock:(XNSuccessBlock)successCB failedBlock:(XNErrorCodeDec)failedCB;

/**
 * 设置IC卡参数
 * @param attrstring             交易属性
 * @param XNSuccessBlock         成功代码块
 * @param XNErrorCodeDec         失败代码块
 */
-(void) setIcTransactionAttributes:(NSString *)attrstring successBlock:(XNSuccessBlock)successCB failedBlock:(XNErrorCodeDec)failedCB;

/**
 * 取IC卡55域交易数据
 * @param tagstring              获取需要tag的集合
 * @param XNGetIC55RespSuccess   获取到55域数据代码块
 * @param XNErrorCodeDec         失败代码块
 */
-(void) getIcTransactionData:(NSString *)tagstring successBlock:(XNGetIC55RespSuccess)successCB failedBlock:(XNErrorCodeDec)failedCB;

/**
 * 取IC卡交易数据   包扣卡号 有效期 服务代码 2磁道数据
 * @param XNReadICSuccess   获取到数据代码块
 * @param XNErrorCodeDec         失败代码块
 */
-(void) getIcTransBasicData:(XNReadICSuccess)successCB failedBlock:(XNErrorCodeDec)failedCB;

/**
 * 执行IC卡标准流程
 * @param emvinfo                执行IC卡标准流程的参数信息
 * @param XNSuccessBlock         成功代码块
 * @param XNErrorCodeDec         失败代码块
 */
-(void) startEmv:(XNP_RUNEMVSTATEINFO *)emvinfo successBlock:(XNSuccessBlock)successCB failedBlock:(XNErrorCodeDec)failedCB;

/**
 * 执行IC卡二次授权
 * @param genarateinfo           二次授权的数据
 * @param XNSuccessBlock         成功代码块
 * @param XNErrorCodeDec         失败代码块
 */
-(void) continueEmv:(XNP_GENARATEACINFO *)genarateinfo successBlock:(XNSuccessBlock)successCB failedBlock:(XNErrorCodeDec)failedCB;

/**
 * 结束PBOC流程
 * @param XNSuccessBlock         成功代码块
 * @param XNErrorCodeDec         失败代码块
 */
-(void) endEmv:(XNSuccessBlock)successCB failedBlock:(XNErrorCodeDec)failedCB;

/**
 * 读取设备消息
 * @param XNSuccessBlock         成功代码块
 * @param XNErrorCodeDec         失败代码块
 */
-(void) getDeviceInfo:(XNGetDeviceInfoRespSuccess)getdevicesuccessCB failedBlock:(XNErrorCodeDec)failedCB;

/**
 * 读取随机数
 * @param getrandsuccessCB         成功代码块
 * @param XNErrorCodeDec         失败代码块
 */
-(void) getRandData:(XNGetRandStringRespSuccess)getrandsuccessCB failedBlock:(XNErrorCodeDec)failedCB;

/**
 * 蜂鸣器
 * @param XNBeepBlock         成功代码块
 * @param XNErrorCodeDec         失败代码块
 */
-(void) beep:(XNP_BEEPINFO *)beepData  successBlock:(XNBeepBlock)successCB failedBlock:(XNErrorCodeDec)failedCB;

/**
 * 设置时间
 * @param dateString             设置的时间
 * @param XNErrorCodeDec         失败代码块
 */
-(void) setDateTime:(NSString *)dateString  successBlock:(XNSuccessBlock)successCB failedBlock:(XNErrorCodeDec)failedCB;

/**
 * 获取时间
 * @param XNGetDateTimeStringRespSuccess   返回成功的代码块
 * @param XNErrorCodeDec                    失败代码块
 */
-(void) getDateTime:(XNGetDateTimeStringRespSuccess)getDatasuccessCB failedBlock:(XNErrorCodeDec)failedCB;

/**
 * 获取时间
 * @param closeAct         关机、休眠
 * @param XNSuccessBlock   返回成功的代码块
 * @param XNErrorCodeDec   失败代码块
 */
-(void) closeDevice:(XN_CLOSE_ACTION)closeAct successBlock:(XNSuccessBlock)successCB failedBlock:(XNErrorCodeDec)failedCB;

/**
 * 获取时间
 * @param XNP_UPDATEDEVICE            升级信息   升级文件的路径
 * @param XNUpdatingRespSuccess       升级过程代码块
 * @param XNUpdatedRespSuccess        升级成功代码块
 * @param XNErrorCodeDec              失败代码块
 */
-(void) updateDevice:(XNP_UPDATEDEVICE *)updatestring updatingsuccessBlock:(XNUpdatingRespSuccess)updatingsuccessCB updatedsuccessBlock:(XNUpdatedRespSuccess)updatedsuccessCB failedBlock:(XNErrorCodeDec)failedCB;

@end



#endif