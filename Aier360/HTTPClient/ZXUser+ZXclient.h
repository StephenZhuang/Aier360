//
//  ZXUser+ZXclient.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/9.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXUser.h"
#import "ZXUpDownLoadManager.h"

@interface ZXUser (ZXclient)
/**
 *  获取赞过的人列表
 *
 *  @param did   动态id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getPraisedListWithDid:(NSInteger)did
                                          block:(void (^)(NSArray *array, NSError *error))block;

/**
 *  获取个人信息
 *
 *  @param uid    用户id
 *  @param in_uid 目标用户id
 *  @param block  user,babyList,isGz
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getUserInfoAndBabyListWithUid:(NSInteger)uid
                                                 in_uid:(NSInteger)in_uid
                                                  block:(void (^)(ZXUser *user, NSArray *array, BOOL isFocus, NSError *error))block;

/**
 *  修改个人信息
 *
 *  @param appuserinfo 用户信息
 *  @param babysinfo   宝宝信息
 *  @param uid         用户id
 *  @param block       回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)updateUserInfoAndBabyListWithAppuserinfo:(NSString *)appuserinfo
                                                         babysinfo:(NSString *)babysinfo
                                                               uid:(NSInteger)uid
                                                             block:(ZXCompletionBlock)block;
@end
