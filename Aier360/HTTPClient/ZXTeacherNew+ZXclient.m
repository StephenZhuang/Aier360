//
//  ZXTeacherNew+ZXclient.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/3/12.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXTeacherNew+ZXclient.h"

@implementation ZXTeacherNew (ZXclient)
+ (NSURLSessionDataTask *)getTeacherListWithSid:(NSInteger)sid
                                            gid:(NSInteger)gid
                                           page:(NSInteger)page
                                       pageSize:(NSInteger)pageSize
                                          block:(void (^)(NSArray *array, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    [parameters setObject:[NSNumber numberWithInteger:gid] forKey:@"gid"];
    [parameters setObject:[NSNumber numberWithInteger:page] forKey:@"pageUtil.page"];
    [parameters setObject:[NSNumber numberWithInteger:pageSize] forKey:@"pageUtil.page_size"];
    return [[ZXApiClient sharedClient] POST:@"nxadminjs/schoolteacher_searchSchoolTeachers.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *array = [JSON objectForKey:@"schoolTeacherNewList"];
        NSArray *arr = [ZXTeacherNew objectArrayWithKeyValuesArray:array];
        
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
