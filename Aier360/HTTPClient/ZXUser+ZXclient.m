//
//  ZXUser+ZXclient.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/9.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXUser+ZXclient.h"

@implementation ZXUser (ZXclient)
+ (NSURLSessionDataTask *)getPraisedListWithDid:(NSInteger)did
                                          block:(void (^)(NSArray *array, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:did] forKey:@"did"];
    return [[ZXApiClient sharedClient] POST:@"nxadminjs/Dynamic_searchDynamicPraise.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *array = [JSON objectForKey:@"userList"];
        NSArray *arr = [ZXUser objectArrayWithKeyValuesArray:array];
        
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
