//
//  ZXCardHistory+ZXclient.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/2.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXCardHistory.h"
#import "ZXApiClient.h"

@interface ZXCardHistory (ZXclient)
/**
 *  我的打卡记录
 *
 *  @param sid             学校id
 *  @param uid             用户id
 *  @param yearAndMonthStr 日期 eg:2014-10
 *  @param page            页码
 *  @param pageSize        每页条数
 *  @param block           回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getMyCardHistoryWithSid:(NSInteger)sid
                                              uid:(NSInteger)uid
                                  yearAndMonthStr:(NSString *)yearAndMonthStr
                                             page:(NSInteger)page
                                         pageSize:(NSInteger)pageSize
                                            block:(void (^)(NSArray *array, NSError *error))block;

/**
 *  我的打卡记录详情
 *
 *  @param uid      用户id
 *  @param beginday 日期
 *  @param block    回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getDayCardHistoryWithUid:(NSInteger)uid
                                          beginday:(NSString *)beginday
                                             block:(void (^)(NSArray *array, NSError *error))block;

/**
 *  教师打卡记录详情
 *
 *  @param tid             教师id
 *  @param yearAndMonthStr 日期
 *  @param block           回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getDayDetailCardHistoryWithTid:(NSInteger)tid
                                         yearAndMonthStr:(NSString *)yearAndMonthStr
                                                   block:(void (^)(NSArray *array, NSError *error))block;

/**
 *  获取所有教师的打卡记录
 *
 *  @param sid      学校id
 *  @param beginday 开始时间
 *  @param lastday  结束时间
 *  @param page     页码
 *  @param pageSize 每页条数
 *  @param block    回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getTeachersCardHistoryWithSid:(NSInteger)sid
                                               beginday:(NSString *)beginday
                                                lastday:(NSString *)lastday
                                                   page:(NSInteger)page
                                               pageSize:(NSInteger)pageSize
                                                  block:(void (^)(NSArray *array, NSError *error))block;

/**
 *  班级学生的打卡记录
 *
 *  @param sid      学校id
 *  @param cid      班级id
 *  @param beginday 开始时间
 *  @param lastday  结束时间
 *  @param page     页码
 *  @param pageSize 每页条数
 *  @param block    回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getClassCardHistoryWithSid:(NSInteger)sid
                                                 cid:(NSInteger)cid
                                            beginday:(NSString *)beginday
                                             lastday:(NSString *)lastday
                                                page:(NSInteger)page
                                            pageSize:(NSInteger)pageSize
                                               block:(void (^)(NSArray *array, NSError *error))block;

/**
 *  学生打卡记录详情
 *
 *  @param uid      用户id
 *  @param beginday 日期
 *  @param block    回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getBabyDetailCardHistoryWithUid:(NSInteger)uid
                                                 beginday:(NSString *)beginday
                                                    block:(void (^)(NSArray *array, NSError *error))block;
@end
