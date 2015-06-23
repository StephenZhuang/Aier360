//
//  ZXSchoolImg+ZXclient.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/19.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXSchoolImg+ZXclient.h"

@implementation ZXSchoolImg (ZXclient)
+ (NSURLSessionDataTask *)getSchoolImgListWithSid:(long)sid
                                            block:(void (^)(NSArray *array, NSError *error))block
{
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithLong:sid] forKey:@"sid"];
    
    return [[ZXApiClient sharedClient] POST:@"schooljs/schoolInfo_showSchoolImg.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *array = [JSON objectForKey:@"schoolImgs"];
        NSArray *arr = [ZXSchoolImg objectArrayWithKeyValuesArray:array];
        
        if (block) {
            block(arr, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

+ (NSURLSessionDataTask *)addSchoolImageWithSid:(long)sid
                                           simg:(NSString *)simg
                                           info:(NSString *)info
                                          block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithLong:sid] forKey:@"sid"];
    [parameters setObject:simg forKey:@"simg"];
    [parameters setObject:info forKey:@"info"];
    
    NSString *url = @"schooljs/schoolInfo_addSchoolImg.shtml?";
    
    return [[ZXApiClient sharedClient] POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        [ZXBaseModel handleCompletion:block baseModel:baseModel];
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [ZXBaseModel handleCompletion:block error:error];
    }];
}

+ (NSURLSessionDataTask *)deleteSchoolImageWithSid:(long)sid
                                              simg:(NSString *)simg
                                             block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithLong:sid] forKey:@"sid"];
    [parameters setObject:simg forKey:@"simg"];
    
    NSString *url = @"schooljs/schoolInfo_deleteSchoolImg.shtml?";
    
    return [[ZXApiClient sharedClient] POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        [ZXBaseModel handleCompletion:block baseModel:baseModel];
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [ZXBaseModel handleCompletion:block error:error];
    }];
}

+ (NSURLSessionDataTask *)setCoverWithSid:(long)sid
                                     simg:(NSString *)simg
                                    block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithLong:sid] forKey:@"sid"];
    [parameters setObject:simg forKey:@"simg"];
    
    NSString *url = @"schooljs/schoolInfo_setSchoolMainImg.shtml?";
    
    return [[ZXApiClient sharedClient] POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        [ZXBaseModel handleCompletion:block baseModel:baseModel];
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [ZXBaseModel handleCompletion:block error:error];
    }];
}
@end
