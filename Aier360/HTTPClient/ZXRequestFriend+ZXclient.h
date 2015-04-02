//
//  ZXRequestFriend+ZXclient.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/4/2.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRequestFriend.h"
#import "ZXApiClient.h"

@interface ZXRequestFriend (ZXclient)
/**
 *  查询好友申请列表
 *
 *  @param uid   用户id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getFriendRequestListWithUid:(long)uid
                                                block:(void (^)(NSArray *array, NSError *error))block;

/**
 *  处理好友申请
 *
 *  @param rfid  主键
 *  @param type  0：同意 1：拒绝 2：删除
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)handleFriendRequestWithURfid:(long)rfid
                                                  type:(NSInteger)type
                                                 block:(ZXCompletionBlock)block;


@end
