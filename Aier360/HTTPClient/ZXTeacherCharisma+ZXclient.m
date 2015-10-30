//
//  ZXTeacherCharisma+ZXclient.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/5.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXTeacherCharisma+ZXclient.h"

@implementation ZXTeacherCharisma (ZXclient)
+ (NSURLSessionDataTask *)addTeacherCharismalWithSid:(NSInteger)sid
                                              stcImg:(NSString *)stcImg
                                             stcname:(NSString *)stcname
                                          stcDesinfo:(NSString *)stcDesinfo
                                               block:(void (^)(ZXBaseModel *baseModel, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    [parameters setObject:stcImg forKey:@"stcImg"];
    [parameters setObject:stcname forKey:@"stcname"];
    [parameters setObject:stcDesinfo forKey:@"stcDesinfo"];
    return [[ZXApiClient sharedClient] POST:@"schooljs/sbinfo_addTeacherCharismal.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
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

+ (NSURLSessionDataTask *)updateTeacherCharismalWithStcid:(NSInteger)stcid
                                                   stcImg:(NSString *)stcImg
                                                  stcname:(NSString *)stcname
                                               stcDesinfo:(NSString *)stcDesinfo
                                                    block:(void (^)(BOOL success, NSString *img, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:stcid] forKey:@"stcid"];
    [parameters setObject:stcImg forKey:@"stcImg"];
    [parameters setObject:stcname forKey:@"stcname"];
    [parameters setObject:stcDesinfo forKey:@"stcDesinfo"];
    return [[ZXApiClient sharedClient] POST:@"schooljs/sbinfo_updateTeacherCharismal.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        if (baseModel && baseModel.s == 1) {
            NSString *img = [JSON objectForKey:@"stcImg"];
            if ([img isNull]) {
                img = @"";
            }
            if (block) {
                block(YES, img, nil);
            }
        } else {
            if (block) {
                block(NO,@"", nil);
            }
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(NO,@"", error);
        }
    }];
}

+ (NSURLSessionDataTask *)getTeacherListWithSid:(long)sid
                                           page:(NSInteger)page
                                       pageSize:(NSInteger)pageSize
                                          block:(void (^)(NSArray *array, NSError *error))block
{
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:@(sid) forKey:@"sid"];
    [parameters setObject:@(page) forKey:@"pageUtil.page"];
    [parameters setObject:@(pageSize) forKey:@"pageUtil.page_size"];
    
    return [[ZXApiClient sharedClient] POST:@"schooljs/sbinfo_searchTeacherCharismaList.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *array = [JSON objectForKey:@"stcList"];
        NSArray *arr = [ZXTeacherCharisma objectArrayWithKeyValuesArray:array];
        
        if (block) {
            block(arr, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

+ (NSURLSessionDataTask *)deleteTeacherCharismalWithStcid:(NSInteger)stcid
                                                    block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:stcid] forKey:@"stcid"];
    return [[ZXApiClient sharedClient] POST:@"schooljs/sbinfo_deleteTeacherCharisma.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        [ZXBaseModel handleCompletion:block baseModel:baseModel];
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [ZXBaseModel handleCompletion:block error:error];
    }];
}
@end
