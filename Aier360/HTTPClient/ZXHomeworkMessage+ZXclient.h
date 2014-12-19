//
//  ZXHomeworkMessage+ZXclient.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/19.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXHomeworkMessage.h"
#import "ZXApiClient.h"

@interface ZXHomeworkMessage (ZXclient)
/**
 *  亲子任务消息列表
 *
 *  @param uid   用户id
 *  @param sid   学校id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getHomeworkMessageListWithUid:(NSInteger)uid
                                                    sid:(NSInteger)sid
                                                  block:(void (^)(NSArray *array, NSError *error))block;
@end
