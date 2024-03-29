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
 *  @param account    手机
 *  @param randomChar 验证码
 *  @param block      回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getCodeWithAccount:(NSString *)account
                                  randomChar:(NSString *)randomChar
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
 *  @param block    回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)registerWithAccount:(NSString *)account
                                     password:(NSString *)password
                                        block:(void (^)(ZXBaseModel *baseModel, NSError *error))block;

/**
 *  修改密码
 *
 *  @param account  账户
 *  @param password 密码
 *  @param oldPwd   旧密码
 *  @param block    回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)changePasswordWithAccount:(NSString *)account
                                           password:(NSString *)password
                                             oldPwd:(NSString *)oldPwd
                                              block:(ZXCompletionBlock)block;

/**
 *  忘记密码
 *
 *  @param account  账户
 *  @param password 密码
 *  @param block    回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)forgetPasswordWithAccount:(NSString *)account
                                           password:(NSString *)password
                                              block:(ZXCompletionBlock)block;

/**
 *  获取随机数
 *
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getRandomChar:(void (^)(NSString *randomChar ,NSString *error_info))block;
@end
