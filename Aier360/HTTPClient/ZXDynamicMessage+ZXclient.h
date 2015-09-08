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
 *  @param sid   学校id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)clearDynamicMessageWithUid:(long)uid
                                                 sid:(NSInteger)sid
                                               block:(ZXCompletionBlock)block;

/**
 *  删除一条消息
 *
 *  @param dmid  消息id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)deleteDynamicMessageWithDmid:(long)dmid
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

/**
 *  查询是否有新的个人消息
 *
 *  @param uid   用户id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)checkHasNewPersonalDynamicWithUid:(long)uid
                                                      block:(void(^)(BOOL hasNewDynamic, NSError *error))block;

/**
 *  获取未读消息数
 *
 *  @param uid   用户id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getNewPersonalDynamicMessageWithUid:(long)uid
                                                        block:(void(^)(NSInteger newMessageNum, NSError *error))block;

/**
 *  已读全部个人消息
 *
 *  @param uid   用户id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)readAllPersonalMessageWithUid:(long)uid
                                                  block:(ZXCompletionBlock)block;

/**
 *  查询是否有新的学校消息
 *
 *  @param uid   用户id
 *  @param sid   学校id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)checkHasNewSchoolDynamicWithUid:(long)uid
                                                      sid:(NSInteger)sid
                                                    block:(void(^)(BOOL hasNewDynamic, NSError *error))block;

/**
 *  获取学校未读消息数
 *
 *  @param uid   用户id
 *  @param sid   学校id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getNewSchoolDynamicMessageWithUid:(long)uid
                                                        sid:(NSInteger)sid
                                                      block:(void(^)(NSInteger newMessageNum, NSError *error))block;

/**
 *  已读全部学校消息
 *
 *  @param uid   用户id
 *  @param sid   学校id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)readAllSchoolMessageWithUid:(long)uid
                                                  sid:(NSInteger)sid
                                                block:(ZXCompletionBlock)block;

/**
 *  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 *2.2.0
 */
/**
 *  获取所有消息数量
 *
 *  @param uid   用户id
 *  @param sid   学校id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getAllDynamicMessageNumWithUid:(long)uid
                                                     sid:(NSInteger)sid
                                                   block:(void (^)(NSUInteger num, NSError *error))block;

/**
 *  获取所有消息
 *
 *  @param uid      用户id
 *  @param sid      学校id
 *  @param page     页码
 *  @param pageSize 每页条数
 *  @param block    回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getAllDynamicMessageListWithUid:(long)uid
                                                      sid:(NSInteger)sid
                                                     page:(NSInteger)page
                                                 pageSize:(NSInteger)pageSize
                                                    block:(void (^)(NSArray *array, NSError *error))block;
@end
