//
//  AC_POSManger.m
//  HuiYingTianXia
//
//  Created by tsmc on 15/5/16.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import "AC_POSManger.h"
#import "AbstractItems.h"
#import "NSString+MD5HexDigest.h"
#import "MJExtension.h"
#import "NSObject+Common.h"
#import "SwingCardViewController.h"

@implementation AC_POSManger
+ (instancetype)shareInstance
{
    static AC_POSManger *_instance = nil;
    static dispatch_once_t once_t;
    
    if(!_instance) {
        dispatch_once(&once_t, ^{
            _instance = [[AC_POSManger alloc] init];
        });
    }
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if(self) {
        
    }
    return self;
}

//余额
- (void)openAndBanding
{
    
    //初始化对象
    m_vcom = [vcom getInstance];
    if ([self hasHeadset]) {
        NSLog(@"耳机插入");
        
    }else{
        NSError *error = [NSError errorWithDomain:@"未检测到设备" code:0 userInfo:@{@"NSLocalizedDescription":@"未检测到设备"}];
//        [self showStatusBarError:error];
        return;
    }
    [m_vcom open];
    m_vcom.eventListener = self;
    //设置数据发送模式和接收模式
    [m_vcom setCommmunicatinMode:aiShua];
    [m_vcom setVloumn:75];
    [m_vcom setDebug:1];
    [m_vcom StopRec];
    [m_vcom Request_GetKsn];
    [m_vcom StartRec];
}

//检查micphone状态
- (BOOL)hasHeadset
{
#if TARGET_IPHONE_SIMULATOR
#warning *** Simulator mode: audio session code works only on a device
    return NO;
#else
    CFStringRef route;
    UInt32 propertySize = sizeof(CFStringRef);
    AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &propertySize, &route);
    if((route == NULL) || (CFStringGetLength(route) == 0))
    {
        // Silent Mode
        //NSLog(@"AudioRoute: SILENT, do nothing!");
    }
    else
    {
        NSString* routeStr = (__bridge NSString *)(route);
        //NSLog(@"AudioRoute: %@", routeStr);
        
        NSRange headphoneRange = [routeStr rangeOfString : @"Headphone"];
        NSRange headsetRange = [routeStr rangeOfString : @"Headset"];
        if (headphoneRange.location != NSNotFound)
        {
            return YES;
        } else if(headsetRange.location != NSNotFound)
        {
            return YES;
        }
    }
    return NO;
#endif
}


-(void)onDeviceReady
{
    NSLog(@"Device Ready");
}


