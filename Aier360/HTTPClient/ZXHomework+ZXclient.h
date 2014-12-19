//
//  ZXHomework+ZXclient.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/18.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXHomework.h"
#import "ZXUpDownLoadManager.h"
#import "ZXHomeworkRead.h"

@interface ZXHomework (ZXclient)
/**
 *  班级亲子任务列表
 *
 *  @param uid       用户id
 *  @param sid       学校id
 *  @param cid       班级id
 *  @param page      页码
 *  @param page_size 每页条数
 *  @param block     回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getClassHomeworkListWithUid:(NSInteger)uid
                                                  sid:(NSInteger)sid
                                                  cid:(NSInteger)cid
                                                 page:(NSInteger)page
                                            page_size:(NSInteger)page_size
                                                block:(void (^)(NSArray *array, NSError *error))block;

/**
 *  所有班级的亲子任务
 *
 *  @param uid       用户id
 *  @param sid       学校id
 *  @param page      页码
 *  @param page_size 每页条数
 *  @param block     回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getAllClassHomeworkListWithUid:(NSInteger)uid
                                                     sid:(NSInteger)sid
                                                    page:(NSInteger)page
                                               page_size:(NSInteger)page_size
                                                   block:(void (^)(NSArray *array, NSError *error))block;

/**
 *  亲子任务详情
 *
 *  @param uid   用户id
 *  @param hid   亲子任务id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getHomeworkDetailWithUid:(NSInteger)uid
                                               hid:(NSInteger)hid
                                             block:(void (^)(ZXHomework *homework, NSError *error))block;

/**
 *  亲子任务已读列表
 *
 *  @param hid   亲子任务id
 *  @param sid   学校id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getHomeworkReadListWithHid:(NSInteger)hid
                                                 sid:(NSInteger)sid
                                               block:(void (^)(NSArray *array, NSError *error))block;

/**
 *  删除亲子任务
 *
 *  @param hid   亲子任务id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)deleteHomeworkWithHid:(NSInteger)hid
                                          block:(ZXCompletionBlock)block;

/**
 *  评论亲子任务或者晒作业
 *
 *  @param hid      亲子任务id
 *  @param sid      学校id
 *  @param content  内容
 *  @param type     身份类型（0普通用户1教师2家长）
 *  @param uid      用户id
 *  @param tid      教师id
 *  @param filePath 文件路径
 *  @param block    回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)commentHomeworkWithHid:(NSInteger)hid
                                             sid:(NSInteger)sid
                                         content:(NSString *)content
                                            type:(NSInteger)type
                                             uid:(NSInteger)uid
                                             tid:(NSInteger)tid
                                        filePath:(NSString *)filePath
                                           block:(ZXCompletionBlock)block;

/**
 *  回复评论或者回复
 *
 *  @param chid    评论id
 *  @param sid     学校id
 *  @param content 内容
 *  @param type    身份类型（1教师2家长）
 *  @param uid     用户id
 *  @param tid     教师id
 *  @param crhid   回复id
 *  @param touid   对象id
 *  @param block   回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)replyCommentWithChid:(NSInteger)chid
                                           sid:(NSInteger)sid
                                       content:(NSString *)content
                                          type:(NSInteger)type
                                           uid:(NSInteger)uid
                                           tid:(NSInteger)tid
                                         crhid:(NSInteger)crhid
                                         touid:(NSInteger)touid
                                         block:(ZXCompletionBlock)block;

/**
 *  发布亲子任务
 *
 *  @param sid         学校id
 *  @param content     内容
 *  @param title       标题
 *  @param cid         班级id
 *  @param tid         教师id
 *  @param isSendPhone 是否发送短信
 *  @param filePath    文件路径
 *  @param block       回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)addHomeworkWithSid:(NSInteger)sid
                                     content:(NSString *)content
                                       title:(NSString *)title
                                         cid:(NSInteger)cid
                                         tid:(NSInteger)tid
                                 isSendPhone:(BOOL)isSendPhone
                                    filePath:(NSString *)filePath
                                       block:(ZXCompletionBlock)block;
@end
