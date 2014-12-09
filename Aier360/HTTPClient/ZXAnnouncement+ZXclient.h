//
//  ZXAnnouncement+ZXclient.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/18.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXAnnouncement.h"
#import "ZXApiClient.h"

@interface ZXAnnouncement (ZXclient)
/**
 *  获取公告列表
 *
 *  @param sid      学校id
 *  @param cid      班级id
 *  @param uid      用户id
 *  @param appState 身份
 *  @param page     页码
 *  @param pageSize 每页的条数
 *  @param block    回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getAnnouncementListWithSid:(NSInteger)sid
                                                 cid:(NSInteger)cid
                                                 uid:(NSInteger)uid
                                            appState:(NSInteger)appState
                                                page:(NSInteger)page
                                            pageSize:(NSInteger)pageSize
                                               block:(void (^)(NSArray *array, NSError *error))block;

/**
 *  首次查看公告时修改阅读量
 *
 *  @param mid   公告id
 *  @param tid   教师id
 *  @param uid   用户id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)readAnnouncementWithMid:(NSInteger)mid
                                              tid:(NSInteger)tid
                                              uid:(NSInteger)uid
                                            block:(void (^)(ZXBaseModel *baseModel, NSError *error))block;

/**
 *  发布公告所需和剩余短信数
 *
 *  @param sid      学校id
 *  @param cid      班级id
 *  @param sendType 发送对象（1、全体老师；2、老师和家长；3、班级公告）
 *  @param block    回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getSmsCountWithSid:(NSInteger)sid
                                         cid:(NSInteger)cid
                                    sendType:(NSInteger)sendType
                                       block:(void (^)(NSInteger totalMessage , NSInteger mesCount, NSError *error))block;
@end
