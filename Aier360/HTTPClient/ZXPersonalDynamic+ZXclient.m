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
#import "NSNull+ZXNullValue.h"
#import "ZXUmengHelper.h"

@implementation ZXPersonalDynamic (ZXclient)
+ (NSURLSessionDataTask *)addDynamicWithUid:(long)uid
                                    content:(NSString *)content
                                        img:(NSString *)img
                                 relativeid:(long)relativeid
                                  authority:(NSInteger)authority
                                     oslids:(NSString *)oslids
                                    address:(NSString *)address
                                        lat:(float)lat
                                        lng:(float)lng
                                      block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithLong:uid] forKey:@"personalDynamic.uid"];
    [parameters setObject:content forKey:@"personalDynamic.content"];
    [parameters setObject:img forKey:@"personalDynamic.img"];
    [parameters setObject:oslids forKey:@"personalDynamic.oslids"];
    [parameters setObject:@(lat) forKey:@"personalDynamic.latitude"];
    [parameters setObject:@(lng) forKey:@"personalDynamic.longitude"];
    [parameters setObject:address forKey:@"personalDynamic.address"];
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
                                           oslids:(NSString *)oslids
                                          address:(NSString *)address
                                              lat:(float)lat
                                              lng:(float)lng
                                            block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithLong:uid] forKey:@"schoolDynamic.uid"];
    [parameters setObject:content forKey:@"schoolDynamic.content"];
    [parameters setObject:img forKey:@"schoolDynamic.img"];
    [parameters setObject:[NSNumber numberWithLong:relativeid] forKey:@"schoolDynamic.relativeid"];
    [parameters setObject:@(sid) forKey:@"schoolDynamic.sid"];
    [parameters setObject:@(cid) forKey:@"schoolDynamic.cid"];
    [parameters setObject:oslids forKey:@"schoolDynamic.oslids"];
    [parameters setObject:@(lat) forKey:@"schoolDynamic.latitude"];
    [parameters setObject:@(lng) forKey:@"schoolDynamic.longitude"];
    [parameters setObject:address forKey:@"schoolDynamic.address"];
    
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
        [ZXUmengHelper logFav];
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
        //添加、删除等情况下，清空好友动态
        if ([[JSON objectForKey:@"isEmptyCache"] integerValue] == 1) {
            [[ZXPersonalDynamic where:@"sid == 0"] each:^(ZXPersonalDynamic *dynamic) {
                [dynamic delete];
            }];
        }
        
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
                    [dataArray addObject:personalDyanmic];
                }
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
                    [dataArray addObject:personalDyanmic];
                }
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
    NSString *key2 = [NSString stringWithFormat:@"schoolVersion%@",@(GLOBAL_UID)];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:key];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:key2];
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
    
    return [[ZXApiClient sharedClient] POST:@"schooljs/onlySchoolDynamic_searchSchoolDynamics.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
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
    
    return [[ZXApiClient sharedClient] POST:@"schooljs/onlySchoolDynamic_searchMoreSchoolDynamics.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
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

+ (NSURLSessionDataTask *)checkNewSchoolDynamicWithUid:(long)uid
                                                  time:(NSString *)time
                                                   sid:(NSInteger)sid
                                                 block:(void(^)(BOOL hasNew, NSError *error))block
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
    [parameters setObject:@(sid) forKey:@"sid"];
    
    return [[ZXApiClient sharedClient] POST:@"schooljs/schoolDynamic_hasNewDynamics.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        BOOL hasNew = [[JSON objectForKey:@"hasNewSchoolDynamics"] boolValue];

        !block?:block(hasNew,nil);
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        !block?:block(NO,error);
    }];
}

#pragma mark- 3.0
+ (NSURLSessionDataTask *)getSquareDynamicWithUid:(long)uid
                                            oslid:(NSInteger)oslid
                                             page:(NSInteger)page
                                         pageSize:(NSInteger)pageSize
                                            block:(void(^)(NSArray *array, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithLong:uid] forKey:@"uid"];
    [parameters setObject:@(oslid) forKey:@"oslid"];
    [parameters setObject:@(page) forKey:@"pageUtil.page"];
    [parameters setObject:@(pageSize) forKey:@"pageUtil.page_size"];
    
    return [[ZXApiClient sharedClient] POST:@"userjs/squareLabel_serachDynamicsBySquareLabelId.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
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

+ (NSURLSessionDataTask *)getHotDynamicWithUid:(long)uid
                                          page:(NSInteger)page
                                      pageSize:(NSInteger)pageSize
                                         block:(void(^)(NSArray *array, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithLong:uid] forKey:@"uid"];
    [parameters setObject:@(page) forKey:@"pageUtil.page"];
    [parameters setObject:@(pageSize) forKey:@"pageUtil.page_size"];
    
    return [[ZXApiClient sharedClient] POST:@"userjs/squareDynamicHot_searchSquareDynamicHot.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
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

+ (NSURLSessionDataTask *)getLatestClassDynamicWithUid:(long)uid
                                                  time:(NSString *)time
                                              pageSize:(NSInteger)pageSize
                                                   sid:(NSInteger)sid
                                                   cid:(long)cid
                                                 block:(void(^)(NSArray *array, NSError *error))block
{
    NSString *key = [NSString stringWithFormat:@"classVersion%@",@(uid)];
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
    
    return [[ZXApiClient sharedClient] POST:@"schooljs/classesDynamic_searchClassesDynamics.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        NSArray *array = [JSON objectForKey:@"classesDynamics"];
        version = [[JSON objectForKey:@"version"] stringValue];
        [[NSUserDefaults standardUserDefaults] setObject:version forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //添加、删除等情况下，清空好友动态
        if ([[JSON objectForKey:@"isEmptyCache"] integerValue] == 1) {
            [[ZXPersonalDynamic where:@"(sid == %@) AND (type == 2)",@(sid)] each:^(ZXPersonalDynamic *dynamic) {
                [dynamic delete];
            }];
        }
        
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

+ (NSURLSessionDataTask *)getOlderClassDynamicWithUid:(long)uid
                                                 time:(NSString *)time
                                             pageSize:(NSInteger)pageSize
                                                  sid:(NSInteger)sid
                                                  cid:(long)cid
                                                block:(void(^)(NSArray *array, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithLong:uid] forKey:@"uid"];
    [parameters setObject:time forKey:@"time"];
    [parameters setObject:@(pageSize) forKey:@"pageUtil.page_size"];
    [parameters setObject:@(sid) forKey:@"sid"];
    if (cid) {
        [parameters setObject:@(cid) forKey:@"cid"];
    }
    
    return [[ZXApiClient sharedClient] POST:@"schooljs/classesDynamic_searchMoreSchoolDynamics.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        NSArray *array = [JSON objectForKey:@"classesDynamics"];
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