//收到数据
//len=-1，data=0表示接收的是错误的数据包
-(void) dataArrive:(vcom_Result*)vs Status:(int)_status
{
    [m_vcom StopRec];
    
    if(_status==-3){
        //设备没有响应
        NSError *error = [NSError errorWithDomain:@"通信超时" code:0 userInfo:@{@"NSLocalizedDescription":@"通信超时"}];
//        [self showStatusBarError:error];
        return;
    }else if(_status == -2){
        //耳机没有插入
        return;
    }else if(_status==-1){
        //接收数据的格式错误
        return;
    }else {
        //操作指令正确
        if(vs->res==0){
            if(vs->rescode[0] == 0x09 && vs->rescode[1] == 0x07)
            {
                NSLog(@"命令已经停止");
            }
            //设备有成功返回指令
            NSMutableString *strTemp = [[NSMutableString alloc] initWithCapacity:0];
            
            if (vs->ksnlen>0) {
                [strTemp appendString:[NSString stringWithFormat:@" KSN :%@",[m_vcom HexValue:vs->ksn  Len:vs->ksnlen]]];
                
            }
            
            [self performSelectorOnMainThread:@selector(updateText:) withObject:strTemp waitUntilDone:YES];
            NSLog(@"Aishua cmd exec ok\n");
        }else {
            
            switch (vs->res) {
                case 0x01:
                    [self performSelectorOnMainThread:@selector(updateText:) withObject:@"命令执行超时" waitUntilDone:YES];
                    break;
                case 0x0a:
                    [self performSelectorOnMainThread:@selector(updateText:) withObject:@"用户退出" waitUntilDone:YES];
                    break;
                case 0x80:
                    [self performSelectorOnMainThread:@selector(updateText:) withObject:@"数据接收正确" waitUntilDone:YES];
                    break;
                case 0x81:
                    [self performSelectorOnMainThread:@selector(updateText:) withObject:@"磁道数据解析失败" waitUntilDone:YES];
                    break;
                    
                case 0x82:
                    [self performSelectorOnMainThread:@selector(updateText:) withObject:@"当前非刷卡状态" waitUntilDone:YES];
                    break;
                case 0x83:
                    [self performSelectorOnMainThread:@selector(updateText:) withObject:@"磁道数据解析成功，返回当前的卡号" waitUntilDone:YES];
                    break;
                case 0xf1:
                    [self performSelectorOnMainThread:@selector(updateText:) withObject:@"不识别的主命令码" waitUntilDone:YES];
                    break;
                case 0xf2:
                    [self performSelectorOnMainThread:@selector(updateText:) withObject:@"不识别的子命令码" waitUntilDone:YES];
                    break;
                case 0xf4:
                    [self performSelectorOnMainThread:@selector(updateText:) withObject:@"随机数长度错误" waitUntilDone:YES];
                    break;
                case 0xf7:
                    [self performSelectorOnMainThread:@selector(updateText:) withObject:@"Ksn错误" waitUntilDone:YES];
                    break;
                case 0xf8:
                    [self performSelectorOnMainThread:@selector(updateText:) withObject:@"更新ksn失败" waitUntilDone:YES];
                    break;
                case 0xf9:
                    [self performSelectorOnMainThread:@selector(updateText:) withObject:@"组包数据失败" waitUntilDone:YES];
                    break;
                case 0xfa:
                    [self performSelectorOnMainThread:@selector(updateText:) withObject:@"加密失败" waitUntilDone:YES];
                    break;
                case 0xfb:
                    [self performSelectorOnMainThread:@selector(updateText:) withObject:@"密钥更新失败" waitUntilDone:YES];
                    break;
                case 0xfc:
                    [self performSelectorOnMainThread:@selector(updateText:) withObject:@"数据内容有误" waitUntilDone:YES];
                    break;
                case 0xfe:
                    [self performSelectorOnMainThread:@selector(updateText:) withObject:@"MAC_TK校验失败" waitUntilDone:YES];
                    break;
                case 0xff:
                    [self performSelectorOnMainThread:@selector(updateText:) withObject:@"校验和错误" waitUntilDone:YES];
                    break;
                default:
                    break;
            }
            
            /* 失败和中间状态代码
             00	成功执行命令
             01	命令执行超时
             0A	用户退出
             80	数据接收正确
             81	磁道数据解析失败
             82	当前非刷卡状态(正常不会出现，可以不用理)
             83	磁道数据解析成功，返回当前的卡号
             F1	不识别的主命令码
             F2	不识别的子命令码
             F4	随机数长度错误
             F7	Ksn错误
             F8	更新ksn失败
             F9	组包数据失败
             FA	加密失败
             FB	密钥更新失败
             FC	数据域内容有误
             FE	MAC_TK校验失败
             FF	校验和错误
             */
        }
    }
}

//通知监听器控制器CSwiperController的操作超时
//(超出预定的操作时间，30秒)
-(void)onTimeout
{
    if ([self.deleagte respondsToSelector:@selector(errorWithInfo:)]) {
        [self.deleagte errorWithInfo:@{@"msg":@"通讯超时"}];
    }
}

- (void)onError:(int)errorCode ErrorMessage:(NSString *)errorMessage;
{
    NSString *errorStr = [NSString stringWithFormat:@"%zd, %@",errorCode ,errorMessage];
    NSError *error = [NSError errorWithDomain:@"error" code:0 userInfo:@{@"NSLocalizedDescription":errorStr}];
//    [self showStatusBarError:error];
}

/*!
 @method
 @abstract 通知ksn
 @discussion 正常启动刷卡器后，将返回ksn
 @param ksn 取得的ksn
 */
