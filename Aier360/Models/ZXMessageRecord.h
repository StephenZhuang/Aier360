//
//	ZXMessageRecord.h
//
//	Create by Zhuang Stephen on 13/11/2015
//	Copyright © 2015 Zhixing Internet of Things Technology Co., Ltd.. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>
#import "ZXBaseModel.h"
#import "ZXApiClient.h"

@interface ZXMessageRecord : ZXBaseModel

@property (nonatomic, assign) NSInteger bid;
@property (nonatomic, strong) NSString * billno;
@property (nonatomic, strong) NSString * cdate;
@property (nonatomic, strong) NSString * cdateStr;
@property (nonatomic, assign) NSInteger cid;
@property (nonatomic, strong) NSString * descript;
@property (nonatomic, assign) NSInteger mescount;
@property (nonatomic, assign) NSInteger money;
@property (nonatomic, strong) NSString * monthStr;
@property (nonatomic, strong) NSString * nickname;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, strong) NSString * pay;
@property (nonatomic, strong) NSString * payState;
@property (nonatomic, strong) NSString * price;
@property (nonatomic, assign) NSInteger sid;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, assign) NSInteger usecount;

/**
 *  获取短信记录列表
 *
 *  @param sid   学校id
 *  @param block 回调
 *
 *  @return task
 */
+ (NSURLSessionDataTask *)getMessageRecordWithSid:(long)sid
                                            block:(void (^)(NSArray *array, NSError *error))block;

/**
 *  获取记录详情
 *
 *  @param block 回调
 *
 *  @return task
 */
- (NSURLSessionDataTask *)getMessageDetailWithBlock:(void (^)(ZXMessageRecord *messageRecord, NSError *error))block;
@end