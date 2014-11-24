//
//  ZXClass+ZXclient.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/17.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXClass.h"
#import "ZXApiClient.h"
#import "ZXClassDetail.h"

@interface ZXClass (ZXclient)
/**
 *  获取学校的班级列表
 *
 *  @param sid   学校id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getClassListWithSid:(NSInteger)sid
                                        block:(void (^)(NSArray *array, NSError *error))block;

/**
 *  获取班级详情
 *
 *  @param cid   班级id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)classDetailWithCid:(NSInteger)cid
                                       block:(void (^)(ZXClassDetail *classDetail, NSError *error))block;
@end
