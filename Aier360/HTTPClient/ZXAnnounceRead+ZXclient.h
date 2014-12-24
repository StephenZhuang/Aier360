//
//  ZXAnnounceRead+ZXclient.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/20.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXAnnounceRead.h"
#import "ZXApiClient.h"

@interface ZXAnnounceRead (ZXclient)
/**
 *  获取已读未读列表
 *
 *  @param mid   公告id
 *  @param sid   学校id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getReaderListWithMid:(NSInteger)mid
                                           sid:(NSInteger)sid
                                         block:(void (^)(ZXAnnounceRead *baseModel, NSError *error))block;
@end
