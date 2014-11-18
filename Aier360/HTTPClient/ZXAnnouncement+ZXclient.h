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
 *  @param appState 身份
 *  @param page     页码
 *  @param pageSize 每页的条数
 *  @param block    回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getAnnouncementListWithSid:(NSInteger)sid
                                                 cid:(NSInteger)cid
                                            appState:(NSInteger)appState
                                                page:(NSInteger)page
                                            pageSize:(NSInteger)pageSize
                                               block:(void (^)(NSArray *array, NSError *error))block;
@end
