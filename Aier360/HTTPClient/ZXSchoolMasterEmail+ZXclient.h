//
//  ZXSchoolMasterEmail+ZXclient.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/9.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXSchoolMasterEmail.h"
#import "ZXApiClient.h"

@interface ZXSchoolMasterEmail (ZXclient)
/**
 *  校长信箱列表
 *
 *  @param sid   学校id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getEmailListWithSid:(NSInteger)sid
                                        block:(void (^)(NSArray *array, NSError *error))block;

/**
 *  回复信箱
 *
 *  @param suid    发信人的用户id
 *  @param ruid    收信人的用户id
 *  @param smeid   信箱留言ID
 *  @param content 私信的内容
 *  @param block   回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)commentEmailListWithSuid:(NSInteger)suid
                                              ruid:(NSInteger)ruid
                                             smeid:(NSInteger)smeid
                                           content:(NSString *)content
                                             block:(void (^)(NSArray *array, NSError *error))block;

/**
 *  留言校长信箱
 *
 *  @param suid    发信人id
 *  @param sid     学校id
 *  @param content 内容
 *  @param block   回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)sendEmailWithSuid:(NSInteger)suid
                                        sid:(NSInteger)sid
                                    content:(NSString *)content
                                      block:(ZXCompletionBlock)block;

/**
 *  删除信件
 *
 *  @param smeid 邮件id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)deleteEmailWithSmeid:(NSInteger)smeid
                                         block:(ZXCompletionBlock)block;
@end
