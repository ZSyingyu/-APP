

#import <Foundation/Foundation.h>

@interface CommTools : NSObject


@property NSInteger businessType;

+(CommTools *) Init;

-(NSString *)DateTime_Now:(NSString *)format;

- (NSString *)getUniqueStrByUUID;

-(BOOL)isValidateMoney:(NSString *)string;
-(BOOL)isValidateNumber:(NSString *)string;

+(NSData *)getHexBytes:(NSString *)hexString;
+(NSData *)getAscllBytes:(NSString*)string;
+(NSString *)getAscllString:(NSString*)string;
+(NSString *)getStringFromAscll:(NSString*)string;
+(NSString *)bytess:(NSData *)_data;

//银行卡号处理
+(NSString *)getCardNo:(NSString *)strCardNo;

@end
