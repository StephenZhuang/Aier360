//
//  ZXSchoolImg+ZXclient.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/19.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXSchoolImg.h"
#import "ZXApiClient.h"

@interface ZXSchoolImg (ZXclient)
/**
 *  获取图片列表
 *
 *  @param sid   学校id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getSchoolImgListWithSid:(long)sid
                                            block:(void (^)(NSArray *array, NSError *error))block;

/**
 *  添加学校图片
 *
 *  @param sid   学校id
 *  @param simg  学校图片，逗号分隔
 *  @param info  照片描述
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)addSchoolImageWithSid:(long)sid
                                           simg:(NSString *)simg
                                           info:(NSString *)info
                                          block:(ZXCompletionBlock)block;

/**
 *  删除学校图片
 *
 *  @param sid   学校id
 *  @param simg  图片名
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)deleteSchoolImageWithSid:(long)sid
                                              simg:(NSString *)simg
                                             block:(ZXCompletionBlock)block;

/**
 *  设为学校封面
 *
 *  @param sid   学校id
 *  @param simg  图片名
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)setCoverWithSid:(long)sid
                                     simg:(NSString *)simg
                                    block:(ZXCompletionBlock)block;
@end
