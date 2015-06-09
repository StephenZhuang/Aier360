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
            [personalDyanmic updateWithDic:dic];
            [dataArray addObject:personalDyanmic];
        }
        !block?:block(dataArray,nil);
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        !block?:block(nil,error);
    }];
}
@end
