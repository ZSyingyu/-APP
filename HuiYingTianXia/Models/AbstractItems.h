//
//  AbstractItems.h
//  HuiYingTianXia
//
//  Created by tsmc on 15-4-9.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface AbstractItems : NSObject
@property(nonatomic ,strong)NSString *n0;                   //消息类型
@property(nonatomic ,strong)NSString *n1;                   //手机号
@property(nonatomic ,strong)NSString *n2;                   //卡号
@property(nonatomic ,strong)NSString *n3;                   //交易处理码
@property(nonatomic ,strong)NSString *n4;                   //交易金额
@property(nonatomic ,strong)NSString *n5;                   //姓名
@property(nonatomic ,strong)NSString *n6;                   //身份证
@property(nonatomic ,strong)NSString *n7;                   //银行卡号
@property(nonatomic ,strong)NSString *n8;                   //密码
@property(nonatomic ,strong)NSString *n9;                   //费率
@property(nonatomic ,strong)NSString *n10;                  //图片流
@property(nonatomic ,strong)NSString *n11;                  //受卡方系统跟踪号 POS终端APP交易流水
@property(nonatomic ,strong)NSString *n12;                  //受卡方所在地时间
@property(nonatomic ,strong)NSString *n13;                  //受卡方所在地日期
@property(nonatomic ,strong)NSString *n14;                  //卡有效期
@property(nonatomic ,strong)NSString *n22;                  //受卡方所在地日期
@property(nonatomic ,strong)NSString *n23;                  //卡片序列号
@property(nonatomic ,strong)NSString *n25;                  //检索参考号
@property(nonatomic ,strong)NSString *n26;                  //服务点PIN 获取码(输入密码有值 不输入没值)
@property(nonatomic ,strong)NSString *n35;                  //磁道数据
@property(nonatomic ,strong)NSString *n37;                  //检索参考号
@property(nonatomic ,strong)NSString *n39;                  //应答码
@property(nonatomic ,strong)NSString *n41;                  //受卡机终端标识码
@property(nonatomic ,strong)NSString *n42;                  //商户编号/受卡机终端标识码(消费)
@property(nonatomic ,strong)NSString *n43;                  //开户行名称
@property(nonatomic ,strong)NSString *n44;                  //机构编码
@property(nonatomic ,strong)NSString *n45;                  //银行名称
@property(nonatomic ,strong)NSString *n46;                  
@property(nonatomic ,strong)NSString *n47;
@property(nonatomic ,strong)NSString *n48;
@property(nonatomic ,strong)NSString *n49;                  //交易货币代码
@property (nonatomic, strong) NSString *n50;                //支付宝
@property(nonatomic ,strong)NSString *n52;                  //PIN 卡密
@property(nonatomic ,strong)NSString *n53;                  //安全控制信息
@property(nonatomic ,strong)NSString *n54;                  //余额
@property(nonatomic ,strong)NSString *n55;                  //IC 卡数据域
@property(nonatomic ,strong)NSArray *n57;                   //订单列表
@property(nonatomic ,strong)NSString *n58;                  //基站信息
@property(nonatomic ,strong)NSString *n59;                  //版本号
@property(nonatomic ,strong)NSString *n60;                  //自定义域
@property(strong,nonatomic)NSString *n601;
@property(strong,nonatomic)NSString *n602;
@property(strong,nonatomic)NSString *n603;
@property(nonatomic ,strong)NSString *n61;                  //原始信息域
@property(nonatomic ,strong)NSString *n62;                  //SN/工作密钥
@property(nonatomic ,strong)NSString *n63;                  //自定义域
@property(nonatomic ,strong)NSString *n64;                  //MAC
@property(nonatomic ,strong)NSString *n65;                  //提额卡片信息

@end
