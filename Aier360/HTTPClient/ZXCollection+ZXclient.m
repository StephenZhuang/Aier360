//
//  ZXCollection+ZXclient.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/16.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXCollection+ZXclient.h"

@implementation ZXCollection (ZXclient)
+ (NSURLSessionDataTask *)getCollectionListWithUid:(long)uid
                                              page:(NSInteger)page
                                          pageSize:(NSInteger)pageSize
                                             block:(void (^)(NSArray *array, NSError *error))block
{
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithLong:uid] forKey:@"uid"];
    [parameters setObject:@(page) forKey:@"page"];
    [parameters setObject:@(pageSize) forKey:@"page_size"];
    
    return [[ZXApiClient sharedClient] POST:@"userjs/userInfo_showCollections.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *array = [JSON objectForKey:@"collectionList"];
        NSArray *arr = [ZXCollection objectArrayWithKeyValuesArray:array];
        
        if (block) {
            block(arr, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

+ (NSURLSessionDataTask *)collectWithUid:(long)uid
                                     did:(long)did
                                   isAdd:(BOOL)isAdd
                                   block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithLong:uid] forKey:@"uid"];
    [parameters setObject:@(did) forKey:@"did"];
    
    NSString *url = isAdd?@"userjs/userInfo_addCollection.shtml?":@"userjs/userInfo_cancelCollectionByDidAndUid.shtml?";
    
    return [[ZXApiClient sharedClient] POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        [ZXBaseModel handleCompletion:block baseModel:baseModel];
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [ZXBaseModel handleCompletion:block error:error];
    }];
}
@end
