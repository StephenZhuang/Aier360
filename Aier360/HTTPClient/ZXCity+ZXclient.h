//
//  ZXCity+ZXclient.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/12.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXCity.h"
#import "ZXApiClient.h"

@interface ZXCity (ZXclient)
/**
 *  获取城市列表
 *
 *  @param cityid -1为获取省，其他为以省id获取市列表
 *  @param block  回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getCities:(NSString *)cityid
                              block:(void (^)(NSArray *array, NSError *error))block;
@end
