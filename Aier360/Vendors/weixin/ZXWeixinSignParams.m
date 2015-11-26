//
//  ZXWeixinSignParams.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/11/25.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXWeixinSignParams.h"
#import "NSString+ZXMD5.h"

@implementation ZXWeixinSignParams
- (instancetype)initWithPrepayid:(NSString *)prepayid noncestr:(NSString *)noncestr
{
    self = [super init];
    if (self) {
        self.prepayid = prepayid;
        self.noncestr = noncestr;
    }
    return self;
}

- (NSString *)appid
{
    if (!_appid) {
        _appid = Weixin_Appid;
    }
    return _appid;
}

- (NSString *)timestamp
{
    if (!_timestamp) {
        time_t now;
        time(&now);
        _timestamp = [NSString stringWithFormat:@"%ld", now];
    }
    return _timestamp;
}

- (NSString *)package
{
    if (!_package) {
        _package = @"Sign=WXPay";
    }
    return _package;
}

- (NSString *)partnerid
{
    if (!_partnerid) {
        _partnerid = Weixin_MCH_ID;
    }
    return _partnerid;
}

- (NSString *)sign
{
    NSDictionary *dic = [self keyValues];
    return [self createMd5Sign:[dic mutableCopy]];
}

- (NSString*)createMd5Sign:(NSMutableDictionary *)dict
{
    NSMutableString *contentString = [NSMutableString string];
    NSArray *keys = [dict allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (![[dict objectForKey:categoryId] isEqualToString:@""]
            && ![categoryId isEqualToString:@"sign"]
            && ![categoryId isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
        }
        
    }
    //添加key字段
    [contentString appendFormat:@"key=%@", Weixin_PARTNER_ID];
    //得到MD5 sign签名
    NSString *md5Sign = [[contentString md5] uppercaseString];
    
    return md5Sign;
}
@end
