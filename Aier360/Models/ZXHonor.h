//
//  ZXHonor.h
//  Aierbon
//
//  Created by Stephen Zhuang on 16/1/7.
//  Copyright © 2016年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseModel.h"

@interface ZXHonor : ZXBaseModel
@property (nonatomic , assign) NSInteger shid;
@property (nonatomic , copy) NSString *honor;
@property (nonatomic , assign) NSInteger sid;
@property (nonatomic , copy) NSString *ctime;

/**
 *  获取荣誉列表
 *
 *  @param sid   学校id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getHonorListWithSid:(NSInteger)sid
                                        block:(void (^)(NSArray *array, NSError *error))block;

/**
 *  添加荣誉
 *
 *  @param sid   学校id
 *  @param honor 荣誉
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)addHonorWithSid:(NSInteger)sid
                                    honor:(NSString *)honor
                                    block:(ZXCompletionBlock)block;

/**
 *  删除学校荣誉
 *
 *  @param shid  荣誉id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)deleteHonorWithShid:(NSInteger)shid
                                        block:(ZXCompletionBlock)block;
@end
