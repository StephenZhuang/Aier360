//
//  ZXTeacherNew+ZXclient.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/3/12.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXTeacherNew.h"
#import "ZXApiClient.h"

@interface ZXTeacherNew (ZXclient)
/**
 *  查询职务下所有老师列表
 *
 *  @param sid      学校id
 *  @param gid      职务id
 *  @param page     页码
 *  @param pageSize 每页条数
 *  @param block    回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getTeacherListWithSid:(NSInteger)sid
                                            gid:(NSInteger)gid
                                           page:(NSInteger)page
                                       pageSize:(NSInteger)pageSize
                                          block:(void (^)(NSArray *array, NSError *error))block;

/**
 *  搜索老师
 *
 *  @param sid   学校id
 *  @param tname 老师姓名
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)searchTeacherWithSid:(NSInteger)sid
                                         tname:(NSString *)tname
                                         block:(void (^)(NSArray *array, NSError *error))block;

/**
 *  获取组织架构总数
 *
 *  @param sid      学校id
 *  @param appState 身份
 *  @param block    职务总数，教师总数，班级总数，学生总数
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getJobNumWithSid:(NSInteger)sid
                                  appState:(NSInteger)appState
                                     block:(void (^)(NSInteger num_grade,NSInteger num_teacher,NSInteger num_classes,NSInteger num_student, NSError *error))block;

/**
 *  添加老师
 *
 *  @param sid      学校id
 *  @param realname 老师姓名
 *  @param gid      职务id
 *  @param uid      用户id
 *  @param tid      操作者的老师id
 *  @param phone    手机号
 *  @param sex      性别
 *  @param cids     班级id，多个以逗号隔开
 *  @param block    回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)addTeacherWithSid:(NSInteger)sid
                                   realname:(NSString *)realname
                                        gid:(NSInteger)gid
                                        uid:(NSInteger)uid
                                        tid:(NSInteger)tid
                                      phone:(NSString *)phone
                                        sex:(NSString *)sex
                                       cids:(NSString *)cids
                                      block:(ZXCompletionBlock)block;

/**
 *  查询班级下的老师和学生
 *
 *  @param cid   班级id
 *  @param block 返回教师数组和学生数组
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getTeacherAndStudentListWithCid:(NSInteger)cid
                                                    block:(void (^)(NSArray *teachers , NSArray *students, NSError *error))block;

/**
 *  根据名称查询老师学生列表
 *
 *  @param sid   学校id
 *  @param name  名字
 *  @param block 返回教师数组和学生数组
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)searchTeacherAndStudentListWithSid:(NSInteger)sid
                                                        name:(NSString *)name
                                                       block:(void (^)(NSArray *teachers , NSArray *students, NSError *error))block;
@end
