//
//  ZXRequestParent+ZXclient.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/25.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRequestParent+ZXclient.h"

@implementation ZXRequestParent (ZXclient)
+ (NSURLSessionDataTask *)getRequestParentListWithCid:(NSInteger)cid
                                                  tid:(NSInteger)tid
                                                state:(NSInteger)state
                                                 page:(NSInteger)page
                                             pageSize:(NSInteger)pageSize
                                                block:(void (^)(NSArray *array, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:cid] forKey:@"cid"];
    [parameters setObject:[NSNumber numberWithInteger:tid] forKey:@"tid"];
            [parameters setObject:[NSNumber numberWithInteger:state] forKey:@"state"];
    [parameters setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [parameters setObject:[NSNumber numberWithInteger:pageSize] forKey:@"page_size"];
    return [[ZXApiClient sharedClient] POST:@"classesjs/cmaudit_searchRequestParentList.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *array = [JSON objectForKey:@"requestParentList"];
        NSArray *arr = [ZXRequestParent objectArrayWithKeyValuesArray:array];
        
        if (block) {
            block(arr, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

+ (NSURLSessionDataTask *)checkParentWithRpid:(NSInteger)rpid
                                        state:(NSInteger)state
                                          cid:(NSInteger)cid
                                        block:(void (^)(ZXBaseModel *baseModel, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:rpid] forKey:@"rpid"];
    [parameters setObject:[NSNumber numberWithInteger:state] forKey:@"state"];
    [parameters setObject:[NSNumber numberWithInteger:cid] forKey:@"cid"];
    return [[ZXApiClient sharedClient] POST:@"classesjs/cmaudit_updateRequestParentState.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        
        if (block) {
            block(baseModel, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}
@end
