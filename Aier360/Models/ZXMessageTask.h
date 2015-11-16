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

typedef enum : NSUInteger {
    ZXMessageTaskTypeSchoolDynamic = 1,
    ZXMessageTaskTypeClassDynamic = 2,
    ZXMessageTaskTypeSchoolSummary = 3,
    ZXMessageTaskTypeSchoolImage = 4
} ZXMessageTaskType;

@interface ZXMessageTask : ZXBaseModel
/**
 *  0未完成1完成
 */
@property (nonatomic, assign) NSInteger complete;
/**
 *  实际动态条数
 */
@property (nonatomic, assign) NSInteger dynamicActual;
/**
 *  动态预计要求
 */
@property (nonatomic, assign) NSInteger dynamicExpect;
/**
 *  动态类型
 */
@property (nonatomic, assign) ZXMessageTaskType dynamicType;
/**
 *  任务内容
 */
@property (nonatomic, strong) NSString * mtContent;
@property (nonatomic, assign) NSInteger mtid;
/**
 *  任务奖励(短信条数)
 */
@property (nonatomic, assign) NSInteger reward;
@property (nonatomic, strong) NSString * rewardStr;
@property (nonatomic, assign) NSInteger sid;
/**
 *  阶段
 */
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