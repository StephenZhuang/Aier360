//
//  ZXTeacherNew+ZXclient.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/3/12.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXTeacherNew+ZXclient.h"
#import "ZXStudent.h"

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

+ (NSURLSessionDataTask *)searchTeacherWithSid:(NSInteger)sid
                                         tname:(NSString *)tname
                                         block:(void (^)(NSArray *array, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    [parameters setObject:tname forKey:@"tname"];
    return [[ZXApiClient sharedClient] POST:@"nxadminjs/schoolteacher_searchTeachersByName.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
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

+ (NSURLSessionDataTask *)getJobNumWithSid:(NSInteger)sid
                                  appState:(NSInteger)appState
                                       uid:(NSInteger)uid
                                     block:(void (^)(NSInteger num_grade,NSInteger num_teacher,NSInteger num_classes,NSInteger num_student, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    [parameters setObject:[NSNumber numberWithInteger:appState] forKey:@"appState"];
    [parameters setObject:[NSNumber numberWithInteger:uid] forKey:@"uid"];
    return [[ZXApiClient sharedClient] POST:@"nxadminjs/schoolchart_searchSchoolCounts.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSInteger num_grade = [[JSON objectForKey:@"num_grade"] integerValue];
        NSInteger num_teacher = [[JSON objectForKey:@"num_teacher"] integerValue];
        NSInteger num_classes = [[JSON objectForKey:@"num_classes"] integerValue];
        NSInteger num_student = [[JSON objectForKey:@"num_student"] integerValue];
        
        if (block) {
            block(num_grade,num_teacher,num_classes,num_student, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(0,0,0,0, error);
        }
    }];
}

+ (NSURLSessionDataTask *)addTeacherWithSid:(NSInteger)sid
                                   realname:(NSString *)realname
                                        gid:(NSInteger)gid
                                        uid:(NSInteger)uid
                                        tid:(NSInteger)tid
                                      phone:(NSString *)phone
                                        sex:(NSString *)sex
                                       cids:(NSString *)cids
                                      block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    [parameters setObject:[NSNumber numberWithInteger:gid] forKey:@"schoolGrade.gid"];
    [parameters setObject:[NSNumber numberWithInteger:tid] forKey:@"tid"];
    [parameters setObject:[NSNumber numberWithInteger:uid] forKey:@"uid"];
    [parameters setObject:realname forKey:@"user.realname"];
    [parameters setObject:phone forKey:@"user.phone"];
    [parameters setObject:sex forKey:@"user.sex"];
    [parameters setObject:cids forKey:@"cids"];
    return [[ZXApiClient sharedClient] POST:@"nxadminjs/schoolchart_ajaxAddMember.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        
        if (block) {
            [ZXBaseModel handleCompletion:block baseModel:baseModel];
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            [ZXBaseModel handleCompletion:block error:error];
        }
    }];
}

+ (NSURLSessionDataTask *)getTeacherAndStudentListWithCid:(NSInteger)cid
                                                    block:(void (^)(NSArray *teachers , NSArray *students, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:cid] forKey:@"cid"];
    return [[ZXApiClient sharedClient] POST:@"nxadminjs/classesArchitecture_searchTeachersAndStudentsByCid.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *teacherArray = [JSON objectForKey:@"schoolTeacherNewList"];
        NSArray *teachers = [ZXTeacherNew objectArrayWithKeyValuesArray:teacherArray];

        NSArray *studentArray = [JSON objectForKey:@"classStudentList"];
        NSArray *students = [ZXStudent objectArrayWithKeyValuesArray:studentArray];
        if (block) {
            block(teachers , students, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil ,nil, error);
        }
    }];
}

+ (NSURLSessionDataTask *)searchTeacherAndStudentListWithSid:(NSInteger)sid
                                                        name:(NSString *)name
                                                        cids:(NSString *)cids
                                                    appState:(NSInteger)appState
                                                       block:(void (^)(NSArray *teachers , NSArray *students, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    [parameters setObject:name forKey:@"name"];
    [parameters setObject:[NSNumber numberWithInteger:appState] forKey:@"appState"];
    [parameters setObject:cids forKey:@"cids"];
    return [[ZXApiClient sharedClient] POST:@"nxadminjs/classesArchitecture_searchTeachersAndStudentsByName.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *teacherArray = [JSON objectForKey:@"schoolTeacherNewList"];
        NSArray *teachers = [ZXTeacherNew objectArrayWithKeyValuesArray:teacherArray];
        
        NSArray *studentArray = [JSON objectForKey:@"classStudentList"];
        NSArray *students = [ZXStudent objectArrayWithKeyValuesArray:studentArray];
        if (block) {
            block(teachers , students, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil ,nil, error);
        }
    }];
}

+ (NSURLSessionDataTask *)deleteTeacherWithTid:(NSInteger)tid
                                         block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:tid] forKey:@"tid"];
    return [[ZXApiClient sharedClient] POST:@"nxadminjs/schoolteacher_deleteTeacher.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        ZXBaseModel *baseModel = [ZXBaseModel objectWithKeyValues:JSON];
        
        if (block) {
            [ZXBaseModel handleCompletion:block baseModel:baseModel];
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            [ZXBaseModel handleCompletion:block error:error];
        }
    }];
}
@end