- (void)onGetKsnCompleted:(NSString *)ksn
{
//    ksn = @"1234567890abcdee";
    NSLog(@"ksn:%@",ksn);
    if (ksn.length > 0) {
        AbstractItems *item = [[AbstractItems alloc] init];
        item.n1 = [[NSUserDefaults standardUserDefaults] objectForKey:Account];
        item.n3 = @"190958";
//        item.n59 = @"CHDS-1.0.0";
        item.n62 = [ksn uppercaseString];
        
        NSString *macStr = [NSString stringWithFormat:@"%@%@%@%@%@%@",item.n0,item.n1,item.n3,item.n59,item.n62,MainKey];
        item.n64 = [[macStr md5HexDigest] uppercaseString];
        [[NetAPIManger sharedManger] request_BindingPosWithParams:[item keyValues] andBlock:^(id data, NSError *error) {
            AbstractItems *item = (AbstractItems *)data;
            if(!error && ([item.n39 isEqualToString:@"00"] || [item.n39 isEqualToString:@"94"]) && item.n41.length > 0 && item.n62.length > 0 && item.n62.length > 0){
                [[NSUserDefaults standardUserDefaults] setValue:item.n41 forKey:TerminalNo];
                if(item.n62.length > 0) {
                    [[NSUserDefaults standardUserDefaults] setValue:item.n62 forKey:WokeKey];
                    NSLog(@"WokeKey:%@",WokeKey);
                    NSLog(@"VoucherNo:%@",item.n11);
                    NSInteger voucherNo = [item.n11 integerValue];
                    
                    self.vouchNo = [NSString stringWithFormat:@"%06zd",++voucherNo];
                    NSLog(@"voucherNo:%@",self.vouchNo);
                }
                [[NSUserDefaults standardUserDefaults] synchronize];
                
               //刷卡
                [m_vcom StopRec];
                [m_vcom setMode:VCOM_TYPE_F2F recvMode:VCOM_TYPE_F2F];
                [m_vcom startDetector:0 random:nil randomLen:0 data:"" datalen:0 time:20];
                [m_vcom StartRec];
                
                [m_vcom StopRec];
                
                
                NSString *cash = @"10010001";
                cash = [[NSUserDefaults standardUserDefaults] objectForKey:Amount];
                NSLog(@"cash:%@",cash);

                int cashLen = [cash length];
                char cData[100];
                cData[0] = 0;
                
                strcpy(cData,((char*)[cash UTF8String]));
//                NSLog(@"cData:%@",cData);
                
                Transactioninfo *tranInfo = [[Transactioninfo alloc] init];
                tranInfo.type = [[NSUserDefaults standardUserDefaults] objectForKey:Type];
                NSLog(@"type:%@",tranInfo.type);
                //    it6=0/1 55域数据是否加密1011
                NSString *ctrm = @"82820000";
                //    8E000000
                //    NSString *ctrm = @"25000000";
                //    NSString *ctrm = @"5b600000";
                char *temp2 = HexToBin((char*)[ctrm UTF8String]);
                char ctr[4];
                memcpy(ctr, temp2, [ctrm length]/2);

                
                [m_vcom stat_EmvSwiper:0 PINKeyIndex:1 DESKeyInex:1 MACKeyIndex:1 CtrlMode:ctr ParameterRandom:nil ParameterRandomLen:0 cash:cData cashLen:cashLen appendData:nil appendDataLen:0 time:30 Transactioninfo:tranInfo];
                [m_vcom StartRec];

                
                
            }else {
                NSError *error = [NSError errorWithDomain:@"error" code:0 userInfo:@{@"NSLocalizedDescription":@"绑定终端失败"}];
//                [self showStatusBarError:error];
            }
        }];
    }else {
        NSError *error = [NSError errorWithDomain:@"error" code:0 userInfo:@{@"NSLocalizedDescription":@"读取终端号失败"}];
//        [self showStatusBarError:error];
    }
}

- (void)onGetKsnAndVersionCompleted:(NSArray *)ksnAndVerson
{
    
    NSLog(@"ksn is %@", [ksnAndVerson objectAtIndex:0]);
    
    NSLog(@"version is %@", [ksnAndVerson objectAtIndex:1]);
}


- (void)updateText:(NSString *)str
{
    NSError *error = [NSError errorWithDomain:@"error" code:0 userInfo:@{@"NSLocalizedDescription":str}];
//    [self showStatusBarError:error];
}

//mic插入
-(void) onMicInOut:(int) inout
{
    
}

- (void) getPanCallback : (unsigned char)status pan:(unsigned char*)pan panLen:(unsigned char)panLen
{
    
}
- (void)onWaitingForCardSwipe
{
    if([self.deleagte respondsToSelector:@selector(waitingForCardSwipe:)]) {
        [self.deleagte waitingForCardSwipe:SUCCESS];
    }
}

