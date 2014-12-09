//
//  ZXTeacher+ZXclient.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/18.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXTeacher+ZXclient.h"

@implementation ZXTeacher (ZXclient)
+ (NSURLSessionDataTask *)getTeacherListWithSid:(NSInteger)sid
                                            gid:(NSInteger)gid
                                           page:(NSInteger)page
                                       pageSize:(NSInteger)pageSize
                                          block:(void (^)(NSArray *array, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    [parameters setObject:[NSNumber numberWithInteger:gid] forKey:@"gid"];
    [parameters setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [parameters setObject:[NSNumber numberWithInteger:pageSize] forKey:@"page_size"];
    return [[ZXApiClient sharedClient] POST:@"schooljs/schoolteachers_searchSchoolTeacherListApp.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *array = [JSON objectForKey:@"schoolTeacherList"];
        NSArray *arr = [ZXTeacher objectArrayWithKeyValuesArray:array];
        
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
