//
//  ZXStudent+ZXclient.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/25.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXStudent+ZXclient.h"
#import "ZXParent.h"

@implementation ZXStudent (ZXclient)
+ (NSURLSessionDataTask *)getStudentListWithCid:(NSInteger)cid
                                    isGetParent:(NSInteger)isGetParent
                                          block:(void (^)(NSArray *array, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:cid] forKey:@"cid"];
    [parameters setObject:[NSNumber numberWithInteger:isGetParent] forKey:@"isGetParent"];
    return [[ZXApiClient sharedClient] POST:@"nxadminjs/callroll_searchCSList.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *array = [JSON objectForKey:@"csList"];
        NSArray *arr = [ZXStudent objectArrayWithKeyValuesArray:array];
        
        if (block) {
            block(arr, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

+ (NSURLSessionDataTask *)getStudentListWithUid:(NSInteger)uid
                                          block:(void (^)(NSArray *array, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:uid] forKey:@"uid"];
    return [[ZXApiClient sharedClient] POST:@"nxadminjs/searchIcardRecord_searchAllChild.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *array = [JSON objectForKey:@"classStudentAllList"];
        NSArray *arr = [ZXStudent objectArrayWithKeyValuesArray:array];
        
        if (block) {
            block(arr, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

+ (NSURLSessionDataTask *)getParentListWithCsid:(NSInteger)csid
                                          block:(void (^)(NSArray *array, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:csid] forKey:@"csid"];
    return [[ZXApiClient sharedClient] POST:@"nxadminjs/classesArchitecture_searchClassParentsByCsid.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *array = [JSON objectForKey:@"classParentList"];
        NSArray *arr = [ZXParent objectArrayWithKeyValuesArray:array];
        
        if (block) {
            block(arr, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

+ (NSURLSessionDataTask *)addStudentWithCid:(NSInteger)cid
                                     snames:(NSString *)snames
                                       sexs:(NSString *)sexs
                                      block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:cid] forKey:@"cid"];
    [parameters setObject:snames forKey:@"snames"];
    [parameters setObject:sexs forKey:@"sexs"];

    return [[ZXApiClient sharedClient] POST:@"nxadminjs/classesArchitecture_addClassStudents.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
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

+ (NSURLSessionDataTask *)addStudentWithCsid:(NSInteger)csid
                                         tid:(NSInteger)tid
                                         sid:(NSInteger)sid
                                       phone:(NSString *)phone
                                    relation:(NSString *)relation
                                         sex:(NSString *)sex
                                       block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:csid] forKey:@"csid"];
    [parameters setObject:[NSNumber numberWithInteger:tid] forKey:@"tid"];
    [parameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    [parameters setObject:phone forKey:@"phone"];
    [parameters setObject:relation forKey:@"relation"];
    [parameters setObject:sex forKey:@"sex"];
    
    return [[ZXApiClient sharedClient] POST:@"nxadminjs/classesArchitecture_addClassParent.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
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