- (void)EmvOperationWaitiing{
    if([self.deleagte respondsToSelector:@selector(EmvOperationWaitiing)]) {
        [self.deleagte EmvOperationWaitiing];
    }
}


#pragma mark 刷卡回调
- (void)onDecodeCompleted:(NSString *)formatID
                   andKsn:(NSString *)ksn
             andencTracks:(NSString *)encTracks
          andTrack1Length:(int)track1Length
          andTrack2Length:(int)track2Length
          andTrack3Length:(int)track3Length
          andRandomNumber:(NSString *)randomNumber
            andCardNumber:(NSString *)maskedPAN
                   andPAN:(NSString *)pan
            andExpiryDate:(NSString *)expiryDate
        andCardHolderName:(NSString *)cardHolderName
                   andMac:(NSString *)mac
         andQTPlayReadBuf:(NSString *)readBuf
                 cardType:(int)type
               cardserial:(NSString *)serialNum
              emvDataInfo:(NSString *)data55
                  cvmData:(NSString *)cvm
{
    
    NSString* string =[[NSString alloc] initWithFormat:@"ksn:%@\n encTracks:%@ \n track1Length:%i \n track2Length:%i \n track3Length:%i \n randomNumber:%@ \n cardNum:%@ \n PAN:%@ \n expiryDate:%@ \n cardHolderName:%@ \n mac:%@ \n cardType:%d \n cardSerial:%@ \n emvDataInfo:%@ \n cmv:%@  \n readBuf:%@",ksn,encTracks,track1Length,track2Length,track3Length,randomNumber, maskedPAN,pan,expiryDate,cardHolderName,mac,type,serialNum,data55,cvm,readBuf];
   NSLog(@"string:%@",string);
    NSLog(@"data55:%@",data55);
    
    if([self.deleagte respondsToSelector:@selector(swingcardCallback:)]){
        NSString *track2 = nil;
        if(track1Length==0 && track3Length == 0){
            track2 = encTracks;
        }else if (encTracks.length >= 48) {
            track2 = [encTracks substringWithRange:NSMakeRange(track1Length*2, track2Length*2)];
        }
        [self.deleagte swingcardCallback:@{@"cardType":[NSNumber numberWithInt:type],
                                           @"randomNumber":randomNumber,
                                           @"expiryDate":expiryDate,
                                           @"cardNumber":maskedPAN,
                                           @"track2":track2,
                                           @"data55":[data55 uppercaseString],
                                           @"cardSerial":serialNum}];
        
    }
}

char bout11[4096];
int  boutlen11;
char* HexToBin11(char* hin)
{
    int i;
    char highbyte,lowbyte;
    int len= (int)strlen(hin);
    for (i=0;i<len/2;i++)
    {
        if (hin[i*2]>='0'&&hin[i*2]<='9')
            highbyte=hin[i*2]-'0';
        if (hin[i*2]>='A'&&hin[i*2]<='F')
            highbyte=hin[i*2]-'A'+10;
        if (hin[i*2]>='a'&&hin[i*2]<='f')
            highbyte=hin[i*2]-'a'+10;
        
        if (hin[i*2+1]>='0'&&hin[i*2+1]<='9')
            lowbyte=hin[i*2+1]-'0';
        if (hin[i*2+1]>='A'&&hin[i*2+1]<='F')
            lowbyte=hin[i*2+1]-'A'+10;
        if (hin[i*2+1]>='a'&&hin[i*2+1]<='f')
            lowbyte=hin[i*2+1]-'a'+10;
        
        bout11[i]=(highbyte<<4)|(lowbyte);
    }
    boutlen11=len/2;
    return bout11;
}

-(void) onDevicePlugged
{
    NSError *error = [NSError errorWithDomain:@"设备已识别" code:0 userInfo:@{@"NSLocalizedDescription":@"设备已识别"}];
//    [self showStatusBarError:error];
}

- (void)onDeviceUnPlugged
{
    NSError *error = [NSError errorWithDomain:@"设备断开连接" code:0 userInfo:@{@"NSLocalizedDescription":@"设备断开连接"}];
//    [self showStatusBarError:error];
}
@end
