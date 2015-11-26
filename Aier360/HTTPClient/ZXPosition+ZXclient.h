//
//  ZXPosition+ZXclient.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/17.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXPosition.h"
#import "ZXApiClient.h"

@interface ZXPosition (ZXclient)
/**
 *  获取职务列表
 *
 *  @param sid   学校id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getPositionListWithSid:(NSInteger)sid
                                           block:(void (^)(NSArray *array,NSInteger num_nologin_teacher, NSError *error))block;

/**
 *  更具tid搜索职务，获取职务下的老师
 *
 *  @param sid   学校id
 *  @param tids  老师id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getPositionListWithSid:(NSInteger)sid
                                            tids:(NSString *)tids
                                           block:(void (^)(NSArray *array, NSError *error))block;
@end
