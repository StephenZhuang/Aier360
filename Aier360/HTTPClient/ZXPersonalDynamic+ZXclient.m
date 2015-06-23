//
//  ZXPersonalDynamic+ZXclient.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/5/27.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXPersonalDynamic+ZXclient.h"
#import "NSManagedObject+ZXRecord.h"
#import <NSArray+ObjectiveSugar.h>

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
        if ([array isNull]) {
            !block?:block(nil,nil);
        } else {
            for (NSDictionary *dic in array) {
                ZXPersonalDynamic *personalDyanmic = [ZXPersonalDynamic create];
                [personalDyanmic updateWithDic:dic save:NO];
                [dataArray addObject:personalDyanmic];
            }
            !block?:block(dataArray,nil);
        }
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
        if ([dic isNull]) {
            !block?:block(nil,nil);
        } else {
            ZXPersonalDynamic *personalDyanmic = [ZXPersonalDynamic create];
            [personalDyanmic updateWithDic:dic save:NO];
            
            !block?:block(personalDyanmic,nil);
        }
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
    if (type == 3) {
        [parameters setObject:[NSNumber numberWithLong:uid] forKey:@"personalDynamic.uid"];
        [parameters setObject:[NSNumber numberWithLong:did] forKey:@"personalDynamic.did"];
        url = @"userjs/userDynamic_praiseDynamic.shtml?";
    } else {
        [parameters setObject:@(uid) forKey:@"schoolDynamic.uid"];
        [parameters setObject:@(did) forKey:@"schoolDynamic.did"];
        url = @"schooljs/schoolDynamic_praiseSchoolDynamic.shtml?";
    }
    
    return [[ZXApiClient sharedClient] POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        [ZXBaseModel handleCompletion:block baseModel:baseModel];
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [ZXBaseModel handleCompletion:block error:error];
    }];
}

+ (NSURLSessionDataTask *)getLatestParentDynamicWithUid:(long)uid
                                                   time:(NSString *)time
                                               pageSize:(NSInteger)pageSize
                                                  block:(void(^)(NSArray *array, NSError *error))block
{
    NSString *key = [NSString stringWithFormat:@"parentVersion%@",@(uid)];
    __block NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (!version) {
        version = @"0";
    }
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithLong:uid] forKey:@"uid"];
    [parameters setObject:version forKey:@"version"];
    [parameters setObject:time forKey:@"time"];
    [parameters setObject:@(pageSize) forKey:@"pageUtil.page_size"];
    
    return [[ZXApiClient sharedClient] POST:@"userjs/userDynamic_searchPersonalDynamics.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        NSArray *array = [JSON objectForKey:@"personalDynamicList"];
        version = [[JSON objectForKey:@"version"] stringValue];
        [[NSUserDefaults standardUserDefaults] setObject:version forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if (![array isNull]) {            
            for (NSDictionary *dic in array) {
                ZXPersonalDynamic *personalDyanmic = [ZXPersonalDynamic insertWithAttribute:@"did" value:[dic objectForKey:@"did"]];
                [personalDyanmic updateWithDic:dic save:YES];
                if (personalDyanmic.ctype == -2) {
                    [personalDyanmic delete];
                } else {
                    [personalDyanmic save];
                }
                [dataArray addObject:personalDyanmic];
            }
        }
        !block?:block(dataArray,nil);
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        !block?:block(nil,error);
    }];
}

+ (NSURLSessionDataTask *)getOlderParentDynamicWithUid:(long)uid
                                                  time:(NSString *)time
                                              pageSize:(NSInteger)pageSize
                                                 block:(void(^)(NSArray *array, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithLong:uid] forKey:@"uid"];
    [parameters setObject:time forKey:@"time"];
    [parameters setObject:@(pageSize) forKey:@"pageUtil.page_size"];
    
    return [[ZXApiClient sharedClient] POST:@"userjs/userDynamic_searchMorePersonalDynamics.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        NSArray *array = [JSON objectForKey:@"personalDynamicList"];
        if (![array isNull]) {
            for (NSDictionary *dic in array) {
                ZXPersonalDynamic *personalDyanmic = [ZXPersonalDynamic insertWithAttribute:@"did" value:[dic objectForKey:@"did"]];
                [personalDyanmic updateWithDic:dic save:YES];
                if (personalDyanmic.ctype == -2) {
                    [personalDyanmic delete];
                } else {
                    [personalDyanmic save];
                }
                [dataArray addObject:personalDyanmic];
            }
        }
        !block?:block(dataArray,nil);
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        !block?:block(nil,error);
    }];
}

