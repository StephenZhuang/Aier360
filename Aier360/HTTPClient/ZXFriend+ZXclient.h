//
//  ZXFriend+ZXclient.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/4/1.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXFriend.h"
#import "ZXApiClient.h"

@interface ZXFriend (ZXclient)
/**
 *  获取好友列表：增量更新
 *
 *  @param uid   用户id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getFriendListWithUid:(long)uid
                                         block:(void (^)(NSArray *array, NSError *error))block;

/**
 *  申请好友的数量
 *
 *  @param uid   用户id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getFriendRequestNumWithUid:(long)uid
                                               block:(void (^)(NSInteger num_requestFriends, NSError *error))block;
@end
