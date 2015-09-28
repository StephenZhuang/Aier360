//
//  ZXSquareLabel+ZXclient.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/9/24.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXSquareLabel.h"
#import "ZXApiClient.h"

@interface ZXSquareLabel (ZXclient)
/**
 *  获得广场标签列表
 *
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getSquareLabelListWithBlock:(void (^)(NSArray *array, NSError *error))block;

/**
 *  获取标签详情
 *
 *  @param oslid 标签id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getSquareLabelWithOslid:(NSInteger)oslid
                                            block:(void (^)(ZXSquareLabel *squareLabel, NSError *error))block;
@end
