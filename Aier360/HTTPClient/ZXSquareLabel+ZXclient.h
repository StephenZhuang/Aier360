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
@end
