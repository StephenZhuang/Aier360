//
//  BaseModel+ZXJoinSchool.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/17.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "BaseModel.h"
#import "ZXApiClient.h"

@interface BaseModel (ZXJoinSchool)
/**
 *  家长加入学校
 *
 *  @param uid        用户id
 *  @param sid        学校id
 *  @param relation   家长与宝宝的关系
 *  @param cid        班级id
 *  @param parentname 家长姓名
 *  @param baby_name  宝宝姓名
 *  @param block      回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)parentJoinSchoolWithUid:(NSInteger)uid
                                         schoolId:(NSInteger)sid
                                         relation:(NSString *)relation
                                          classid:(NSInteger)cid
                                       parentname:(NSString *)parentname
                                         babyname:(NSString *)baby_name
                                            block:(void (^)(BaseModel *baseModel, NSError *error))block;

/**
 *  教师加入学校
 *
 *  @param uid    用户id
 *  @param sid    学校id
 *  @param gid    职务id
 *  @param tname  教师名字
 *  @param strcid 班级id，用,隔开
 *  @param block  回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)teacherJoinSchoolWithUid:(NSInteger)uid
                                          schoolId:(NSInteger)sid
                                               gid:(NSInteger)gid
                                       teachername:(NSString *)tname
                                            strcid:(NSString *)strcid
                                             block:(void (^)(BaseModel *baseModel, NSError *error))block;

/**
 *  切换身份
 *
 *  @param sid       学校id
 *  @param appstatus 身份
 *  @param cid       班级id
 *  @param uid       用户id
 *  @param block     回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)changeIdentyWithSchoolId:(NSInteger)sid
                                         appstatus:(NSString *)appstatus
                                               cid:(NSInteger)cid
                                               uid:(NSInteger)uid
                                             block:(void (^)(BaseModel *baseModel, NSError *error))block;
@end
