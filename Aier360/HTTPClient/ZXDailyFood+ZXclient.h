//
//  ZXDailyFood+ZXclient.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/25.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXDailyFood.h"
#import "ZXApiClient.h"

@interface ZXDailyFood (ZXclient)
/**
 *  每日餐饮列表
 *
 *  @param sid      学校id
 *  @param page     页码
 *  @param pageSize 每页条数
 *  @param block    回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getFoodListWithSid:(NSInteger)sid
                                        page:(NSInteger)page
                                    pageSize:(NSInteger)pageSize
                                       block:(void (^)(NSArray *array, NSError *error))block;

/**
 *  新增餐饮
 *
 *  @param sid       学校id
 *  @param dailyfood 时间$餐点：内容\\n餐点：内容 (注意是中文冒号)
 *  @param ismessage 是否发送短信，0否，1是
 *  @param block     回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)addFoodWithSid:(NSInteger)sid
                               dailyfood:(NSString *)dailyfood
                               ismessage:(NSInteger)ismessage
                                   block:(void (^)(ZXBaseModel *baseModel, NSError *error))block;

/**
 *  修改餐饮
 *
 *  @param dfid    餐饮id
 *  @param ddate   用餐日期
 *  @param content 餐饮内容
 *  @param block   回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)eidtFoodWithDfid:(NSInteger)dfid
                                     ddate:(NSString *)ddate
                                   content:(NSString *)content
                                     block:(void (^)(ZXBaseModel *baseModel, NSError *error))block;
@end
