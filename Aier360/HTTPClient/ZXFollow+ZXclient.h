//
//  ZXFollow+ZXclient.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/25.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXFollow.h"
#import "ZXApiClient.h"

@interface ZXFollow (ZXclient)
/**
 *  查看所有关注||粉丝||朋友
 *
 *  @param uid       用户id
 *  @param state     关注状态：1已关注；2互相关注;0全部 3：粉丝
 *  @param page      页码
 *  @param page_size 每页条数
 *  @param block     回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getFollowListWithUid:(NSInteger)uid
                                         state:(NSInteger)state
                                          page:(NSInteger)page
                                     page_size:(NSInteger)page_size
                                         block:(void (^)(NSArray *array, NSError *error))block;
@end
