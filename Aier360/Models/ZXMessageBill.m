//
//  ZXMessageBill.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/11/24.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXMessageBill.h"
#import "ZXApiClient.h"

@implementation ZXMessageBill
+ (NSURLSessionDataTask *)submitOrderWithUid:(long)uid
                                         sid:(NSInteger)sid
                                         num:(NSInteger)num
                                         cid:(long)cid
                                       block:(void (^)(ZXMessageBill *bill, NSError *error))block
{
    NSString *url = @"payjs/pay_createBill.shtml?";
    
    return [[ZXApiClient sharedClient] POST:url parameters:nil success:^(NSURLSessionDataTask *task, id JSON) {
        ZXMessageBill *bill = [ZXMessageBill objectWithKeyValues:[JSON objectForKey:@"bill"]];
        !block?:block(bill,nil);
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        !block?:block(nil,error);
    }];
}
@end
