//
//  ZXICCard+ZXclient.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/24.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXICCard.h"
#import "ZXApiClient.h"

@interface ZXICCard (ZXclient)

/**
 *  获取ic卡列表
 *
 *  @param uid      用户id
 *  @param sid      学校id
 *  @param page     页码
 *  @param pageSize 每页条数
 *  @param block    回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getCardListWithUid:(long)uid
                                         sid:(NSInteger)sid
                                        page:(NSInteger)page
                                    pageSize:(NSInteger)pageSize
                                       block:(void (^)(NSArray *array, NSError *error))block;

/**
 *  修改ic卡状态
 *
 *  @param sid   学校id
 *  @param icid  IC卡id
 *  @param state 学校卡状态 10:启用,20:注销
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)changeICCardStateWithSid:(NSInteger)sid
                                              icid:(NSInteger)icid
                                             state:(NSInteger)state
                                             block:(void (^)(ZXBaseModel *baseModel, NSError *error))block;

/**
 *  判断有无门禁
 *
 *  @param sid   学校id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)checkHasEntranceWithSid:(long)sid
                                            block:(ZXCompletionBlock)block;
@end
