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
@end
