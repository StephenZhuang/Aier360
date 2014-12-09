//
//  BaseModel+ZXRegister.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/13.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseModel.h"
#import "ZXApiClient.h"

@interface ZXBaseModel (ZXRegister)
/**
 *  获取短信接口
 *
 *  @param account  手机
 *  @param authCode 验证码
 *  @param block    回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getCodeWithAccount:(NSString *)account
                                    authCode:(NSString *)authCode
                                       block:(void (^)(ZXBaseModel *baseModel, NSError *error))block;

/**
 *  验证手机号是否被注册
 *
 *  @param phone 手机号
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)checkPhoneHasRegister:(NSString *)phone
                                          block:(void (^)(ZXBaseModel *baseModel, NSError *error))block;

/**
 *  验证短信验证码是否正确
 *
 *  @param code  验证码
 *  @param phone 手机号
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)checkCode:(NSString *)code
                              phone:(NSString *)phone
                              block:(void (^)(ZXBaseModel *baseModel, NSError *error))block;

/**
 *  注册
 *
 *  @param account  账户
 *  @param password 密码
 *  @param nickName 昵称
 *  @param block    回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)registerWithAccount:(NSString *)account
                                     password:(NSString *)password
                                     nickName:(NSString *)nickName
                                        block:(void (^)(ZXBaseModel *baseModel, NSError *error))block;
@end
