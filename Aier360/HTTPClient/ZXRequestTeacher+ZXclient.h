//
//  ZXRequestTeacher+ZXclient.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/19.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRequestTeacher.h"
#import "ZXApiClient.h"

@interface ZXRequestTeacher (ZXclient)
/**
 *  获取教师审核列表
 *
 *  @param sid      学校id
 *  @param uid      用户id
 *  @param page     页数
 *  @param pageSize 每页条数
 *  @param block    回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getRequestTeacherListWithSid:(NSInteger)sid
                                                   uid:(NSInteger)uid
                                                  page:(NSInteger)page
                                              pageSize:(NSInteger)pageSize
                                                 block:(void (^)(NSArray *array, NSError *error))block;

/**
 *  审核教师申请
 *
 *  @param ritd  requestid
 *  @param state 审核状态 0:审核中,1:同意,2:拒绝
 *  @param tid   教师id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)checkTeacherWithRtid:(NSInteger)rtid
                                         state:(NSInteger)state
                                           tid:(NSInteger)tid
                                         block:(void (^)(ZXBaseModel *baseModel, NSError *error))block;
@end
