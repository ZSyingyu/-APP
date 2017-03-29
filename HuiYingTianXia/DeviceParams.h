

#import <Foundation/Foundation.h>

/**
 * 密钥算法
 *
 */
typedef enum {
    /**单倍长*/
    KeyAlgorithmSingle,
    /**双倍长*/
    KeyAlgorithmDouble
} KeyAlgorithm;

@interface DeviceParams : NSObject

+ (DeviceParams *) sharedController;

/**商户号*/
@property (nonatomic, copy) NSString *merchantNo;
/**	商户名称 */
@property (nonatomic, copy) NSString *merchantName;
/**终端号*/
@property (nonatomic, copy) NSString *terminalNo;
/**手机号*/
@property (nonatomic, copy) NSString *telephone;
/**流水号*/
@property (nonatomic, copy) NSString *transectionNo;
/**批次号*/
@property (nonatomic, copy) NSString *batchNo;
/**操作员*/
@property (nonatomic, copy) NSString *operatorNo;
/**硬件序列号*/
@property (nonatomic, copy) NSString *SN;
/**交易类型*/
@property (nonatomic) int transType;

//public static final String SIGN_IN="0";                 //签到
//public static final String CONSUME="2";   //消费
//public static final String REVOKE="3";    //撤销
//public static final String QUERY="4";   //查余
//public static final String REVERSAL="5";    //冲正


@property (nonatomic, copy) NSString *oldBatchNo;
@property (nonatomic, copy) NSString *oldTransectionNo;
@property (nonatomic, copy) NSString *oldMoney;
@property (nonatomic, copy) NSString *oldTID;

@property (nonatomic, assign) BOOL isMainKeyLoaded;
@property (nonatomic, assign) BOOL isIcParamLoaded;
@property (nonatomic, assign) BOOL isSignIn;
@property (nonatomic, copy) NSString *signInTime;

- (NSString *)setCustomFieldWithTransTypeCode:(NSString*)transTypeCode batchNo:(NSString*)batchNo algorithm:(KeyAlgorithm)alg;
NSString *GetKeyAlgorithmString(KeyAlgorithm alg);

@end
