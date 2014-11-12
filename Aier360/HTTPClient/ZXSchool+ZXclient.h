//
//  ZXSchool+ZXclient.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/12.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXSchool.h"
#import "ZXApiClient.h"

@interface ZXSchool (ZXclient)
/**
 *  搜素学校
 *
 *  @param cityid     城市id
 *  @param schoolName 学校名
 *  @param block      回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)searchSchoolWithCityid:(NSString *)cityid
                                      schoolName:(NSString *)schoolName
                                           block:(void (^)(NSArray *array, NSError *error))block;
@end
