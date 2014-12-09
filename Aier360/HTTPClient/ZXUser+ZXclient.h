//
//  ZXUser+ZXclient.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/9.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXUser.h"
#import "ZXUpDownLoadManager.h"

@interface ZXUser (ZXclient)
/**
 *  获取赞过的人列表
 *
 *  @param did   动态id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getPraisedListWithDid:(NSInteger)did
                                          block:(void (^)(NSArray *array, NSError *error))block;
@end
