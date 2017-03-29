//
//  APPCommon.h
//  HuiYingTianXia
//
//  Created by tsmc on 15/5/4.
//  Copyright (c) 2015年 tsmc. All rights reserved.
//

#ifndef HuiYingTianXia_APPCommon_h
#define HuiYingTianXia_APPCommon_h


#pragma mark NSUserDefaults
#define Account         @"Account"
#define Password        @"Password"
#define MerchantNo      @"MerchantNo"   //商户号
#define MerchantName      @"MerchantName" //商户名称
#define TerminalNo      @"TerminalNo"   //终端号
#define BatchNum         @"BatchNum"      //批次号
#define VoucherNo       @"VoucherNo"    //流水号
#define WokeKey         @"WokeKey"      //工作密钥
#define TranceInfo      @"TranceInfo"   //终端列表(批次号,流水号,终端号可能多个)


//#define MerchantNumber  @"MerchantNumber"//商户号

#define CardID          @"CardID"  //身份证号
#define BankName        @"BankName"//银行名称
#define CardName        @"CardName"//开户姓名
#define CardNumber      @"CardNumber"//银行卡号

//图片存储
#define HandCard        @"HandCard" //手持身份证照
#define FrontCard       @"FrontCard"//身份证正面照
#define BackCard        @"BackCard" //身份证反面照
#define FrontBank       @"FrontBank"//银行卡正面
#define BackBank        @"BackBank"//银行卡反面
#define ImageType       @"ImageType"//图片类型


#define ShopPhoto        @"ShopPhoto" //商户门头照


//输入的金额
#define Amount          @"Amount"

//交易类型
#define Type            @"Type" 

//区分刷卡头的标识
#define Tag             @"Tag"

//存入行的颜色
#define Color           @"Color"

//审核信息
#define CheckInfomation @"CheckInfomation"

//W8错误码信息
#define W8Str           @"W8Str"

//提额信息
#define RaiseCardID          @"RaiseCardID"  //身份证号
#define RaiseBankName        @"RaiseBankName"//银行名称
#define RaiseCardName        @"RaiseCardName"//开户姓名
#define RaiseCardNumber      @"RaiseCardNumber"//银行卡号

//图片存储
#define RaiseHandCard        @"RaiseHandCard" //手持身份证照
#define RaiseCardFrontCard       @"RaiseCardFrontCard"//身份证正面照
#define RaiseCardBackCard        @"RaiseCardBackCard" //身份证反面照
#define RaiseBankFrontCard       @"RaiseBankFrontCard"//银行卡正面照
#define RaiseBankBackCard        @"RaiseBankBackCard" //银行卡反面照
#define RaiseImageType       @"RaiseImageType"//图片类型

//公告
#define Notice                  @"Notice"   //公告对象
#define NoticeId                @"NoticeId" //新公告id
#define Content                 @"Content" //公告内容
#define Title                   @"Title"   //公告标题
#define Number                  @"Number"  //公告id
#define Time                    @"Time"    //公告时间
#define Isread                  @"Isread"  //公告是否被读取(0表示未读取,1表示已读取,默认值为0)
#define NewImage                @"NewImage"//是否显示新消息图片

//是APP登陆还是POS登陆
#define MerchantSource          @"MerchantSource" //登陆途径

//认证状态
#define FreezeStatus            @"FreezeStatus" //返回的认证状态

//商户状态(启用/禁用)
#define UseStatus               @"UseStatus"    //商户是否禁用

//判断照片是否上传成功
#define HandUpload             @"HandUpload"
#define CardFrontUpload        @"CardFrontUpload"
#define CardBackUpload         @"CardFrontUpload"
#define BankFrontUpload        @"BankFrontUpload"
#define BankBackUpload         @"BankBackUpload"

//判断是哪个界面点击的查看认证说明
#define Certify                @"Certify"

//判断商户是否是审核拒绝商户
#define JuJue                @"JuJue"

//今日交易总额
#define Money                @"Money"

//银行的code
#define Code                    @"Code"

//经营类目ID
#define ManageTypeID                    @"ManageTypeID"


//提额中银行的code
#define BankCode                @"BankCode"

//后台返回的费率
#define Rate            @"Rate"

//记住密码
#define RememberPsd     @"RememberPsd"

#endif
