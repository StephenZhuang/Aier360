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
    NSMutableDictionary *prameters = [[NSMutableDictionary alloc] init];
    [prameters setObject:[NSNumber numberWithInteger:cid] forKey:@"cid"];
    [prameters setObject:[NSNumber numberWithInteger:tid] forKey:@"tid"];
            [prameters setObject:[NSNumber numberWithInteger:state] forKey:@"state"];
    [prameters setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [prameters setObject:[NSNumber numberWithInteger:pageSize] forKey:@"page_size"];
    return [[ZXApiClient sharedClient] POST:@"classesjs/cmaudit_searchRequestParentList.shtml?" parameters:prameters success:^(NSURLSessionDataTask *task, id JSON) {
        
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
                                        block:(void (^)(BaseModel *baseModel, NSError *error))block
{
    NSMutableDictionary *prameters = [[NSMutableDictionary alloc] init];
    [prameters setObject:[NSNumber numberWithInteger:rpid] forKey:@"rpid"];
    [prameters setObject:[NSNumber numberWithInteger:state] forKey:@"state"];
    [prameters setObject:[NSNumber numberWithInteger:cid] forKey:@"cid"];
    return [[ZXApiClient sharedClient] POST:@"classesjs/cmaudit_updateRequestParentState.shtml?" parameters:prameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        BaseModel *baseModel = [BaseModel objectWithKeyValues:JSON];
        
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
