//
//  ZXCollection+ZXclient.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/16.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXCollection.h"
#import "ZXApiClient.h"

@interface ZXCollection (ZXclient)
+ (NSURLSessionDataTask *)getCollectionListWithUid:(long)uid
                                              page:(NSInteger)page
                                          pageSize:(NSInteger)pageSize
                                             block:(void (^)(NSArray *array, NSError *error))block;

/**
 *  收藏
 *
 *  @param uid   用户id
 *  @param did   动态id
 *  @param isAdd 是否新增
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)collectWithUid:(long)uid
                                     did:(long)did
                                   isAdd:(BOOL)isAdd
                                   block:(ZXCompletionBlock)block;
@end
