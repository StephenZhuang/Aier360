//
//  BaseModel+ZXRegister.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/13.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "BaseModel.h"
#import "ZXApiClient.h"

@interface BaseModel (ZXRegister)
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
                                       block:(void (^)(BaseModel *baseModel, NSError *error))block;
@end
