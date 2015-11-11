//
//  ZXAnnounceMessage.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/11/11.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZXAnnounceMessage : NSObject
@property (nonatomic , assign) NSInteger sid;
@property (nonatomic , assign) long mid;
@property (nonatomic , copy) NSString *content;
@property (nonatomic , assign) NSInteger needSendPeopleNum;
@property (nonatomic , assign) NSInteger messageNum;

+ (NSInteger)getMessageNumWithTextlength:(NSInteger)length;

/**
 *  获取学校剩余短信
 *
 *  @param sid   学校id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getSchoolMesCountWithSid:(NSInteger)sid
                                             block:(void (^)(BOOL success , NSInteger mesCount, NSString *errorInfo))block;

/**
 *  给未激活的用户发送短信
 *
 *  @param mid          公告id
 *  @param sid          学校id
 *  @param phoneContent 短信内容
 *  @param block        回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)sendMessageWithMid:(long)mid
                                         sid:(NSInteger)sid
                                phoneContent:(NSString *)phoneContent
                                       block:(ZXCompletionBlock)block;
@end
