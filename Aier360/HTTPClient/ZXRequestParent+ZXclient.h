//
//  ZXRequestParent+ZXclient.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/25.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRequestParent.h"
#import "ZXApiClient.h"

@interface ZXRequestParent (ZXclient)
/**
 *  审核家长列表
 *
 *  @param cid      班级id
 *  @param tid      教师id
 *  @param state    审核状态
 *  @param page     页码
 *  @param pageSize 每页条数
 *  @param block    回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getRequestParentListWithCid:(NSInteger)cid
                                                  tid:(NSInteger)tid
                                                state:(NSInteger)state
                                                 page:(NSInteger)page
                                             pageSize:(NSInteger)pageSize
                                                block:(void (^)(NSArray *array, NSError *error))block;

/**
 *  审核家长
 *
 *  @param rpid  家长申请记录id
 *  @param state 审核状态 0:审核中，1：同意，2：拒绝
 *  @param cid   班级id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)checkParentWithRpid:(NSInteger)rpid
                                        state:(NSInteger)state
                                          cid:(NSInteger)cid
                                        block:(void (^)(ZXBaseModel *baseModel, NSError *error))block;
@end
