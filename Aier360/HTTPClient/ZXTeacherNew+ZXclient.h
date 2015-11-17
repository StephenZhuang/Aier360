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
 *  @param sid       学校id
 *  @param appStates 身份
 *  @param uid       用户id
 *  @param block     教师总数，学生总数
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getJobNumWithSid:(NSInteger)sid
                                 appStates:(NSString *)appStates
                                       uid:(NSInteger)uid
                                     block:(void (^)(NSInteger num_teacher,NSInteger num_student, NSError *error))block;

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
                                                    block:(void (^)(NSArray *teachers , NSArray *students,NSInteger num_nologin_parent, NSError *error))block;

/**
 *  根据名称查询老师学生列表
 *
 *  @param sid      学校id
 *  @param name     名字
 *  @param cids     班级id
 *  @param appState 身份
 *  @param block    返回教师数组和学生数组
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)searchTeacherAndStudentListWithSid:(NSInteger)sid
                                                        name:(NSString *)name
                                                        cids:(NSString *)cids
                                                    appState:(NSInteger)appState
                                                       block:(void (^)(NSArray *teachers , NSArray *students, NSError *error))block;

/**
 *  删除教师
 *
 *  @param tid   被删除的教师id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)deleteTeacherWithTid:(NSInteger)tid
                                         block:(ZXCompletionBlock)block;

/**
 *  获取未读教师
 *
 *  @param sid   学校id
 *  @param mid   公告id
 *  @param type  类型
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getUnreadTeacherWithSid:(NSInteger)sid
                                              mid:(long)mid
                                             type:(NSInteger)type
                                            block:(void (^)(NSArray *array, NSError *error))block;

/**
 *  获取未读家长
 *
 *  @param sid   学校id
 *  @param mid   公告id
 *  @param cid   班级id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getUnreadParentWithSid:(NSInteger)sid
                                             mid:(long)mid
                                             cid:(long)cid
                                           block:(void (^)(NSArray *array, NSError *error))block;

/**
 *  获取未激活教师
 *
 *  @param sid   学校id
 *  @param uid   用户id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getUnactiveTeacherWithSid:(NSInteger)sid
                                                uid:(long)uid
                                              block:(void (^)(NSArray *array,BOOL hasSentMessage,NSString *messageStr, NSError *error))block;

/**
 *  获取未激活家长
 *
 *  @param sid   学校id
 *  @param uid   用户id
 *  @param cid   班级id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getUnacitveParentWithSid:(NSInteger)sid
                                               uid:(long)uid
                                               cid:(long)cid
                                             block:(void (^)(NSArray *array,BOOL hasSentMessage,NSString *messageStr, NSError *error))block;

/**
 *  给未激活的发送短信
 *
 *  @param sid        学校id
 *  @param cid        班级id，教师传0
 *  @param messageStr 内容
 *  @param block      回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)sendMessageToUnactiveWithSid:(NSInteger)sid
                                                   cid:(long)cid
                                            messageStr:(NSString *)messageStr
                                                 block:(ZXCompletionBlock)block;

@end
