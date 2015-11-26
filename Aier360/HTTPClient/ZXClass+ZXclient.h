//
//  ZXClass+ZXclient.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/17.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXClass.h"
#import "ZXApiClient.h"
#import "ZXClassDetail.h"

@interface ZXClass (ZXclient)
/**
 *  获取学校的班级列表
 *
 *  @param sid   学校id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getClassListWithSid:(NSInteger)sid
                                        block:(void (^)(NSArray *array, NSError *error))block;

/**
 *  获取某个用户的班级列表
 *
 *  @param sid       学校id
 *  @param uid       用户id
 *  @param appStates 身份
 *  @param block     回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getClassListWithSid:(NSInteger)sid
                                          uid:(NSInteger)uid
                                    appStates:(NSString *)appStates
                                        block:(void (^)(NSArray *array, NSError *error))block;

/**
 *  获取班级详情
 *
 *  @param cid   班级id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)classDetailWithCid:(NSInteger)cid
                                       block:(void (^)(ZXClassDetail *classDetail, NSError *error))block;

/**
 *  所有班级的餐饮图片
 *
 *  @param dfid      餐饮id
 *  @param page      页码
 *  @param page_size 每页条数
 *  @param block     回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getClassImageListWithDfid:(NSInteger)dfid
                                               page:(NSInteger)page
                                          page_size:(NSInteger)page_size
                                              block:(void (^)(NSArray *array, NSError *error))block;

/**
 *  查询可以发布动态的班级列表
 *
 *  @param sid   学校id
 *  @param uid   用户id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getReleaseClassListWithSid:(NSInteger)sid
                                                 uid:(NSInteger)uid
                                               block:(void (^)(NSArray *array, NSError *error))block;

/**
 *  获取通知视图
 *
 *  @param sid   学校id
 *  @param mid   公告id
 *  @param type  公告类型
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getUnreadClassListWithSid:(NSInteger)sid
                                                mid:(long)mid
                                               type:(NSInteger)type
                                              block:(void (^)(NSArray *array,NSInteger unReaderTeacherNum, NSError *error))block;
@end
