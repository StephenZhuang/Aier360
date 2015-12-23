//
//  ZXSensitiveWords.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/12/23.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXSensitiveWords.h"
#import "ZXApiClient.h"

@implementation ZXSensitiveWords
+ (NSURLSessionDataTask *)getAllWordsWithSid:(NSInteger)sid
                                       block:(void (^)(NSArray *array, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:@(sid) forKey:@"sid"];
    return [[ZXApiClient sharedClient] POST:@"schooljs/monitoring_searchSensitiveWords.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *array = [JSON objectForKey:@"wordList"];
        NSArray *arr = [ZXSensitiveWords objectArrayWithKeyValuesArray:array];
        
        if (block) {
            block(arr, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

+ (NSURLSessionDataTask *)deleteWordWithSwid:(long)swid
                                       block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:@(swid) forKey:@"swid"];
    
    return [[ZXApiClient sharedClient] POST:@"schooljs/monitoring_delSensitiveWords.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
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

+ (NSURLSessionDataTask *)addWordWithSid:(NSInteger)sid
                                    word:(NSString *)word
                                   block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:@(sid) forKey:@"sid"];
    [parameters setObject:word forKey:@"word"];
    
    return [[ZXApiClient sharedClient] POST:@"schooljs/monitoring_addSensitiveWords.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
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
