//
//  ZXAnnouncement+ZXclient.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/8/7.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXAnnouncement.h"
#import "ZXApiClient.h"

@interface ZXAnnouncement (ZXclient)
/**
 *  发布公告
 *
 *  @param sid     学校id
 *  @param tid     发布教师id
 *  @param title   标题
 *  @param type    通告类型 0:校园通告(全体师生),1:班级通告,2:校园通告(全体教师)3:部分老师
 *  @param img     图片
 *  @param message 内容
 *  @param tids    部分老师id
 *  @param block   回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)addAnnoucementWithSid:(long)sid
                                            tid:(long)tid
                                          title:(NSString *)title
                                           type:(NSInteger)type
                                            img:(NSString *)img
                                        message:(NSString *)message
                                           tids:(NSString *)tids
                                          block:(void(^)(BOOL success , NSInteger unActiceUserNumber,ZXAnnouncement *announcement ,NSString *errorInfo))block;

/**
 *  删除公告
 *
 *  @param mid   公告id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)deleteAnnoucementWithMid:(long)mid
                                             block:(ZXCompletionBlock)block;

/**
 *  获取公告详情
 *
 *  @param uid   用户id
 *  @param mid   公告id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getAnnoucementWithUid:(long)uid
                                            mid:(long)mid
                                          block:(void (^)(ZXAnnouncement *announcement, NSError *error))block;

/**
 *  公告列表
 *
 *  @param uid      用户id
 *  @param sid      学校id
 *  @param page     页面
 *  @param pageSize 每页条数
 *  @param block    回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getAnnoucementListWithUid:(long)uid
                                                sid:(NSInteger)sid
                                               page:(NSInteger)page
                                           pageSize:(NSInteger)pageSize
                                              block:(void (^)(NSArray *array, NSError *error))block;

/**
 *  公告提醒
 *
 *  @param mid   公告id
 *  @param sid   学校id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)remindAnnoucementWithMid:(long)mid
                                               sid:(NSInteger)sid
                                             block:(ZXCompletionBlock)block;

/**
 *  获取未阅列表
 *
 *  @param sid   学校id
 *  @param mid   公告id
 *  @param type  类型
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getAnnoucementUnreadWithSid:(long)sid
                                                  mid:(long)mid
                                                 type:(NSInteger)type
                                                block:(void (^)(ZXAnnouncement *announcement, NSError *error))block;
@end
