//
//  UUID.h
//  BLEDKSDK
//
//  Created by D500 user on 13/2/19.
//  Copyright (c) 2013年 D500 user. All rights reserved.
//

#ifndef BLEDKSDK_DLUUID_h
#define BLEDKSDK_DLUUID_h

//GAP
#define UUIDSTR_GAP_SERVICE @"1800"

//Device Info service
#define UUIDSTR_DEVICE_INFO_SERVICE             @"180A"
#define UUIDSTR_MANUFACTURE_NAME_CHAR           @"2A29"
#define UUIDSTR_MODEL_NUMBER_CHAR               @"2A24"
#define UUIDSTR_SERIAL_NUMBER_CHAR              @"2A25"
#define UUIDSTR_HARDWARE_REVISION_CHAR          @"2A27"
#define UUIDSTR_FIRMWARE_REVISION_CHAR          @"2A26"
#define UUIDSTR_SOFTWARE_REVISION_CHAR          @"2A28"
#define UUIDSTR_SYSTEM_ID_CHAR                  @"2A23"
#define UUIDSTR_IEEE_11073_20601_CHAR           @"2A2A"

#define UUIDSTR_ISSC_PROPRIETARY_SERVICE        @"49535343-FE7D-4AE5-8FA9-9FAFD205E455"
#define UUIDSTR_CONNECTION_PARAMETER_CHAR       @"49535343-6DAA-4D02-ABF6-19569ACA69FE"
#define UUIDSTR_AIR_PATCH_CHAR                  @"49535343-ACA3-481C-91EC-D85E28A60318"
#define UUIDSTR_ISSC_TRANS_TX                   @"49535343-1E4D-4BD9-BA61-23C647249616"
#define UUIDSTR_ISSC_TRANS_RX                   @"49535343-8841-43F4-A8D4-ECBE34729BB3"
#define UUIDSTR_ISSC_MP                         @"49535343-ACA3-481C-91EC-D85E28A60318"

//device UUID
//小杨蓝牙模块
#define UUID_SERVICE1                           @"FFD0"
#define UUID_SERVICE2                           @"FFE0"
#define UUID_W1                                 @"FFE1"
#define UUID_R1                                 @"FFD1"
//小付,小梁
#define UUID_SERVICE3                           @"11112233-4455-6677-8899-aabbccddeeff"
#define UUID_W3                                 @"0000ffe1-0000-1000-8000-00805f9b34fb"
#define UUID_R3                                 @"0000ffe2-0000-1000-8000-00805f9b34fb"
//双模
#define UUID_SERVICE4                           @"FFF0"
#define UUID_W4                                 @"FFF2"
#define UUID_R4                                 @"FFF1"

//CBCentralManagerOptionRestoreIdentifierKey
#define ISSC_RestoreIdentifierKey               @"ISSC_RestoreIdentifierKey"
#endif
