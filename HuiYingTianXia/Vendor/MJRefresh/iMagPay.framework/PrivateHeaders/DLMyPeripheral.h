//
//  DLMyPeripheral.h
//
//  Created by zheng wei on 14/12/3.
//  Copyright (c) 2014年 szzcs. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BluetoothHandler.h"
//修改名称用到的接口
#import "CommonUtils.h"
#import "DLUUID.h"

@protocol DLmyPeripheralDelegate <NSObject>
- (void)findCharacteristicForWrite;
@end
@interface DLMyPeripheral : NSObject<CBPeripheralDelegate>
{
    id<SwipeDelegate>  __unsafe_unretained mDelegate;
}
@property (nonatomic,assign)id<SwipeDelegate>mDelegate;
@property (nonatomic,strong) CBPeripheral *peripheral;
@property (nonatomic,copy) NSString *deviceName;
@property (nonatomic,assign) BOOL conectedStae;
@property (nonatomic,assign)id<DLmyPeripheralDelegate>myDelegate;

//DIS
@property(retain) CBCharacteristic *manufactureNameChar;
@property(retain) CBCharacteristic *modelNumberChar;
@property(retain) CBCharacteristic *serialNumberChar;
@property(retain) CBCharacteristic *hardwareRevisionChar;
@property(retain) CBCharacteristic *firmwareRevisionChar;
@property(retain) CBCharacteristic *softwareRevisionChar;
@property(retain) CBCharacteristic *systemIDChar;
@property(retain) CBCharacteristic *certDataListChar;
@property(retain) CBCharacteristic *specificChar1;
@property(retain) CBCharacteristic *specificChar2;

//Proprietary
@property(retain) CBCharacteristic *airPatchChar;
@property(retain) CBCharacteristic *transparentDataWriteChar;
@property(retain) CBCharacteristic *transparentDataReadChar;
@property(retain) CBCharacteristic *connectionParameterChar;

- (void)sendCommand:(NSString *)str;
@end
