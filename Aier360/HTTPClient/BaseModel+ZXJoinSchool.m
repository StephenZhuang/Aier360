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
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:uid] forKey:@"uid"];
    [parameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    [parameters setObject:[NSNumber numberWithInteger:cid] forKey:@"cid"];
    [parameters setObject:relation forKey:@"relation"];
    [parameters setObject:parentname forKey:@"parentname"];
    [parameters setObject:baby_name forKey:@"baby_name"];
    
    return [[ZXApiClient sharedClient] POST:@"schooljs/schoolhome_addRequest_parent.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
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
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:uid] forKey:@"uid"];
    [parameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    [parameters setObject:[NSNumber numberWithInteger:gid] forKey:@"gid"];
    [parameters setObject:strcid forKey:@"strcid"];
    [parameters setObject:tname forKey:@"tname"];
    
    return [[ZXApiClient sharedClient] POST:@"schooljs/schoolhome_addRequest_teacher.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
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
                                               uid:(NSInteger)uid
                                             block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    [parameters setObject:[NSNumber numberWithLong:uid] forKey:@"uid"];
    
    return [[ZXApiClient sharedClient] POST:@"nxadminjs/userstauts_checkStautNew.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        [ZXBaseModel handleCompletion:block baseModel:baseModel];
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [ZXBaseModel handleCompletion:block error:error];
    }];
}
@end
