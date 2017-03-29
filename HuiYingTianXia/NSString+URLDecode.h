//
//  NSString+URLDecode.h
//  CashierTreasure
//
//  Created by tsmc on 13-9-3.
//  Copyright (c) 2013年 Tsmc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface  NSString (URLDecode)
- (NSString *)stringByDecodingURLFormat;
- (NSString *)encodeToPercentEscapeString: (NSString *) input;
@end
