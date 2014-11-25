//
//  ZXStudent+ZXclient.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/25.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXStudent+ZXclient.h"

@implementation ZXStudent (ZXclient)
+ (NSURLSessionDataTask *)getStudentListWithCid:(NSInteger)cid
                                    isGetParent:(NSInteger)isGetParent
                                          block:(void (^)(NSArray *array, NSError *error))block
{
    NSMutableDictionary *prameters = [[NSMutableDictionary alloc] init];
    [prameters setObject:[NSNumber numberWithInteger:cid] forKey:@"cid"];
    [prameters setObject:[NSNumber numberWithInteger:isGetParent] forKey:@"isGetParent"];
    return [[ZXApiClient sharedClient] POST:@"nxadminjs/callroll_searchCSList.shtml?" parameters:prameters success:^(NSURLSessionDataTask *task, id JSON) {
        
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
@end
