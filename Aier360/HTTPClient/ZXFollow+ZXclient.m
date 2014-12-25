//
//  ZXFollow+ZXclient.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/25.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXFollow+ZXclient.h"

@implementation ZXFollow (ZXclient)
+ (NSURLSessionDataTask *)getFollowListWithUid:(NSInteger)uid
                                         state:(NSInteger)state
                                          page:(NSInteger)page
                                     page_size:(NSInteger)page_size
                                         block:(void (^)(NSArray *array, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:uid] forKey:@"uid"];
    [parameters setObject:[NSNumber numberWithInteger:state] forKey:@"state"];
    [parameters setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [parameters setObject:[NSNumber numberWithInteger:page_size] forKey:@"page_size"];
    return [[ZXApiClient sharedClient] POST:@"userjs/usermyfollow_searchAllFriend.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *array = [JSON objectForKey:@"followList"];
        NSArray *arr = [ZXFollow objectArrayWithKeyValuesArray:array];
        
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
