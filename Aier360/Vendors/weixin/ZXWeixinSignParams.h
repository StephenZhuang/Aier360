//
//  ZXWeixinSignParams.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/11/25.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
//微信开发平台应用id
#define Weixin_Appid @"wx6ec038c7794dba76"
//财付通商户号
#define Weixin_MCH_ID @"1281641601"
//商户号对应的密钥
#define Weixin_PARTNER_ID @"n2HXOwSbfKI6WfaXtwX84WFFrKa5drBT"

@interface ZXWeixinSignParams : NSObject

@property (nonatomic , copy) NSString *appid;
@property (nonatomic , copy) NSString *noncestr;
@property (nonatomic , copy) NSString *package;
@property (nonatomic , copy) NSString *partnerid;
@property (nonatomic , copy) NSString *timestamp;
@property (nonatomic , copy) NSString *prepayid;

- (instancetype)initWithPrepayid:(NSString *)prepayid noncestr:(NSString *)noncestr;
- (NSString *)sign;
@end
