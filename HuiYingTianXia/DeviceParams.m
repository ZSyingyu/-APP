

#import "DeviceParams.h"

@implementation DeviceParams

static DeviceParams *shareRoot = nil;

+ (DeviceParams *) sharedController
{
    @synchronized(self)
    {
        if(shareRoot == nil)
        {
            shareRoot = [[self alloc] init];  //add autorelease: 考虑多线程的情况
        }
        
        return shareRoot;
    }
    
    return shareRoot;
}

+ (id) allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (shareRoot == nil)
        {
            shareRoot = [super allocWithZone:zone];
            return  shareRoot;
        }
    }
    return nil;
}

- (NSString *)setCustomFieldWithTransTypeCode:(NSString*)transTypeCode batchNo:(NSString*)batchNo algorithm:(KeyAlgorithm)alg
{
    return [NSString stringWithFormat:@"%@%@%@", transTypeCode, batchNo, GetKeyAlgorithmString(alg)];
}

NSString *GetKeyAlgorithmString(KeyAlgorithm alg)
{
    switch (alg) {
        case KeyAlgorithmSingle:
            return @"001";
            
        default:
            return @"003";
    }
}

@end
