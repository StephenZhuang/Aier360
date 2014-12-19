//
//  ZXHomeworkMessage+ZXclient.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/19.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXHomeworkMessage+ZXclient.h"

@implementation ZXHomeworkMessage (ZXclient)
+ (NSURLSessionDataTask *)getHomeworkMessageListWithUid:(NSInteger)uid
                                                    sid:(NSInteger)sid
                                                  block:(void (^)(NSArray *array, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:uid] forKey:@"uid"];
    [parameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    return [[ZXApiClient sharedClient] POST:@"userjs/userHomework_searchHomeworkMessages.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *array = [JSON objectForKey:@"hms"];
        NSArray *arr = [ZXHomeworkMessage objectArrayWithKeyValuesArray:array];
        
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
