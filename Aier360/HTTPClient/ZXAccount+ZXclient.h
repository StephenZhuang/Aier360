//
//  ZXAccount+ZXclient.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/5.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXAccount.h"
#import "ZXApiClient.h"

@interface ZXAccount (ZXclient)
/**
 *  登录
 *
 *  @param accountString 账户
 *  @param message       短信验证码
 *  @param block         回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)loginWithAccount:(NSString *)accountString
                                   message:(NSString *)message
                                     block:(void (^)(ZXUser *user, NSError *error))block;

/**
 *  切换身份，获取学校列表
 *
 *  @param uid   用户id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getSchoolWithUid:(NSString *)uid
                                     block:(void (^)(ZXAccount *account, NSError *error))block;

/**
 *  获取身份
 *
 *  @param uid   用户id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getLoginStatusWithUid:(NSInteger)uid
                                          block:(void (^)(ZXAccount *account, NSError *error))block;

/**
 *  上报环信错误并处理
 *
 *  @param uid   用户id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)uploadEMErrorWithUid:(NSInteger)uid
                                         block:(ZXCompletionBlock)block;

/**
 *  二维码登录后台
 *
 *  @param account  账号
 *  @param qrcodeid 二维码id
 *  @param block    回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)loginBackendWithAccount:(NSString *)account
                                         qrcodeid:(NSString *)qrcodeid
                                            block:(ZXCompletionBlock)block;
@end
