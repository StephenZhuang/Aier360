//
//  ZXDynamicMessage+ZXclient.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/8.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXDynamicMessage+ZXclient.h"

@implementation ZXDynamicMessage (ZXclient)
+ (NSURLSessionDataTask *)getDynamicMessageListWithUid:(NSInteger)uid
                                                  page:(NSInteger)page
                                              pageSize:(NSInteger)pageSize
                                                 block:(void (^)(NSArray *array, NSError *error))block
{
    NSMutableDictionary *prameters = [[NSMutableDictionary alloc] init];
    [prameters setObject:[NSNumber numberWithInteger:uid] forKey:@"uid"];
    [prameters setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [prameters setObject:[NSNumber numberWithInteger:pageSize] forKey:@"page_size"];
    return [[ZXApiClient sharedClient] POST:@"nxadminjs/Dynamic_searchDynamicMessage.shtml?" parameters:prameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *array = [JSON objectForKey:@"dmList"];
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

+ (NSURLSessionDataTask *)clearDynamicMessageWithUid:(NSInteger)uid
                                               block:(ZXCompletionBlock)block
{
    NSMutableDictionary *prameters = [[NSMutableDictionary alloc] init];
    [prameters setObject:[NSNumber numberWithInteger:uid] forKey:@"uid"];
    return [[ZXApiClient sharedClient] POST:@"nxadminjs/Dynamic_deleteDynamicMessageAboutMe.shtml?" parameters:prameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        BaseModel *baseModel = [BaseModel objectWithKeyValues:JSON];
        [BaseModel handleCompletion:block baseModel:baseModel];
        
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [BaseModel handleCompletion:block error:error];
    }];
}

+ (NSURLSessionDataTask *)deleteDynamicMessageWithDmid:(NSInteger)dmid
                                               block:(ZXCompletionBlock)block
{
    NSMutableDictionary *prameters = [[NSMutableDictionary alloc] init];
    [prameters setObject:[NSNumber numberWithInteger:dmid] forKey:@"dmid"];
    return [[ZXApiClient sharedClient] POST:@"nxadminjs/Dynamic_deleteDynamicMessage.shtml?" parameters:prameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        BaseModel *baseModel = [BaseModel objectWithKeyValues:JSON];
        [BaseModel handleCompletion:block baseModel:baseModel];
        
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [BaseModel handleCompletion:block error:error];
    }];
}
@end
