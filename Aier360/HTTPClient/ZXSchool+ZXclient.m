//
//  ZXSchool+ZXclient.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/12.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXSchool+ZXclient.h"

@implementation ZXSchool (ZXclient)
+ (NSURLSessionDataTask *)searchSchoolWithCityid:(NSString *)cityid
                                      schoolName:(NSString *)schoolName
                              block:(void (^)(NSArray *array, NSError *error))block
{
    NSMutableDictionary *prameters = [[NSMutableDictionary alloc] init];
    [prameters setObject:cityid forKey:@"scid"];
    [prameters setObject:schoolName forKey:@"words"];
    return [[ZXApiClient sharedClient] POST:@"userjs/lookup_searchSchoolByCidAndWord.shtml?" parameters:prameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *array = [JSON objectForKey:@"schoolList"];
        NSArray *arr = [ZXSchool objectArrayWithKeyValuesArray:array];
        
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
