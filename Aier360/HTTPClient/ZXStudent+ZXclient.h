//
//  ZXStudent+ZXclient.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/25.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXStudent.h"
#import "ZXApiClient.h"

@interface ZXStudent (ZXclient)
/**
 *  获取班级学生列表
 *
 *  @param cid         班级id
 *  @param isGetParent 是否获取学生家长 1:是，0：否
 *  @param block       回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getStudentListWithCid:(NSInteger)cid
                                    isGetParent:(NSInteger)isGetParent
                                          block:(void (^)(NSArray *array, NSError *error))block;
@end
