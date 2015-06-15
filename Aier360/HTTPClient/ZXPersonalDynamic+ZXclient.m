//
//  ZXPersonalDynamic+ZXclient.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/5/27.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXPersonalDynamic+ZXclient.h"
#import "NSManagedObject+ZXRecord.h"

@implementation ZXPersonalDynamic (ZXclient)
+ (NSURLSessionDataTask *)addDynamicWithUid:(long)uid
                                    content:(NSString *)content
                                        img:(NSString *)img
                                 relativeid:(long)relativeid
                                  authority:(NSInteger)authority
                                      block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithLong:uid] forKey:@"personalDynamic.uid"];
    [parameters setObject:content forKey:@"personalDynamic.content"];
    [parameters setObject:img forKey:@"personalDynamic.img"];
    [parameters setObject:[NSNumber numberWithLong:relativeid] forKey:@"personalDynamic.relativeid"];
    [parameters setObject:[NSNumber numberWithInteger:authority] forKey:@"personalDynamic.authority"];
    
    return [[ZXApiClient sharedClient] POST:@"userjs/userDynamic_publishDynamic.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        [ZXBaseModel handleCompletion:block baseModel:baseModel];
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [ZXBaseModel handleCompletion:block error:error];
    }];
}

+ (NSURLSessionDataTask *)addSchoolDynamicWithUid:(long)uid
                                          content:(NSString *)content
                                              img:(NSString *)img
                                       relativeid:(long)relativeid
                                              sid:(long)sid
                                              cid:(long)cid
                                            block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithLong:uid] forKey:@"schoolDynamic.uid"];
    [parameters setObject:content forKey:@"schoolDynamic.content"];
    [parameters setObject:img forKey:@"schoolDynamic.img"];
    [parameters setObject:[NSNumber numberWithLong:relativeid] forKey:@"schoolDynamic.relativeid"];
    [parameters setObject:@(sid) forKey:@"schoolDynamic.sid"];
    [parameters setObject:@(cid) forKey:@"schoolDynamic.cid"];
    
    return [[ZXApiClient sharedClient] POST:@"schooljs/schoolDynamic_insertSchoolDynamic.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        [ZXBaseModel handleCompletion:block baseModel:baseModel];
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [ZXBaseModel handleCompletion:block error:error];
    }];
}

+ (NSURLSessionDataTask *)getPersonalDynamicWithUid:(long)uid
                                               fuid:(long)fuid
                                               page:(NSInteger)page
                                           pageSize:(NSInteger)pageSize
                                      block:(void(^)(NSArray *array, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithLong:uid] forKey:@"uid"];
    [parameters setObject:[NSNumber numberWithLong:fuid] forKey:@"fuid"];
    [parameters setObject:@(page) forKey:@"page"];
    [parameters setObject:@(pageSize) forKey:@"page_size"];
    
    return [[ZXApiClient sharedClient] POST:@"userjs/userInfo_searchPersonalDynamic.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        NSArray *array = [JSON objectForKey:@"dynamicList"];
        for (NSDictionary *dic in array) {
            ZXPersonalDynamic *personalDyanmic = [ZXPersonalDynamic create];
            [personalDyanmic updateWithDic:dic save:NO];
            [dataArray addObject:personalDyanmic];
        }
        !block?:block(dataArray,nil);
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        !block?:block(nil,error);
    }];
}

+ (NSURLSessionDataTask *)getPersonalDynamicDetailWithUid:(long)uid
                                                      did:(long)did
                                              block:(void(^)(ZXPersonalDynamic *dynamic, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithLong:uid] forKey:@"personalDynamic.uid"];
    [parameters setObject:[NSNumber numberWithLong:did] forKey:@"personalDynamic.did"];
    
    return [[ZXApiClient sharedClient] POST:@"userjs/userDynamic_searchOnlyDynamic.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        NSDictionary *dic = [JSON objectForKey:@"personalDynamic"];
        ZXPersonalDynamic *personalDyanmic = [ZXPersonalDynamic create];
        [personalDyanmic updateWithDic:dic save:NO];

        !block?:block(personalDyanmic,nil);
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        !block?:block(nil,error);
    }];
}

+ (NSURLSessionDataTask *)praiseDynamicWithUid:(long)uid
                                           did:(long)did
                                          type:(NSInteger)type
                                         block:(ZXCompletionBlock)block
{
    NSString *url = @"";
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (type == 1) {
        [parameters setObject:@(uid) forKey:@"schoolDynamic.uid"];
        [parameters setObject:@(did) forKey:@"schoolDynamic.did"];
        url = @"schooljs/schoolDynamic_praiseSchoolDynamic.shtml?";
    } else {
        [parameters setObject:[NSNumber numberWithLong:uid] forKey:@"personalDynamic.uid"];
        [parameters setObject:[NSNumber numberWithLong:did] forKey:@"personalDynamic.did"];
        url = @"userjs/userDynamic_praiseDynamic.shtml?";
    }
    
    return [[ZXApiClient sharedClient] POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        [ZXBaseModel handleCompletion:block baseModel:baseModel];
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [ZXBaseModel handleCompletion:block error:error];
    }];
}
@end
