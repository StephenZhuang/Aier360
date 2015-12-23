//
//  ZXSensitiveWords.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/12/23.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseModel.h"

@interface ZXSensitiveWords : ZXBaseModel
@property (nonatomic , copy) NSString *ctime;
@property (nonatomic , assign) NSInteger sid;
@property (nonatomic , assign) long swid;
@property (nonatomic , copy) NSString *word;

/**
 *  获取所有敏感词
 *
 *  @param sid   学校id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getAllWordsWithSid:(NSInteger)sid
                                       block:(void (^)(NSArray *array, NSError *error))block;

/**
 *  删除敏感词
 *
 *  @param swid  敏感词id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)deleteWordWithSwid:(long)swid
                                       block:(ZXCompletionBlock)block;

/**
 *  添加敏感词
 *
 *  @param sid   学校id
 *  @param word  敏感词
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)addWordWithSid:(NSInteger)sid
                                    word:(NSString *)word
                                   block:(ZXCompletionBlock)block;
@end
