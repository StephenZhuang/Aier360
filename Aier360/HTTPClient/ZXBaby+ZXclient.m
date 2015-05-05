//
//  ZXBaby+ZXclient.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/5/5.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaby+ZXclient.h"

@implementation ZXBaby (ZXclient)
+ (NSURLSessionDataTask *)addBabyWithUid:(long)uid
                                nickname:(NSString *)nickname
                                     sex:(NSString *)sex
                                birthday:(NSString *)birthday
                                   block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithLong:uid] forKey:@"bb.uid"];
    [parameters setObject:nickname forKey:@"bb.nickname"];
    [parameters setObject:sex forKey:@"bb.sex"];
    [parameters setObject:birthday forKey:@"bb.birthday"];
    return [[ZXApiClient sharedClient] POST:@"userjs/userInfo_addBaby.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        [ZXBaseModel handleCompletion:block baseModel:baseModel];
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [ZXBaseModel handleCompletion:block error:error];
    }];
}

+ (NSURLSessionDataTask *)updateBabyWithUid:(long)uid
                                        bid:(long)bid
                                   nickname:(NSString *)nickname
                                        sex:(NSString *)sex
                                   birthday:(NSString *)birthday
                                      block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithLong:uid] forKey:@"bb.uid"];
    [parameters setObject:[NSNumber numberWithLong:bid] forKey:@"bb.bid"];
    [parameters setObject:nickname forKey:@"bb.nickname"];
    [parameters setObject:sex forKey:@"bb.sex"];
    [parameters setObject:birthday forKey:@"bb.birthday"];
    return [[ZXApiClient sharedClient] POST:@"userjs/userInfo_modifyBaby.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        [ZXBaseModel handleCompletion:block baseModel:baseModel];
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [ZXBaseModel handleCompletion:block error:error];
    }];
}

+ (NSURLSessionDataTask *)deleteBabyWithUid:(long)uid
                                        bid:(long)bid
                                      block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithLong:uid] forKey:@"uid"];
    [parameters setObject:[NSNumber numberWithLong:bid] forKey:@"bid"];
    return [[ZXApiClient sharedClient] POST:@"userjs/userInfo_deleteBaby.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        [ZXBaseModel handleCompletion:block baseModel:baseModel];
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [ZXBaseModel handleCompletion:block error:error];
    }];
}
@end
