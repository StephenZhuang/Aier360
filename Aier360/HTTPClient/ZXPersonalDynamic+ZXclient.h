//
//  ZXPersonalDynamic+ZXclient.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/5/27.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXPersonalDynamic.h"
#import "ZXApiClient.h"

@interface ZXPersonalDynamic (ZXclient)
/**
 *  发布/转发个人动态
 *
 *  @param uid        用户id
 *  @param content    动态内容
 *  @param img        图片名称，多个以逗号隔开（可为空）
 *  @param relativeid 原创动态的id（可不填，即是原创动态）
 *  @param authority  个人动态权限（1：所有人可见 2：仅好友 3：仅自己可见）
 *  @param oslids     广场标签id
 *  @param address    地址
 *  @param lat        纬度
 *  @param lng        经度
 *  @param block      回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)addDynamicWithUid:(long)uid
                                    content:(NSString *)content
                                        img:(NSString *)img
                                 relativeid:(long)relativeid
                                  authority:(NSInteger)authority
                                     oslids:(NSString *)oslids
                                    address:(NSString *)address
                                        lat:(float)lat
                                        lng:(float)lng
                                      block:(ZXCompletionBlock)block;

/**
 *  发布/转发学校动态
 *
 *  @param uid        用户id
 *  @param content    内容
 *  @param img        图片
 *  @param relativeid 动态id
 *  @param sid        学校id
 *  @param cid        班级id，可不传
 *  @param oslids     广场标签id
 *  @param address    地址
 *  @param lat        纬度
 *  @param lng        经度
 *  @param block      回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)addSchoolDynamicWithUid:(long)uid
                                          content:(NSString *)content
                                              img:(NSString *)img
                                       relativeid:(long)relativeid
                                              sid:(long)sid
                                              cid:(long)cid
                                           oslids:(NSString *)oslids
                                          address:(NSString *)address
                                              lat:(float)lat
                                              lng:(float)lng
                                            block:(ZXCompletionBlock)block;

/**
 *  获取个人动态
 *
 *  @param uid      对象uid
 *  @param fuid     自己的uid
 *  @param page     页码
 *  @param pageSize 每页条数
 *  @param block    回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getPersonalDynamicWithUid:(long)uid
                                               fuid:(long)fuid
                                               page:(NSInteger)page
                                           pageSize:(NSInteger)pageSize
                                              block:(void(^)(NSArray *array, NSError *error))block;
/**
 *  获取个人动态详情
 *
 *  @param uid   用户id
 *  @param did   动态id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getPersonalDynamicDetailWithUid:(long)uid
                                                      did:(long)did
                                                    block:(void(^)(ZXPersonalDynamic *dynamic, NSError *error))block;

/**
 *  喜欢个人动态
 *
 *  @param uid   用户id
 *  @param did   动态id
 *  @param type  1学校 3个人
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)praiseDynamicWithUid:(long)uid
                                           did:(long)did
                                          type:(NSInteger)type
                                         block:(ZXCompletionBlock)block;

/**
 *  家长圈增量更新
 *
 *  @param uid      用户id
 *  @param time     缓存的最早的时间
 *  @param pageSize 页码
 *  @param block    回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getLatestParentDynamicWithUid:(long)uid
                                                   time:(NSString *)time
                                               pageSize:(NSInteger)pageSize
                                                  block:(void(^)(NSArray *array, NSError *error))block;

/**
 *  获取较早的家长圈动态
 *
 *  @param uid      用户id
 *  @param time     最早的时间
 *  @param pageSize 页码
 *  @param block    回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getOlderParentDynamicWithUid:(long)uid
                                                  time:(NSString *)time
                                              pageSize:(NSInteger)pageSize
                                                 block:(void(^)(NSArray *array, NSError *error))block;

/**
 *  退出登录时清除缓存
 */
+ (void)clearDynamicWhenLogout;

/**
 *  删除动态
 *
 *  @param did   动态id
 *  @param type  1：学校 3：个人
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)deleteDynamicWithDid:(long)did
                                          type:(NSInteger)type
                                         block:(ZXCompletionBlock)block;

/**
 *  获取学校动态（增量更新）
 *
 *  @param uid      用户id
 *  @param time     最早的时间
 *  @param pageSize 每页条数
 *  @param sid      学校id
 *  @param block    回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getLatestSchoolDynamicWithUid:(long)uid
                                                   time:(NSString *)time
                                               pageSize:(NSInteger)pageSize
                                                    sid:(NSInteger)sid
                                                  block:(void(^)(NSArray *array, NSError *error))block;

/**
 *  获取更多学校动态
 *
 *  @param uid      用户id
 *  @param time     最早的时间
 *  @param pageSize 每页条数
 *  @param sid      学校id
 *  @param block    回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getOlderSchoolDynamicWithUid:(long)uid
                                                  time:(NSString *)time
                                              pageSize:(NSInteger)pageSize
                                                   sid:(NSInteger)sid
                                                 block:(void(^)(NSArray *array, NSError *error))block;
/**
 *  检查有没有新的校园动态
 *
 *  @param uid   用户id
 *  @param time  最新的time
 *  @param sid   学校id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)checkNewSchoolDynamicWithUid:(long)uid
                                                  time:(NSString *)time
                                                   sid:(NSInteger)sid
                                                 block:(void(^)(BOOL hasNew, NSError *error))block;
@end
