//
//  ZXDailyFood+ZXclient.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/25.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXDailyFood+ZXclient.h"

@implementation ZXDailyFood (ZXclient)
+ (NSURLSessionDataTask *)getFoodListWithSid:(NSInteger)sid
                                         cid:(NSInteger)cid
                              dailyFoodState:(NSInteger)dailyFoodState
                                        page:(NSInteger)page
                                    pageSize:(NSInteger)pageSize
                                       block:(void (^)(NSArray *array, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    [parameters setObject:[NSNumber numberWithInteger:cid] forKey:@"cid"];
    [parameters setObject:[NSNumber numberWithInteger:dailyFoodState] forKey:@"dailyFoodState"];
    [parameters setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [parameters setObject:[NSNumber numberWithInteger:pageSize] forKey:@"page_size"];
    return [[ZXApiClient sharedClient] POST:@"schooljs/schooldailyfood_searchDailyfoodList.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *array = [JSON objectForKey:@"dfList"];
        NSArray *arr = [ZXDailyFood objectArrayWithKeyValuesArray:array];
        
        if (block) {
            block(arr, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

+ (NSURLSessionDataTask *)addFoodWithSid:(NSInteger)sid
                               dailyfood:(NSString *)dailyfood
                               ismessage:(NSInteger)ismessage
                                   block:(void (^)(ZXBaseModel *baseModel, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    [parameters setObject:[NSNumber numberWithInteger:ismessage] forKey:@"ismessage"];
    [parameters setObject:dailyfood forKey:@"dailyfood"];
    return [[ZXApiClient sharedClient] POST:@"schooljs/schooldailyfood_addDailyfood.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
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

+ (NSURLSessionDataTask *)eidtFoodWithDfid:(NSInteger)dfid
                                     ddate:(NSString *)ddate
                                   content:(NSString *)content
                                     block:(void (^)(ZXBaseModel *baseModel, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:dfid] forKey:@"dfid"];
    [parameters setObject:ddate forKey:@"ddate"];
    [parameters setObject:content forKey:@"content"];
    return [[ZXApiClient sharedClient] POST:@"schooljs/schooldailyfood_updateDailyfood.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
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
