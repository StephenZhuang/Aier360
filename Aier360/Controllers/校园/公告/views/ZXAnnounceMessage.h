//
//  ZXAnnounceMessage.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/11/11.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    ZXSendMessageTypeUnregister,
    ZXSendMessageTypeUnread
} ZXSendMessageType;

@interface ZXAnnounceMessage : NSObject
@property (nonatomic , assign) NSInteger sid;
@property (nonatomic , assign) long mid;
@property (nonatomic , copy) NSString *content;
@property (nonatomic , assign) NSInteger needSendPeopleNum;
@property (nonatomic , assign) NSInteger messageNum;
@property (nonatomic , assign) ZXSendMessageType type;

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
 *  发送短信
 *
 *  @param block 回调
 *
 *  @return task
 */
- (NSURLSessionDataTask *)sendMessageWithBlock:(ZXCompletionBlock)block;
@end
