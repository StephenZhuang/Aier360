//
//  ZXDailyFood+ZXclient.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/25.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXDailyFood.h"
#import "ZXApiClient.h"

@interface ZXDailyFood (ZXclient)
/**
 *  每日餐饮列表
 *
 *  @param sid      学校id
 *  @param page     页码
 *  @param pageSize 每页条数
 *  @param block    回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getFoodListWithSid:(NSInteger)sid
                                        page:(NSInteger)page
                                    pageSize:(NSInteger)pageSize
                                       block:(void (^)(NSArray *array, NSError *error))block;
@end
