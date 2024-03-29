//
//  ZXTeacherCharisma+ZXclient.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/5.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXTeacherCharisma.h"
#import "ZXApiClient.h"

@interface ZXTeacherCharisma (ZXclient)
/**
 *  新增教师风采
 *
 *  @param sid        学校id
 *  @param stcImg     教师头像
 *  @param stcname    名字
 *  @param stcDesinfo 简介
 *  @param block      回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)addTeacherCharismalWithSid:(NSInteger)sid
                                              stcImg:(NSString *)stcImg
                                             stcname:(NSString *)stcname
                                          stcDesinfo:(NSString *)stcDesinfo
                                               block:(void (^)(ZXBaseModel *baseModel, NSError *error))block;

/**
 *  修改教师风采
 *
 *  @param stcid      风采id
 *  @param stcImg     头像
 *  @param stcname    名字
 *  @param stcDesinfo 简介
 *  @param block      回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)updateTeacherCharismalWithStcid:(NSInteger)stcid
                                                   stcImg:(NSString *)stcImg
                                                  stcname:(NSString *)stcname
                                               stcDesinfo:(NSString *)stcDesinfo
                                                    block:(void (^)(BOOL success, NSString *img, NSError *error))block;

/**
 *  获取教师风采列表
 *
 *  @param sid      学校id
 *  @param page     页码
 *  @param pageSize 每页条数
 *  @param block    回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getTeacherListWithSid:(long)sid
                                           page:(NSInteger)page
                                       pageSize:(NSInteger)pageSize
                                          block:(void (^)(NSArray *array, NSError *error))block;

/**
 *  删除教师风采
 *
 *  @param stcid 教师风采id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)deleteTeacherCharismalWithStcid:(NSInteger)stcid
                                                    block:(ZXCompletionBlock)block;
@end