+ (void)clearDynamicWhenLogout
{
    [[ZXPersonalDynamic all] each:^(ZXPersonalDynamic *dynamic) {
        [dynamic delete];
    }];
    NSString *key = [NSString stringWithFormat:@"parentVersion%@",@(GLOBAL_UID)];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSURLSessionDataTask *)deleteDynamicWithDid:(long)did
                                          type:(NSInteger)type
                                         block:(ZXCompletionBlock)block
{
    NSString *url = @"";
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (type == 3) {
        [parameters setObject:[NSNumber numberWithLong:did] forKey:@"personalDynamic.did"];
        url = @"userjs/userDynamic_deletePersonalDynamic.shtml?";
    } else {
        [parameters setObject:@(did) forKey:@"schoolDynamic.did"];
        url = @"schooljs/schoolDynamic_deleteSchoolDynamic.shtml?";
    }
    
    return [[ZXApiClient sharedClient] POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        [ZXBaseModel handleCompletion:block baseModel:baseModel];
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [ZXBaseModel handleCompletion:block error:error];
    }];
}

+ (NSURLSessionDataTask *)getLatestSchoolDynamicWithUid:(long)uid
                                                   time:(NSString *)time
                                               pageSize:(NSInteger)pageSize
                                                    sid:(NSInteger)sid
                                                  block:(void(^)(NSArray *array, NSError *error))block
{
    NSString *key = [NSString stringWithFormat:@"schoolVersion%@",@(uid)];
    __block NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (!version) {
        version = @"0";
    }
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithLong:uid] forKey:@"uid"];
    [parameters setObject:version forKey:@"version"];
    [parameters setObject:time forKey:@"time"];
    [parameters setObject:@(pageSize) forKey:@"pageUtil.page_size"];
    [parameters setObject:@(sid) forKey:@"sid"];
    
    return [[ZXApiClient sharedClient] POST:@"schooljs/schoolDynamic_searchSchoolDynamics.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        NSArray *array = [JSON objectForKey:@"schoolDynamicList"];
        version = [[JSON objectForKey:@"version"] stringValue];
        [[NSUserDefaults standardUserDefaults] setObject:version forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if (![array isNull]) {
            for (NSDictionary *dic in array) {
                ZXPersonalDynamic *personalDyanmic = [ZXPersonalDynamic insertWithAttribute:@"did" value:[dic objectForKey:@"did"]];
                [personalDyanmic updateWithDic:dic save:YES];
                if (personalDyanmic.ctype == -2) {
                    [personalDyanmic delete];
                } else {
                    [personalDyanmic save];
                }
                [dataArray addObject:personalDyanmic];
            }
        }
        !block?:block(dataArray,nil);
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        !block?:block(nil,error);
    }];
}

+ (NSURLSessionDataTask *)getOlderSchoolDynamicWithUid:(long)uid
                                                  time:(NSString *)time
                                              pageSize:(NSInteger)pageSize
                                                   sid:(NSInteger)sid
                                                 block:(void(^)(NSArray *array, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithLong:uid] forKey:@"uid"];
    [parameters setObject:time forKey:@"time"];
    [parameters setObject:@(pageSize) forKey:@"pageUtil.page_size"];
    [parameters setObject:@(sid) forKey:@"sid"];
    
    return [[ZXApiClient sharedClient] POST:@"schooljs/schoolDynamic_searchMoreSchoolDynamics.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        NSArray *array = [JSON objectForKey:@"schoolDynamicList"];
        if (![array isNull]) {
            for (NSDictionary *dic in array) {
                ZXPersonalDynamic *personalDyanmic = [ZXPersonalDynamic insertWithAttribute:@"did" value:[dic objectForKey:@"did"]];
                [personalDyanmic updateWithDic:dic save:YES];
                if (personalDyanmic.ctype == -2) {
                    [personalDyanmic delete];
                } else {
                    [personalDyanmic save];
                }
                [dataArray addObject:personalDyanmic];
            }
        }
        !block?:block(dataArray,nil);
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        !block?:block(nil,error);
    }];
}
@end
