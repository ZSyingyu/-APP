//
//  Encode_3DES.h
//  CashierTreasure
//
//  Created by tsmc on 13-9-16.
//  Copyright (c) 2013年 Tsmc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CommonCrypto/CommonDigest.h"
#import "CommonCrypto/CommonCryptor.h"
#import <Security/Security.h>

@interface Encode_3DES : NSObject {

}
+ (NSString *)TripleDES:(NSString*)plainText keyText:(NSString *)keyText encryptOrDecrypt:(CCOperation)encryptOrDecrypt;

@end
