//
//  ZXBaby+ZXclient.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/5/5.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaby.h"
#import "ZXApiClient.h"

@interface ZXBaby (ZXclient)
/**
 *  添加宝宝
 *
 *  @param uid      用户id
 *  @param nickname 宝宝昵称
 *  @param sex      性别
 *  @param birthday 生日
 *  @param block    回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)addBabyWithUid:(long)uid
                                nickname:(NSString *)nickname
                                     sex:(NSString *)sex
                                birthday:(NSString *)birthday
                                   block:(ZXCompletionBlock)block;

/**
 *  编辑宝宝
 *
 *  @param uid      用户id
 *  @param bid      宝宝id
 *  @param nickname 昵称
 *  @param sex      性别
 *  @param birthday 生日
 *  @param block    回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)updateBabyWithUid:(long)uid
                                        bid:(long)bid
                                   nickname:(NSString *)nickname
                                        sex:(NSString *)sex
                                   birthday:(NSString *)birthday
                                      block:(ZXCompletionBlock)block;

/**
 *  删除宝宝
 *
 *  @param uid   用户id
 *  @param bid   宝宝id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)deleteBabyWithUid:(long)uid
                                        bid:(long)bid
                                      block:(ZXCompletionBlock)block;
@end
