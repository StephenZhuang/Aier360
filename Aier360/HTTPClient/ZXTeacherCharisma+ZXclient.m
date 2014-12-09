//
//  ZXTeacherCharisma+ZXclient.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/5.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXTeacherCharisma+ZXclient.h"

@implementation ZXTeacherCharisma (ZXclient)
+ (NSURLSessionDataTask *)addTeacherCharismalWithSid:(NSInteger)sid
                                              stcImg:(NSString *)stcImg
                                             stcname:(NSString *)stcname
                                          stcDesinfo:(NSString *)stcDesinfo
                                               block:(void (^)(ZXBaseModel *baseModel, NSError *error))block
{
    NSMutableDictionary *prameters = [[NSMutableDictionary alloc] init];
    [prameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    [prameters setObject:stcImg forKey:@"stcImg"];
    [prameters setObject:stcname forKey:@"stcname"];
    [prameters setObject:stcDesinfo forKey:@"stcDesinfo"];
    return [[ZXApiClient sharedClient] POST:@"schooljs/sbinfo_addTeacherCharismal.shtml?" parameters:prameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        
        if (block) {
            block(baseModel, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

+ (NSURLSessionDataTask *)updateTeacherCharismalWithStcid:(NSInteger)stcid
                                                   stcImg:(NSString *)stcImg
                                                  stcname:(NSString *)stcname
                                               stcDesinfo:(NSString *)stcDesinfo
                                                    block:(void (^)(ZXBaseModel *baseModel, NSError *error))block
{
    NSMutableDictionary *prameters = [[NSMutableDictionary alloc] init];
    [prameters setObject:[NSNumber numberWithInteger:stcid] forKey:@"stcid"];
    [prameters setObject:stcImg forKey:@"stcImg"];
    [prameters setObject:stcname forKey:@"stcname"];
    [prameters setObject:stcDesinfo forKey:@"stcDesinfo"];
    return [[ZXApiClient sharedClient] POST:@"schooljs/sbinfo_updateTeacherCharismal.shtml?" parameters:prameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        
        if (block) {
            block(baseModel, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}
@end
