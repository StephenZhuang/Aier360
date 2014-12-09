//
//  ZXDynamic+ZXclient.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/9.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXDynamic.h"
#import "ZXApiClient.h"
#import "ZXUpDownLoadManager.h"

typedef NS_ENUM(NSUInteger, ZXDynamicListType) {
    /**
     *  学校动态
     */
    ZXDynamicListTypeSchool = 0,
    /**
     *  班级动态
     */
    ZXDynamicListTypeClass = 1,
    /**
     *  个人动态
     */
    ZXDynamicListTypeUser = 2,
    /**
     *  好友动态
     */
    ZXDynamicListTypeFriend = 3
};

@interface ZXDynamic (ZXclient)
/**
 *  获取动态列表
 *
 *  @param sid      学校id
 *  @param uid      用户id
 *  @param cid      班级id
 *  @param fuid     好友id
 *  @param type     动态列表的类别
 *  @param page     页码
 *  @param pageSize 每页条数
 *  @param block    回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getDynamicListWithSid:(NSInteger)sid
                                            uid:(NSInteger)uid
                                            cid:(NSInteger)cid
                                           fuid:(NSInteger)fuid
                                           type:(ZXDynamicListType)type
                                           page:(NSInteger)page
                                       pageSize:(NSInteger)pageSize
                                          block:(void (^)(NSArray *array, NSError *error))block;

/**
 *  获取动态详情
 *
 *  @param uid   用户id
 *  @param did   动态id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getDynamicDetailWithUid:(NSInteger)uid
                                              did:(NSInteger)did
                                            block:(void (^)(ZXDynamic *dynamic, NSError *error))block;

/**
 *  获取动态回复列表
 *
 *  @param did      动态id
 *  @param page     页码
 *  @param pageSize 每页条数
 *  @param block    回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getDynamicCommentListWithDid:(NSInteger)did
                                                  page:(NSInteger)page
                                              pageSize:(NSInteger)pageSize
                                                 block:(void (^)(NSArray *array, NSError *error))block;

/**
 *  发布动态
 *
 *  @param uid      用户id
 *  @param sid      学校id
 *  @param cid      班级id
 *  @param content  内容
 *  @param type     动态类型(1学校动态2班级动态3个人动态)
 *  @param filePath zip路径
 *  @param block    回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)addDynamicWithUid:(NSInteger)uid
                                        sid:(NSInteger)sid
                                        cid:(NSInteger)cid
                                    content:(NSString *)content
                                       type:(NSInteger)type
                                   filePath:(NSString *)filePath
                                      block:(ZXCompletionBlock)block;

/**
 *  转发动态
 *
 *  @param uid     用户id
 *  @param sid     学校id
 *  @param cid     班级id
 *  @param content 转发内容
 *  @param type    动态类型(1学校动态2班级动态3个人动态)
 *  @param did     动态id
 *  @param block   回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)repostDynamicWithUid:(NSInteger)uid
                                           sid:(NSInteger)sid
                                           cid:(NSInteger)cid
                                       content:(NSString *)content
                                          type:(NSInteger)type
                                           did:(NSInteger)did
                                         block:(ZXCompletionBlock)block;
@end
