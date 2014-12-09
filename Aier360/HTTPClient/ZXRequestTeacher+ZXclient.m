//
//  ZXRequestTeacher+ZXclient.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/19.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRequestTeacher+ZXclient.h"

@implementation ZXRequestTeacher (ZXclient)
+ (NSURLSessionDataTask *)getRequestTeacherListWithSid:(NSInteger)sid
                                                   uid:(NSInteger)uid
                                                  page:(NSInteger)page
                                              pageSize:(NSInteger)pageSize
                                                 block:(void (^)(NSArray *array, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    [parameters setObject:[NSNumber numberWithInteger:uid] forKey:@"uid"];
    [parameters setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [parameters setObject:[NSNumber numberWithInteger:pageSize] forKey:@"page_size"];
    return [[ZXApiClient sharedClient] POST:@"classesjs/cmaudit_searchRequestTeacherList.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *array = [JSON objectForKey:@"requestTeacherList"];
        NSArray *arr = [ZXRequestTeacher objectArrayWithKeyValuesArray:array];
        
        if (block) {
            block(arr, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

+ (NSURLSessionDataTask *)checkTeacherWithRtid:(NSInteger)rtid
                                         state:(NSInteger)state
                                           tid:(NSInteger)tid
                                         block:(void (^)(ZXBaseModel *baseModel, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:rtid] forKey:@"rtid"];
    [parameters setObject:[NSNumber numberWithInteger:state] forKey:@"state"];
    [parameters setObject:[NSNumber numberWithInteger:tid] forKey:@"tid"];
    return [[ZXApiClient sharedClient] POST:@"classesjs/cmaudit_updateRequestTeacherState.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
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
