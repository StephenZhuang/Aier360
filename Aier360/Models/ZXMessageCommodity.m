//
//  ZXMessageCommodity.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/11/24.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXMessageCommodity.h"
#import "ZXApiClient.h"

@implementation ZXMessageCommodity
+ (NSURLSessionDataTask *)getMessageCommodityWithBlock:(void (^)(ZXMessageCommodity *messageCommodity, NSError *error))block
{
    NSString *url = @"payjs/pay_searchMesCommodity.shtml?";
    
    return [[ZXApiClient sharedClient] POST:url parameters:nil success:^(NSURLSessionDataTask *task, id JSON) {
        ZXMessageCommodity *messageCommodity = [ZXMessageCommodity objectWithKeyValues:[JSON objectForKey:@"commodity"]];
        !block?:block(messageCommodity,nil);
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        !block?:block(nil,error);
    }];
}
@end
