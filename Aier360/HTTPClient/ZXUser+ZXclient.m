//
//  ZXUser+ZXclient.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/9.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXUser+ZXclient.h"

@implementation ZXUser (ZXclient)
+ (NSURLSessionDataTask *)getPraisedListWithDid:(NSInteger)did
                                          block:(void (^)(NSArray *array, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:did] forKey:@"did"];
    return [[ZXApiClient sharedClient] POST:@"nxadminjs/Dynamic_searchDynamicPraise.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *array = [JSON objectForKey:@"userList"];
        NSArray *arr = [ZXUser objectArrayWithKeyValuesArray:array];
        
        if (block) {
            block(arr, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

+ (NSURLSessionDataTask *)getUserInfoAndBabyListWithUid:(NSInteger)uid
                                                 in_uid:(NSInteger)in_uid
                                                  block:(void (^)(ZXUser *user, NSArray *array, BOOL isFocus, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:uid] forKey:@"uid"];
    [parameters setObject:[NSNumber numberWithInteger:in_uid] forKey:@"in_uid"];
    return [[ZXApiClient sharedClient] POST:@"userjs/uccomm_userInfoapp.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *array = [JSON objectForKey:@"babyList"];
        NSArray *arr = [ZXUser objectArrayWithKeyValuesArray:array];
        ZXUser *user = [ZXUser objectWithKeyValues:[JSON objectForKey:@"user"]];
        BOOL isFocus = ([[JSON objectForKey:@"isGZ"] integerValue] == 1);
        if (block) {
            block(user ,arr,isFocus, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil,nil,NO, error);
        }
    }];
}

+ (NSURLSessionDataTask *)updateUserInfoAndBabyListWithAppuserinfo:(NSString *)appuserinfo
                                                         babysinfo:(NSString *)babysinfo
                                                               uid:(NSInteger)uid
                                                             block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:uid] forKey:@"uid"];
    [parameters setObject:appuserinfo forKey:@"appuserinfo"];
    [parameters setObject:babysinfo forKey:@"babysinfo"];
    return [[ZXApiClient sharedClient] POST:@"userjs/useraccountsettings_updateUserInfoApp.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        [ZXBaseModel handleCompletion:block baseModel:baseModel];
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [ZXBaseModel handleCompletion:block error:error];
    }];
}

@end
