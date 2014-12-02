//
//  ZXCardHistory+ZXclient.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/2.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXCardHistory.h"
#import "ZXApiClient.h"

@interface ZXCardHistory (ZXclient)
/**
 *  我的打卡记录
 *
 *  @param sid             学校id
 *  @param uid             用户id
 *  @param yearAndMonthStr 日期 eg:2014-10
 *  @param page            页码
 *  @param pageSize        每页条数
 *  @param block           回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getMyCardHistoryWithSid:(NSInteger)sid
                                              uid:(NSInteger)uid
                                  yearAndMonthStr:(NSString *)yearAndMonthStr
                                             page:(NSInteger)page
                                         pageSize:(NSInteger)pageSize
                                            block:(void (^)(NSArray *array, NSError *error))block;
@end
