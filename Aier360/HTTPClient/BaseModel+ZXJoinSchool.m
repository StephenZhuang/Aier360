//
//  BaseModel+ZXJoinSchool.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/17.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "BaseModel+ZXJoinSchool.h"

@implementation ZXBaseModel (ZXJoinSchool)
+ (NSURLSessionDataTask *)parentJoinSchoolWithUid:(NSInteger)uid
                                         schoolId:(NSInteger)sid
                                         relation:(NSString *)relation
                                          classid:(NSInteger)cid
                                       parentname:(NSString *)parentname
                                        babyname:(NSString *)baby_name
                                            block:(void (^)(ZXBaseModel *baseModel, NSError *error))block
{
    NSMutableDictionary *prameters = [[NSMutableDictionary alloc] init];
    [prameters setObject:[NSNumber numberWithInteger:uid] forKey:@"uid"];
    [prameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    [prameters setObject:[NSNumber numberWithInteger:cid] forKey:@"cid"];
    [prameters setObject:relation forKey:@"relation"];
    [prameters setObject:parentname forKey:@"parentname"];
    [prameters setObject:baby_name forKey:@"baby_name"];
    
    return [[ZXApiClient sharedClient] POST:@"schooljs/schoolhome_addRequest_parent.shtml?" parameters:prameters success:^(NSURLSessionDataTask *task, id JSON) {
        
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

+ (NSURLSessionDataTask *)teacherJoinSchoolWithUid:(NSInteger)uid
                                          schoolId:(NSInteger)sid
                                               gid:(NSInteger)gid
                                       teachername:(NSString *)tname
                                            strcid:(NSString *)strcid
                                             block:(void (^)(ZXBaseModel *baseModel, NSError *error))block
{
    NSMutableDictionary *prameters = [[NSMutableDictionary alloc] init];
    [prameters setObject:[NSNumber numberWithInteger:uid] forKey:@"uid"];
    [prameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    [prameters setObject:[NSNumber numberWithInteger:gid] forKey:@"gid"];
    [prameters setObject:strcid forKey:@"strcid"];
    [prameters setObject:tname forKey:@"tname"];
    
    return [[ZXApiClient sharedClient] POST:@"schooljs/schoolhome_addRequest_teacher.shtml?" parameters:prameters success:^(NSURLSessionDataTask *task, id JSON) {
        
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

+ (NSURLSessionDataTask *)changeIdentyWithSchoolId:(NSInteger)sid
                                              appstatus:(NSString *)appstatus
                                                    cid:(NSInteger)cid
                                                    uid:(NSInteger)uid
                                                  block:(void (^)(ZXBaseModel *baseModel, NSError *error))block
{
    NSMutableDictionary *prameters = [[NSMutableDictionary alloc] init];
    [prameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    [prameters setObject:[NSNumber numberWithInteger:cid] forKey:@"cid"];
    [prameters setObject:[NSNumber numberWithInteger:uid] forKey:@"uid"];
    [prameters setObject:appstatus forKey:@"appStatus"];
    
    return [[ZXApiClient sharedClient] POST:@"nxadminjs/userstauts_checkStautNew.shtml?" parameters:prameters success:^(NSURLSessionDataTask *task, id JSON) {
        
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
