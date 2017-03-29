//
//  Encode_3DES.m
//  CashierTreasure
//
//  Created by tsmc on 13-9-16.
//  Copyright (c) 2013年 Tsmc. All rights reserved.
//

#import "Encode_3DES.h"

@implementation Encode_3DES

+ (NSArray *)stringToArray:(NSString *)str {
    
    NSMutableArray *returnArray = [NSMutableArray array];
    for (NSInteger i = 0; i < [str length] - 1; i+=2) {
        NSString *tempStr = [str substringWithRange:NSMakeRange(i, 2)];
        if ([tempStr length] == 2) {
            NSString *subStr = [NSString string];
            int value = 0;
            for (NSInteger index = 0; index < 2; index++) {
                NSString *str = [tempStr substringWithRange:NSMakeRange(index, 1)];
                subStr = [subStr stringByAppendingString:str];
                if (index == 0) {
                    value  = [self stringToInt:str]*16;
                }else{
                    value = value + [self stringToInt:str];
                }
            }
            NSString *enStr = [NSString stringWithFormat:@"%d",value];
            [returnArray addObject:enStr];
            
        }else{
            return returnArray;
        }
    }
    return returnArray;
}

+ (int)stringToInt:(NSString *)str {
    int value = 0;
    
    if ([str isEqualToString:@"A"] || [str isEqualToString:@"a"]) {
        value = 10;
    }else if ([str isEqualToString:@"B"] || [str isEqualToString:@"b"]){
        value = 11;
    }else if ([str isEqualToString:@"C"] || [str isEqualToString:@"c"]){
        value = 12;
    }else if ([str isEqualToString:@"D"] || [str isEqualToString:@"d"]){
        value = 13;
    }else if ([str isEqualToString:@"E"] || [str isEqualToString:@"e"]){
        value = 14;
    }else if ([str isEqualToString:@"F"] || [str isEqualToString:@"f"]){
        value = 15;
    }else{
        value = [str intValue];
    }
    return value;
}


+ (NSString *)TripleDES:(NSString*)plainText keyText:(NSString *)keyText encryptOrDecrypt:(CCOperation)encryptOrDecrypt {
    
    
    NSArray *keyArray = [self stringToArray:keyText];
    NSArray *srcArray = [self stringToArray:plainText];
    
    Byte keyByte[[keyArray count]];
    for (int i = 0; i < [keyArray count]; i++) {
        keyByte[i] = [[keyArray objectAtIndex:i] integerValue];
    }
    
    Byte srcByte[[srcArray count]];
    for (int i = 0; i < [srcArray count]; i++) {
        srcByte[i] = [[srcArray objectAtIndex:i] integerValue];
    }
    
    
    size_t plainTextBufferSize;
    
    if (encryptOrDecrypt == kCCDecrypt) {//解密
        //        NSData *EncryptData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [srcArray count];
    }else {//加密
        //        NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [srcArray count];
    }
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset(bufferPtr, 0x0, bufferPtrSize);
    // memset((void *) iv, 0x0, (size_t) sizeof(iv));
    // NSString *initVec = @"init Vec";
    //const void *vinitVec = (const void *) [initVec UTF8String];
    //  Byte iv[] = {0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF};
    ccStatus = CCCrypt(encryptOrDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionECBMode,
                       keyByte,
                       kCCKeySize3DES,
                       nil,
                       srcByte,
                       plainTextBufferSize,
                       bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    //if (ccStatus == kCCSuccess) NSLog(@"SUCCESS");
    /*else if (ccStatus == kCC ParamError) return @"PARAM ERROR";
     else if (ccStatus == kCCBufferTooSmall) return @"BUFFER TOO SMALL";
     else if (ccStatus == kCCMemoryFailure) return @"MEMORY FAILURE";
     else if (ccStatus == kCCAlignmentError) return @"ALIGNMENT";
     else if (ccStatus == kCCDecodeError) return @"DECODE ERROR";
     else if (ccStatus == kCCUnimplemented) return @"UNIMPLEMENTED"; */
    
    NSString *result = [NSString string];
    
    if (encryptOrDecrypt == kCCDecrypt) {
        
        for (int i = 0; i < movedBytes; i++) {
            NSString *temp = [NSString stringWithFormat:@"%x",bufferPtr[i]];
            if ([temp length] < 2) {
                temp = [@"0" stringByAppendingString:temp];
                NSLog(@"%@",temp);
            }
            result = [result stringByAppendingString:temp];
        }
        
    }else {
        
        for (int i = 0; i < movedBytes; i++) {
            NSString *temp = [NSString stringWithFormat:@"%x",bufferPtr[i]];
            if ([temp length] < 2) {
                temp = [@"0" stringByAppendingString:temp];
                NSLog(@"%@",temp);
            }
            result = [result stringByAppendingString:temp];
        }
    }
    
    return result;
}

@end
