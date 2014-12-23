//
//  ZXClass+ZXclient.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/17.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXClass+ZXclient.h"

@implementation ZXClass (ZXclient)
+ (NSURLSessionDataTask *)getClassListWithSid:(NSInteger)sid
                                        block:(void (^)(NSArray *array, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    return [[ZXApiClient sharedClient] POST:@"schooljs/schooliccard_searchClassesBySid.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *array = [JSON objectForKey:@"schoolClassList"];
        NSArray *arr = [ZXClass objectArrayWithKeyValuesArray:array];
        
        if (block) {
            block(arr, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

+ (NSURLSessionDataTask *)classDetailWithCid:(NSInteger)cid
                                       block:(void (^)(ZXClassDetail *classDetail, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:cid] forKey:@"cid"];
    return [[ZXApiClient sharedClient] POST:@"schooljs/schooliccard_queryClassDetailInfo.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *array = [JSON objectForKey:@"obList"];
        ZXClassDetail *classDetail = nil;
        if (array.count > 0) {
            NSDictionary *dic = [array firstObject];
            classDetail = [ZXClassDetail objectWithKeyValues:dic];
        }
        
        if (block) {
            block(classDetail, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}


+ (NSURLSessionDataTask *)getClassImageListWithDfid:(NSInteger)dfid
                                               page:(NSInteger)page
                                          page_size:(NSInteger)page_size
                                        block:(void (^)(NSArray *array, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:dfid] forKey:@"dfid"];
    [parameters setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [parameters setObject:[NSNumber numberWithInteger:page_size] forKey:@"page_size"];
    return [[ZXApiClient sharedClient] POST:@"schooljs/schooldailyfood_searchDailyfoodImgList.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *array = [JSON objectForKey:@"classes"];
        NSArray *arr = [ZXClass objectArrayWithKeyValuesArray:array];
        
        if (block) {
            block(arr, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}
@end
