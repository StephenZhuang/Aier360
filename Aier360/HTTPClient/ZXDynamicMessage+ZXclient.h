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
+ (NSURLSessionDataTask *)getDynamicMessageListWithUid:(NSInteger)uid
                                                  page:(NSInteger)page
                                              pageSize:(NSInteger)pageSize
                                                 block:(void (^)(NSArray *array, NSError *error))block;


/**
 *  清空消息
 *
 *  @param uid   用户id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)clearDynamicMessageWithUid:(NSInteger)uid
                                               block:(ZXCompletionBlock)block;

/**
 *  删除一条消息
 *
 *  @param dmid  消息id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)deleteDynamicMessageWithDmid:(NSInteger)dmid
                                                 block:(ZXCompletionBlock)block;
@end
