//
//  ZXSchool+ZXclient.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/12.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXSchool.h"
#import "ZXApiClient.h"
#import "ZXSchoolDetail.h"
#import "ZXTeacherCharisma.h"

@interface ZXSchool (ZXclient)
/**
 *  搜素学校
 *
 *  @param cityid     城市id
 *  @param schoolName 学校名
 *  @param block      回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)searchSchoolWithCityid:(NSString *)cityid
                                      schoolName:(NSString *)schoolName
                                           block:(void (^)(NSArray *array, NSError *error))block;

/**
 *  学校的基本信息
 *
 *  @param sid   学校id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)schoolInfoWithSid:(NSInteger)sid
                                      block:(void (^)(ZXSchool *school , ZXSchoolDetail *schoolDetail,NSArray *array, NSError *error))block;

/**
 *  修改学校简介
 *
 *  @param sid               学校id
 *  @param schools           没用，传@“”
 *  @param schoolInfoDetails json格式，学校简介
 *  @param block             回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)updateSchoolInfoWithSid:(NSInteger)sid
                                          schools:(NSString *)schools
                                schoolInfoDetails:(NSString *)schoolInfoDetails
                                            block:(void (^)(ZXBaseModel *baseModel, NSError *error))block;

/**
 *  更新学校简介
 *
 *  @param sid     学校id
 *  @param desinfo 简介
 *  @param phone   电话
 *  @param address 地址
 *  @param sname   学校名称
 *  @param block   回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)updateSchoolInfoWithSid:(NSInteger)sid
                                          desinfo:(NSString *)desinfo
                                            phone:(NSString *)phone
                                          address:(NSString *)address
                                            sname:(NSString *)sname
                                            block:(ZXCompletionBlock)block;
@end
