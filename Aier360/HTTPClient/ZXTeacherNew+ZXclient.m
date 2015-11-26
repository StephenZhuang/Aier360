//
//  ZXTeacherNew+ZXclient.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/3/12.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXTeacherNew+ZXclient.h"
#import "ZXStudent.h"
#import "ZXParent.h"
#import "NSNull+ZXNullValue.h"

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
                                 appStates:(NSString *)appStates
                                       uid:(NSInteger)uid
                                     block:(void (^)(NSInteger num_teacher,NSInteger num_student, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    [parameters setObject:appStates forKey:@"appStates"];
    [parameters setObject:[NSNumber numberWithInteger:uid] forKey:@"uid"];
    return [[ZXApiClient sharedClient] POST:@"nxadminjs/schoolchart_searchSchoolCountsNew.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSInteger num_teacher = [[JSON objectForKey:@"num_teacher"] integerValue];
        NSInteger num_student = [[JSON objectForKey:@"num_student"] integerValue];
        
        if (block) {
            block(num_teacher,num_student, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(0,0, error);
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
                                                    block:(void (^)(NSArray *teachers , NSArray *students,NSInteger num_nologin_parent, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:cid] forKey:@"cid"];
    return [[ZXApiClient sharedClient] POST:@"nxadminjs/classesArchitecture_searchTeachersAndStudentsByCid.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *teacherArray = [JSON objectForKey:@"schoolTeacherNewList"];
        NSArray *teachers = [ZXTeacherNew objectArrayWithKeyValuesArray:teacherArray];

        NSArray *studentArray = [JSON objectForKey:@"classStudentList"];
        NSArray *students = [ZXStudent objectArrayWithKeyValuesArray:studentArray];
        
        NSInteger num_nologin_parent = [[JSON objectForKey:@"num_nologin_parent"] integerValue];
        if (block) {
            block(teachers , students,num_nologin_parent, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil ,nil,0, error);
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

+ (NSURLSessionDataTask *)getUnreadTeacherWithSid:(NSInteger)sid
                                              mid:(long)mid
                                             type:(NSInteger)type
                                            block:(void (^)(NSArray *array, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    [parameters setObject:@(mid) forKey:@"mid"];
    [parameters setObject:@(type) forKey:@"type"];
    return [[ZXApiClient sharedClient] POST:@"schooljs/schoolmessagen_searchUnreadTeachers.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *array = [[JSON objectForKey:@"schoolMessage"] objectForKey:@"unReadedTeachers"];
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

+ (NSURLSessionDataTask *)getUnreadParentWithSid:(NSInteger)sid
                                             mid:(long)mid
                                             cid:(long)cid
                                           block:(void (^)(NSArray *array, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    [parameters setObject:@(mid) forKey:@"mid"];
    [parameters setObject:@(cid) forKey:@"cid"];
    return [[ZXApiClient sharedClient] POST:@"schooljs/schoolmessagen_searchUnreadParents.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *array = [JSON objectForKey:@"unParents"];
        NSArray *arr = [ZXParent objectArrayWithKeyValuesArray:array];
        
        if (block) {
            block(arr, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

+ (NSURLSessionDataTask *)getUnactiveTeacherWithSid:(NSInteger)sid
                                                uid:(long)uid
                                              block:(void (^)(NSArray *array,BOOL hasSentMessage,NSString *messageStr, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    [parameters setObject:@(uid) forKey:@"uid"];
    return [[ZXApiClient sharedClient] POST:@"nxadminjs/classesArchitecture_searchNoLoginTeacher.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *array = [JSON objectForKey:@"schoolTeacherNewList"];
        NSArray *arr = [ZXTeacherNew objectArrayWithKeyValuesArray:array];
        NSString *string = [[JSON objectForKey:@"messageStr"] stringValue];
        BOOL hasSentMessage = ([[JSON objectForKey:@"sendMessageFlag"] integerValue] > 0);
        
        if (block) {
            block(arr,hasSentMessage,string, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil,NO,@"", error);
        }
    }];
}

+ (NSURLSessionDataTask *)getUnacitveParentWithSid:(NSInteger)sid
                                               uid:(long)uid
                                               cid:(long)cid
                                             block:(void (^)(NSArray *array,BOOL hasSentMessage,NSString *messageStr, NSError *error))block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    [parameters setObject:@(uid) forKey:@"uid"];
    [parameters setObject:@(cid) forKey:@"cid"];
    return [[ZXApiClient sharedClient] POST:@"nxadminjs/classesArchitecture_searchNoLoginParent.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSArray *array = [JSON objectForKey:@"classParentList"];
        NSArray *arr = [ZXParent objectArrayWithKeyValuesArray:array];
        
        NSString *string = [[JSON objectForKey:@"messageStr"] stringValue];
        BOOL hasSentMessage = ([[JSON objectForKey:@"sendMessageFlag"] integerValue] > 0);
        
        if (block) {
            block(arr,hasSentMessage,string, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil,NO,@"", error);
        }
    }];
}

+ (NSURLSessionDataTask *)sendMessageToUnactiveWithSid:(NSInteger)sid
                                                   cid:(long)cid
                                            messageStr:(NSString *)messageStr
                                                 block:(ZXCompletionBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:sid] forKey:@"sid"];
    [parameters setObject:messageStr forKey:@"messageStr"];
    if (cid > 0) {
        [parameters setObject:@(cid) forKey:@"cid"];
    }
    return [[ZXApiClient sharedClient] POST:@"nxadminjs/classesArchitecture_updateSendInviteMessage.shtml?" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        
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
