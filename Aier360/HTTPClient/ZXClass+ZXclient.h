//
//  ZXClass+ZXclient.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/17.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXClass.h"
#import "ZXApiClient.h"

@interface ZXClass (ZXclient)
/**
 *  获取学校的班级列表
 *
 *  @param sid   学校id
 *  @param block <#block description#>
 *
 *  @return <#return value description#>
 */
+ (NSURLSessionDataTask *)getClassListWithSid:(NSInteger)sid
                                        block:(void (^)(NSArray *array, NSError *error))block;
@end
