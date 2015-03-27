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
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:accountString forKey:@"account"];
    [parameters setObject:pwd forKey:@"pwd"];
    return [[ZXApiClient sharedClient] POST:@"userjs/useraccountnew_appLoginVN.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {

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

+ (NSURLSessionDataTask *)getSchoolWithUid:(NSString *)uid
                                     block:(void (^)(ZXAccount *account, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:uid forKey:@"uid"];
    return [[ZXApiClient sharedClient] POST:@"nxadminjs/nalogin_GetSchoolAppState.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
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

+ (NSURLSessionDataTask *)getLoginStatusWithUid:(NSInteger)uid
                                          block:(void (^)(ZXAccount *account, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:uid] forKey:@"uid"];
    return [[ZXApiClient sharedClient] POST:@"nxadminjs/nalogin_logonInitAppStatus.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
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
