

#import "CommTools.h"

@implementation CommTools
@synthesize businessType;

static CommTools *shareRootViewController = nil;

+ (CommTools *) Init
{
    @synchronized(self)
    {
        if(shareRootViewController == nil)
        {
            shareRootViewController = [[self alloc] init];
        }
    }
    return shareRootViewController;
}

+ (id) allocWithZone:(NSZone *)zone{
    @synchronized(self){
        if (shareRootViewController == nil) {
            shareRootViewController = [super allocWithZone:zone];
            return  shareRootViewController;
        }
    }
    return nil;
}


-(NSString *)DateTime_Now:(NSString *)format
{
    NSDate *today = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSString *string = [formatter stringFromDate:today];
    return string;
}

- (NSString *)getUniqueStrByUUID
{
    CFUUIDRef uuidObj = CFUUIDCreate(nil);//create a new UUID
    
    //get the string representation of the UUID
    NSString *uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
    
    CFRelease(uuidObj);
    return [uuidString lowercaseString];
}

//利用正则表达式验证金额
-(BOOL)isValidateMoney:(NSString *)string {
    NSString *Regex = @"^(([1-9]{1}\\d*)|([0]{1})|([.]{1}))(\\.(\\d){0,2})?$";
    NSPredicate *money = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [money evaluateWithObject:string];
}

//利用正则表达式验证数字
-(BOOL)isValidateNumber:(NSString *)string {
    NSString *Regex = @"^(([1-9]{1}\\d*)|([0]{1}))(\\.(\\d){0,2})?$";
    NSPredicate *number = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [number evaluateWithObject:string];
}

int gethexChar(unichar c)
{
    int v = 0;
    if(c >= '0' && c <='9'){
        v = (c-48);   // 0 的Ascll - 48
    }else if(c >= 'A' && c <='F'){
        v = (c-55);   // A 的Ascll - 65
    }else if(c >= 'a' && c <='f'){
        v = (c-87);   // a 的Ascll - 97
    }else{
        v = -1;
    }
    return v;
}

// 将字符串如："2b3edf" 转换为 0x2b3edf
+(NSData *)getHexBytes:(NSString *)hexString
{
    @try {
        int j=0;
        u_char bytes[1024];  ///3ds key的Byte 数组， length/2
        
        if (hexString.length % 2) {
            hexString = [NSString stringWithFormat:@"0%@", hexString];
        }
        
        unsigned long len = [hexString length]/2;
        
        for(int i=0; i<[hexString length]; i++)
        {
            int int_ch;  /// 两位16进制数转化后的10进制数
            
            unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
            int int_ch1;
            if(hex_char1 >= '0' && hex_char1 <='9')
                int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
            else if(hex_char1 >= 'A' && hex_char1 <='F')
                int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
            else
                int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
            i++;
            
            unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
            int int_ch2;
            if(hex_char2 >= '0' && hex_char2 <='9')
                int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
            else if(hex_char2 >= 'A' && hex_char2 <='F')
                int_ch2 = hex_char2-55; //// A 的Ascll - 65
            else
                int_ch2 = hex_char2-87; //// a 的Ascll - 97
            
            int_ch = int_ch1+int_ch2;
            
            bytes[j] = int_ch;  ///将转化后的数放入Byte数组里
            j++;
        }
        
        NSData *newData = [NSData dataWithBytes:bytes length:len];
        return newData;
    }
    @catch (NSException *exception) {
        return nil;
    }
    @catch (...) {
        return nil;
    }
}

// 将字符串如："9559982397527462" 转换为 39353539393832333937353237343632
+(NSData *)getAscllBytes:(NSString*)string
{
    if( string == nil || string == NULL || [string length] % 2 != 0 || [string length] > 1000 ){
        // 数据有问题或者或者数据过长
        NSLog(@"Convert Hex String error: %@", string);
        return nil;
    }
    
    int len = (int)[string length];
    u_char bytes[len];
    
    for(int i=0; i<[string length]; i++)
    {
        unichar hex_char1 = [string characterAtIndex:i];
        bytes[i] = (hex_char1);
    }
    
    NSData *newData = [[NSData alloc] initWithBytes:bytes length:len];
    return newData;
}

// 将字符串如："9559982397527462" 转换为 39353539393832333937353237343632
+(NSString *)getAscllString:(NSString*)string
{
    if( string == nil || string == NULL || [string length] > 1000 ){
        // 数据有问题或者或者数据过长
        NSLog(@"Convert Hex String error: %@", string);
        return nil;
    }
    
    int len = (int)[string length];
    u_char bytes[len];
    
    for(int i=0; i<[string length]; i++)
    {
        unichar hex_char1 = [string characterAtIndex:i];
        bytes[i] = (hex_char1);
    }
    
    NSData *newData = [[NSData alloc] initWithBytes:bytes length:len];
    return [self bytess:newData];
}

// 将字符串如："39353539393832333937353237343632" 转换为 "9559982397527462"
+(NSString *)getStringFromAscll:(NSString*)string
{
    if( string == nil || string == NULL || [string length] % 2 != 0 || [string length] > 1000 ){
        // 数据有问题或者或者数据过长
        NSLog(@"Convert Hex String error: %@", string);
        return nil;
    }
    
    unsigned long len = [string length]/2;
    unichar bytes[len];
    
    for(int i=0; i<[string length]; i++)
    {
        unichar hex_char1 = [string characterAtIndex:i];
        hex_char1 = gethexChar(hex_char1);
        i++;
        unichar hex_char2 = [string characterAtIndex:i];
        hex_char2 = gethexChar(hex_char2);
        
        bytes[i/2] = hex_char1 * 0x10 + hex_char2;
    }
    
    NSString *encrypted = [NSString stringWithCharacters:(const unichar*)bytes length:len];
    
    return encrypted;
}

//把string以byte字符串形式
+(NSString *)bytess:(NSData *)_data
{
    NSString *hashSN = [_data description];
    hashSN = [hashSN stringByReplacingOccurrencesOfString:@" " withString:@""];
    hashSN = [hashSN stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hashSN = [hashSN stringByReplacingOccurrencesOfString:@">" withString:@""];
    //NSLog(@"sn0000=%@",hashSN);
    return hashSN;
}

//银行卡号处理
+(NSString *)getCardNo:(NSString *)strCardNo
{
    if (strCardNo.length > 10) {
        NSRange range = NSMakeRange(6, [strCardNo length]-10);
        NSMutableString *str1 = [NSMutableString string];
        for(int i = 0;i<[strCardNo length]-10;i++)
        {
            [str1 appendString:@"*"];
        }
        return [strCardNo stringByReplacingCharactersInRange:range withString:str1];
    } else {
        return strCardNo;
    }
}

@end
