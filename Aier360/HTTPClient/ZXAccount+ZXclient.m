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
                                   message:(NSString *)message
                                     block:(void (^)(ZXUser *, NSError *))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:accountString forKey:@"account"];
    [parameters setObject:message forKey:@"message"];
    return [[ZXApiClient sharedClient] POST:@"userjs/useraccountnew_appLoginVN_New.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {

        ZXUser *user = [ZXUser objectWithKeyValues:[JSON objectForKey:@"user"]];
        
        if (block) {
            block(user, nil);
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

+ (NSURLSessionDataTask *)uploadEMErrorWithUid:(NSInteger)uid
                                          block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:uid] forKey:@"uid"];
    return [[ZXApiClient sharedClient] POST:@"userjs/useraccountnew_modEasemobInfo.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        
        if (block) {
            [ZXBaseModel handleCompletion:block baseModel:baseModel];
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            [ZXBaseModel handleCompletion:block error:error];
        }
    }];
}

+ (NSURLSessionDataTask *)loginBackendWithAccount:(NSString *)account
                                         qrcodeid:(NSString *)qrcodeid
                                            block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:account forKey:@"account"];
    [parameters setObject:qrcodeid forKey:@"qrCodeId"];
    return [[ZXApiClient sharedClient] POST:@"userjs/useraccountnew_rqCodeLogon.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        
        if (block) {
            [ZXBaseModel handleCompletion:block baseModel:baseModel];
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            [ZXBaseModel handleCompletion:block error:error];
        }
    }];
}
@end
