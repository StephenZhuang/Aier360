//
//  ZXHonor.m
//  Aierbon
//
//  Created by Stephen Zhuang on 16/1/7.
//  Copyright © 2016年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXHonor.h"
#import "ZXApiClient.h"

@implementation ZXHonor
+ (NSURLSessionDataTask *)getHonorListWithSid:(NSInteger)sid
                                        block:(void (^)(NSArray *array, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:@(sid) forKey:@"sid"];

    return [[ZXApiClient sharedClient] POST:@"schooljs/schoolInfo_searchSchoolHonor.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *array = [JSON objectForKey:@"schoolHonor"];
        NSArray *arr = [ZXHonor objectArrayWithKeyValuesArray:array];
        
        if (block) {
            block(arr, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

+ (NSURLSessionDataTask *)addHonorWithSid:(NSInteger)sid
                                    honor:(NSString *)honor
                                    block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    [parameters setObject:honor forKey:@"honor.honor"];
    return [[ZXApiClient sharedClient] POST:@"schooljs/schoolInfo_searchSchoolHonor.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        
        [ZXBaseModel handleCompletion:block baseModel:baseModel];
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [ZXBaseModel handleCompletion:block error:error];
    }];
}

+ (NSURLSessionDataTask *)deleteHonorWithShid:(NSInteger)shid
                                        block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:@(shid) forKey:@"honor.shid"];
    return [[ZXApiClient sharedClient] POST:@"schooljs/schoolInfo_deleteSchoolHonor.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        
        [ZXBaseModel handleCompletion:block baseModel:baseModel];
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [ZXBaseModel handleCompletion:block error:error];
    }];
}
@end
