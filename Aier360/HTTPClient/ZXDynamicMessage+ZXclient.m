//
//  ZXDynamicMessage+ZXclient.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/8.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXDynamicMessage+ZXclient.h"

@implementation ZXDynamicMessage (ZXclient)
+ (NSURLSessionDataTask *)getDynamicMessageListWithUid:(long)uid
                                                  page:(NSInteger)page
                                              pageSize:(NSInteger)pageSize
                                                 block:(void (^)(NSArray *array, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithLong:uid] forKey:@"uid"];
    [parameters setObject:[NSNumber numberWithInteger:page] forKey:@"pageUtil.page"];
    [parameters setObject:[NSNumber numberWithInteger:pageSize] forKey:@"pageUtil.page_size"];
    return [[ZXApiClient sharedClient] POST:@"userjs/userDynamic_searchPersonalDynamicMessage.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *array = [JSON objectForKey:@"dynamicMessages"];
        NSArray *arr = [ZXDynamicMessage objectArrayWithKeyValuesArray:array];
        
        if (block) {
            block(arr, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

+ (NSURLSessionDataTask *)clearDynamicMessageWithUid:(long)uid
                                                type:(NSInteger)type
                                               block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithLong:uid] forKey:@"uid"];
    
    NSString *url = @"";
    if (type == 1) {
        url = @"schooljs/schoolDynamic_emptyDynamicMessage.shtml?";
    } else {
        url = @"userjs/userDynamic_emptyDynamicMessage.shtml?";
    }
    
    return [[ZXApiClient sharedClient] POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        [ZXBaseModel handleCompletion:block baseModel:baseModel];
        
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [ZXBaseModel handleCompletion:block error:error];
    }];
}

+ (NSURLSessionDataTask *)deleteDynamicMessageWithDmid:(long)dmid
                                                  type:(NSInteger)type
                                               block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithLong:dmid] forKey:@"dmid"];
    
    NSString *url = @"";
    if (type == 1) {
        url = @"schooljs/schoolDynamic_deleteDynamicMessage.shtml?";
    } else {
        url = @"userjs/userDynamic_deleteDynamicMessage.shtml?";
    }
    
    return [[ZXApiClient sharedClient] POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        [ZXBaseModel handleCompletion:block baseModel:baseModel];
        
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [ZXBaseModel handleCompletion:block error:error];
    }];
}

+ (NSURLSessionDataTask *)getSchoolDynamicMessageListWithUid:(long)uid
                                                         sid:(NSInteger)sid
                                                        page:(NSInteger)page
                                                    pageSize:(NSInteger)pageSize
                                                       block:(void (^)(NSArray *array, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithLong:uid] forKey:@"uid"];
    [parameters setObject:@(sid) forKey:@"sid"];
    [parameters setObject:[NSNumber numberWithInteger:page] forKey:@"pageUtil.page"];
    [parameters setObject:[NSNumber numberWithInteger:pageSize] forKey:@"pageUtil.page_size"];
    return [[ZXApiClient sharedClient] POST:@"schooljs/schoolDynamic_searchSchoolDynamicMessage.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *array = [JSON objectForKey:@"dynamicMessages"];
        NSArray *arr = [ZXDynamicMessage objectArrayWithKeyValuesArray:array];
        
        if (block) {
            block(arr, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}
@end
