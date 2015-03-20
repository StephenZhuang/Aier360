//
//  ZXStudent+ZXclient.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/25.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXStudent.h"
#import "ZXApiClient.h"

@interface ZXStudent (ZXclient)
/**
 *  获取班级学生列表
 *
 *  @param cid         班级id
 *  @param isGetParent 是否获取学生家长 1:是，0：否
 *  @param block       回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getStudentListWithCid:(NSInteger)cid
                                    isGetParent:(NSInteger)isGetParent
                                          block:(void (^)(NSArray *array, NSError *error))block;

/**
 *  查询家长下的所有孩子
 *
 *  @param uid   家长用户id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getStudentListWithUid:(NSInteger)uid
                                          block:(void (^)(NSArray *array, NSError *error))block;

/**
 *  根据学生id获取家长列表
 *
 *  @param csid  学生id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getParentListWithCsid:(NSInteger)csid
                                          block:(void (^)(NSArray *array, NSError *error))block;

/**
 *  添加学生
 *
 *  @param cid    班级id
 *  @param snames 学生姓名
 *  @param sexs   性别
 *  @param block  回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)addStudentWithCid:(NSInteger)cid
                                     snames:(NSString *)snames
                                       sexs:(NSString *)sexs
                                      block:(ZXCompletionBlock)block;

/**
 *  添加家长
 *
 *  @param csid     学生id
 *  @param tid      操作教师id
 *  @param sid      学校id
 *  @param phone    手机号
 *  @param relation 关系
 *  @param sex      性别
 *  @param block    回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)addParentWithCsid:(NSInteger)csid
                                        tid:(NSInteger)tid
                                        sid:(NSInteger)sid
                                      phone:(NSString *)phone
                                   relation:(NSString *)relation
                                        sex:(NSString *)sex
                                      block:(ZXCompletionBlock)block;

/**
 *  删除家长
 *
 *  @param csid  学生id
 *  @param uid   家长id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)deleteParentWithCsid:(NSInteger)csid
                                           uid:(NSInteger)uid
                                         block:(ZXCompletionBlock)block;
@end
