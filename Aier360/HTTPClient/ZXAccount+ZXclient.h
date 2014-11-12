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
 *  @param pwd           密码
 *  @param block         回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)loginWithAccount:(NSString *)accountString
                                       pwd:(NSString *)pwd
                                     block:(void (^)(ZXAccount *account, NSError *error))block;

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
@end
