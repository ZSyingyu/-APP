//
//  CommunicationCallBack.h
//

#ifndef CommunicationCallBack_h
#define CommunicationCallBack_h

#import <Foundation/Foundation.h>

#define Print_log    0x01
#define SUCESS       0x00
#define FAILD        0x01

#define MAIN_KEY_ID  0x01
#define PIN_KEY_ID   0x02
#define TRACK_KEY_ID 0x03
#define MACK_KEY_ID  0x04

#define GETCARD_CMD  0x12
#define GETTRACK_CMD 0x20
#define MAINKEY_CMD  0x34
#define PINBLOCK_CMD 0x36
#define GETMAC_CMD   0x37
#define WORKKEY_CMD  0x38
#define GETSNVERSION 0x40
#define GETTERNUMBER 0x41
#define WRITETERNUMBER   0x42
//默认超时时间15秒
#define WAIT_TIMEOUT 15000


typedef struct
{
    unsigned char iTransNo;					//交易类型,指的什么交易
    int iCardtype;				//刷卡卡类型  磁条卡 IC卡
    int iCardmodem;				//刷卡模式
    char TrackPAN[21];				//域2	主帐号
    unsigned char CardValid[5];				//域14	卡有效期
    char szServiceCode[4];			//服务代码
    unsigned char CardSeq[2];				//域23	卡片序列号
    unsigned char szEntryMode[3];			//域22	服务点输入方式
    int      nTrack2Len;                    //2磁道数据大小
    unsigned char szTrack2[40];				//域35	磁道2数据
    int      nEncryTrack2Len;                   //2磁道加密数据大小
    unsigned char szEncryTrack2[40];			//域35	磁道2加密数据	第一个字节为长度
    int      nTrack3Len;                    //3磁道数据大小
    unsigned char szTrack3[108];			//域36	磁道3数据
    int      nEncryTrack3Len;                    //3加密磁道数据大小
    unsigned char szEncryTrack3[108];			//域36	磁道3加密数据
    unsigned char sPIN[13];					//域52	个人标识数据(pind ata)
    int      IccdataLen;
    unsigned char Field55Iccdata[300];			//的55域信息512->300

    
}FieldTrackData;

typedef enum {
    KNOWED_DEVICE_ING =0,       //Card reader is recognised.
    UNKNOW_DEVICE_ING=1,          //Device is inserted, but can't be recognised for card reader.
    NO_DEVICE_INSERT=-4,          //No device access ( device pull out )
    KNOWING_DEVICE_ING,         //Device access is recognising
    
    DEVICE_NEED_UPDATE_ING      //Card reader is recognised, but need update.
}AndioDeviceStatus;


@protocol CommunicationCallBack <NSObject>

-(void)onSendOK;
-(void)onReceive:(NSData*)data;
-(void)onTimeout;
-(void)onError:(NSInteger)code message:(NSString*)msg;
-(void)onProgress:(NSData*)data;

@end

#endif
