//
//  ZXMessageBill.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/11/24.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXMessageBill.h"
#import "ZXApiClient.h"
#import "NSNull+ZXNullValue.h"

@implementation ZXMessageBill
+ (NSURLSessionDataTask *)submitOrderWithUid:(long)uid
                                         sid:(NSInteger)sid
                                         num:(NSInteger)num
                                         cid:(long)cid
                                       block:(void (^)(ZXMessageBill *bill, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:@(uid) forKey:@"uid"];
    [parameters setObject:@(sid) forKey:@"sid"];
    [parameters setObject:@(num) forKey:@"num"];
    [parameters setObject:@(cid) forKey:@"cid"];
    
    NSString *url = @"payjs/pay_createBill.shtml?";
    
    return [[ZXApiClient sharedClient] POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        ZXMessageBill *bill = [ZXMessageBill objectWithKeyValues:[JSON objectForKey:@"bill"]];
        !block?:block(bill,nil);
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        !block?:block(nil,error);
    }];
}

+ (NSURLSessionDataTask *)getPrepayWithUid:(long)uid
                                       sid:(NSInteger)sid
                                       num:(NSInteger)num
                                       cid:(long)cid
                                        ip:(NSString *)ip
                                     block:(void (^)(NSString *prepay_id,NSString *nonce_str, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:@(uid) forKey:@"uid"];
    [parameters setObject:@(sid) forKey:@"sid"];
    [parameters setObject:@(num) forKey:@"num"];
    [parameters setObject:@(cid) forKey:@"cid"];
    [parameters setObject:ip forKey:@"ip"];
    
    NSString *url = @"payjs/pay_GoTenpay.shtml?";
    
    return [[ZXApiClient sharedClient] POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        NSString *prepay_id = [[JSON objectForKey:@"prepay_id"] stringValue];
        NSString *nonce_str = [[JSON objectForKey:@"nonce_str"] stringValue];
        !block?:block(prepay_id,nonce_str,nil);
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        !block?:block(nil,nil,error);
    }];
}
@end
