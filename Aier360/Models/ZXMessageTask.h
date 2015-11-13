//
//	ZXMessageTask.h
//
//	Create by Zhuang Stephen on 13/11/2015
//	Copyright © 2015 Zhixing Internet of Things Technology Co., Ltd.. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>
#import "ZXBaseModel.h"
#import "ZXApiClient.h"

@interface ZXMessageTask : ZXBaseModel

@property (nonatomic, assign) NSInteger complete;
@property (nonatomic, assign) NSInteger dynamicActual;
@property (nonatomic, assign) NSInteger dynamicExpect;
@property (nonatomic, assign) NSInteger dynamicType;
@property (nonatomic, strong) NSString * mtContent;
@property (nonatomic, assign) NSInteger mtid;
@property (nonatomic, assign) NSInteger reward;
@property (nonatomic, strong) NSString * rewardStr;
@property (nonatomic, assign) NSInteger sid;
@property (nonatomic, assign) NSInteger step;

/**
 *  任务列表
 *
 *  @param sid   学校id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getMessageTaskWithSid:(long)sid
                                          block:(void (^)(NSArray *array,NSInteger mesCount, NSError *error))block;

/**
 *  完成任务领取奖励
 *
 *  @param block 回调
 *
 *  @return task
 */
- (NSURLSessionDataTask *)completeTaskWithBlock:(ZXCompletionBlock)block;
@end