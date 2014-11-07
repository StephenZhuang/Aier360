//
//  ZXAccount+ZXclient.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/5.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXAccount+ZXclient.h"

@implementation ZXAccount (ZXclient)

+ (NSURLSessionDataTask *)loginWithAccount:(NSString *)accountString
                                       pwd:(NSString *)pwd
                                     block:(void (^)(ZXAccount *account, NSError *error))block
{
    NSMutableDictionary *prameters = [[NSMutableDictionary alloc] init];
    [prameters setObject:accountString forKey:@"account"];
    [prameters setObject:pwd forKey:@"pwd"];
    return [[ZXApiClient sharedClient] POST:@"nxadminjs/nalogin_appLoginVN.shtml?" parameters:prameters success:^(NSURLSessionDataTask *task, id JSON) {

        ZXAccount *account = [ZXAccount objectWithKeyValues:JSON];
        
        if (block) {
            block(account, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}
@end
