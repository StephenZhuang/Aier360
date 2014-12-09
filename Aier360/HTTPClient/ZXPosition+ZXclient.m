//
//  ZXPosition+ZXclient.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/17.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXPosition+ZXclient.h"

@implementation ZXPosition (ZXclient)
+ (NSURLSessionDataTask *)getPositionListWithSid:(NSInteger)sid
                                           block:(void (^)(NSArray *array, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    return [[ZXApiClient sharedClient] POST:@"schooljs/schoolgrade_searchSchoolGradeListApp.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *array = [JSON objectForKey:@"schoolGradeList"];
        NSArray *arr = [ZXPosition objectArrayWithKeyValuesArray:array];
        
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
