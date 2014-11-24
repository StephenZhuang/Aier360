//
//  ZXICCard+ZXclient.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/24.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXICCard+ZXclient.h"

@implementation ZXICCard (ZXclient)
+ (NSURLSessionDataTask *)getTeacherCardListWithSid:(NSInteger)sid
                                                tid:(NSInteger)tid
                                               page:(NSInteger)page
                                           pageSize:(NSInteger)pageSize
                                              block:(void (^)(NSArray *array, NSError *error))block
{
    NSMutableDictionary *prameters = [[NSMutableDictionary alloc] init];
    [prameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    [prameters setObject:[NSNumber numberWithInteger:tid] forKey:@"tid"];
    [prameters setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [prameters setObject:[NSNumber numberWithInteger:pageSize] forKey:@"page_size"];
    return [[ZXApiClient sharedClient] POST:@"schooljs/schoolica_searchNormal.shtml?" parameters:prameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *array = [JSON objectForKey:@"schoolIcCardList"];
        NSArray *arr = [ZXICCard objectArrayWithKeyValuesArray:array];
        
        if (block) {
            block(arr, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

+ (NSURLSessionDataTask *)getParentCardListWithUid:(NSInteger)uid
                                              page:(NSInteger)page
                                          pageSize:(NSInteger)pageSize
                                             block:(void (^)(NSArray *array, NSError *error))block
{
    NSMutableDictionary *prameters = [[NSMutableDictionary alloc] init];
    [prameters setObject:[NSNumber numberWithInteger:uid] forKey:@"uid"];
    [prameters setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [prameters setObject:[NSNumber numberWithInteger:pageSize] forKey:@"page_size"];
    return [[ZXApiClient sharedClient] POST:@"userjs/userhscb_searchStuSchoolIcCardList.shtml?" parameters:prameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *array = [JSON objectForKey:@"schoolIcCardList"];
        NSArray *arr = [ZXICCard objectArrayWithKeyValuesArray:array];
        
        if (block) {
            block(arr, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

+ (NSURLSessionDataTask *)changeICCardStateWithSid:(NSInteger)sid
                                              icid:(NSInteger)icid
                                             state:(NSInteger)state
                                             block:(void (^)(BaseModel *baseModel, NSError *error))block
{
    NSMutableDictionary *prameters = [[NSMutableDictionary alloc] init];
    [prameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    [prameters setObject:[NSNumber numberWithInteger:icid] forKey:@"icid"];
    [prameters setObject:[NSNumber numberWithInteger:state] forKey:@"state"];
    return [[ZXApiClient sharedClient] POST:@"schooljs/schoolica_updateSchoolIcardState.shtml?" parameters:prameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        BaseModel *baseModel = [BaseModel objectWithKeyValues:JSON];
        
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
