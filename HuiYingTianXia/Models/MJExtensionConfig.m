//
//  MJExtensionConfig.m
//  HuiYingTianXia
//
//  Created by tsmc on 15/5/5.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import "MJExtensionConfig.h"
#import "MJExtension.h"
#import "AbstractItems.h"
#import "OrderItem.h"

@implementation MJExtensionConfig
/**
 *  这个方法会在MJExtensionConfig加载进内存时调用一次
 */
+ (void)load
{
    [AbstractItems setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"n0" : @"0",                   //消息类型
                 @"n1" : @"1",                   //手机号
                 @"n2" : @"2",                   //主账号
                 @"n3" : @"3",                   //交易处理码
                 @"n4" : @"4",                   //交易金额
                 @"n5" : @"5",                   //姓名
                 @"n6" : @"6",                   //身份证
                 @"n7" : @"7",                   //银行卡号
                 @"n8" : @"8",                   //密码
                 @"n9" : @"9",                   //费率
                 @"n10" : @"10",                  //图片流
                 @"n11" : @"11",                  //受卡方系统跟踪号 POS终端APP交易流水
                 @"n12" : @"12",                  //受卡方所在地时间
                 @"n13" : @"13",                  //受卡方所在地日期
                 @"n14" : @"14",                  //卡有效期
                 @"n22" : @"22",                  //受卡方所在地日期
                 @"n23" : @"23",                  //卡片序列号
                 @"n25" : @"25",                  //检索参考号
                 @"n26" : @"26",                  //检索参考号
                 @"n35" : @"35",                  //磁道数据
                 @"n37" : @"37",                  //检索参考号
                 @"n39" : @"39",                  //应答码
                 @"n41" : @"41",                  //受卡机终端标识码
                 @"n42" : @"42",                  //商户编号/受卡机终端标识码(消费)
                 @"n43" : @"43",                  //开户行名称
                 @"n44" : @"44",                  //机构编码
                 @"n45" : @"45",                  //机构编码
                 @"n46" : @"46",
                 @"n47" : @"47",
                 @"n48" : @"48",
                 @"n49" : @"49",                  //交易货币代码
                 @"n50" : @"50",                  //支付宝
                 @"n52" : @"52",                  //交易货币代码
                 @"n53" : @"53",                  //安全控制信息
                 @"n54" : @"54",                  //余额
                 @"n55" : @"55",                  //安全控制信息
                 @"n57" : @"57",                  //order json
                 @"n58" : @"58",                  //基站信息
                 @"n59" : @"59",                  //版本号
                 @"n60" : @"60",                  //自定义域
                 @"n61" : @"61",                  //原始信息域
                 @"n62" : @"62",                  //SN/工作密钥
                 @"n63" : @"63",                  //自定义域
                 @"n64" : @"64",                  //MAC
                 @"n65" : @"65"                   //提额卡片信息
                 };
    }];
    
    [AbstractItems setupObjectClassInArray:^NSDictionary *{
        return @{
                    @"n57" : @"OrderItem"
                };
    }];
    
//    [AbstractItems setupObjectClassInArray:^NSDictionary *{
//        return @{
//                    @"n42" : @"MerchantInfo"
//                };
//    }];
    
}
@end
