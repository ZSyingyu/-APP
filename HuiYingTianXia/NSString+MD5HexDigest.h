//
//  NSString+MD5HexDigest.h
//  CashierTreasure
//
//  Created by tsmc on 13-9-2.
//  Copyright (c) 2013年 Tsmc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonCrypto/CommonDigest.h"

@interface NSString (MD5HexDigest)

- (NSString *) md5HexDigest;

@end
