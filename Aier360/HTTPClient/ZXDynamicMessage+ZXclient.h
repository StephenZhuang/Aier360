//
//  ZXDynamicMessage+ZXclient.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/8.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXDynamicMessage.h"
#import "ZXApiClient.h"

@interface ZXDynamicMessage (ZXclient)
/**
 *  动态消息列表
 *
 *  @param uid      用户id
 *  @param page     页码
 *  @param pageSize 每页条数
 *  @param block    回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getDynamicMessageListWithUid:(long)uid
                                                  page:(NSInteger)page
                                              pageSize:(NSInteger)pageSize
                                                 block:(void (^)(NSArray *array, NSError *error))block;


/**
 *  清空消息
 *
 *  @param uid   用户id
 *  @param type  1学校2个人
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)clearDynamicMessageWithUid:(long)uid
                                                type:(NSInteger)type
                                               block:(ZXCompletionBlock)block;

/**
 *  删除一条消息
 *
 *  @param dmid  消息id
 *  @param type  1学校2个人
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)deleteDynamicMessageWithDmid:(long)dmid
                                                  type:(NSInteger)type
                                                 block:(ZXCompletionBlock)block;

/**
 *  查询学校动态消息
 *
 *  @param uid      用户id
 *  @param sid      学校id
 *  @param page     页码
 *  @param pageSize 每页条数
 *  @param block    回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getSchoolDynamicMessageListWithUid:(long)uid
                                                         sid:(NSInteger)sid
                                                        page:(NSInteger)page
                                                    pageSize:(NSInteger)pageSize
                                                       block:(void (^)(NSArray *array, NSError *error))block;
@end
